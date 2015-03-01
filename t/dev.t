use Test::Most tests => 1;

use strict;
use warnings;

use Quiver::Backend::Perldoc;

# TODO Look more at <https://metacpan.org/source/PLAVEN/Padre-1.00/lib/Padre/Browser/PseudoPerldoc.pm>
my $doc = Quiver::Backend::Perldoc->run('Test::More');
like $doc, qr/I love it when a plan comes together/;

done_testing;
