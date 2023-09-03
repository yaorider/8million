package FCC::ControllerForm;
$VERSION = 1.00;
use strict;
use warnings;
use File::Basename;
use CGI;
use Config::Tiny;
use Net::Netmask;
use CGI::Utils;
use FCC::Class::Syscnf;
use FCC::Class::SessionForm;
use FCC::Class::Mpfmec::Msg;
use FCC::Class::Mpfmec::Item;
use FCC::Class::HTTP::MobileAgent;
use FCC::Class::Mpfmec::Iplock;
use FCC::Class::HTTP::Cookie;
use FCC::Class::Env;

sub new {
	my($caller, %args) = @_;
	my $class = ref($caller) || $caller;
	my $self = { params => $args{params} };
	bless $self, $class;
	return $self;
}

sub dispatch {
	my($self) = @_;
	#CGI.pmのインスタンス
	$self->{q} = new CGI;
	#設定を取り出す
	my $c = $self->load_conf();
	#呼び出されたCGIのURL
	my $cu = FCC::Class::Env->new(q=>$self->{q})->get_url_path();
	$c->{CGI_URL} = $cu->{CGI_URL};	# http://www.futomi.com/framework/admin.cgi
	$c->{CGI_URL_PATH} = $cu->{CGI_URL_PATH};	# /framework/admin.cgi
	$c->{CGI_DIR_URL} = $cu->{CGI_DIR_URL};	# http://www.futomi.com/framework
	$c->{CGI_DIR_URL_PATH} = $cu->{CGI_DIR_URL_PATH};	# /framework
	#
	$self->{conf} = $c;
	#エラーメッセージ
	my $emsgs = FCC::Class::Mpfmec::Msg->new(conf=>$self->{conf})->get_all();
	#利用禁止ホストかどうかを評価
	if( $self->is_denied_host() ) {
		$self->error("403", $emsgs->{acl_deny_hosts});
	}
	#連続投稿禁止のIPアドレスロックの評価
	if($self->{conf}->{acl_post_deny_sec}) {
		if( FCC::Class::Mpfmec::Iplock->new(conf=>$self->{conf})->is_locked($ENV{REMOTE_ADDR}) ) {
			$self->error("403", $emsgs->{acl_post_deny});
		}
	}
	#端末キャリアを取得
	my $carrier = FCC::Class::HTTP::MobileAgent->new()->carrier();
	#アクセスされたCGIファイル名からセレクターを取り出す
	my $f = $self->get_selector();
	$c->{FCC_SELECTOR} = $f;
	#テンプレートディレクトリ
	$c->{TEMPLATE_DIR} = "$c->{BASE_DIR}/template/$c->{FCC_SELECTOR}";
	#処理モード取得
	my $m = $self->{q}->param('m');
	unless($m) {$m = "Frmshw";}
	$m = ucfirst $m;
	if($m =~ /^[^a-zA-Z0-9]/) {
		$self->error("403", "unauthorized access");
	}
	#HTTPメソッドをチェック
	#if($m =~ /^(Cfmsmt|Cptsmt)$/) {
	if($m eq "Cfmsmt" || ($m eq "Ctpsmt" && $c->{confirm_enable}) ) {
		if($ENV{REQUEST_METHOD} !~ /^post$/i) {
			$self->error("403", "unauthorized access");
		}
	}
	#携帯端末の端末識別ID
	my $mobi_serial = FCC::Class::HTTP::MobileAgent->new()->serial();
	#セッション
	my $session = new FCC::Class::SessionForm(conf=>$c, q =>$self->{q}, expire=>3600);
	my($sid, $cookie_available) = $session->get_sid_from_client();
	if($cookie_available) {
		$cookie_available = 1;
	} else {
		$cookie_available = 0;
	}
	$c->{cookie_available} = $cookie_available;
	my $session_data;
	my $pid = $self->{q}->param("pid");
	unless( defined $pid && $pid =~ /^[a-fA-F0-9]{32}$/ ) { $pid = ""; }
	if($sid && $sid =~ /^[a-fA-F0-9]{32}$/) {
		$session_data = $session->auth($sid, {cookie_available=>$cookie_available});
		#セッションチェック
		#sid（Cookie用）に加え、pid（hidden）を評価する。さらに携帯の場合は端末識別IDも評価することで、同一セッションかをチェックする
		if( ! defined $pid || ! defined $session_data->{pid} || $pid eq "" || $session_data->{pid} eq "" || $pid ne $session_data->{pid} ) {
			$session_data = undef;
		} elsif( defined $session_data->{mobi_serial} && $session_data->{mobi_serial} ne "" ) {
			if( ! defined $mobi_serial || $mobi_serial eq "" || $session_data->{mobi_serial} ne $mobi_serial) {	# 携帯端末セッションセキュリティー対策（端末識別IDをチェック）
				$session_data = undef;
			}
		}
	}
	if($session_data) {
		#Cookie受け入れない場合は、pidを変更
		unless($cookie_available) {
			$pid = $session->renew_pid();
			$session->{data}->{pid} = $pid;
		}
	} else {
		if($m eq "Frmshw") {
			#DoCoMo端末の場合、guid=ONがなければ、それを付加してリダイレクト
			if($carrier eq "DoCoMo" && $ENV{REQUEST_URI} && $ENV{REQUEST_URI} !~ /guid=ON/i ) {
				print "Location: $c->{CGI_URL}?m=frmshw&guid=ON\n\n";
				exit;
			}
			#セッションを新規に生成
			$sid = $session->create({cookie_available=>$cookie_available, mobi_serial=>$mobi_serial});
			unless($sid) {
				$self->error("503", "SYSTEM ERROR. faield to generate your session.");
			}
		} else {
			if($sid) { $session->remove(); }
			#Cookie
			my $secure = 0;
			if( $c->{CGI_URL} =~ /^https\:\/\// ) {
				$secure = 1;
			}
			my $cookie = new FCC::Class::HTTP::Cookie(
				-name   => 'sid',
				-value  => 'dummy',
				-expires =>  '-1M',
				-secure => $secure
			);
			my $url = "$c->{CGI_URL}?m=frmshw";
			if($carrier eq "DoCoMo" && $ENV{REQUEST_URI} && $ENV{REQUEST_URI} !~ /guid=ON/i ) {
				$url .= "&guid=ON";
			} elsif($carrier eq "KDDI") {
				$url .= "&tm=" . time;
			}
			print "Set-Cookie: ", $cookie->as_string, "\n";
			print "Location: ${url}\n";
			print "\n";
			exit;
		}
	}
	#ユーザーエージェントから表示文字コードを選定
	my $target_encoding;
	if($c->{html_mobi_selectable}) {
		if($carrier eq "DoCoMo") {
			$target_encoding = $c->{html_11_encoding};
		} elsif($carrier eq "KDDI") {
			$target_encoding = $c->{html_12_encoding};
		} elsif($carrier eq "Softbank") {
			$target_encoding = $c->{html_13_encoding};
		} else {
			$target_encoding = $c->{html_00_encoding};
		}
	} else {
		if($carrier =~ /^(DoCoMo|KDDI|Softbank)$/) {
			$target_encoding = $c->{html_10_encoding};
		} else {
			$target_encoding = $c->{html_00_encoding};
		}
	}
	unless($target_encoding) {
		$target_encoding = "0";
	}
	$c->{target_encoding} = $target_encoding;
	#項目情報を取得
	my $items = FCC::Class::Mpfmec::Item->new(conf=>$c)->get();
	#アクション（モデル）
	my $apm;
	if(-e "$c->{BASE_DIR}/lib/FCC/Action/${f}/${m}Action.pm") {
		$apm = "FCC::Action::${f}::${m}Action";
		eval qq(require $apm; import $apm);
		if($@) { die $@; }
	} else {
		$self->error("404", "Not Found");
	}
	my $action = new $apm;
	$action->set('conf' ,$c);
	$action->set('q', $self->{q});
	$action->set('session', $session);
	$action->set('items', $items);
	$action->set('emsgs', $emsgs);
	my $context = $action->dispatch();
	#ビュー
	my $vpm;
	if(-e "$c->{BASE_DIR}/lib/FCC/View/${f}/${m}View.pm") {
		$vpm = "FCC::View::${f}::${m}View";
		eval qq(require $vpm; import $vpm);
		if($@) { die $@; }
	} else {
		$self->error("404", "Not Found");
	}
	my $view = new $vpm;
	$view->set('conf' ,$c);
	$view->set('q', $self->{q});
	$view->set('session', $session);
	$view->set('items', $items);
	$view->set('emsgs', $emsgs);
	$view->dispatch($context);
}

