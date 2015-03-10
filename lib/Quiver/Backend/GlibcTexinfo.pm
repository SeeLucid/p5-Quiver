package Quiver::Backend::GlibcTexinfo;

use strict;
use warnings;

use Moo;

# TODO find a better way to deal with texinfo install
#use lib '/usr/share/texinfo';
use File::Temp ();

has tarball_filename => ( is => 'ro', default => sub { 'libc-info.tar.gz' } );
has tarball_uri => ( is => 'ro',
	default => sub { "https://www.gnu.org/software/libc/manual/info/libc-info.tar.gz" } );
# via https://www.gnu.org/software/libc/manual/
# source
# tarballs
#     http://ftp.gnu.org/gnu/glibc/
#     e.g., http://ftp.gnu.org/gnu/glibc/glibc-2.21.tar.xz
# Git
#     git clone git://sourceware.org/git/glibc.git
#         manual/ directory
#         http://sourceware.org/git/?p=glibc.git;a=tree;f=manual;hb=HEAD

with qw(Quiver::Backend::Role::WebArchive);

sub run {
	my ($self, $doc) = @_;
	my $archive_filename = $self->tarball_file_path;

	my $tempfile = File::Temp->new;

	system(qw( info ),
		-o => $tempfile->filename,
		-f => $archive_filename,
		"--index-search=$doc",
		);

	my $text = file($tempfile->filename)->slurp;
}


1;
