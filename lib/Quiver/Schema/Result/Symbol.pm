use utf8;
package Quiver::Schema::Result::Symbol;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

Quiver::Schema::Result::Symbol

=cut

use strict;
use warnings;

use base 'DBIx::Class::Core';

=head1 TABLE: C<symbol>

=cut

__PACKAGE__->table("symbol");

=head1 ACCESSORS

=head2 symboluid

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0

=head2 name

  data_type: 'text'
  is_nullable: 1

=head2 symtypeid

  data_type: 'integer'
  is_foreign_key: 1
  is_nullable: 0

=head2 filename

  data_type: 'text'
  is_nullable: 0

=head2 linestart

  data_type: 'integer'
  is_nullable: 0

=head2 lineend

  data_type: 'integer'
  is_nullable: 1

=head2 uri

  data_type: 'text'
  is_nullable: 1

=head2 backendname

  data_type: 'text'
  is_nullable: 0

=head2 scanid

  data_type: 'integer'
  is_foreign_key: 1
  is_nullable: 1

=cut

__PACKAGE__->add_columns(
  "symboluid",
  { data_type => "integer", is_auto_increment => 1, is_nullable => 0 },
  "name",
  { data_type => "text", is_nullable => 1 },
  "symtypeid",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 0 },
  "filename",
  { data_type => "text", is_nullable => 0 },
  "linestart",
  { data_type => "integer", is_nullable => 0 },
  "lineend",
  { data_type => "integer", is_nullable => 1 },
  "uri",
  { data_type => "text", is_nullable => 1 },
  "backendname",
  { data_type => "text", is_nullable => 0 },
  "scanid",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 1 },
);

=head1 PRIMARY KEY

=over 4

=item * L</symboluid>

=back

=cut

__PACKAGE__->set_primary_key("symboluid");

=head1 RELATIONS

=head2 scanid

Type: belongs_to

Related object: L<Quiver::Schema::Result::Scan>

=cut

__PACKAGE__->belongs_to(
  "scanid",
  "Quiver::Schema::Result::Scan",
  { scanid => "scanid" },
  {
    is_deferrable => 0,
    join_type     => "LEFT",
    on_delete     => "NO ACTION",
    on_update     => "NO ACTION",
  },
);

=head2 symboltext

Type: might_have

Related object: L<Quiver::Schema::Result::Symboltext>

=cut

__PACKAGE__->might_have(
  "symboltext",
  "Quiver::Schema::Result::Symboltext",
  { "foreign.symboluid" => "self.symboluid" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 symtypeid

Type: belongs_to

Related object: L<Quiver::Schema::Result::Symtype>

=cut

__PACKAGE__->belongs_to(
  "symtypeid",
  "Quiver::Schema::Result::Symtype",
  { symtypeid => "symtypeid" },
  { is_deferrable => 0, on_delete => "NO ACTION", on_update => "NO ACTION" },
);


# Created by DBIx::Class::Schema::Loader v0.07039 @ 2014-05-07 12:21:24
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:/6l4QDlncoE+sIGTH2osJQ


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
