package FCC::Action::Admin::OptdtlsetAction;
$VERSION = 1.00;
use strict;
use warnings;
use base qw(FCC::Action::Admin::_SuperAction);
use CGI::Utils;
use FCC::Class::Syscnf;
use FCC::Class::String::Checker;

sub dispatch {
	my($self) = @_;
	my $context = {};
	#プロセスセッション
	my $pkey = $self->{q}->param("pkey");
	my $proc = $self->get_proc_session_data($pkey, "optdtl");
	if( ! $proc) {
		$context->{fatalerrs} = ["不正なリクエストです。"];
		return $context;
	}
	#入力値のname属性値のリスト
	my $in_names = [
		'atc_max_total_size',
		'atc_thumb_show',
		'atc_thumb_w',
		'atc_thumb_h',
		'atc_thumb_module',
		'atc_thumb_format'
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
		#システム設定情報をセット
		FCC::Class::Syscnf->new(conf=>$self->{conf})->set($proc->{in});
	}
	#
	$self->set_proc_session_data($proc);
	$context->{proc} = $proc;
	return $context;
}

sub input_check {
	my($self, $names, $in) = @_;
	my %cap = (
		atc_max_total_size => '添付ファイルの合計サイズ制限',
		atc_thumb_show     => '添付ファイルのサムネイル表示',
		atc_thumb_w        => '添付ファイルのサムネイル横幅',
		atc_thumb_h        => '添付ファイルのサムネイル縦幅',
		atc_thumb_module   => '画像変換モジュール',
		atc_thumb_format   => 'サムネイルの画像フォーマット'
	);
	my @errs;
	for my $k (@{$names}) {
		my $v = $in->{$k};
		unless( defined $v ) { $v = ""; }
		#添付ファイルの合計サイズ制限
		if($k eq "atc_max_total_size") {
			if($v eq "") {
				push(@errs, [$k, "\"$cap{$k}\"は必須です。"]);
			} elsif($v =~ /[^\d]/) {
				push(@errs, [$k, "\"$cap{$k}\"は半角数字で指定してください。"]);
			} elsif($v == 0) {
				push(@errs, [$k, "\"$cap{$k}\"に0を指定することはできません。"]);
			} else {
				$in->{$k} += 0;
			}
		#添付ファイルのサムネイル表示
		} elsif($k eq "atc_thumb_show") {
			if($v ne "" && $v ne "1") {
				push(@errs, [$k, "\"$cap{$k}\"に不正な値が送信されました。"]);
			}
		#添付ファイルのサムネイル横幅
		} elsif($k eq "atc_thumb_w") {
			if($v ne "") {
				if($v =~ /[^\d]/) {
					push(@errs, [$k, "\"$cap{$k}\"は半角数字で指定してください。"]);
				} elsif($v == 0) {
					push(@errs, [$k, "\"$cap{$k}\"に0を指定することはできません。"]);
				} elsif($v > 1024) {
					push(@errs, [$k, "\"$cap{$k}\"には1024より大きい値を指定することはできません。"]);
				} else {
					$in->{$k} += 0;
				}
			}
		#添付ファイルのサムネイル縦幅
		} elsif($k eq "atc_thumb_h") {
			if($v ne "") {
				if($v =~ /[^\d]/) {
					push(@errs, [$k, "\"$cap{$k}\"は半角数字で指定してください。"]);
				} elsif($v == 0) {
					push(@errs, [$k, "\"$cap{$k}\"に0を指定することはできません。"]);
				} elsif($v > 1024) {
					push(@errs, [$k, "\"$cap{$k}\"には1024より大きい値を指定することはできません。"]);
				} else {
					$in->{$k} += 0;
				}
			}
		#画像変換モジュール
		} elsif($k eq "atc_thumb_module") {
			if($v eq "") {
				if($in->{atc_thumb_show}) {
					push(@errs, [$k, "\"$cap{$k}\"は必須です。"]);
				}
			} elsif($v !~ /^(auto|im|gd)$/) {
				push(@errs, [$k, "\"$cap{$k}\"に不正な値が送信されました。"]);
			}
		#サムネイルの画像フォーマット
		} elsif($k eq "atc_thumb_format") {
			if($v eq "") {
				if($in->{atc_thumb_show}) {
					push(@errs, [$k, "\"$cap{$k}\"は必須です。"]);
				}
			} elsif($v !~ /^(gif|jpeg|png)$/) {
				push(@errs, [$k, "\"$cap{$k}\"に不正な値が送信されました。"]);
			}
		}
	}
	#
	return @errs;
}

1;
