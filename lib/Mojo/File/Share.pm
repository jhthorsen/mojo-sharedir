package Mojo::File::Share;
use Mojo::Base 'Mojo::File';

use Carp;
use Mojo::Loader 'load_class';
use Scalar::Util 'blessed';

use constant DEBUG => $ENV{MOJO_FILE_SHARE_DEBUG} || 0;

# Setting this, might be breaking
use constant SUPPORTS_MODULE_SEARCH => $ENV{MOJO_FILE_SHARE_SUPPORTS_MODULE_SEARCH} || 0;

our @EXPORT_OK = 'dist_path';
our $VERSION   = '0.01';

our @AUTO_SHARE_DIST   = split '/', 'auto/share/dist';
our @AUTO_SHARE_MODULE = split '/', 'auto/share/module';
our $SHARE_DIR         = 'share';

sub dist_path { __PACKAGE__->new(@_) }

sub new {
  return shift->SUPER::new(@_) if blessed $_[0];

  my $class = shift;
  my ($param, @rest) = (@_ ? shift : scalar caller, @_);
  $param = ref $param if blessed $param;

  my @parts = split /(?:-|::)/, $param;
  my $inc   = sprintf '%s.pm', join '/', @parts;

  warn "[Share] From $param\n" if DEBUG;

  my $path
    = $INC{$inc} && $class->_new_from_inc(\@parts, $inc)
    || $class->_new_from_installed(\@parts, $param)
    || Carp::croak(qq(Could not find dist path for "$param".));

  return @rest ? $path->child(@rest) : $path;
}

sub to_app {
  return shift->new(ref $_[0])->to_app(@_) unless blessed $_[0];

  my ($self, $app, %params) = @_;

  $params{directories} ||= {renderer => 'templates', static => 'public'};
  $params{home}        ||= 0;

  for my $kind (keys %{$params{directories}}) {
    my $path = $self->child($params{directories}{$kind});
    warn "[Share] unshift $kind, $path.\n" if DEBUG;
    next unless -d $path;
    shift @{$app->$kind->paths} unless -d $app->$kind->paths->[0];
    unshift @{$app->$kind->paths}, $path;
  }

  return $self;
}

sub _new_from_inc {
  my ($class, $parts, $inc) = @_;
  my $path = $class->SUPER::new($INC{$inc})->to_abs->to_array;

  pop @$path for 0 .. @$parts;
  my $share = $class->SUPER::new(@$path, $SHARE_DIR);
  warn "[Share] Looking in \@INC for $share\n" if DEBUG;
  return undef unless -d $share;
  return $share;
}

sub _new_from_installed {
  my ($class, $parts, $param) = @_;
  my @auto_path;

  push @auto_path, $class->SUPER::new(@AUTO_SHARE_MODULE, join '-', @$parts)
    if SUPPORTS_MODULE_SEARCH and $param =~ m!::!;

  push @auto_path, $class->SUPER::new(@AUTO_SHARE_DIST, join '-', @$parts);    # File::ShareDir::_dist_dir_new()
  push @auto_path, $class->SUPER::new('auto', @$parts);                        # File::ShareDir::_dist_dir_old()

  for my $auto_path (@auto_path) {
    for my $inc (@INC) {
      my $share = $class->SUPER::new($inc, $auto_path);
      warn "[Share] Looking for $share\n" if DEBUG;
      return $share if -d $share;
    }
  }

  return undef;
}

1;

=encoding utf8

=head1 NAME

Mojo::File::Share - Extension to Mojo::File to find shared/installed files

=head1 SYNOPSIS

  use Mojo::File::Share;

  # These will result in the same thing
  my $path = Mojo::File::Share->new("My-Application");
  my $path = Mojo::File::Share->new("My::Application");
  my $path = Mojo::File::Share->new(My::Application->new);

  # Example full application
  package MyApp;

  sub startup {
    my $self = shift;

    # Change public and templates directories to share/ path
    Mojo::File::Share->to_app($self);
  }

  # Example Makefile.PL
  use File::ShareDir::Install;
  install_share 'share';

=head1 DESCRIPTION

L<Mojo::File::Share> is a merge of L<File::ShareDir> and L<File::Share>, but
also allows you to modify a L<Mojolicious> application with ease.

Note: In the same way as L<File::Share>, this module does not support
per-module share directoris.

To install the files in "share/", you need something like
L<File::ShareDir::Install>.

=head1 FUNCTIONS

L<Mojo::File::Share> implements the following functions, which can be imported
individually.

=head2 dist_path

  my $path = dist_path;
  my $path = dist_path "Some-Dist", @path;
  my $path = dist_path "Some::Module", @path;
  my $path = dist_path $some_object, @path;

Construct a new L<Mojo::File::Share> object. Follows the same rules as L</new>.

=head1 METHODS

L<Mojo::File::Share> inherits all methods from L<Mojo::File> and implements the
following new ones.

=head2 new

  my $path = Mojo::File::Share->new;
  my $path = Mojo::File::Share->new("Some-Dist", @path);
  my $path = Mojo::File::Share->new("Some::Module", @path);
  my $path = Mojo::File::Share->new($some_object, @path);

Construct a new L<Mojo::File::Share> object with C<$path> set to either the
local "share/" path or the installed for a given distribution.

Will throw an exception if the distribution cannot be found.

To resolve the shared path, these rules will apply:

=over 2

=item * No arguments

Will use the caller package name.

=item * A dist name

To resolve the local path, by converting the dist name into a module name, and
look it up in C<%INC>. This means the module need to be loaded.

=item * A module name

See "A dist name" above.

=item * An object

Will find the class name for the object and apply the same rule as for "A
module name".

=back

=head2 to_app

  my $path = Mojo::File::Share->to_app($mojo_app);
  my $path = Mojo::File::Share->new("What-Ever")->to_app($mojo_app);

Used to apply the "public" and "templates" directories to you L<Mojolicious>'s
L<Mojolicious::Static> and L<Mojolicious::Renderer> objects.

=head1 AUTHOR

Jan Henning Thorsen

=head1 COPYRIGHT AND LICENSE

Copyright (C), Jan Henning Thorsen.

This program is free software, you can redistribute it and/or modify it under
the terms of the Artistic License version 2.0.

=head1 SEE ALSO

L<File::ShareDir::Install>

L<File::ShareDir>

L<File::Share>

=cut
