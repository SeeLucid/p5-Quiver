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
  is_nullable: 1

=head2 sourcename

  data_type: 'text'
  is_nullable: 1

=head2 timestarted

  data_type: 'integer'
  is_nullable: 1

=cut

__PACKAGE__->add_columns(
  "scanid",
  { data_type => "integer", is_nullable => 1 },
  "sourcename",
  { data_type => "text", is_nullable => 1 },
  "timestarted",
  { data_type => "integer", is_nullable => 1 },
);

=head1 RELATIONS

=head2 scanfilemetas

Type: has_many

Related object: L<Quiver::Schema::Result::Scanfilemeta>

=cut

__PACKAGE__->has_many(
  "scanfilemetas",
  "Quiver::Schema::Result::Scanfilemeta",
  { "foreign.scanid" => "self.scanid" },
  { cascade_copy => 0, cascade_delete => 0 },
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


# Created by DBIx::Class::Schema::Loader v0.07039 @ 2014-01-19 14:48:51
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:PC1ri0hu4CYMg+wTUOxMzw


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
