package Quiver::Backend::GlibcTexinfo;

use strict;
use warnings;

# TODO find a better way to deal with texinfo install
use lib '/usr/share/texinfo';
use HTTP::Tiny;
use Path::Class;
use File::Temp ();

my $info_url = "https://www.gnu.org/software/libc/manual/info/libc-info.tar.gz";
my $info_archive_filename = "libc-info.tar.gz";
# via https://www.gnu.org/software/libc/manual/
# source
# tarballs
#     http://ftp.gnu.org/gnu/glibc/
#     e.g., http://ftp.gnu.org/gnu/glibc/glibc-2.21.tar.xz
# Git
#     git clone git://sourceware.org/git/glibc.git
#         manual/ directory
#         http://sourceware.org/git/?p=glibc.git;a=tree;f=manual;hb=HEAD

sub run {
	my ($self, $doc) = @_;

	my $http = HTTP::Tiny->new;
	my $response = $http->get( $info_url );
	die "Could not download" unless $response->{success};
	my $dir = Path::Class::tempdir(CLEANUP => 1);
	my $archive_filename = $dir->file($info_archive_filename);
	$archive_filename->spew( iomode => '>:raw', $response->{content} );

	my $tempfile = File::Temp->new();

	system(qw( info ),
		-o => $tempfile->filename,
		-f => $archive_filename,
		'--index-search' => $doc,
		);
	my $text = $tempfile->slurp;
}


1;
