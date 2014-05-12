package Quiver::Backend;

use strict;
use Moo;

has name => ( is => 'ro',
	default => sub {
		my ($self) = @_;
		return ref($self) =~ s/^Quiver::Backend:://r;
	});

# TODO Maybe this can be put somewhere better
sub _drop_symbols_with_backend {
	my ($self, $schema, $sourceid) = @_;
	# drop all symbols from the same set of files we are working
	# with that come from this backend
	my $files = $self->source->files;
	for my $file (@$files) {
		my $delete_rs = $schema->resultset('Symbol')->search(
			{ 'scanfilemetaid.filename' => $file,
			  'scanid.sourceid' => $sourceid },
			{ join => [ qw( scanfilemetaid scanid ) ] }  );
		$delete_rs->delete_all;
	}
}

1;
