use utf8;
package Quiver::Schema::Result::Scan;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

Quiver::Schema::Result::Scan

=cut

use strict;
use warnings;

use base 'DBIx::Class::Core';

=head1 TABLE: C<scan>

=cut

__PACKAGE__->table("scan");

=head1 ACCESSORS

=head2 scanid

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0

=head2 sourceid

  data_type: 'integer'
  is_foreign_key: 1
  is_nullable: 0

=head2 timestarted

  data_type: 'integer'
  is_nullable: 0

=cut

__PACKAGE__->add_columns(
  "scanid",
  { data_type => "integer", is_auto_increment => 1, is_nullable => 0 },
  "sourceid",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 0 },
  "timestarted",
  { data_type => "integer", is_nullable => 0 },
);

=head1 PRIMARY KEY

=over 4

=item * L</scanid>

=back

=cut

__PACKAGE__->set_primary_key("scanid");

=head1 RELATIONS

=head2 sourceid

Type: belongs_to

Related object: L<Quiver::Schema::Result::Source>

=cut

__PACKAGE__->belongs_to(
  "sourceid",
  "Quiver::Schema::Result::Source",
  { sourceid => "sourceid" },
  { is_deferrable => 0, on_delete => "NO ACTION", on_update => "NO ACTION" },
);

=head2 symbols

Type: has_many

Related object: L<Quiver::Schema::Result::Symbol>

=cut

__PACKAGE__->has_many(
  "symbols",
  "Quiver::Schema::Result::Symbol",
  { "foreign.scanid" => "self.scanid" },
  { cascade_copy => 0, cascade_delete => 0 },
);


# Created by DBIx::Class::Schema::Loader v0.07039 @ 2014-05-11 22:26:44
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:NFsSWwKWL1Xzk0842/YkaA


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
