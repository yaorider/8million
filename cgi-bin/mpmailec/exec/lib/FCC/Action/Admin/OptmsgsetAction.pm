package FCC::Action::Admin::OptmsgsetAction;
$VERSION = 1.00;
use strict;
use warnings;
use base qw(FCC::Action::Admin::_SuperAction);
use FCC::Class::String::Checker;
use FCC::Class::Mpfmec::Msg;

sub dispatch {
	my($self) = @_;
	my $context = {};
	#プロセスセッション
	my $pkey = $self->{q}->param("pkey");
	my $proc = $self->get_proc_session_data($pkey, "optmsg");
	if( ! $proc) {
		$context->{fatalerrs} = ["不正なリクエストです。"];
		return $context;
	}
	#入力値のname属性値のリスト
	my $mg = new FCC::Class::Mpfmec::Msg(conf=>$self->{conf});
	my $in_names = $mg->get_key_list();
	#入力値を取得
	$proc->{in} = $self->get_input_data($in_names);
	#入力値チェック
	my @errs = $self->input_check($in_names, $proc->{in});
	#エラーハンドリング
	if(@errs) {
		$proc->{errs} = \@errs;
	} else {
		$proc->{errs} = [];
		#メッセージ情報を一括セット
		$mg->set_all($proc->{in});
	}
	#
	$self->set_proc_session_data($proc);
	$context->{proc} = $proc;
	return $context;
}

sub input_check {
	my($self, $names, $in) = @_;
	my %cap = (
		rpy_deny_maddrs     => '利用禁止メールアドレスエラーメッセージ ',
		acl_deny_hosts      => '利用禁止ホストエラーメッセージ',
		acl_allow_form_urls => '外部サーバからの利用禁止エラーメッセージ',
		item_required => => '必須項目に入力・選択されなかった場合のエラーメッセージ',
		item_1_minlength => 'テキストフィールド - 入力文字数が最小文字数より少なかった場合のエラーメッセージ',
		item_1_maxlength => 'テキストフィールド - 入力文字数が最大文字数より多かった場合のエラーメッセージ',
		item_2_minlength => 'パスワードフィールド - 入力文字数が最小文字数より少なかった場合のエラーメッセージ',
		item_2_maxlength => 'パスワードフィールド - 入力文字数が最大文字数より多かった場合のエラーメッセージ',
		item_4_minlength => 'チェックボックス - 選択数が最小数より少なかった場合のエラーメッセージ',
		item_4_maxlength => 'チェックボックス - 選択数が最大数より多かった場合のエラーメッセージ',
		item_5_minlength => 'セレクトメニュー - 選択数が最小数より少なかった場合のエラーメッセージ',
		item_5_maxlength => 'セレクトメニュー - 選択数が最大数より多かった場合のエラーメッセージ',
		item_7_allow_exts => 'ファイル添付 - 選択数が最大数より多かった場合のエラーメッセージ',
		item_7_maxsize => 'ファイル添付 - 添付ファイルのサイズ制限をオーバーした場合のエラーメッセージ',
		atc_max_total_size => 'ファイル添付 - 添付ファイルの合計サイズ制限をオーバーした場合のエラーメッセージ',
		restrict_en01 => '半角数字のみ (0-9)',
		restrict_en02 => '半角英字のみ (a-zA-Z)',
		restrict_en03 => '半角英数字のみ (0-9a-zA-Z)',
		restrict_en11 => 'メールアドレス - 文字列チェックのみ',
		restrict_en12 => 'メールアドレス - 文字列チェック + DNSによるドメインチェック',
		restrict_en21 => 'URL - 文字列チェックのみ',
		restrict_en22 => 'URL - 文字列チェック + HTTP通信による実在チェック',
		restrict_en31 => '電話番号（日本国内向け）- 半角/固定電話/ハイフンなし (例:0312345678)',
		restrict_en32 => '電話番号（日本国内向け）- 半角/固定電話/ハイフンあり (例:03-1234-5678)',
		restrict_en33 => '電話番号（日本国内向け）- 半角/携帯・PHS/ハイフンなし (例:09012345678)',
		restrict_en34 => '電話番号（日本国内向け）- 半角/携帯・PHS/ハイフンあり (例:090-1234-5678)',
		restrict_en35 => '電話番号（日本国内向け）- 半角/電話全般/ハイフンなし',
		restrict_en36 => '電話番号（日本国内向け）- 半角/電話全般/ハイフンあり',
		restrict_en41 => '郵便番号（日本国内向け） - 半角/ハイフンなし (例：1234567)',
		restrict_en42 => '郵便番号（日本国内向け） - 半角/ハイフンあり (例：123-4567)',
		restrict_ja01 => '全角数字のみ (０-９)',
		restrict_ja02 => '全角アルファベットのみ (ａ-ｚＡ-Ｚ)',
		restrict_ja03 => '全角英数のみ (０-９ａ-ｚＡ-Ｚ)',
		restrict_ja04 => '全角ひらがなのみ',
		restrict_ja05 => '全角カタカナのみ'
	);
	my @errs;
	for my $k (@{$names}) {
		my $v = $in->{$k};
		if($v eq "") {
			#push(@errs, [$k, "\"$cap{$k}\"は必須です。"]);
		} else {
			my $char_num = FCC::Class::String::Checker->new($v, "utf8")->get_char_num();
			if($char_num > 255) {
				push(@errs, [$k, "\"$cap{$k}\"は255文字以内で入力してください。"]);
			}
		}
	}
	#
	return @errs;
}

1;
