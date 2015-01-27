use Test::Most;

use strict;
use warnings;

use Quiver::Backend::SWIProlog;

my $doc = Quiver::Backend::SWIProlog->run('bagof');
use DDP; p $doc;



throws_ok
	{ Quiver::Backend::SWIProlog->run('agof') }
	'Quiver::Error::NotFound';

throws_ok
	{ Quiver::Backend::SWIProlog->run(q{a\\\\gof}); }
	'Quiver::Error::Input';

throws_ok
	{ Quiver::Backend::SWIProlog->run(q{a'b}); }
	'Quiver::Error::Input';

done_testing;
