use Test::More;

use strict;
use warnings;

use Quiver::Backend::SWIProlog;

my $doc = Quiver::Backend::SWIProlog->run('bagof');
use DDP; p $doc;

done_testing;
