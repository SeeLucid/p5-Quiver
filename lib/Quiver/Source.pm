package Quiver::Source;

# TODO
# [ ] specify source files and directories to inspect
# [ ] add a file
# [ ] add a directory (recursively or not)
# [ ] use Path::Iterator::Rule

use strict;
use warnings;

use Path::Iterator::Rule;


sub new {
	my $class = shift;
	bless { _files => [], _dirs => [], _rules =>  }, $class;
}

sub add {
	my ($self, @items) = @_;
	for my $item (@items) {
		# TODO
	}
}

sub files {

}



1;
# ABSTRACT: one line description TODO

=pod

=head1 SYNOPSIS

  use My::Package; # TODO

  print My::Package->new;

=head1 DESCRIPTION

TODO

=cut
