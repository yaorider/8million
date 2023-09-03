package FCC::View::Admin::LogatcdwnView;
$VERSION = 1.00;
use strict;
use warnings;
use base qw(FCC::View::Admin::_SuperView);

sub dispatch {
	my($self, $context) = @_;
	#システムエラーの評価
	if($context->{fatalerrs}) {
		$self->error($context->{fatalerrs});
		exit;
	}
	#
	my $path = $context->{path};
	my $filename = $context->{filename};
	my $size = -s $path;
	#
	if( open my $fh, "<", $path ) {
		binmode($fh);
		print STDOUT "Content-Type: application/octet-stream\n";
		print STDOUT "Content-Disposition: attachment; filename=${filename}\n";
		print STDOUT "Content-Length: ${size}\n";
		print STDOUT "\n";
		my $chunk;
		while( my $byte = sysread($fh, $chunk, 1048576) ) {
			print STDOUT $chunk;
		}
		close($fh);
	} else {
		$self->error(["failed to open ${path}"]);
		exit;
	}
}

1;
