package FCC::View::Form::ImgshwView;
$VERSION = 1.00;
use strict;
use warnings;
use base qw(FCC::View::Form::_SuperView);

sub dispatch {
	my($self, $context) = @_;
	#システムエラーの評価
	if($context->{fatalerrs}) {
		$self->error($context->{fatalerrs});
		exit;
	}
	#サムネイル出力
	my $path = $context->{thumb}->{thumb_path};
	my $size = $context->{thumb}->{thumb_size};
	my $mtype = $context->{thumb}->{thumb_mtype};
	if( open my $fh, "<", $path ) {
		print "Cache-Control: no-cache\n";
		print "Pragma: no-cache\n";
		print "Content-Length: ${size}\n";
		print "Content-Type: ${mtype}\n";
		print "\n";
		binmode($fh);
		my $chunk;
		while( sysread $fh, $chunk, 1048576 ) {
			print STDOUT $chunk;
		}
	} else {
		$self->error(["failed to open a image file. : $!"]);
		exit;
	}
}

1;
