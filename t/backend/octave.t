use Test::Most;

use strict;
use warnings;

BEGIN {
	eval "use Quiver::Backend::Octave";
	if( $@ =~ /Quiver::Error::Backend::NotAvailable/ ) {
		plan skip_all => "$@";
	} elsif( $@ ) {
		die $@;
	}
}

plan tests => 2;

subtest 'lookup Octave documentation' => sub {
	my $doc = Quiver::Backend::Octave->run('sum');
	like $doc,
		qr/Sum of elements along dimension DIM/,
		"sum documentation contains the correct phrase";

	my $doc_apo_escape = Quiver::Backend::Octave->run(".'");
	like $doc_apo_escape,
		qr/Matrix transpose operator.*_not_ the complex conjugate transpose/s,
		"correct documentation for the .' matrix transpose operator: escaped quote properly";
};


subtest "errors in Octave documentation lookup" => sub {
	throws_ok
		{ my $doc = Quiver::Backend::Octave->run('not_an_octave_function'); }
		'Quiver::Error::NotFound',
		"no doc for 'not_an_octave_function'";
};

done_testing;
