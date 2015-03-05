use Test::Most tests => 2;

use strict;
use warnings;

use Quiver::Backend::Rstats;

{
	my $doc = Quiver::Backend::Rstats->run('data.frame');
	like $doc, qr/This function creates data frames/;
}

{
	throws_ok { my $doc = Quiver::Backend::Rstats->run('not.an.r.function'); } 'Quiver::Error::NotFound';
}

done_testing;
