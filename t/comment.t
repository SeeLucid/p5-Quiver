use Test::Most;
use FindBin;
use Path::Class;
use Clone;
use Clone qw(clone);

use_ok 'Quiver::Source';
use_ok 'Quiver::Backend::RegexpCommon';


my $src = Quiver::Source->new();
$src->add( dir($FindBin::Bin, 'data', 'comment_extraction') );

my $comments = Quiver::Backend::RegexpCommon->new( source => $src );
my $iter = $comments->comments_iter;

my $data;
my $data_eol;
my $data_noeol;
while( my $cmt = $iter->()   ) {
	push @$data, $cmt;
	my $cmt_wo_file = clone($cmt);
	delete $cmt_wo_file->{file};
	push @$data_eol, $cmt_wo_file if $cmt->{file} =~ /test\.c$/;
	push @$data_noeol, $cmt_wo_file if $cmt->{file} =~ /test_noeol\.c$/;
}

is( @$data, 8, 'found 8 comments');

is_deeply( $data_eol, $data_noeol, 'found same comments in file with and without newline at end' );

done_testing;
