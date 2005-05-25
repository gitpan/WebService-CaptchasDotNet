
use Test::More tests => 8;

my $class = qw(WebService::CaptchasDotNet);

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
  my $ok = $o->verify('wvphhh', 'RandomZufall');

  ok (! $ok,
      'captcha mismatch');
}

{
  my $ok = $o->verify('wvphnh', 'RandomZufall');

  ok ($ok,
      'captcha match');
}

