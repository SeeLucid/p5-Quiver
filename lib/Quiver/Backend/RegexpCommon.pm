package Quiver::Backend::RegexpCommon;

use strict;
use warnings;

use Moo;
use Regexp::Common qw/ comment /;
use File::Slurp qw/read_file/;
use List::BinarySearch qw(:all);
use Path::Class;
use Try::Tiny;

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

sub populate_db {
	my ($self, $schema) = @_;
	my $iter = $self->comments_iter;

	my $coderef = sub {
		while( defined(  my $data = $iter->() ) ) {
			if( my $row = $self->_convert_to_row($schema, $data) ) {
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

sub _convert_to_row {
	my ($self, $schema, $data) = @_;
	my $comment_symtype = $schema->resultset('Symtype')->search( { name => 'comment' } )->first;
	return  {
		symtypeid => $comment_symtype->symtypeid,
		filename => ~~ file($data->{file}),

		linestart => $data->{start_line},
		lineend => $data->{end_line},

		# TODO: is using a URI a good idea?
		uri => ~~ URI->new("pos:$data->{start_pos},$data->{end_pos}" ),
	};
}

1;
