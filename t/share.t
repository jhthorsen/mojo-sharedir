use Mojo::Base -strict;
use Mojo::File::Share;
use Test::More;

my ($path, $share);

$share = Mojo::File::Share->new('Mojo::File::Share');
$path  = Mojo::File->new('share')->to_abs;
is $share, $path, 'found share dir for Mojo::File::Share';

$share = Mojo::File::Share->new('Mojo-File-Share', 'whatever');
$path  = $path->child('whatever');
is $share, $path, 'got whatever for Mojo::File::Share';

$share = Mojo::File::Share->new('Mojo::File::Share', '.gitignore');
ok -e $share, 'got gitignore for Mojo::File::Share';

eval { Mojo::File::Share->new('No::Such::Module') };
like $@, qr{Could not find dist path for "No::Such::Module"}, 'No::Such::Module';

done_testing;
