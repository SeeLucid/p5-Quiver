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

=head2 scanid

  data_type: 'integer'
  is_foreign_key: 1
  is_nullable: 1

=head2 filename

  data_type: 'text'
  is_nullable: 1

=head2 timelastmod

  data_type: 'integer'
  is_nullable: 1

=head2 md5sum

  data_type: 'text'
  is_nullable: 1

=cut

__PACKAGE__->add_columns(
  "scanid",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 1 },
  "filename",
  { data_type => "text", is_nullable => 1 },
  "timelastmod",
  { data_type => "integer", is_nullable => 1 },
  "md5sum",
  { data_type => "text", is_nullable => 1 },
);

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


# Created by DBIx::Class::Schema::Loader v0.07039 @ 2014-01-19 14:48:51
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:T654UmmLHE6Ano/svTm/Pg


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
