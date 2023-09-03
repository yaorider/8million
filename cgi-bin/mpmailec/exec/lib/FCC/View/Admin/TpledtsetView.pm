package FCC::View::Admin::TpledtsetView;
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
	my $tid = $context->{proc}->{in}->{tid};
	#
	if(@{$context->{proc}->{errs}}) {
		my $rurl = $self->{conf}->{CGI_URL} . "?m=tpledtfrm&pkey=${pkey}&tid=${tid}";
		print "Location: ${rurl}\n\n";
	} else {
		my $rurl = $self->{conf}->{CGI_URL} . "?m=tpledtcpt&pkey=${pkey}&tid=${tid}";
		print "Location: ${rurl}\n\n";
	}
}

1;
