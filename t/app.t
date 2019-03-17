use Mojo::Base -strict;
use Test::Mojo;
use Test::More;

use lib 't/lib';
plan skip_all => 'Cannot read TestApp' unless -d $INC[0];

for my $key (qw(test_from_caller test_from_class test_from_function test_from_object)) {
  local $ENV{uc $key} = 1;

  my $t     = Test::Mojo->new('TestApp');
  my $share = Mojo::File->new(qw(t share))->to_abs;
  my $paths;

  diag join ' - ', @{$t->app->static->paths};
  $paths = $t->app->static->paths;
  is $paths->[0], $share->child('public'), "$key static";
  is @$paths, 1, "$key removed default path";

  diag join ' - ', @{$t->app->renderer->paths};
  $paths = $t->app->renderer->paths;
  is $paths->[0], $share->child('templates'), "$key template";
  is @$paths, 1, "$key removed default path";
}

done_testing;
