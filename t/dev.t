use Test::More tests => 1;

use Quiver::Backend::GlibcTexinfo;

my $info = Quiver::Backend::GlibcTexinfo->new;
my $doc = $info->run('printf');
use DDP; p $doc;

pass;

done_testing;
