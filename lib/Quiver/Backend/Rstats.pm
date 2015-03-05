package Quiver::Backend::Rstats;

use strict;
use warnings;
use Capture::Tiny qw(capture);
use Quiver::Error;

sub run {
	my ($self, $doc) = @_;
	my ($stdout, $stderr, $exit) = capture {
		delete local $ENV{DISPLAY}; # unset so it doesn't use X11 display
		my $doc_escape = $doc =~ s/([\\'])/\\$1/r;
		system( qw(Rscript -e), "help('$doc_escape')"  );
	};

	if( $stdout =~ /^No documentation for/ ) {
		Quiver::Error::NotFound->throw( $stdout );
	}

	return $stdout;
}


1;
