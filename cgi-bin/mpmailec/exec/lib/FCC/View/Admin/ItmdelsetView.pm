package FCC::View::Admin::ItmdelsetView;
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
	my $rurl = $self->{conf}->{CGI_URL} . "?m=itmalllst";
	print "Location: ${rurl}\n\n";
}

1;
