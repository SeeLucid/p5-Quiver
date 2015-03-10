use Test::More tests => 1;

use strict;
use warnings;

use Quiver::Backend::GlibcTexinfo;
use Quiver::Backend::LinuxManPages;

do {
	my $info = Quiver::Backend::GlibcTexinfo->new;
	my $doc = $info->run('printf');
	use DDP; p $doc;
} if 0;

do {
	my $info = Quiver::Backend::LinuxManPages->new;
	use DDP; p $info->tarball_uri;
};

pass;

done_testing;
