package Quiver::Backend::Role::WebArchive;

use strict;
use warnings;

use Moo::Role;

use HTTP::Tiny;
use Path::Class;

requires 'tarball_filename';
requires 'tarball_uri';

has tarball_file_path => ( is => 'lazy' );

sub _build_tarball_file_path {
	my ($self) = @_;
	my $http = HTTP::Tiny->new;
	my $response = $http->get( $self->tarball_uri );
	Quiver::Error::IO::Network->throw("Could not download: @{[$self->tarball_uri]}")
		unless $response->{success};
	my $dir = Path::Class::tempdir(CLEANUP => 1);
	my $archive_filename = $dir->file( $self->tarball_filename );
	$archive_filename->spew( iomode => '>:raw', $response->{content} );

	$archive_filename;
}

1;
