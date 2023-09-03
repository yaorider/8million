package FCC::Action::Admin::OptmaisetAction;
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
	my $proc = $self->get_proc_session_data($pkey, "optmai");
	if( ! $proc) {
		$context->{fatalerrs} = ["不正なリクエストです。"];
		return $context;
	}
	#入力値のname属性値のリスト
	my $in_names = [
		'mai_to',
		'mai_cc',
		'mai_bcc',
		'mai_from',
		'mai_from_default',
		'mai_sender',
		'mai_subject',
		'mai_word_wrap',
		'mai_addon_headers'
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
		mai_to            => '受信アドレス',
		mai_cc            => 'Cc',
		mai_bcc           => 'Bcc',
		mai_from          => '差出人メールアドレスの入力項目',
		mai_from_default  => 'デフォルトの差出人メールアドレス',
		mai_sender        => '差出人名',
		mai_subject       => 'サブジェクト（題名）',
		mai_word_wrap     => '英文ワードラップ・禁則処理折返文字数',
		mai_addon_headers => '追加メールヘッダー'
	);
	my @errs;
	for my $k (@{$names}) {
		my $v = $in->{$k};
		#受信アドレス
		if($k eq "mai_to") {
			$v =~ s/\s//g;
			my $n = FCC::Class::String::Checker->new($v, "utf8")->get_char_num();
			if($v eq "") {
				push(@errs, [$k, "\"$cap{$k}\"は必須です。"]);
			} elsif($n > 1024) {
				push(@errs, [$k, "\"$cap{$k}\"は1024文字以内で指定してください。"]);
			} else {
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
			}
		#Cc
		} elsif($k eq "mai_cc") {
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
		} elsif($k eq "mai_bcc") {
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
		#差出人メールアドレスの入力項目
		} elsif($k eq "mai_from") {
			#全フォーム項目情報を取得
			my $items = FCC::Class::Mpfmec::Item->new(conf=>$self->{conf})->get();
			if($v eq "") {

			} elsif( ! exists $items->{$v} ) {
				push(@errs, [$k, "\"$cap{$k}\"に不正な値が送信されました。"]);
			} elsif( $items->{$v}->{type} ne "1" || $items->{$v}->{type_1_is_email} ne "1") {
				push(@errs, [$k, "\"$cap{$k}\"に指定できるフォーム項目はテキストフィールドでメールアドレス入力欄として定義された項目のみです。"]);
			}
		#デフォルトの差出人メールアドレス
		} elsif($k eq "mai_from_default") {
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
		} elsif($k eq "mai_sender") {
			if($v ne "") {
				my $n = FCC::Class::String::Checker->new($v, "utf8")->get_char_num();
				if($n > 255) {
					push(@errs, [$k, "\"$cap{$k}\"は255文字以内で指定してください。"]);
				}
			}
		#サブジェクト
		} elsif($k eq "mai_subject") {
			if($v eq "") {
				push(@errs, [$k, "\"$cap{$k}\"は必須です。"]);
			} else {
				my $n = FCC::Class::String::Checker->new($v, "utf8")->get_char_num();
				if($n > 255) {
					push(@errs, [$k, "\"$cap{$k}\"は255文字以内で指定してください。"]);
				}
			}
		#英文ワードラップ・禁則処理折返文字数
		} elsif($k eq "mai_word_wrap") {
			if($v ne "") {
				if($v =~ /[^\d]/) {
					push(@errs, [$k, "\"$cap{$k}\"は半角数字で指定してください。"]);
				} elsif($v < 50) {
					push(@errs, [$k, "\"$cap{$k}\"は50以上の値を指定してください。"]);
				} else{
					$in->{$k} += 0;
				}
			}
		#追加メールヘッダー
		} elsif($k eq "mai_addon_headers") {
			if( length($v) > 1024 ) {
				push(@errs, [$k, "\"$cap{$k}\"は改行も含め1024文字以内で指定してください。"]);
			} else {
				my @lines = split(/\n+/, $v);
				my @recs;
				for my $line (@lines) {
					if($line eq "") { next; }
					if($line =~ /^([^\:]+)\s*\:\s*(.+)$/) {
						my $h = $1;
						my $hv = $2;
						if($h =~ /[^a-zA-Z0-9\-]/) {
							my $escaped_h = CGI::Utils->new()->escapeHtml($h);
							push(@errs, [$k, "\"$cap{$k}\"に指定したヘッダー名 '${escaped_h}' に半角英数および半角ハイフン以外の文字が含まれています。"]);
						} elsif($h =~ /^(To|Cc|Bcc|Subject|From|Return\-Path|X\-Mailer|MIME\-Version|Content\-Type|Content\-Transfer\-Encoding)$/i) {
							my $escaped_h = CGI::Utils->new()->escapeHtml($h);
							push(@errs, [$k, "\"$cap{$k}\"に指定したヘッダー名 '${escaped_h}' を追加することはできません。"]);
						} elsif($hv =~ /[^\x20-\x7e]/) {
							my $escaped_h = CGI::Utils->new()->escapeHtml($h);
							my $escaped_hv = CGI::Utils->new()->escapeHtml($hv);
							push(@errs, [$k, "\"$cap{$k}\"に指定したヘッダー名 '${escaped_h}' の値 '${escaped_hv}' に半角英数および記号以外の文字が含まれています。"]);
						}
					} else {
						my $escaped_line = CGI::Utils->new()->escapeHtml($line);
						push(@errs, [$k, "\"$cap{$k}\"に指定した '${escaped_line}' はヘッダーとして不適切です。"]);
					}
					$line =~ s/\s*\:\s*/\: /;
					push(@recs, $line);
				}
				$in->{$k} = join("\n", @recs);
			}
		}
	}
	#
	return @errs;
}

1;
