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
  my $share = $class->SUPER::new(@$path, 'share');
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
