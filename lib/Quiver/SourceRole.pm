package Quiver::SourceRole;

use strict;
use warnings;
use Moo::Role;

# take a list of source files as input
has source => ( is => 'rw', required => 1 );

1;
