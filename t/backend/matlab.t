use Test::Most;

use strict;
use warnings;

BEGIN {
	eval "use Quiver::Backend::MATLAB";
	if( $@ =~ /Quiver::Error::Backend::NotAvailable/ ) {
		plan skip_all => "$@";
	} elsif( $@ ) {
		die $@;
	}
}

plan tests => 2;

subtest 'lookup MATLAB documentation' => sub {
	my $doc = Quiver::Backend::MATLAB->run('sum');
	like $doc,
		qr/is the sum of the elements of the vector X/,
		"sum documentation contains the correct phrase";
	like $doc, qr|gpuArray/sum\Z|, "Removed whitespace and special characters";

	my $doc_apo_escape = Quiver::Backend::MATLAB->run(".'");
	like $doc_apo_escape,
		qr/is the non-conjugate transpose./s,
		"correct documentation for the .' matrix transpose operator: escaped quote properly";
};


subtest "errors in MATLAB documentation lookup" => sub {
	throws_ok
		{ my $doc = Quiver::Backend::MATLAB->run('not_an_matlab_function'); }
		'Quiver::Error::NotFound',
		"no doc for 'not_an_matlab_function'";
};

done_testing;
