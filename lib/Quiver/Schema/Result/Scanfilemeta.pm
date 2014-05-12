use utf8;
package Quiver::Schema::Result::Scanfilemeta;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

Quiver::Schema::Result::Scanfilemeta

=cut

use strict;
use warnings;

use base 'DBIx::Class::Core';

=head1 TABLE: C<scanfilemeta>

=cut

__PACKAGE__->table("scanfilemeta");

=head1 ACCESSORS

=head2 scanfilemetaid

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0

=head2 filename

  data_type: 'text'
  is_nullable: 0

=head2 timelastmod

  data_type: 'integer'
  is_nullable: 0

=cut

__PACKAGE__->add_columns(
  "scanfilemetaid",
  { data_type => "integer", is_auto_increment => 1, is_nullable => 0 },
  "filename",
  { data_type => "text", is_nullable => 0 },
  "timelastmod",
  { data_type => "integer", is_nullable => 0 },
);

=head1 PRIMARY KEY

=over 4

=item * L</scanfilemetaid>

=back

=cut

__PACKAGE__->set_primary_key("scanfilemetaid");

=head1 UNIQUE CONSTRAINTS

=head2 C<filename_unique>

=over 4

=item * L</filename>

=back

=cut

__PACKAGE__->add_unique_constraint("filename_unique", ["filename"]);

=head1 RELATIONS

=head2 symbols

Type: has_many

Related object: L<Quiver::Schema::Result::Symbol>

=cut

__PACKAGE__->has_many(
  "symbols",
  "Quiver::Schema::Result::Symbol",
  { "foreign.scanfilemetaid" => "self.scanfilemetaid" },
  { cascade_copy => 0, cascade_delete => 0 },
);


# Created by DBIx::Class::Schema::Loader v0.07039 @ 2014-05-11 23:18:42
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:769DtCkZ/7nfxIB25jDFBw


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
