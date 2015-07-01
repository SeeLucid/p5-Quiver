use Test::Most tests => 2;

use strict;
use warnings;

use Quiver::Backend::Rstats;

subtest 'lookup R documentation' => sub {
	my $doc = Quiver::Backend::Rstats->run('data.frame');
	like $doc, qr/This function creates data frames/, "data.frame documentation contains the correct phrase";
};

subtest "errors in R documentation lookup" => sub {
	throws_ok { my $doc = Quiver::Backend::Rstats->run('not.an.r.function'); } 'Quiver::Error::NotFound', "no doc for 'not.an.r.function'";
};

done_testing;
