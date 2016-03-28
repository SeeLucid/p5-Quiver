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

extends qw(Quiver::Backend);
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
		'--verbose=yes',
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
	my ($self, $schema, $options) = @_;
	my $iter = $self->symbol_table_iter;
	$self->_populate_db($schema, $options, $iter);
}

sub _convert_to_row {
	my ($self, $schema, $data) = @_;
	my $func_symtype = $schema->resultset('Symtype')->find( { name => 'function definition' } );
	my $scanfilemetaid = $schema->resultset('Scanfilemeta')->find(
		{ filename => file($data->{file}) } )->scanfilemetaid;
	if( $data->{'kind'} eq 'f' ) {
		return  {
			name => $data->{name},
			symtypeid => $func_symtype->symtypeid,
			scanfilemetaid => $scanfilemetaid,

			linestart => $data->{addressLineNumber},

			# TODO: is using a URI a good idea?
			uri => ~~ URI->new('ctags:'. $data->{addressPattern}),
		};
	}
}

1;
