package Quiver::Backend::SWIProlog;

use strict;
use warnings;
use Capture::Tiny qw(capture);
# /usr/lib/swi-prolog/library/MANUAL
# /usr/lib/swi-prolog/library/helpidx.pl

sub run {
	my ($self, $doc) = @_;
	my ($stdout, $stderr, $success) = capture {
		delete local $ENV{DISPLAY}; # unset so it doesn't use X11 display
		system( qw(swipl -g),  "help('$doc'),halt" );
	};
	$stdout;
}

1;
