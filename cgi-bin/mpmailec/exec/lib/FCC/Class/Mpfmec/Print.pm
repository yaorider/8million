package FCC::Class::Mpfmec::Print;
$VERSION = 1.00;
use strict;
use warnings;
use base qw(FCC::_Super);
use Carp;
use FCC::Class::Mpfmec::Tpl;
use FCC::Class::HTTP::MobileAgent;
use Unicode::Japanese;

sub init {
	my($self, %args) = @_;
	$self->{conf} = $args{conf};
}

#---------------------------------------------------------------------
#■ 出力
#---------------------------------------------------------------------
#[引数]
#	1.HTML::Templateオブジェクト
#	2.ヘッダーを格納したhashref
#[戻り値]
#	なし
#---------------------------------------------------------------------
sub print_html {
	my($self, $t, $hdrs_ref) = @_;
	my %hdrs;
	if($hdrs_ref) {
		while( my($k, $v) = each %{$hdrs_ref} ) {
			$k = lc $k;
			$hdrs{$k} = $v;
		}
	}
	if($hdrs{status} && $hdrs{status} =~ /^\d{3}$/) {
		my $msg = $self->get_http_status($hdrs{status});
		unless($msg) { $msg = ""; }
		$hdrs{status} .= ": ${msg}";
	}
  	#テンプレートを展開
 	my $body = $t->output();
	#ヘッダー初期値
	my $charset = "utf-8";
	if( defined $self->{conf}->{target_encoding} ) {
		if($self->{conf}->{target_encoding} eq "1") {
			$charset = "shift_jis";
			$body = Unicode::Japanese->new($body, "utf8")->sjis();
		} elsif($self->{conf}->{target_encoding} eq "2") {
			$charset = "euc-jp";
			$body = Unicode::Japanese->new($body, "utf8")->euc();
		} elsif($self->{conf}->{target_encoding} eq "3") {
			$charset = "jis";
			$body = Unicode::Japanese->new($body, "utf8")->jis();
		}
	}
	unless($hdrs{"content-type"}) {
 		$hdrs{"content-type"} = "text/html; charset=${charset}";
 	}
	#ヘッダーにContent-Lengthをセット
	$hdrs{"content-length"} = length $body;
	#出力
	while( my($k, $v) = each %hdrs ) {
		my $name = $k;
		$name =~ s/^([a-z]+)\-([a-z]+)$/\u$1\-\u$2/;
		if( ref($v) && ref($v) eq "ARRAY") {
			for my $str (@{$v}) {
				print STDOUT "${name}: ${str}\n";
			}
		} else {
			print STDOUT "${name}: ${v}\n";
		}
	}
	print STDOUT "\n";
	print STDOUT $body;
	exit;
}

sub load_template {
	my($self, $tcode) = @_;
	my $c = $self->{conf};
	my $tid;
	if($c->{lang} eq "ja" && $c->{html_mobi_selectable} eq "1") {
		my $carrier = FCC::Class::HTTP::MobileAgent->new()->carrier();
		if($c->{html_mobi_carrier_selectable}) {
			if($carrier eq "DoCoMo") {
				$tid = "${tcode}11";
			} elsif($carrier eq "KDDI") {
				$tid = "${tcode}12";
			} elsif($carrier eq "Softbank") {
				$tid = "${tcode}13";
			} else {
				$tid = "${tcode}00";
			}
		} else {
			if($carrier =~ /^(DoCoMo|KDDI|Softbank)$/) {
				$tid = "${tcode}10";
			} else {
				$tid = "${tcode}00";
			}
		}
	} else {
		$tid = "${tcode}00";
	}
	my $otpl = new FCC::Class::Mpfmec::Tpl(conf=>$self->{conf});
	my $t = $otpl->get_for_render($tid);
	my $meta = $otpl->get_meta($tid);
	return $t, $meta;
}

sub get_http_status {
	my($self, $code) = @_;
	unless($code) { return undef; }
	my %http_status_codes = (
		'100' => 'Continue',
		'101' => 'Switching Protocols',
		'200' => 'OK',
		'201' => 'Created',
		'202' => 'Accepted',
		'203' => 'Non-Authoritative Information',
		'204' => 'No Content',
		'205' => 'Reset Content',
		'206' => 'Partial Content',
		'300' => 'Multiple Choices',
		'301' => 'MovedPermanently',
		'302' => 'Found',
		'303' => 'See Other',
		'304' => 'Not Modified',
		'305' => 'Use Proxy',
		'306' => 'Unused',
		'307' => 'Temporary Redirect',
		'400' => 'Bad Request',
		'401' => 'Unauthorized',
		'402' => 'Payment Required',
		'403' => 'Forbidden',
		'404' => 'Not Found',
		'405' => 'Method Not Allowed',
		'406' => 'Not Acceptable',
		'407' => 'Proxy Authentication Required',
		'408' => 'Request Timeout',
		'409' => 'Conflict',
		'410' => 'Gone',
		'411' => 'Length Required',
		'412' => 'Precondition Failed',
		'413' => 'Request Entity Too Large',
		'414' => 'Request-Uri Too Long',
		'415' => 'Unsupported Media Type',
		'416' => 'Requested Range Not Satisfiable',
		'417' => 'Expectation Failed',
		'500' => 'Internal Server Error',
		'501' => 'Not Implemented',
		'502' => 'Bad Gateway',
		'503' => 'Service Unavailable',
		'504' => 'Gateway Timeout',
		'505' => 'Http Version Not Supported'
	);
	if($http_status_codes{$code}) {
		return $http_status_codes{$code};
	} else {
		return undef;
	}
}

1;
