package Quiver::Backend::RegexpCommon;

use strict;
use warnings;

use Moo;
use Regexp::Common qw/ comment /;
use File::Slurp qw/read_file/;

with('Quiver::SourceRole');

sub get_comments {
	my ($self) = @_;
	my $files = $self->source->files;
	for my $file (@$files) {
		next unless $file =~ /\.[ch]$/; # just C files
		my $contents = read_file( $file );
		while( $contents =~ /$RE{comment}{'C++'}{-keep}/g ) {
			print "$file: $1\n";
		}
	}
}

1;
