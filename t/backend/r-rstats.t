use Test::Most tests => 2;

use strict;
use warnings;

use Quiver::Backend::Rstats;

{
	my $doc = Quiver::Backend::Rstats->run('data.frame');
	like $doc, qr/This function creates data frames/, "data.frame documentation contains the correct phrase";
}

{
	throws_ok { my $doc = Quiver::Backend::Rstats->run('not.an.r.function'); } 'Quiver::Error::NotFound', "no doc for 'not.an.r.function'";
}

done_testing;
