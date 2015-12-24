package Quiver::Backend::SWIProlog;

use strict;
use warnings;
use Capture::Tiny qw(capture);
use Quiver::Error;
use File::Which;

BEGIN {
	which('swipl')
		or Quiver::Error::Backend::NotAvailable
			->throw('swipl is not in the PATH');
}


# /usr/lib/swi-prolog/library/MANUAL
# /usr/lib/swi-prolog/library/helpidx.pl

# TODO apropos/1 for searching
# TODO document the arguments to help/1

sub run {
	my ($self, $doc) = @_;
	my ($stdout, $stderr, $exit) = capture {
		delete local $ENV{DISPLAY}; # unset so it doesn't use X11 display
		system( qw(swipl -g),  "help($doc),halt" );
	};

	# trim newlines off the end
	$stdout =~ s/\n*$//sg;
	$stderr =~ s/\n*$//sg;

	if( $exit != 0 || $stderr ) {
		my $error_msg = $stderr;
		$error_msg .= $stdout if $stdout;
		Quiver::Error::Input->throw( $error_msg );
	}
	if( $stdout =~ /^No help available for/ ) {
		Quiver::Error::NotFound->throw( $stdout );
	}
	$stdout;
}

1;
