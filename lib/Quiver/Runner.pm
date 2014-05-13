package Quiver::Runner;

use strict;
use Moo;
use Try::Tiny;
use File::stat;
use Digest::MD5;

has schema => ( is => 'rw', required => 1 );

has _backends => ( is => 'rw',
	default => sub {[]} );

=method add_backend( @backends )

Adds backends for this runner to execute when it initiates scanning.

=cut
sub add_backend {
	my ($self, @backends) = @_;
	for (@backends) {
		# TOOD make typechecking use ->can() instead
		die "Not of type Quiver::Backend: $_" unless $_->isa("Quiver::Backend");
	}
	push @{ $self->_backends }, @backends;
}


sub _register_backend {
	my ($self, $backend) = @_;
	$self->schema->resultset('Source')->find_or_create(
		{ name => $backend->name } );
}

sub _record_source_metadata {
	my ($self, $backend) = @_;
	return unless $backend->can('source');
	my $files = $backend->source->files;
	for my $file (@$files) {
		next unless -f $file;

		my $stat = stat( $file );
		my $timelastmod = $stat->mtime;

		$self->schema->resultset('Scanfilemeta')->update_or_create({
			filename => $file,
			timelastmod => $timelastmod, });
	}
}

sub _initiate_scan {
	my ($self, $backend) = @_;
	my $sourceid;
	try {
		$sourceid = $self->schema
			->resultset('Source')
			->find( { name => $backend->name } )
			->sourceid;
	} catch {
		die "could not find source name";
	};
	my $timestarted = time;
	# record start of scan after scan is finished
	my $scan = $self->schema->resultset('Scan')->create({
		sourceid => $sourceid,
		timestarted => $timestarted, });

	$backend->populate_db( $self->schema, { scan => $scan  } );
}

# TODO see if this can be done in parallel?
=method scan()

Runs scan on each of the registered backends.

=cut
sub scan {
	my ($self) = @_;
	for my $backend (@{ $self->_backends }) {
		my $rs;
		try {
			$rs = $self->schema->txn_do( sub {
				$self->_register_backend($backend);
				$self->_record_source_metadata($backend);
				$self->_initiate_scan( $backend );
			});
		} catch {
			my $error = shift;
			# Transaction failed
			die "something terrible has happened!"
				if ($error =~ /Rollback failed/);          # Rollback failed
			$error->rethrow;
		};
	}
}



1;
