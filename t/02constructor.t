
use Test::More tests => 13;

my $class = qw(WebService::CaptchasDotNet);

use_ok($class);

{
  my $o = $class->new;

  isa_ok($o, $class);

  ok (exists $o->{_secret},
      "private attribute '_secret' exists");

  ok (! defined $o->{_secret},
      "private attribute '_secret' is undef");

  ok (exists $o->{_uid},
      "private attribute '_uid' exists");

  ok (! defined $o->{_secret},
      "private attribute '_uid' is undef");
}

{
  my $o = $class->new(secret => 'mysecret');

  isa_ok($o, $class);

  is ($o->{_secret},
      'mysecret',
      "private attribute '_secret' properly populated");

  ok (exists $o->{_uid},
      "private attribute '_uid' exists");

  ok (! defined $o->{_uid},
      "private attribute '_uid' is undef");
}

{
  my $o = $class->new(secret   => 'mysecret',
                      username => 'demo');

  isa_ok($o, $class);

  is ($o->{_secret},
      'mysecret',
      "private attribute '_secret' properly populated");

  is ($o->{_uid},
      'demo',
      "private attribute '_uid' properly populated");
}
