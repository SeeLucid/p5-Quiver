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

1;
