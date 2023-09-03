package FCC::Action::Admin::DivdelsetAction;
$VERSION = 1.00;
use strict;
use warnings;
use base qw(FCC::Action::Admin::_SuperAction);
use FCC::Class::Mpfmec::Item;
use FCC::Class::Mpfmec::Div;
use FCC::Class::String::Checker;

sub dispatch {
	my($self) = @_;
	my $context = {};
	my @errs;
	#プロセスセッション
	my $pkey = $self->{q}->param("pkey");
	my $proc = $self->get_proc_session_data($pkey, "divcnf");
	if( ! $proc) {
		$context->{fatalerrs} = ["不正なリクエストです。"];
		return $context;
	}
	#全フォーム項目情報を取得
	my $items = FCC::Class::Mpfmec::Item->new(conf=>$self->{conf})->get();
	#振り分け情報を取得
	my $divs = FCC::Class::Mpfmec::Div->new(conf=>$self->{conf})->get();
	#振り分けもとになることができない項目を除外
	while( my($k, $v) = each %{$items} ) {
		if($v->{type} !~ /^(3|4|5)$/) {
			delete $items->{$k};
		}
	}
	#パラメータ
	my $name = $self->{q}->param("name");
	if($name) {
		if($name =~ /[^a-zA-Z0-9\-\_]/) {
			push(@errs, "不正な値が送信されました。");
		} elsif( ! exists($items->{$name}) ) {
			push(@errs, "不正な値が送信されました。");
		} elsif($name ne $divs->{name}) {
			push(@errs, "不正な値が送信されました。");
		}
	} else {
		push(@errs, "項目が指定されていません。");
	}
	if(@errs) {
		$context->{fatalerrs} = \@errs;
		return $context;
	}
	#設定クリア
	FCC::Class::Mpfmec::Div->new(conf=>$self->{conf})->clear();
	#
	$context->{proc} = $proc;
	return $context;
}

1;
