package Quiver::Backend::Perldoc;

use strict;
use warnings;

use File::Temp ();
use Path::Class;
use IO::Scalar;

sub run {
	my ($self, $query) = @_;
	my $tempfile = File::Temp->new();
	my @args = (
		'-u',
		"-d@{[ $tempfile->filename ]}",
		$query
	);
	my $pd = Quiver::Backend::Perldoc::Helper->new( args => \@args );
	{
		local (*STDOUT,*STDERR);
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
 

1;
