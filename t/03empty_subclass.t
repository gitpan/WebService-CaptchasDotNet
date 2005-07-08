use strict;
use warnings FATAL => qw(all);

use Cwd qw(cwd);
use File::Spec ();

use lib File::Spec->catfile(cwd, qw(t lib));
use My::CommonTestRoutines;

# localize tmpdir to our test directory
no warnings qw(once);
local *File::Spec::tmpdir = sub { My::CommonTestRoutines->tmpdir };


use Test::More tests => 12;

# same as 03verify.t but with the subclass
my $class = qw(My::EmptySubclass);

use_ok($class);

{
  my $o = $class->new;

  my $ok = $o->verify('wvphnh', 'RandomZufall');

  ok (! $ok,
      'no secret');
}

my $o = $class->new(secret   => 'secret',
                    username => 'demo');

{
  my $ok = $o->verify;

  ok (! $ok,
      'no captcha or random arguments');
}

{
  my $ok = $o->verify('wvphnh');

  ok (! $ok,
      'no random argument');
}

{
  my $ok = $o->verify(undef, 'RandomZufall');

  ok (! $ok,
      'no input argument');
}

{
  my $ok = $o->verify('wvphn', 'RandomZufall');

  ok (! $ok,
      'improper captcha length');
}

{
  my $ok = $o->verify('wvph1h', 'RandomZufall');

  ok (! $ok,
      'improper captcha contents');
}

{
  my $ok = $o->verify('wvphnh', 'RandomZufall');

  ok (! $ok,
      'captcha match but no sanity file');
}


{
  my $file = File::Spec->catfile(My::CommonTestRoutines->tmpdir,
                                 qw(CaptchasDotNet RandomZufall));

  my $fh = IO::File->new(">$file");
  undef $fh;

  {
    my $ok = $o->verify('wvphhh', 'RandomZufall');

    ok (! $ok,
        'captcha mismatch');
  }

  {
    my $ok = $o->verify('wvphnh', 'RandomZufall');

    ok ($ok,
        'captcha match');
  }
}
