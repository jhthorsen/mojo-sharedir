package TestApp;
use Mojo::Base 'Mojolicious';

use Mojo::File::Share 'dist_path';

sub startup {
  my $self = shift;

  if ($ENV{TEST_FROM_CALLER}) {
    Mojo::File::Share->new->to_app($self);
  }
  elsif ($ENV{TEST_FROM_CLASS}) {
    Mojo::File::Share->to_app($self);
  }
  elsif ($ENV{TEST_FROM_FUNCTION}) {
    dist_path($self)->to_app($self);
  }
  else {
    Mojo::File::Share->new($self)->to_app($self);
  }
}

1;
