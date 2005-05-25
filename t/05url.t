
use Test::More tests => 3;

my $class = qw(WebService::CaptchasDotNet);

use_ok($class);

{
  my $o = $class->new(secret   => 'secret',
                      username => 'demo');

  isa_ok($o, $class);

  my $random = 'RandomZufall';

  my $url = $o->url($random);

  is ($url,
      'http://image.captchas.net?client=demo&amp;random=RandomZufall',
      'url() generates the proper URL');
}