sub is_denied_host {
	my($self) = @_;
	my $str = $self->{conf}->{acl_deny_hosts};
	if( ! defined $str || $str eq "") {
		return 0;
	}
	my $ip = $ENV{REMOTE_ADDR};
	if( ! $ip ) { return 0; }
	my $host = $self->get_hostname_from_ip($ip);
	my @blocks = split(/\n+/, $str);
	for my $block (@blocks) {
		if($block =~ /^[\d\.]+$/) {
			if($ip =~ /^\Q${block}\E/) {
				return 1;
			}
		} elsif($block =~ /^\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}\/\d{1,2}$/) {
			my $nm = new2 Net::Netmask($block);
			if($nm &&  Net::Netmask->new($block)->match($ip)) {
				return 1;
			}
		} else {
			if($host =~ /\Q${block}\E$/) {
				return 1;
			}
		}
	}
	return 0;
}

sub get_hostname_from_ip {
	my($self, $ip) = @_;
	my @addr = split(/\./, $ip);
	my $packed_addr = pack("C4", $addr[0], $addr[1], $addr[2], $addr[3]);
	my($host) = gethostbyaddr($packed_addr, 2);
	return $host;
}

sub load_conf {
	my($self) = @_;
	my $c = {};
	while( my($k, $v) = each %{$self->{params}} ) {
		$c->{$k} = $v;
	}
	#デフォルト設定値を取得
	my $ct = Config::Tiny->read("$c->{BASE_DIR}/default/default.ini.cgi") or die "failed to read deafult configurations file '$c->{BASE_DIR}/default/default.ini.cgi'. : $!";
	while( my($k, $v) = each %{$ct->{default}} ) {
		$c->{$k} = $v;
	}
	#システム設定情報を取得
	my $sc = FCC::Class::Syscnf->new(conf=>$c)->get();
	while( my($k, $v) = each %{$sc} ) {
		$c->{$k} = $v;
	}
	#
	return $c;
}

sub get_selector {
	my($self) = @_;
	if($self->{params}->{FCC_SELECTOR}) {
		return $self->{params}->{FCC_SELECTOR};
	} else {
		my($file, $dir, $ext) = File::Basename::fileparse( $self->{q}->url(-absolute=>1), qr/\..*/ );
		my $selector = ucfirst $file;
		return $selector;
	}
}

sub error {
	my($self, $code, $err) = @_;
	if( ! defined $code ) {
		$code = "200";
	}
	require FCC::Class::Mpfmec::Print;
	my $oprt = new FCC::Class::Mpfmec::Print(conf=>$self->{conf});
	my($t) = $oprt->load_template("err");
	$err = CGI::Utils->new()->escapeHtml($err);
	$t->param("err_loop" => [ { err => $err } ]);
	$oprt->print_html($t, { Status => $code });
	exit;
}

1;
