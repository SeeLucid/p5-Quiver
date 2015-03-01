package Quiver::Backend::Perldoc;

use strict;
use warnings;

use File::Temp ();
use Path::Class;

sub run {
	my ($self, $query) = @_;
	my $tempfile = File::Temp->new();
	# TODO find functions
	# -f -e
	my @args = (
		'-u',
		"-d@{[ $tempfile->filename ]}",
		$query
	);
	my $pd = Quiver::Backend::Perldoc::Helper->new( args => \@args );
	{
		local (*STDOUT,*STDERR);
		# TODO do something about STDOUT and STDERR
		open STDOUT, '>', \my $stdout;
		open STDERR, '>', \my $stderr;
		$pd->process;
	}
	my $pod = file( $tempfile->filename )->slurp;

	$pod;
}

package Quiver::Backend::Perldoc::Helper;

use Pod::Perldoc ();
use Pod::Perldoc::ToPod ();
use Data::Dumper;
use Quiver::Error;

our @ISA     = 'Pod::Perldoc';
 
sub new {
	my $class = shift;
	my $self  = $class->SUPER::new(@_);
	return $self;
}

sub find_good_formatter_class {
        $_[0]->{'formatter_class'} = 'Pod::Perldoc::ToPod';
        return;
}

sub grand_search_init {
	my ($self, @rest) = @_;
	my @found = $self->SUPER::grand_search_init( @rest );
	return @found if( @found );

	Quiver::Error::NotFound->throw( Dumper(\@rest) );
}
 

1;
