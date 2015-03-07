use Test::More tests => 1;

use Quiver::Backend::GlibcTexinfo;

my $doc = Quiver::Backend::GlibcTexinfo->run('printf');

pass;

done_testing;
