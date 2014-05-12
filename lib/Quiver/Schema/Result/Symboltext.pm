use utf8;
package Quiver::Schema::Result::Symboltext;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

Quiver::Schema::Result::Symboltext

=cut

use strict;
use warnings;

use base 'DBIx::Class::Core';

=head1 TABLE: C<symboltext>

=cut

__PACKAGE__->table("symboltext");

=head1 ACCESSORS

=head2 symboluid

  data_type: 'integer'
  is_auto_increment: 1
  is_foreign_key: 1
  is_nullable: 0

=head2 symboltext

  data_type: 'text'
  is_nullable: 0

=cut

__PACKAGE__->add_columns(
  "symboluid",
  {
    data_type         => "integer",
    is_auto_increment => 1,
    is_foreign_key    => 1,
    is_nullable       => 0,
  },
  "symboltext",
  { data_type => "text", is_nullable => 0 },
);

=head1 PRIMARY KEY

=over 4

=item * L</symboluid>

=back

=cut

__PACKAGE__->set_primary_key("symboluid");

=head1 RELATIONS

=head2 symboluid

Type: belongs_to

Related object: L<Quiver::Schema::Result::Symbol>

=cut

__PACKAGE__->belongs_to(
  "symboluid",
  "Quiver::Schema::Result::Symbol",
  { symboluid => "symboluid" },
  { is_deferrable => 0, on_delete => "NO ACTION", on_update => "NO ACTION" },
);


# Created by DBIx::Class::Schema::Loader v0.07039 @ 2014-05-11 22:26:44
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:TjajJKWqjL6v3DHYlXqWGQ


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
