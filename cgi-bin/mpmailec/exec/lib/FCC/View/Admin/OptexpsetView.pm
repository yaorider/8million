package FCC::View::Admin::OptexpsetView;
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
	#DUMPデータ
	my $d = $context->{proc}->{dumpdata};
	my $size = length $d;
	my $filename = "mpmailec.dump";
	#出力
	print "Content-Type: application/octet-stream\n";
	print "Content-Disposition: attachment; filename=${filename}\n";
	print "Content-Length: ${size}\n";
	print "\n";
	print $d;
}

1;
