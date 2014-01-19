use utf8;
package Quiver::Schema::Result::Symtype;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

Quiver::Schema::Result::Symtype

=cut

use strict;
use warnings;

use base 'DBIx::Class::Core';

=head1 TABLE: C<symtype>

=cut

__PACKAGE__->table("symtype");

=head1 ACCESSORS

=head2 symtypeid

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0

=head2 name

  data_type: 'text'
  is_nullable: 0

=cut

__PACKAGE__->add_columns(
  "symtypeid",
  { data_type => "integer", is_auto_increment => 1, is_nullable => 0 },
  "name",
  { data_type => "text", is_nullable => 0 },
);

=head1 PRIMARY KEY

=over 4

=item * L</symtypeid>

=back

=cut

__PACKAGE__->set_primary_key("symtypeid");

=head1 RELATIONS

=head2 symbols

Type: has_many

Related object: L<Quiver::Schema::Result::Symbol>

=cut

__PACKAGE__->has_many(
  "symbols",
  "Quiver::Schema::Result::Symbol",
  { "foreign.symtypeid" => "self.symtypeid" },
  { cascade_copy => 0, cascade_delete => 0 },
);


# Created by DBIx::Class::Schema::Loader v0.07039 @ 2014-01-19 14:48:51
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:lKFnjtLYZ/Vm7Bthze1kUw


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
