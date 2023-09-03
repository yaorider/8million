package FCC::Action::Admin::TpledtfrmAction;
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
	#プロセスセッション
	my $pkey = $self->{q}->param("pkey");
	my $proc = $self->get_proc_session_data($pkey, "tpledt");
	unless($proc) {
		$proc = $self->create_proc_session_data("tpledt");
		#テンプレートロード
		my $tpltype = $self->{q}->param("tpltype");
		my $tpl;
		if(defined $tpltype && $tpltype =~ /^(1|2)$/) {
			$tpl = FCC::Class::Mpfmec::Tpl->new(conf=>$self->{conf})->get_default($tid, $tpltype);
		} else {
			$tpl = FCC::Class::Mpfmec::Tpl->new(conf=>$self->{conf})->get($tid, 1);
		}
		$proc->{in}->{tid} = $tid;
		$proc->{in}->{tpl} = $tpl;
	}
	#メタ情報
	my $meta = FCC::Class::Mpfmec::Tpl->new(conf=>$self->{conf})->get_meta($tid);
	#
	$proc->{titles} = $titles;
	$proc->{meta} = $meta;
	$context->{proc} = $proc;
	return $context;
}

1;
