use utf8;
package Quiver::Schema;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

use strict;
use warnings;

use base 'DBIx::Class::Schema';

__PACKAGE__->load_namespaces;


# Created by DBIx::Class::Schema::Loader v0.07039 @ 2014-01-19 14:48:51
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:2Gjssjl+sssOS+FPRdlXvQ

use Try::Tiny;
use Moo;

after deploy => sub {
	my ($schema) = @_;
	$schema->populate_symtype;
};

=method populate_symtype()

Adds default symbol types to the Symtype table.

=cut
sub populate_symtype {
	my ($schema) = @_;
	my $rs;
	try {
		$rs = $schema->txn_do(sub {
			$schema->resultset('Symtype')->populate([
				[ qw(symtypeid name) ],
				[ 100, 'function definition' ],
				[ 101,  'function prototype' ],
				[ 102,             'comment' ],
				[ 103,       'documentation' ],
				[ 104,               'macro' ],
			]);
		});
	} catch {
		my $error = shift;
		$error->rethrow;
	};
}

1;
