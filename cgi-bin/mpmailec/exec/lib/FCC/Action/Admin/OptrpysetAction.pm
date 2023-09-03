package FCC::Action::Admin::OptrpysetAction;
$VERSION = 1.00;
use strict;
use warnings;
use base qw(FCC::Action::Admin::_SuperAction);
use CGI::Utils;
use Email::Valid;
use FCC::Class::Syscnf;
use FCC::Class::String::Checker;
use FCC::Class::Mpfmec::Item;

sub dispatch {
	my($self) = @_;
	my $context = {};
	#プロセスセッション
	my $pkey = $self->{q}->param("pkey");
	my $proc = $self->get_proc_session_data($pkey, "optrpy");
	if( ! $proc) {
		$context->{fatalerrs} = ["不正なリクエストです。"];
		return $context;
	}
	#入力値のname属性値のリスト
	my $in_names = [
		'rpy_enable',
		'rpy_item',
		'rpy_from',
		'rpy_sender',
		'rpy_subject',
		'rpy_cc',
		'rpy_bcc',
		'rpy_error_to',
		'rpy_word_wrap',
		'rpy_priority',
		'rpy_notification',
		'rpy_atc_reply'
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
		if($proc->{in}->{rpy_enable} eq "1") {
			%u = %{$proc->{in}};
		} else {
			$u{rpy_enable} = "";
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
		rpy_enable       => '自動返信メール送信',
		rpy_item         => 'メールアドレス入力欄のフォーム項目',
		rpy_from         => '差出人メールアドレス',
		rpy_sender       => '差出人名',
		rpy_subject      => 'サブジェクト（件名）',
		rpy_cc           => 'Cc',
		rpy_bcc          => 'Bcc',
		rpy_error_to     => 'エラーメール受信アドレス',
		rpy_word_wrap    => '英文ワードラップ・禁則処理折返文字数',
		rpy_priority     => 'メール重要度',
		rpy_notification => '開封確認メッセージの要求',
		rpy_atc_reply    => '添付ファイルの扱い'
	);
	my @errs;
	for my $k (@{$names}) {
		my $v = $in->{$k};
		if( ! defined $v ) { $v = ""; }
		#自動返信メール送信
		if($k eq "rpy_enable") {
			if($v ne "" && $v ne "1") {
				push(@errs, [$k, "\"$cap{$k}\"に不正な値が送信されました。"]);
			} elsif($v ne "1") {
				last;
			}
		#メールアドレス入力欄のフォーム項目
		} elsif($k eq "rpy_item") {
			#全フォーム項目情報を取得
			my $items = FCC::Class::Mpfmec::Item->new(conf=>$self->{conf})->get();
			if($v eq "") {
				push(@errs, [$k, "\"$cap{$k}\"は必須です。"]);
			} elsif( ! exists $items->{$v} ) {
				push(@errs, [$k, "\"$cap{$k}\"に不正な値が送信されました。"]);
			} elsif( $items->{$v}->{type} ne "1" || ! $items->{$v}->{type_1_is_email} ) {
				push(@errs, [$k, "\"$cap{$k}\"に指定できるフォーム項目はテキストフィールドでメールアドレス入力欄として定義された項目のみです。"]);
			}
		#差出人メールアドレス
		} elsif($k eq "rpy_from") {
			if($v eq "") {
				push(@errs, [$k, "\"$cap{$k}\"は必須です。"]);
			} elsif( ! Email::Valid->rfc822($v) ) {
				push(@errs, [$k, "\"$cap{$k}\"に入力された値はメールアドレスとして不適切です。"]);
			} else {
				my $n = FCC::Class::String::Checker->new($v, "utf8")->get_char_num();
				if($n > 255) {
					push(@errs, [$k, "\"$cap{$k}\"は255文字以内で指定してください。"]);
				}
			}
		#差出人名
		} elsif($k eq "rpy_sender") {
			if($v ne "") {
				my $n = FCC::Class::String::Checker->new($v, "utf8")->get_char_num();
				if($n > 255) {
					push(@errs, [$k, "\"$cap{$k}\"は255文字以内で指定してください。"]);
				}
			}
		#サブジェクト（件名）
		} elsif($k eq "rpy_subject") {
			if($v eq "") {
				push(@errs, [$k, "\"$cap{$k}\"は必須です。"]);
			} else {
				my $n = FCC::Class::String::Checker->new($v, "utf8")->get_char_num();
				if($n > 255) {
					push(@errs, [$k, "\"$cap{$k}\"は255文字以内で指定してください。"]);
				}
			}
		#Cc
		} elsif($k eq "rpy_cc") {
			$v =~ s/\s//g;
			my $n = FCC::Class::String::Checker->new($v, "utf8")->get_char_num();
			if($n > 1024) {
				push(@errs, [$k, "\"$cap{$k}\"は1024文字以内で指定してください。"]);
			}
			my @parts = split(/,/, $v);
			my @list;
			for my $p (@parts) {
				if($p eq "") { next; }
				if( ! Email::Valid->rfc822($p) ) {
					my $escaped_v = CGI::Utils->new()->escapeHtml($p);
					push(@errs, [$k, "\"$cap{$k}\"に指定した '${escaped_v}' はメールアドレスとして不適切です。"]);
				}
				push(@list, $p);
			}
			$in->{$k} = join(",", @list);
		#Bcc
		} elsif($k eq "rpy_bcc") {
			$v =~ s/\s//g;
			my $n = FCC::Class::String::Checker->new($v, "utf8")->get_char_num();
			if($n > 1024) {
				push(@errs, [$k, "\"$cap{$k}\"は1024文字以内で指定してください。"]);
			}
			my @parts = split(/,/, $v);
			my @list;
			for my $p (@parts) {
				if($p eq "") { next; }
				if( ! Email::Valid->rfc822($p) ) {
					my $escaped_v = CGI::Utils->new()->escapeHtml($p);
					push(@errs, [$k, "\"$cap{$k}\"に指定した '${escaped_v}' はメールアドレスとして不適切です。"]);
				}
				push(@list, $p);
			}
			$in->{$k} = join(",", @list);
		#エラーメール受信アドレス
		} elsif($k eq "rpy_error_to") {
			if($v ne "") {
				if( ! Email::Valid->rfc822($v) ) {
					push(@errs, [$k, "\"$cap{$k}\"に入力された値はメールアドレスとして不適切です。"]);
				} else {
					my $n = FCC::Class::String::Checker->new($v, "utf8")->get_char_num();
					if($n > 255) {
						push(@errs, [$k, "\"$cap{$k}\"は255文字以内で指定してください。"]);
					}
				}
			}
		#英文ワードラップ・禁則処理折返文字数
		} elsif($k eq "rpy_word_wrap") {
			if($v ne "") {
				if($v =~ /[^\d]/) {
					push(@errs, [$k, "\"$cap{$k}\"は半角数字で指定してください。"]);
				} elsif($v < 50) {
					push(@errs, [$k, "\"$cap{$k}\"は50以上の値を指定してください。"]);
				} else{
					$in->{$k} += 0;
				}
			}
		#メール重要度
		} elsif($k eq "rpy_priority") {
			if($v eq "") {
				push(@errs, [$k, "\"$cap{$k}\"は必須です。"]);
			} elsif($v !~ /^(1|2|3|4|5)$/) {
				push(@errs, [$k, "\"$cap{$k}\"に不正な値がそうしんされました。"]);
			}
		#開封確認メッセージの要求
		} elsif($k eq "rpy_notification") {
			if($v ne "" && $v ne "1") {
				push(@errs, [$k, "\"$cap{$k}\"に不正な値が送信されました。"]);
			}
		#添付ファイルの扱い
		} elsif($k eq "rpy_atc_reply") {
			if($v ne "" && $v ne "1") {
				push(@errs, [$k, "\"$cap{$k}\"に不正な値が送信されました。"]);
			}
		}
	}
	#
	return @errs;
}

1;
