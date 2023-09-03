package FCC::Action::Admin::OptactsetAction;
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
	my $proc = $self->get_proc_session_data($pkey, "optact");
	if( ! $proc) {
		$context->{fatalerrs} = ["不正なリクエストです。"];
		return $context;
	}
	#入力値のname属性値のリスト
	my $in_names = [
		'lang',
		'html_00_encoding',
		'html_00_doctype',
		'html_mobi_selectable',
		'html_mobi_carrier_selectable',
		'html_auto_ctype',
		'html_10_doctype',
		'html_10_encoding',
		'html_11_doctype',
		'html_11_encoding',
		'html_12_doctype',
		'html_12_encoding',
		'html_13_doctype',
		'html_13_encoding',
		'confirm_enable',
		'thx_redirect_enable',
		'thx_redirect_url'
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
		my %u = %{$proc->{in}};
		if($u{lang} eq "ja") {
			if($u{html_mobi_selectable} eq "1") {
				if($u{html_mobi_carrier_selectable} eq "1") {
					delete $u{html_10_doctype};
					delete $u{html_10_encoding};
				} else {
					delete $u{html_11_doctype};
					delete $u{html_11_encoding};
					delete $u{html_12_doctype};
					delete $u{html_12_encoding};
					delete $u{html_13_doctype};
					delete $u{html_13_encoding};
				}
			} else {
				delete $u{html_mobi_carrier_selectable};
				delete $u{html_10_doctype};
				delete $u{html_10_encoding};
				delete $u{html_11_doctype};
				delete $u{html_11_encoding};
				delete $u{html_12_doctype};
				delete $u{html_12_encoding};
				delete $u{html_13_doctype};
				delete $u{html_13_encoding};
			}
		} else {
			delete $u{html_mobi_selectable};
			delete $u{html_mobi_carrier_selectable};
			delete $u{html_10_doctype};
			delete $u{html_10_encoding};
			delete $u{html_11_doctype};
			delete $u{html_11_encoding};
			delete $u{html_12_doctype};
			delete $u{html_12_encoding};
			delete $u{html_13_doctype};
			delete $u{html_13_encoding};
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
		lang                 => '言語',
		html_00_encoding     => 'サイトの文字エンコーディング',
		html_00_doctype      => 'サイトのドキュメントタイプ',
		html_mobi_selectable => '携帯端末の画面自動振り分け',
		html_mobi_carrier_selectable => '携帯キャリアごとの画面自動振り分け',
		html_auto_ctype      => 'Content-Typeの自動認識',
		html_10_doctype      => '携帯端末共通ドキュメントタイプ',
		html_10_encoding     => '携帯端末共通文字エンコーディング',
		html_11_doctype      => 'DoCoMo端末用ドキュメントタイプ',
		html_11_encoding     => 'DoCoMo端末用文字エンコーディング',
		html_12_doctype      => 'au端末用ドキュメントタイプ',
		html_12_encoding     => 'au端末用文字エンコーディング',
		html_13_doctype      => 'Softbank端末用ドキュメントタイプ',
		html_13_encoding     => 'Softbank端末用文字エンコーディング',
		confirm_enable       => '確認画面の表示',
		thx_redirect_enable  => '完了画面表示方法',
		thx_redirect_url     => '完了画面リダイレクト先URL'
	);
	my @errs;
	for my $k (@{$names}) {
		my $v = $in->{$k};
		#言語
		if($k eq "lang") {
			if($v eq "") {
				push(@errs, [$k, "\"$cap{$k}\"は必須です。"]);
			} elsif($v !~ /^(de|en|es|fr|ja|ko|pt|ru|zh)$/) {
				push(@errs, [$k, "\"$cap{$k}\"に不正な値が送信されました。"]);
			}
		#サイトの文字エンコーディング
		} elsif($k eq "html_00_encoding") {
			if($v eq "") {
				push(@errs, [$k, "\"$cap{$k}\"は必須です。"]);
			} elsif($v !~ /^(0|1|2|3|4)$/) {
				push(@errs, [$k, "\"$cap{$k}\"に不正な値が送信されました。"]);
			}
		#サイトのドキュメントタイプ
		} elsif($k eq "html_00_doctype") {
			if($v eq "") {
				push(@errs, [$k, "\"$cap{$k}\"は必須です。"]);
			} elsif($v !~ /^\d{4}$/) {
				push(@errs, [$k, "\"$cap{$k}\"に不正な値が送信されました。"]);
			}
		#携帯端末の画面自動振り分け
		} elsif($k eq "html_mobi_selectable") {
			if($in->{lang} eq "ja") {
				if($v ne "" && $v ne "1") {
					push(@errs, [$k, "\"$cap{$k}\"に不正な値が送信されました。"]);
				}
			} else {
				delete $in->{$k};
			}
		#携帯キャリアごとの画面自動振り分け
		} elsif($k eq "html_mobi_carrier_selectable") {
			if($in->{lang} eq "ja" && $in->{html_mobi_selectable} eq "1") {
				if($v eq "") {
					push(@errs, [$k, "\"$cap{$k}\"は必須です。"]);
				} elsif($v !~ /^(0|1)$/) {
					push(@errs, [$k, "\"$cap{$k}\"に不正な値が送信されました。"]);
				}
			}
		#携帯端末共通ドキュメントタイプ
		} elsif($k eq "html_10_doctype") {
			if($in->{lang} eq "ja" && $in->{html_mobi_selectable} eq "1" && $in->{html_mobi_carrier_selectable} eq "0") {
				if($v eq "") {
					push(@errs, [$k, "\"$cap{$k}\"は必須です。"]);
				} elsif($v !~ /^\d{4}$/) {
					push(@errs, [$k, "\"$cap{$k}\"に不正な値が送信されました。"]);
				}
			}
		#携帯端末共通文字エンコーディング
		} elsif($k eq "html_10_encoding") {
			if($in->{lang} eq "ja" && $in->{html_mobi_selectable} eq "1" && $in->{html_mobi_carrier_selectable} eq "0") {
				if($v eq "") {
					push(@errs, [$k, "\"$cap{$k}\"は必須です。"]);
				} elsif($v !~ /^(0|1|2|3|4)$/) {
					push(@errs, [$k, "\"$cap{$k}\"に不正な値が送信されました。"]);
				}
			}
		#携帯キャリア別ドキュメントタイプ
		} elsif($k =~ /html_1\d_doctype/) {
			if($in->{lang} eq "ja" && $in->{html_mobi_selectable} eq "1" && $in->{html_mobi_carrier_selectable} eq "1") {
				if($v eq "") {
					push(@errs, [$k, "\"$cap{$k}\"は必須です。"]);
				} elsif($v !~ /^\d{4}$/) {
					push(@errs, [$k, "\"$cap{$k}\"に不正な値が送信されました。"]);
				}
			} else {
				delete $in->{$k};
			}
		#携帯キャリア別文字エンコーディング
		} elsif($k =~ /^html_1\d_encoding$/) {
			if($in->{lang} eq "ja" && $in->{html_mobi_selectable} eq "1" && $in->{html_mobi_carrier_selectable} eq "1") {
				if($v eq "") {
					push(@errs, [$k, "\"$cap{$k}\"は必須です。"]);
				} elsif($v !~ /^(0|1|2|3|4)$/) {
					push(@errs, [$k, "\"$cap{$k}\"に不正な値が送信されました。"]);
				}
			}
		#Content-Typeの自動認識
		} elsif($k eq "html_auto_ctype") {
			if($v ne "" && $v ne "1") {
				push(@errs, [$k, "\"$cap{$k}\"に不正な値が送信されました。"]);
			}
		#完了画面表示方法
		} elsif($k eq "thx_redirect_enable") {
			if($v eq "") {
				push(@errs, [$k, "\"$cap{$k}\"は必須です。"]);
			} elsif($v !~ /^(0|1)$/) {
				push(@errs, [$k, "\"$cap{$k}\"に不正な値が送信されました。"]);
			}
		#リダイレクト先URL
		} elsif($k eq "thx_redirect_url") {
			if($in->{thx_redirect_enable} eq "1") {
				if($v eq "") {
					push(@errs, [$k, "\"$cap{$k}\"は必須です。"]);
				} elsif( length($v) > 255 ) {
					push(@errs, [$k, "\"$cap{$k}\"は255文字以内で指定してください。"]);
				} elsif( ! FCC::Class::String::Checker->new($v)->is_url() ) {
					push(@errs, [$k, "\"$cap{$k}\"がURLとして正しくありません。"]);
				}
			}
		}
	}
	#
	return @errs;
}

1;
