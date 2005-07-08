use strict;
use warnings FATAL => qw(all);

use Cwd qw(cwd);
use File::Spec ();

use lib File::Spec->catfile(cwd, qw(t lib));
use My::CommonTestRoutines;

# localize tmpdir to our test directory
no warnings qw(once);
my $tmpdir = My::CommonTestRoutines->tmpdir;
local *File::Spec::tmpdir = sub { $tmpdir };


use Test::More tests => 6;

my $class = qw(WebService::CaptchasDotNet);

use_ok($class);

{
  no warnings qw(redefine);
  local *Digest::MD5::hexdigest = sub { 'cleantest' };

  # create the directory
  my $o = $class->new(expire => 2);

  my $file = File::Spec->catfile($tmpdir,
                                 qw(CaptchasDotNet cleantest));

  ok (! -e $file,
      'cache file does not exist');

  # put a known random file in it
  my $random = $o->random;

  ok (-e $file,
      'cache file exists');

  sleep 3;

  $o->_cleanup();

  ok (! -e $file,
      'cache file was removed');
}
