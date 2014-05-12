package Quiver::Backend;

use strict;
use Moo;

has name => ( is => 'ro',
	default => sub {
		my ($self) = @_;
		return ref $self =~ s/Quiver::Backend//gr;
	});

1;
