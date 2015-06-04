use Test::Most tests => 3;

use strict;
use warnings;

use Quiver::Backend::SWIProlog;

subtest "bagof documentation" => sub {
	my $doc = Quiver::Backend::SWIProlog->run('bagof');
	like( $doc, qr/bagof\([^)]*\)/ );
};

subtest 'valid Prolog identifiers' => sub {
	my @valid_identifiers = (
		qw( help apropos ),
		'\\+', '#/\\', '?=', '**',
		qw(statistics statistics/0 statistics/2)
	);
	for my $ident (@valid_identifiers) {
		ok(Quiver::Backend::SWIProlog->run($ident), "Got documentation for SWI-Prolog $ident");
	}
};

subtest 'errors' => sub {
	throws_ok
		{ Quiver::Backend::SWIProlog->run('agof') }
		'Quiver::Error::NotFound',
		"no doc found for 'agof'";

	throws_ok
		{ Quiver::Backend::SWIProlog->run(q{a\\\\gof}); }
		'Quiver::Error::Input';

	throws_ok
		{ Quiver::Backend::SWIProlog->run(q{a'b}); }
		'Quiver::Error::Input';
};

done_testing;
