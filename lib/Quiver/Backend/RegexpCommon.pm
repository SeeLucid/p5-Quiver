package Quiver::Backend::RegexpCommon;

use strict;
use warnings;

use Moo;
use Regexp::Common qw/ comment /;
use File::Slurp qw/read_file/;
use List::BinarySearch qw(:all);
use Path::Class;
use Try::Tiny;
use Iterator;
use Iterator::Util;

extends qw(Quiver::Backend);
with('Quiver::SourceRole');

sub comments_iter {
	my ($self) = @_;
	my $files = $self->source->files;
	my $done = 0;
	my $comment = sub { undef };
	my $file = undef;
	my $file_iter = $self->_files_iter;
	return sub {
		return undef if $done;
		COMMENT:
		while( 1 ) {
			my $data = $comment->();
			if( not defined $data ) {
				if( $file_iter->is_exhausted ) {
					# no next file
					$done = 1;
					return undef;
				} else {
					$file = $file_iter->value();
					$comment = $self->_extract_comment_iter($file);
					next COMMENT;
				}
			} else {
				return $data;
			}
		}
	};
}

sub _files_iter {
	my ($self) = @_;
	my $files = $self->source->files;
	my $file_it = Iterator->new( sub {
		my $data = $files->each;
		Iterator::is_done unless defined $data;
		$data;
	} );
	igrep { $_ =~ /\.[ch]$/  } $file_it; # just C files
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
	my ($self, $schema, $options) = @_;
	my $iter = $self->comments_iter;
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

sub _convert_to_row {
	my ($self, $schema, $data) = @_;
	my $comment_symtype = $schema->resultset('Symtype')->find( { name => 'comment' } );
	my $scanfilemetaid = $schema->resultset('Scanfilemeta')->find(
		{ filename => file($data->{file}) } )->scanfilemetaid;
	return  {
		symtypeid => $comment_symtype->symtypeid,
		scanfilemetaid => $scanfilemetaid,

		linestart => $data->{start_line},
		lineend => $data->{end_line},

		# TODO: is using a URI a good idea?
		uri => ~~ URI->new("pos:$data->{start_pos},$data->{end_pos}" ),
	};
}

1;
