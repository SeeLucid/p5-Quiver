package Quiver::Source;

# TODO
# [ ] specify source files and directories to inspect
# [ ] add a file
# [ ] add a directory (recursively or not)
# [ ] use Path::Iterator::Rule

use strict;
use warnings;

use Path::Class;
use Path::Iterator::Rule;
use Set::Scalar;

sub new {
	my $class = shift;
	bless { _files => Set::Scalar->new,
		_dirs => Set::Scalar->new,
		_coderefs => Set::Scalar->new, }, $class;
}


=method add( @items )

@items is a list made up of strings of file names, strings of directory names,
and coderefs that return lists of files


    $src->add( 'main.c' );
    $src->add( 'list.c', '/path/to/src/',
                   sub {
                       Path::Iterator::Rule->new->file->name(qr/\.pm$/)->all( @INC );
                   } );

=cut
sub add {
	my ($self, @items) = @_;
	for my $item (@items) {
		if( -f $item ) {
			$self->{_files}->insert( file($item)->stringify );
		} elsif( -d $item ) {
			$self->{_dirs}->insert( dir($item)->stringify );
		} elsif( ref $item eq 'CODE' ) {
			$self->{_coderefs}->insert($item);
		} elsif( ref $item->CAN('_get_items') ) {
			# for adding another Quiver::Source
			push @items, $item->_get_items;
		} else {
			die "Could not add item: $item\n";
		}
	}
}

# returns all items stored
sub _get_items {
	my ($self) = @_;
	( $self->{_files}->members,
		$self->{_dirs}->members,
		$self->{_coderefs}->members );
}

=method files()

returns a L<Set::Scalar> that contains all files from the items added using C<add()>.

=cut
sub files {
	my ($self) = @_;
	my $files = Set::Scalar->new();

	$files->union( $self->{_files} );

	if( $self->{_dirs}->members ) {
		$files->insert( Path::Iterator::Rule->new
				->file->all( $self->{_dirs}->members ));
	}

        while (defined(my $rule = $self->{_coderefs}->each)) {
		my @files = $rule->();
		$files->insert( @files );
	}
	$files;
}



1;
# ABSTRACT: store a list of files to scan

=pod

=head1 SYNOPSIS

  use Quiver::Source;

  my $src = Quiver::Source->new;
  $src->add( 'main.c', '/usr/include' );
  my $file_set = $src->files;

=head1 DESCRIPTION

This class is used to represent a set of files to run the analysis over.

=cut
