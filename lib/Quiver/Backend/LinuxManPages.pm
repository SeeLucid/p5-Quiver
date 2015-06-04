package Quiver::Backend::LinuxManPages;

use strict;
use warnings;

use Quiver::Error;
use Moo;
use HTML::LinkExtor;
# Debian:
#     dpkg -L manpages-dev

has tarball_filename => ( is => 'lazy' );
sub _build_tarball_filename {
	my ($self) = @_;
	my $uri = URI->new( $self->tarball_uri );
	($uri->path_segments)[-1];
}

has tarball_uri => ( is => 'lazy' );
sub _build_tarball_uri {
	my $manpage_download_page = "https://www.kernel.org/pub/linux/docs/man-pages/";
	my $http = HTTP::Tiny->new;
	my $response = $http->get( $manpage_download_page );
	Quiver::Error::IO::Network->throw("Could not download: $manpage_download_page")
		unless $response->{success};
	my @links;
	my $cb = sub {
		my($tag, %attr) = @_;
		return if $tag ne 'a';
		return unless exists $attr{href};
		push(@links, $attr{href});
	};
	my $extractor = HTML::LinkExtor->new($cb, $manpage_download_page);

	$extractor->parse( $response->{content} );
	@links = grep { /man-pages-\d+\.\d+\.tar\.xz$/ } @links;
	my @sorted_links = sort @links;
	$sorted_links[-1];
}

# <https://www.kernel.org/pub/linux/docs/man-pages/>
# via <https://www.kernel.org/doc/man-pages/download.html>
# <http://man7.org/linux/man-pages/index.html>
with qw(Quiver::Backend::Role::WebArchive);

sub run {
	my ($self, $doc) = @_;
}


1;
