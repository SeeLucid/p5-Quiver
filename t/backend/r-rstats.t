use Test::Most;

use strict;
use warnings;

BEGIN {
	eval "use Quiver::Backend::Rstats";
	if( $@ =~ /Quiver::Error::Backend::NotAvailable/ ) {
		plan skip_all => "$@";
	} elsif( $@ ) {
		die $@;
	}
}

plan tests => 3;

subtest 'lookup R documentation' => sub {
	my $doc = Quiver::Backend::Rstats->run('data.frame');
	like $doc,
		qr/This function creates data frames/,
		"data.frame documentation contains the correct phrase";
};

subtest 'lookup R documentation in a library' => sub {
	throws_ok
		{ my $doc = Quiver::Backend::Rstats->run('grid.bezier'); }
		'Quiver::Error::NotFound',
		"no doc for 'grid.bezier' when the 'grid' library is not loaded";

	my $doc_w_lib = Quiver::Backend::Rstats->run('grid.bezier', libraries => ['grid'] );
	like $doc_w_lib,
		qr/These functions create and draw Bezier Curves/,
		"grid.bezier documentation contains the correct phrase";
};

subtest "errors in R documentation lookup" => sub {
	throws_ok
		{ my $doc = Quiver::Backend::Rstats->run('not.an.r.function'); }
		'Quiver::Error::NotFound',
		"no doc for 'not.an.r.function'";
};

done_testing;
