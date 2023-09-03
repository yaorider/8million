package FCC::Action::Admin::Opta8fsetAction;
$VERSION = 1.00;
use strict;
use warnings;
use base qw(FCC::Action::Admin::_SuperAction);
use FCC::Class::Syscnf;
use FCC::Class::String::Checker;

sub dispatch {
	my($self) = @_;
	my $context = {};
	#プロセスセッション
	my $pkey = $self->{q}->param("pkey");
	my $proc = $self->get_proc_session_data($pkey, "opta8f");
	if( ! $proc) {
		$context->{fatalerrs} = ["不正なリクエストです。"];
		return $context;
	}
	#入力値のname属性値のリスト
	my $in_names = [
		'a8f_enable',
		'a8f_type',
		'a8f_url',
		'a8f_pid',
		'a8f_item_price',
		'a8f_item_num',
		'a8f_item_code'
	];
	#入力値を取得
	$proc->{in} = $self->get_input_data($in_names);
	#入力値チェック
	my @errs = $self->input_check($in_names, $proc->{in});
	#エラーハンドリング
	if(@errs) {
		$proc->{errs} = \@errs;
	} else {
		$proc->{errs} = [];
		my %u;
		if($proc->{in}->{a8f_enable} eq "1") {
			%u = %{$proc->{in}};
		} else {
			$u{a8f_enable} = "";
		}
		#システム設定情報をセット
		FCC::Class::Syscnf->new(conf=>$self->{conf})->set(\%u);
	}
	#
	$self->set_proc_session_data($proc);
	$context->{proc} = $proc;
	return $context;
}

sub input_check {
	my($self, $names, $in) = @_;
	my %cap = (
		a8f_enable     => 'A8FLYの利用',
		a8f_type       => '利用パターン',
		a8f_url        => 'リクエストURL',
		a8f_pid        => 'プログラムID',
		a8f_item_price => '商品単価/報酬額',
		a8f_item_num   => '商品個数',
		a8f_item_code  => '商品コード'
	);
	my @errs;
	for my $k (@{$names}) {
		my $v = $in->{$k};
		#A8FLYの利用
		if($k eq "a8f_enable") {
			if($v ne "" && $v ne "1") {
				push(@errs, [$k, "\"$cap{$k}\"に不正な値が送信されました。"]);
			} elsif($v ne "1") {
				last;
			}
		#利用パターン
		} elsif($k eq "a8f_type") {
			if($v eq "") {
				push(@errs, [$k, "\"$cap{$k}\"は必須です。"]);
			} elsif($v !~ /^(1|2)$/) {
				push(@errs, [$k, "\"$cap{$k}\"に不正な値が送信されました。"]);
			}
		#リクエストURL
		} elsif($k eq "a8f_url") {
			if($v eq "") {
				push(@errs, [$k, "\"$cap{$k}\"は必須です。"]);
			} elsif( length($v) > 255 ) {
				push(@errs, [$k, "\"$cap{$k}\"は255文字以内で指定してください。"]);
			} elsif( ! FCC::Class::String::Checker->new($v)->is_url() ) {
				push(@errs, [$k, "\"$cap{$k}\"がURLとして正しくありません。"]);
			}
		#プログラムID
		} elsif($k eq "a8f_pid") {
			if($v eq "") {
				push(@errs, [$k, "\"$cap{$k}\"は必須です。"]);
			} elsif($v !~ /^s\d{14}$/) {
				push(@errs, [$k, "\"$cap{$k}\"は小文字のsで始まる15文字の英数字を指定してください。"]);
			}
		#商品単価/報酬額
		} elsif($k eq "a8f_item_price") {
			if($v eq "") {
				push(@errs, [$k, "\"$cap{$k}\"は必須です。"]);
			} elsif($v =~ /[^\d]/) {
				push(@errs, [$k, "\"$cap{$k}\"は半角数字で指定してください。"]);
			} elsif(length($v) > 9) {
				push(@errs, [$k, "\"$cap{$k}\"に9桁以上の金額を指定することはできません。"]);
			} elsif($v == 0) {
				push(@errs, [$k, "\"$cap{$k}\"に0を指定することはできません。"]);
			}
		#商品個数
		} elsif($k eq "a8f_item_num") {
			if($in->{a8f_type} eq "1") {
				if($v eq '') {
					push(@errs, [$k, "\"$cap{$k}\"は必須です。"]);
				} elsif($v =~ /[^\d]/) {
					push(@errs, [$k, "\"$cap{$k}\"は半角数字で指定してください。"]);
				} elsif(length($v) > 4) {
					push(@errs, [$k, "\"$cap{$k}\"に4桁以上の個数額を指定することはできません。"]);
				} elsif($v == 0) {
					push(@errs, [$k, "\"$cap{$k}\"に0を指定することはできません。"]);
				}
			} else {
				$in->{a8f_item_num} = "";
			}
		#商品コード
		} elsif($k eq "a8f_item_code") {
			if($v eq "") {
				push(@errs, [$k, "\"$cap{$k}\"は必須です。"]);
			} elsif($v =~ /[^a-zA-Z0-9\-]/) {
				push(@errs, [$k, "\"$cap{$k}\"には半角英数字および半角ハイフン以外の文字を指定することはできません。"]);
			} elsif(length($v) > 50) {
				push(@errs, [$k, "\"$cap{$k}\"に50桁以上の文字を指定することはできません。"]);
			} elsif($v eq "0") {
				push(@errs, [$k, "\"$cap{$k}\"に0を指定することはできません。"]);
			}
		}
	}
	#
	return @errs;
}

1;
