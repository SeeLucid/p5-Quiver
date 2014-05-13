package Quiver::Backend;

use strict;
use Moo;
use Try::Tiny;

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

# TODO document the methods used here
sub _populate_db {
	my ($self, $schema, $options, $iter) = @_;
	my $scanid = $options->{scan}->scanid;
	my $sourceid = $options->{scan}->get_column('sourceid');

	my $coderef = sub {
		$self->_drop_symbols_with_backend($schema, $sourceid);
		while( defined(  my $data = $iter->() ) ) {
			if( my $row = $self->_convert_to_row($schema, $data) ) {
				$row->{scanid} = $scanid;
				my $symbol_row = $schema->resultset('Symbol')
					->create( $row );
				$symbol_row->create_related('symboltext', {
					symboltext => $data->{text}
				}) if exists $data->{text};
			}
		}
	};

	my $rs;
	try {
		$rs = $schema->txn_do($coderef);
	} catch {
		my $error = shift;
		# Transaction failed
		die "something terrible has happened!"
			if ($error =~ /Rollback failed/);          # Rollback failed
		$error->rethrow;
	};
}

1;
