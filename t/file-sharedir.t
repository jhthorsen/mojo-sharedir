use Mojo::Base -strict;
use Mojo::File::Share;
use Test::More;

plan skip_all => 'File::ShareDir is not installed' unless eval 'require File::ShareDir;1';

my ($path, $share);

$share = Mojo::File::Share->new('File-ShareDir');
$path  = File::ShareDir::dist_dir('File-ShareDir');
is $path, $share, 'same dist result';

{
  local $TODO = 'Not supported yet.';
  $share = Mojo::File::Share->new('File::ShareDir');
  $path  = File::ShareDir::module_dir('File::ShareDir');
  is $path, $share, 'same module result';
}

done_testing;
