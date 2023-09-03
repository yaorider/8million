package FCC::Action::Admin::ChkaddsetAction;
$VERSION = 1.00;
use strict;
use warnings;
use base qw(FCC::Action::Admin::_SuperAction);
use CGI::Utils;
use FCC::Class::Mpfmec::Item;
use FCC::Class::Mpfmec::Check;

sub dispatch {
	my($self) = @_;
	my $context = {};
	#プロセスセッション
	my $pkey = $self->{q}->param("pkey");
	my $proc = $self->get_proc_session_data($pkey, "chkadd");
	if( ! $proc) {
		$context->{fatalerrs} = ["不正なリクエストです。"];
		return $context;
	}
	#入力値のname属性値のリスト
	my $in_names = ['item_1', 'item_2'];
	#入力値を取得
	$proc->{in} = $self->get_input_data($in_names);
	#入力値チェック
	my @errs = $self->input_check($in_names, $proc->{in});
	#エラーハンドリング
	if(@errs) {
		$proc->{errs} = \@errs;
		$self->set_proc_session_data($proc);
	} else {
		$proc->{errs} = [];
		$self->del_proc_session_data();
		FCC::Class::Mpfmec::Check->new(conf=>$self->{conf})->set($proc->{in});
	}
	#
	$context->{proc} = $proc;
	return $context;
}

sub input_check {
	my($self, $names, $in) = @_;
	my %cap = (
		item_1  => '項目1',
		item_2  => '項目2'
	);
	#全フォーム項目情報を取得
	my $items = FCC::Class::Mpfmec::Item->new(conf=>$self->{conf})->get();
	#チェック
	my @errs;
	for my $i ("1", "2") {
		my $k = "item_${i}";
		my $v = $in->{$k};
		if($v eq "") {
			push(@errs, [$k, "\"$cap{$k}\"は必須です。"]);
		} elsif($v =~ /[^a-zA-Z0-9\-\_]/) {
			push(@errs, [$k, "\"$cap{$k}\"に不正な値が送信されました。"]);
		} elsif( ! exists $items->{$v} ) {
			push(@errs, [$k, "\"$cap{$k}\"に未定義の項目が送信されました。"]);
		}
	}
	unless(@errs) {
		if($in->{item_1} eq $in->{item_2}) {
			push(@errs, ["item_1", "\"$cap{item_1}\" と \"$cap{item_2}\" に同じ項目を指定することはできません。"]);
		}
	}
	#
	return @errs;
}

1;
