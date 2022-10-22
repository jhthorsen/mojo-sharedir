use Mojo::Base -strict;
use Mojo::ShareDir;
use Test::More;

subtest 'Find local share path by module name' => sub {
  my $share = Mojo::ShareDir->new('Mojo::ShareDir');
  my $path  = Mojo::File->new('share')->to_abs;
  is $share, $path, 'found share for Mojo::ShareDir';
};

subtest 'Find local share path by dist name' => sub {
  my $share = Mojo::ShareDir->new('Mojo-ShareDir', 'whatever');
  my $path  = Mojo::File->new(qw(share whatever))->to_abs;
  is $share, $path, 'got whatever for Mojo::ShareDir';

  $share = Mojo::ShareDir->new('Mojo::ShareDir', '.gitignore');
  ok -e $share, 'got gitignore for Mojo::ShareDir';
};

subtest 'Failed to find path for unknown module' => sub {
  eval { Mojo::ShareDir->new('No::Such::Module') };
  like $@, qr{Could not find dist path for "No::Such::Module"}, 'No::Such::Module';
};

done_testing;
