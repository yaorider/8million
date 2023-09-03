package FCC::Controller;
$VERSION = 1.00;
use strict;
use warnings;
use File::Basename;
use CGI;
use Config::Tiny;
use FCC::Class::Syscnf;
use FCC::Class::Session;
use FCC::Class::Iprestriction;
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
	#IPアドレス制限
	unless( FCC::Class::Iprestriction->new(conf=>$c)->match($ENV{REMOTE_ADDR}) ) {
		$self->error403();
	}
	#アクセスされたCGIファイル名からセレクターを取り出す
	my $f = $self->get_selector();
	$c->{FCC_SELECTOR} = $f;
	#テンプレートディレクトリ
	$c->{TEMPLATE_DIR} = "$c->{BASE_DIR}/template/$c->{FCC_SELECTOR}";
	#処理モード取得
	my $m = $self->{q}->param('m');
	unless($m) {$m = "index";}
	$m = ucfirst $m;
	if($m =~ /^[^a-zA-Z0-9]/) {
		die 'Invalid Parameter.';
	}
	#認証処理
	my $session = new FCC::Class::Session(
		conf => $c,
		timeout => $c->{session_timeout},
		expire => $c->{session_expire}*3600
	);
	if($m !~ /^auth/i) {
		require FCC::Class::Auth;
		my $auth = new FCC::Class::Auth(conf=>$c, q=>$self->{q}, session=>$session);
		$auth->dispatch();
	}
	#アクション（モデル）
	my $apm;
	if(-e "$c->{BASE_DIR}/lib/FCC/Action/${f}/${m}Action.pm") {
		$apm = "FCC::Action::${f}::${m}Action";
		eval qq(require $apm; import $apm);
		if($@) { die $@; }
	} elsif(-e "$c->{BASE_DIR}/lib/FCC/Action/${f}/DefaultAction.pm") {
		$apm = "FCC::Action::${f}::DefaultAction";
		eval qq(require $apm; import $apm);
		if($@) { die $@; }
	} else {
		$apm = "FCC::Action::DefaultAction";
		eval qq(require $apm; import $apm);
		if($@) { die $@; }
	}
	my $action = new $apm;
	$action->set('conf' ,$c);
	$action->set('q', $self->{q});
	$action->set('session', $session);
	my $context = $action->dispatch();
	#ビュー
	my $vpm;
	if(-e "$c->{BASE_DIR}/lib/FCC/View/${f}/${m}View.pm") {
		$vpm = "FCC::View::${f}::${m}View";
		eval qq(require $vpm; import $vpm);
		if($@) { die $@; }
	} elsif(-e "$c->{BASE_DIR}/lib/FCC/View/${f}/DefaultView.pm") {
		$vpm = "FCC::View::${f}::DefaultView";
		eval qq(require $vpm; import $vpm);
		if($@) { die $@; }
	} else {
		$vpm = "FCC::View::DefaultView";
		eval qq(require $vpm; import $vpm);
		if($@) { die $@; }
	}
	my $view = new $vpm;
	$view->set('conf' ,$c);
	$view->set('q', $self->{q});
	$view->set('session', $session);
	$view->dispatch($context);
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

sub error403 {
	my($self) = @_;
	my $body=<<EOM;
<!DOCTYPE HTML PUBLIC "-//IETF//DTD HTML 2.0//EN">
<html><head>
<title>403 Forbidden</title>
</head><body>
<h1>Forbidden</h1>
<p>You don't have permission to access /framework/
on this server.</p>
</body></html>
EOM
	my $content_length = length $body;
	unless($self->{q}) {
		$self->{q} = new CGI;
	}
	print $self->{q}->header(
		-status         => '403 Forbidden',
		-type           => 'text/html; charset=iso-8859-1',
		-Content_length => $content_length
	);
	print $body;
	exit;
}

1;
