use Test::More;

use strict;
use warnings;

use Quiver::Backend::SWIProlog;

my $doc = Quiver::Backend::SWIProlog->run('bagof');
use DDP; p $doc;

my $doc1 = Quiver::Backend::SWIProlog->run('agof');
use DDP; p $doc1;

my $doc2 = Quiver::Backend::SWIProlog->run(q{a\\\\gof});
use DDP; p $doc2;
is( $doc2, 'No help available for a\\\\gof' );

my $doc3 = Quiver::Backend::SWIProlog->run(q{a'b});
use DDP; p $doc3;
is( $doc3, q{No help available for a'b} );

done_testing;
