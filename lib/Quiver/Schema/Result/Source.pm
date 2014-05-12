use utf8;
package Quiver::Schema::Result::Source;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

Quiver::Schema::Result::Source

=cut

use strict;
use warnings;

use base 'DBIx::Class::Core';

=head1 TABLE: C<source>

=cut

__PACKAGE__->table("source");

=head1 ACCESSORS

=head2 sourceid

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0

=head2 name

  data_type: 'text'
  is_nullable: 0

=cut

__PACKAGE__->add_columns(
  "sourceid",
  { data_type => "integer", is_auto_increment => 1, is_nullable => 0 },
  "name",
  { data_type => "text", is_nullable => 0 },
);

=head1 PRIMARY KEY

=over 4

=item * L</sourceid>

=back

=cut

__PACKAGE__->set_primary_key("sourceid");

=head1 UNIQUE CONSTRAINTS

=head2 C<name_unique>

=over 4

=item * L</name>

=back

=cut

__PACKAGE__->add_unique_constraint("name_unique", ["name"]);

=head1 RELATIONS

=head2 scans

Type: has_many

Related object: L<Quiver::Schema::Result::Scan>

=cut

__PACKAGE__->has_many(
  "scans",
  "Quiver::Schema::Result::Scan",
  { "foreign.sourceid" => "self.sourceid" },
  { cascade_copy => 0, cascade_delete => 0 },
);


# Created by DBIx::Class::Schema::Loader v0.07039 @ 2014-05-11 23:18:42
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:mu1EjcO7mXjw8EItDOxcEQ


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
