package Quiver::Backend::Ctags;

use strict;
use warnings;

# TODO
# [X] read all symbols from file
# [ ] convert into internal index
# [ ] dump all function definitions
# [ ] find all comments in those files and try to match them with the function
#     definitions
# [ ] caching of filelist + timestamps / hash ?

use Parse::ExuberantCTags;
use File::Temp;
use Path::Class;
use URI;
use Try::Tiny;

use Moo;

with('Quiver::SourceRole');

has tags_file => ( is => 'rw', default => sub { File::Temp->new } );

sub _run_analysis {
	my ($self) = @_;

	# TODO: this should be a function in a package
	# for now, just call exuberant ctags with file list
	# create tempfile list of files
	my $files_fh = File::Temp->new();
	my $files = $self->source->files;
	for my $file (@$files) {
		print $files_fh "$file\n";
	}

	system('ctags',
		'-f', $self->tags_file,
		'-L', $files_fh->filename,
		'--fields=+n',);
}

sub symbol_table_iter {
	my ($self) = @_;
	$self->_run_analysis;

	my $parser = Parse::ExuberantCTags->new( $self->tags_file );
	my $tag = $parser->firstTag;
	return sub {
		my $old_tag = $tag;
		$tag = $parser->nextTag;
		return $old_tag;
	};
}

sub populate_db {
	my ($self, $schema) = @_;
	my $iter = $self->symbol_table_iter;

	my $coderef = sub {
		# TODO drop all symbols from files that come from this backend
		while( defined(  my $data = $iter->() ) ) {
			if( my $row = $self->_convert_to_row($schema, $data) ) {
				$schema->resultset('Symbol')->create( $row );
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

sub _convert_to_row {
	my ($self, $schema, $data) = @_;
	my $func_symtype = $schema->resultset('Symtype')->search( { name => 'function definition' } )->first;
	if( $data->{'kind'} eq 'f' ) {
		return  {
			name => $data->{name},
			symtypeid => $func_symtype->symtypeid,
			filename => ~~ file($data->{file}),

			linestart => $data->{addressLineNumber},

			# TODO: is using a URI a good idea?
			uri => ~~ URI->new('ctags:'. $data->{addressPattern}),
		};
	}
}

1;
