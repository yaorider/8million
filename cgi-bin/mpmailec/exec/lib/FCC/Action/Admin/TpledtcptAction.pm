package FCC::Action::Admin::TpledtcptAction;
$VERSION = 1.00;
use strict;
use warnings;
use base qw(FCC::Action::Admin::_SuperAction);
use FCC::Class::Mpfmec::Tpl;

sub dispatch {
	my($self) = @_;
	my $context = {};
	#テンプレートのタイトルを取得
	my $titles = FCC::Class::Mpfmec::Tpl->new(conf=>$self->{conf})->get_titles();
	#テンプレートIDを取得
	my $tid = $self->{q}->param("tid");
	if( ! defined $tid || $tid eq "" || $tid =~ /[^a-zA-Z0-9]/ || ! $titles->{$tid}) {
		$context->{fatalerrs} = ['不正なパラメータが送信されました。'];
		return $context;
	}
	#プロセスセッションを削除
	$self->del_proc_session_data();
	#メタ情報
	my $meta = FCC::Class::Mpfmec::Tpl->new(conf=>$self->{conf})->get_meta($tid);
	#
	my $proc = {};
	$proc->{titles} = $titles;
	$proc->{meta} = $meta;
	$proc->{tid} = $tid;
	#
	$context->{proc} = $proc;
	return $context;
}

1;
