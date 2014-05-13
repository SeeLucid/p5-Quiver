package Quiver::Schema::Result::DocumentationMatch;

# TODO: document

use strict;
use warnings;
#use base qw/Quiver::Schema::Result::Symbol/;
use base 'DBIx::Class::Core';

__PACKAGE__->table_class('DBIx::Class::ResultSource::View');
__PACKAGE__->table('documentationMatch');
__PACKAGE__->result_source_instance->is_virtual(1);

__PACKAGE__->add_columns(
  "comment_symbol",
  { data_type => "integer", is_auto_increment => 1, is_nullable => 0 },
  "function_symbol",
  { data_type => "integer", is_auto_increment => 1, is_nullable => 0 },
  "filenameid",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 1 },
);

__PACKAGE__->belongs_to(
  "$_",
  "Quiver::Schema::Result::Symbol",
  { "symboluid" => $_ },
) for qw(function_symbol comment_symbol);

__PACKAGE__->belongs_to(
  "filenameid",
  "Quiver::Schema::Result::Scanfilemeta",
  { scanfilemetaid => "filenameid" },
);

# NOTE: SQL
__PACKAGE__->result_source_instance->view_definition(
	q[
		SELECT *, MIN(dist)
		FROM
			(
			SELECT
				comm.symboluid                AS comment_symbol,
				func.symboluid                AS function_symbol,
				comm.scanfilemetaid           AS filenameid,
				func.linestart - comm.lineend AS dist
			FROM
				symbol comm,
				symbol func
			WHERE
				comm.symtypeid = (SELECT symtypeid FROM symtype WHERE name = 'comment') AND
				func.symtypeid = (SELECT symtypeid FROM symtype WHERE name = 'function definition') AND
				comm.scanfilemetaid = func.scanfilemetaid AND
				dist > 0
			)
		 GROUP BY function_symbol
	]
);
