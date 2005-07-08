use 5.006;

use strict;
use warnings FATAL => qw(all);

use ExtUtils::MakeMaker;

WriteMakefile(
  'NAME'              => 'WebService::CaptchasDotNet',
  'VERSION_FROM'      => 'CaptchasDotNet.pm',
  'PREREQ_PM'         => { 'Digest::MD5' => 0,
                           'IO::File'    => 0,
                           'IO::Dir'     => 0,
                           'File::Spec'  => 0,
                           'File::Path'  => 0,
                           'Cwd'         => 0, },
);

sub MY::test {

  my $test = shift->MM::test(@_);

  eval { require Test::More } or return <<EOF;
test::
\t\@echo sorry, cannot run tests without Test::More
EOF

  if (eval { require Devel::Cover }) {
    $test .= <<EOF;
testcover ::
	cover -delete
	HARNESS_PERL_SWITCHES=-MDevel::Cover make test
	cover
EOF
  }

  return $test;
}
