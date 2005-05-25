package WebService::CaptchasDotNet;

use strict;
use warnings FATAL => qw(all);

use Digest::MD5 qw(md5 md5_hex);

our $VERSION = 0.01;

my @letters = 'a'..'z';

sub new {

  my $class = shift;

  my %args = @_;

  return bless { _secret => $args{secret},
                 _uid    => $args{username},
               }, $class;
}

sub verify {

  my $self = shift;

  my ($captcha, $random) = @_;

  my $secret = $self->{_secret};

  # basic sanity checking

  return unless $secret;                    # secret required

  return unless $captcha && $random;        # both are required

  return unless $captcha =~ m/^[a-z]{6}$/; # the captcha is always
                                            # 6 lowercase letters

  # now for the computation
  my $decode = join '', $secret, $random;

  my $pass = '';

  foreach my $byte (split //, md5($decode)) {
    $pass .= $letters[ord($byte) % 26];
  }

  return $captcha eq substr($pass, 0, 6);
}

sub random {

  my $self = shift;

  my $string = join '', ('.', '/', 0..9,
                         'A'..'Z', 'a'..'z')[rand 64, rand 64,
                                             rand 64, rand 64,
                                             rand 64, rand 64,
                                             rand 64, rand 64,
                                             rand 64, rand 64,
                                             rand 64, rand 64,
                                             rand 64, rand 64,
                                             rand 64, rand 64,
                                             rand 64, rand 64,
                                             rand 64, rand 64,
                                            ];

  return md5_hex($string);
}

sub url {

  my $self = shift;

  my $random = shift;

  my $user = $self->{_uid};

  return "http://image.captchas.net?client=$user&amp;random=$random";
}

1;

__END__

=head1 NAME 

WebService::CaptchasDotNet - routines for captchas.net free captcha service

=head1 SYNOPSIS

  # create the object
  my $o = WebService::CaptchasDotNet->new(secret   => 'secret',
                                          username => 'demo');

  # generate a random string using a convenience method
  my $random = $o->random;

  # generate an image url
  my $url = $o->url($random);

  # verify that the typed captcha and image are a match
  my $ok = $o->verify($user_input, $random);

=head1 DESCRIPTION

WebService::CaptchasDotNet contains several useful routines for using the
free captcha service at http://captchas.net.

to use these routines you will need to visit http://captchas.net and
register with them.  they will provide you with a username and a
shared secret key that you will need for these routines to work.

=head1 CONSTRUCTOR

=over 4

=item new()

instantiate a new WebService::CaptchasDotNet object.

  my $o = WebService::CaptchasDotNet->new(secret   => 'secret',
                                          username => 'demo');

the 'secret' parameter represents the secret key assigned to
you when you registered with the captchas.net service.  the
'username' parameter is your assigned username.  both are
required for things to work properly, but you will always get
a valid object back.

=back

=head1 METHODS

=over 4

=item verify()

this is the heart of the interface, the verification routine.
basically it takes the captcha phrase that the user entered and
checks whether it matches the image presented by captchas.net.

  my $ok = $o->verify($user_input, $random_string);

here '$user_input' is what the user keyed in, and '$random_string'
is the random string you attached to the captchas.net URL.  for
example, if the URL you presented on the webpage was

  http://image.captchas.net?client=demo&random=RandomZufall

then the call would look like

  my $ok = $o->verify($user_input, 'RandomZufall');

so basically you need to keep track of the random string
yourself between calls.

verify() returns true if the user correctly identified the
captcha image string and false otherwise.

=item random()

random() is a utility method that will generate random strings for
you.  

  # object method
  my $random = $o->random;

  # class method
  my $random = WebService::CaptchasDotNet->random;

the captchas.net service suggests that you never use the same
random string twice in your urls, so this method is there to help.
it isn't guaranteed to be completely random given an infinite number
of calls, but it should be sufficiently random for these specific
purposes.

=item url()

generate a suitable captchas.net URL for embedding within a webpage.

  my $url = $o->url($random_string);

the returned URL will have both the passed random string and the
username provided with the class constructor embedded within it.
for example

  my $o = WebService::CaptchasDotNet->new(secret   => 'secret',
                                          username => 'demo');

  my $random = 'RandomZufall';

  # http://image.captchas.net?client=demo&amp;random=RandomZufall
  my $url = $o->url($random);

it is important to note that the returned URL is not encoded with
the exception of the ampersand - if you use your own random routine
and it included funky characters you're on your own.

=back

=head1 SEE ALSO

http://captchas.net/

=head1 AUTHOR

Geoffrey Young <geoff@modperlcookbook.org>

=head1 COPYRIGHT

Copyright (c) 2005, Geoffrey Young
All rights reserved.

This module is free software.  It may be used, redistributed
and/or modified under the same terms as Perl itself.

=cut
