package FCC::View::Admin::OptaclsetView;
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
	#プロセスキー
	my $pkey = $context->{proc}->{pkey};
	#
	if(@{$context->{proc}->{errs}}) {
		my $rurl = $self->{conf}->{CGI_URL} . "?m=optaclfrm&pkey=${pkey}";
		print "Location: ${rurl}\n\n";
	} else {
		my $rurl = $self->{conf}->{CGI_URL} . "?m=optaclcpt&pkey=${pkey}";
		print "Location: ${rurl}\n\n";
	}
}

1;
