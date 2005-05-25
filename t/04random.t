
use Test::More tests => 8;

my $class = qw(WebService::CaptchasDotNet);

use_ok($class);

{
  my $o = $class->new;

  isa_ok($o, $class);

  my $string = $o->random;

  ok ($string,
      "random string '$string' returned");

  my $string2 = $o->random;

  ok ($string,
      "another random string '$string2' returned");

  isnt ($string,
        $string2,
        'random strings from the same object are not equal');
}

{
  my $string = $class->random;

  ok ($string,
      "random string '$string' returned from class interface");

  my $string2 = $class->random;

  ok ($string,
      "another random string '$string2' returned from class interface");

  isnt ($string,
        $string2,
        'random strings from class interface are not equal');
}
