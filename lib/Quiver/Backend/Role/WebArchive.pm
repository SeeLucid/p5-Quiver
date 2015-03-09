package Quiver::Backend::Role::WebArchive;

use strict;
use warnings;

use Moo::Role;

requires 'tarball_uri';

has tarball_file_path => ( is => 'lazy' );

1;
