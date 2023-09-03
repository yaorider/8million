package FCC::View::Admin::IndexView;
$VERSION = 1.00;
use strict;
use warnings;
use base qw(FCC::View::Admin::_SuperView);
use FCC::Class::HTTP::Cookie;

sub dispatch {
	my($self, $context) = @_;
	#エラーの評価
	if($context->{fatalerrs}) {
		$self->error($context->{fatalerrs});
		exit;
	}
	#
	my $t = $self->load_template();
	$t->param('epoch' => time);
	if($context->{auto_logon_enable} && $context->{auto_logon_enable} eq "1") {
		#sid用Cookie
		my $cs = new FCC::Class::HTTP::Cookie(
			-name    =>  "$self->{conf}->{FCC_SELECTOR}_sid",
			-value   =>  "$context->{sid}",
			-expires =>  "+$self->{conf}->{session_expire}h",
		);
		my $cs_string = $cs->as_string;
		$t->param("cookie_string_sid" => $cs_string);
		#auto_logon_enable用Cookie
		my $ca = new FCC::Class::HTTP::Cookie(
			-name    =>  "$self->{conf}->{FCC_SELECTOR}_auto_logon_enable",
			-value   =>  "1",
			-expires =>  "+$self->{conf}->{session_expire}h",
		);
		my $ca_string = $ca->as_string;
		$t->param("cookie_string_auto_logon_enable" => $ca_string);
		#画面出力
		my $hdrs = { "Set-Cookie" => [$cs_string, $ca_string] };
		$self->print_html($t, $hdrs);
	} else {
		my $cs = new FCC::Class::HTTP::Cookie(
			-name    =>  "$self->{conf}->{FCC_SELECTOR}_sid",
			-value   =>  "$context->{sid}",
		);
		my $cs_string = $cs->as_string;
		$t->param("cookie_string_sid" => $cs_string);
		#画面出力
		my $hdrs = { "Set-Cookie" => $cs_string };
		$self->print_html($t, $hdrs);
	}
}

1;
