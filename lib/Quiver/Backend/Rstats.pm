package Quiver::Backend::Rstats;

use strict;
use warnings;
use Capture::Tiny qw(capture);
use Quiver::Error;
use File::Which;

BEGIN {
	which('Rscript')
		or Quiver::Error::Backend::NotAvailable
			->throw('Rscript is not in the PATH');
}

sub run {
	my ($self, $doc, %rest) = @_;
	my @pre_expression = ();
	my $library_code = "";
	if( exists $rest{libraries} ) {
		$library_code = join "; ", map { "library('$_')" } @{ $rest{libraries} };
		push @pre_expression, $library_code;
	}
	my ($stdout, $stderr, $exit) = capture {
		delete local $ENV{DISPLAY}; # unset so it doesn't use X11 display
		my $doc_escape = $doc =~ s/([\\'])/\\$1/r;
		my @pre_expression_args = map { (qw(-e), $_) } @pre_expression;
		system( qw(Rscript), @pre_expression_args, qw(-e), "help('$doc_escape')"  );
	};

	if( $stdout =~ /^No documentation for/ ) {
		Quiver::Error::NotFound->throw( $stdout );
	}

	return $stdout;
}


1;
