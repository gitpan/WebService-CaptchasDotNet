use strict;
use warnings FATAL => qw(all);

use ExtUtils::MakeMaker;

WriteMakefile(
  'NAME'              => 'WebService::CaptchasDotNet',
  'VERSION_FROM'      => 'CaptchasDotNet.pm',
  'PREREQ_PM'         => { 'Digest::MD5' => 0, },
);

sub MY::test {

  my $test = shift->MM::test(@_);

  eval { require Test::More; } or return <<EOF;
test::
\t\@echo sorry, cannot run tests without Test::More
EOF

  return $test;
}
