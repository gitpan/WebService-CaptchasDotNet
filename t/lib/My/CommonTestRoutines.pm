package My::CommonTestRoutines;

use Cwd qw(cwd);
use File::Spec ();
use File::Path qw(rmtree);

use Test::More;

my $tmpdir = File::Spec->catfile(cwd, qw(t tmp));

sub tmpdir {
  return $tmpdir;
}

END {
  # cleanup

  ok (-e $tmpdir, "$tmpdir exists");

  chdir 't';
  rmtree 'tmp';

  ok (! -e $tmpdir, "$tmpdir removed");
}
