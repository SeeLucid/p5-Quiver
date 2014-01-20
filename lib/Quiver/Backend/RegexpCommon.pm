package Quiver::Backend::RegexpCommon;

use strict;
use warnings;

use Moo;
use Regexp::Common qw/ comment /;
use File::Slurp qw/read_file/;
use List::BinarySearch qw(:all);

with('Quiver::SourceRole');

sub comments_iter {
	my ($self) = @_;
	my $files = $self->source->files;
	my $done = 0;
	my $comment = sub { undef };
	my $file = undef;
	return sub {
		return undef if $done;
		COMMENT:
		while( 1 ) {
			my $data = $comment->();
			if( not defined $data ) {
				FILE:
				while( defined( $file = $files->each ) ) {
					next FILE unless $file =~ /\.[ch]$/; # just C files
					$comment = $self->_extract_comment_iter($file);
					next COMMENT;
				}
				if( not defined $file ) {
					# no next file
					$done = 1;
					return undef;
				}
			} else {
				return $data;
			}
		}
	};
}

sub _extract_comment_iter {
	my ($self, $file) = @_;
	my $contents = read_file( $file );
	use feature 'unicode_strings'; # lexically turn on character semantics
	my @offsets=(0); push @offsets, $-[0] while $contents=~/\n/gc;
	pos($contents) = 0; # reset
	return sub {
		if($contents =~ /$RE{comment}{'C++'}{-keep}/g) {
			my $start_pos = $-[0] + 1;
			my $end_pos = $+[0];
			my $start_line = binsearch_pos { $a <=> $b } $start_pos, @offsets;
			my $end_line = binsearch_pos { $a <=> $b } $end_pos, @offsets;
			return {
				file => $file,
				text => "$1",
				start_pos => $start_pos,
				end_pos => $end_pos,
				start_line => $start_line,
				end_line => $end_line,
			};
		} else {
			return undef;
		}
	};
}

1;
