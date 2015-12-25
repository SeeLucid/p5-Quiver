package Quiver::Backend::Octave;

use strict;
use warnings;
use Capture::Tiny qw(capture);
use Quiver::Error;
use File::Which;

BEGIN {
	which('octave')
		or Quiver::Error::Backend::NotAvailable
			->throw('octave is not in the PATH');
}

sub run {
	my ($self, $doc) = @_;
	my ($stdout, $stderr, $exit) = capture {
		delete local $ENV{DISPLAY}; # unset so it doesn't use X11 display
		my $doc_escape = $doc =~ s/'/''/r; # double apostrophes to escape
		system( qw(octave -q --eval), "help '$doc_escape'"  );
	};

	if( $stderr =~ /^error: help: .* not found/ ) {
		Quiver::Error::NotFound->throw( $stdout );
	}

	return $stdout;
}

1;
