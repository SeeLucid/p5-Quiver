use Test::Most;

use strict;
use warnings;

use Quiver::Backend::SWIProlog;

my $doc = Quiver::Backend::SWIProlog->run('bagof');
like( $doc, qr/bagof\([^)]*\)/ );

ok(Quiver::Backend::SWIProlog->run('help'));
ok(Quiver::Backend::SWIProlog->run('apropos'));

ok(Quiver::Backend::SWIProlog->run('\\+'));
ok(Quiver::Backend::SWIProlog->run('#/\\'));
ok(Quiver::Backend::SWIProlog->run('?='));
ok(Quiver::Backend::SWIProlog->run('**'));

ok(Quiver::Backend::SWIProlog->run('statistics'));
ok(Quiver::Backend::SWIProlog->run('statistics/0'));
ok(Quiver::Backend::SWIProlog->run('statistics/2'));

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
