package Quiver::Backend::MATLAB;

use strict;
use warnings;
use Capture::Tiny qw(capture);
use Quiver::Error;
use File::Which;

BEGIN {
	which('matlab')
		or Quiver::Error::Backend::NotAvailable
			->throw('matlab is not in the PATH');
}

sub run {
	my ($self, $doc) = @_;
	my ($stdout, $stderr, $exit) = capture {
		delete local $ENV{DISPLAY}; # unset so it doesn't use X11 display
		my $doc_escape = $doc =~ s/'/''/r; # double apostrophes to escape
		system( qw(matlab -nosplash -nodesktop -nojvm), '-r', "help '$doc_escape', exit"  );
	};

	# remove the MATLAB banner text
	$stdout =~ s/\A.*\QFor product information, visit www.mathworks.com.\E\s*//ms;
	# and trim whitespace and special characters at the end
	my $special_characters = "\e\[?1l\e>";
	$stdout =~ s/\s*\Q$special_characters\E\Z//ms;

	if( $stdout =~ /^\Q$doc\E not found.*Use the Help browser/ms ) {
		Quiver::Error::NotFound->throw( $stdout );
	}

	return $stdout;
}

1;
