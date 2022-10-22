use Mojo::Base -strict;
use Mojo::File::Share;
use Test::More;

subtest 'Find local share path by module name' => sub {
  my $share = Mojo::File::Share->new('Mojo::File::Share');
  my $path  = Mojo::File->new('share')->to_abs;
  is $share, $path, 'found share for Mojo::File::Share';
};

subtest 'Find local share path by dist name' => sub {
  my $share = Mojo::File::Share->new('Mojo-File-Share', 'whatever');
  my $path  = Mojo::File->new(qw(share whatever))->to_abs;
  is $share, $path, 'got whatever for Mojo::File::Share';

  $share = Mojo::File::Share->new('Mojo::File::Share', '.gitignore');
  ok -e $share, 'got gitignore for Mojo::File::Share';
};

subtest 'Failed to find path for unknown module' => sub {
  eval { Mojo::File::Share->new('No::Such::Module') };
  like $@, qr{Could not find dist path for "No::Such::Module"}, 'No::Such::Module';
};

done_testing;
