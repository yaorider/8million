package FCC::View::Form::CfmsmtView;
$VERSION = 1.00;
use strict;
use warnings;
use base qw(FCC::View::Form::_SuperView);
use FCC::Class::HTTP::Cookie;
use FCC::Class::HTTP::MobileAgent;

sub dispatch {
	my($self, $context) = @_;
	#システムエラーの評価
	if($context->{fatalerrs}) {
		$self->error($context->{fatalerrs});
		exit;
	}
	#セッションID
	my $sid = $self->{session}->{sid};
	my $pid = $self->{session}->{data}->{pid};
	#Cookie有効フラグ
	my $sid_param = "";
	if( ! $self->{session}->{data}->{cookie_available} ) {
		$sid_param = "&sid=${sid}";
	}
	#Cookie
	my $secure = 0;
	if( $self->{conf}->{CGI_URL} =~ /^https\:\/\// ) {
		$secure = 1;
	}
	my $cookie = new FCC::Class::HTTP::Cookie(
		-name   => 'sid',
		-value  => $sid,
		-secure => $secure
	);
	#
	my $carrier = FCC::Class::HTTP::MobileAgent->new()->carrier();
	my $guid_on_param = "";
	my $tm_param = "";
	if($carrier eq "DoCoMo") {
		$guid_on_param = "&guid=ON";
	} elsif($carrier eq "KDDI") {
		$tm_param = "&tm=" . time;
	}
	#
	print "Set-Cookie: ", $cookie->as_string, "\n";
	if(@{$context->{proc}->{errs}}) {
		my $rurl = $self->{conf}->{CGI_URL} . "?m=frmshw&pid=${pid}${sid_param}${tm_param}${guid_on_param}";
		print "Location: ${rurl}\n\n";
	} elsif($self->{conf}->{confirm_enable}) {
		my $rurl = $self->{conf}->{CGI_URL} . "?m=cfmshw&pid=${pid}${sid_param}${tm_param}${guid_on_param}";
		print "Location: ${rurl}\n\n";
	} else {
		my $rurl = $self->{conf}->{CGI_URL} . "?m=cptsmt&pid=${pid}${sid_param}${tm_param}${guid_on_param}";
		print "Location: ${rurl}\n\n";
	}
}

1;
