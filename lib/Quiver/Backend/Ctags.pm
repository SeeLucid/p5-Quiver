package Quiver;

use strict;
use warnings;

# TODO
# [ ] take a directory or list of source files as input
# [ ] call call ctags (or other tags file generator) and place in temp
# [ ] read all symbols from file
# [ ] convert into internal index
# [ ] dump all function definitions
# [ ] find all comments in those files and try to match them with the function
#     definitions

use Parse::ExuberantCTags;
use File::Temp;

sub symbol_table {
	$self->{_symbols} = {};
}

sub new {
	 my $
}

1;
