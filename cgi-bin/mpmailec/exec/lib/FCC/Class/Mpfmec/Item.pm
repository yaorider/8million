package FCC::Class::Mpfmec::Item;
$VERSION = 1.00;
use strict;
use warnings;
use base qw(FCC::_Super);
use Carp;
use Data::Serializer;
use File::Copy;
use FCC::Class::Mpfmec::Txt;
use FCC::Class::String::Checker;

sub init {
	my($self, %args) = @_;
	$self->{conf} = $args{conf};
	#
	$self->{file} = "$args{conf}->{BASE_DIR}/data/items.cgi";
	#$self->{serializer} = Data::Serializer->new(raw => 1);	#Data::Serializer
	$self->{serializer} = Data::Serializer->new();	#Data::Serializer
	#
	unless( -e $self->{file} ) {
		open my $fh, ">", $self->{file} or croak "failed to make $self->{file} : $!";
		close($fh);
		chmod 0600, $self->{file};
	}
}

#---------------------------------------------------------------------
#■ フォーム項目のオフセットをアップデート
#---------------------------------------------------------------------
#[引数]
#	1.name属性値
#	2.オフセット値
#[戻り値]
#	成功すれば1を返す。
#	失敗すればcroakする。
#---------------------------------------------------------------------
sub offset_update {
	my($self, $name, $offset) = @_;
	#設定情報を読み取る
	my $items = $self->get();
	#引数のチェック
	if($name eq "") {
		croak "the augument of name attribute is lacking.";
	} elsif( ! exists $items->{$name} ) {
		croak "the specified name attribute is not found.";
	}
	if($offset eq "") {
		croak "the augument of offset is lacking.";
	} elsif( $offset =~ /[^\d]/ ) {
		croak "the specified offset attribute must be a number.";
	}
	#該当の項目が存在しなければcroak
	if( ! $items->{$name} ) {
		croak "the item which has the specified name is not exists.";
	}
	#新しいオフセットをセット
	my $itm = $items->{$name};
	$itm->{offset} = $offset + 0;
	#アップデート
	$self->set($itm);
	#
	return 1;
}

#---------------------------------------------------------------------
#■ フォーム項目リストをゲット
#---------------------------------------------------------------------
#[引数]
#	なし
#[戻り値]
#	成功すればhashrefを返す。
#	失敗すればcroakする。
#---------------------------------------------------------------------
sub get {
	my($self) = @_;
	my $data;
	eval { $data = $self->{serializer}->retrieve($self->{file}); };
	if($@) {
		croak "failed to retrieve form controls configuration data from $self->{file}. : $@";
	}
	unless($data) {
		$data = {};
	}
	return $data;
}

#---------------------------------------------------------------------
#■ フォーム項目リストをセット
#---------------------------------------------------------------------
#[引数]
#	1.設定情報を格納したhashref
#[戻り値]
#	成功すれば挿入後の全項目のhashrefを返す。
#	失敗すればcroakする。
#---------------------------------------------------------------------
sub set {
	my($self, $itm) = @_;
	#引数のチェック
	if($itm) {
		if( ref($itm) ne "HASH") {
			croak "the 1st augument must be a hashref.";
		} elsif($itm->{name} eq "") {
			croak "the 1st augument must be a hashref including a name attribute.";
		}
	} else {
		croak "auguments are lacking.";
	}
	#設定情報を読み取る
	my $items = $self->get();
	#項目数を調べる
	my $num = scalar keys %{$items};
	#登録する項目のoffsetを決定
	if( exists $items->{$itm->{name}} ) {
		delete $items->{$itm->{name}};
		$itm->{offset} = $itm->{offset};
	} else {
		$itm->{offset} = $num;
	}
	$itm->{offset} += 0;
	#offsetを考慮しながら、項目データを再構成
	my $new_offset = 0;
	for my $name ( sort { $items->{$a}->{offset} <=> $items->{$b}->{offset} } keys %{$items} ) {
		if($new_offset == $itm->{offset}) {
			$new_offset ++;
		}
		$items->{$name}->{offset} = $new_offset;
		$new_offset ++;
	}
	$items->{$itm->{name}} = $itm;
	#一括セット
	$self->set_all($items);
	#
	return $items;
}

#---------------------------------------------------------------------
#■ フォーム項目を削除
#---------------------------------------------------------------------
#[引数]
#	1.name属性値
#[戻り値]
#	成功すれば削除後の全項目のhashrefを返す。
#	失敗すればcroakする。
#---------------------------------------------------------------------
sub del {
	my($self, $name) = @_;
	#引数のチェック
	if($name eq "") {
		croak "auguments are lacking.";
	}
	#設定情報を読み取る
	my $items = $self->get();
	#指定のname属性の項目がなければcroak
	if( ! exists $items->{$name} ) {
		croak "the specified name attribute is not found.";
	}
	#削除
	delete $items->{$name};
	#オフセットを再構成
	my $new_offset = 0;
	for my $name ( sort { $items->{$a}->{offset} <=> $items->{$b}->{offset} } keys %{$items} ) {
		$items->{$name}->{offset} = $new_offset;
		$new_offset ++;
	}
	#一括セット
	$self->set_all($items);
	#
	return $items;
}

#---------------------------------------------------------------------
#■一括セット
#---------------------------------------------------------------------
#[引数]
#	1.hashref
#[戻り値]
#	成功すれば1を返す。
#	失敗すればcroakする。
#---------------------------------------------------------------------
sub set_all {
	my($self, $ref) = @_;
	#引数のチェック
	if($ref) {
		if( ref($ref) ne "HASH") {
			croak "the 1st augument must be a hashref.";
		}
	} else {
		croak "auguments are lacking.";
	}
	#古いデータ格納ファイルを削除
	unlink $self->{file};
	#新しいデータ格納ファイルを生成
	eval { $self->{serializer}->store($ref, $self->{file}, "w", 0600); };
	if($@) {
		croak "failed to set form controls configuration data. : $@"; ;
	}
	chmod 0600, $self->{file};
	return 1;
}

#---------------------------------------------------------------------
#■登録・修正時の入力値チェック
#---------------------------------------------------------------------

sub input_check {
	my($self, $names, $in) = @_;
	my %cap = (
		name               => '識別キー',
		caption            => '項目名',
		desc               => '説明文',
		type               => 'コントロール種別',
		required           => '必須指定',
		type_1_width       => '横幅のサイズ',
		type_1_minlength   => '最小入力文字数',
		type_1_maxlength   => '最大入力文字数',
		type_1_value       => 'デフォルト値',
		type_1_is_email    => 'メールアドレス入力欄',
		type_1_deny_emails => '禁止メールアドレス',
		type_2_width       => '横幅のサイズ',
		type_2_minlength   => '最小入力文字数',
		type_2_maxlength   => '最大入力文字数',
		type_3_elements    => '選択項目',
		type_3_arrangemen  => '表示方法',
		type_4_elements    => '選択項目',
		type_4_arrangement => '表示方法',
		type_4_minlength   => '最小選択数',
		type_4_maxlength   => '最大選択数',
		type_5_elements    => '選択項目',
		type_5_multiple    => '複数行選択',
		type_5_minlength   => '最小選択数',
		type_5_maxlength   => '最大選択数',
		type_6_cols        => '横サイズ',
		type_6_rows        => '縦サイズ',
		type_6_minlength   => '最小入力文字数',
		type_6_maxlength   => '最大入力文字数',
		type_6_value       => 'デフォルト値',
		type_7_maxsize     => '添付ファイルのサイズ制限',
		type_7_allow_exts  => '添付ファイルの拡張子制限',
		type_8_handover    => 'パラメータ引き継ぎ',
		type_8_minlength   => '最小入力文字数',
		type_8_maxlength   => '最大入力文字数',
		type_8_value       => '固定値'
	);
	for( my $i=1; $i<=5; $i++ ) {
		$cap{"type_1_convert_${i}"} = "変換ルール${i}";
		$cap{"type_6_convert_${i}"} = "変換ルール1";
	}
	for( my $i=1; $i<=3; $i++ ) {
		$cap{"type_1_restrict_${i}"} = "制限ルール${i}";
	}
	#全フォーム項目情報を取得
	my $items = FCC::Class::Mpfmec::Item->new(conf=>$self->{conf})->get();
	#FCC::Class::Mpfmec::Txtのインスタンス
	my $otxt = new FCC::Class::Mpfmec::Txt(conf=>$self->{conf});
	#入力値制限ハッシュ
	my $restricts = $otxt->get_restricts();
	#入力値変換ハッシュ
	my $converts = $otxt->get_converts();
	#
	my @errs;
	for my $k (@{$names}) {
		my $v = $in->{$k};
		my $len = FCC::Class::String::Checker->new($v, "utf8")->get_char_num();
		#識別キー
		if($k eq "name") {
			$v = lc $v;
			if($v eq "") {
				push(@errs, [$k, "\"$cap{$k}\"は必須です。"]);
			} elsif($v =~ /[^a-zA-Z0-9\_]/) {
				push(@errs, [$k, "\"$cap{$k}\"に不適切な文字が含まれています。"]);
			} elsif($v !~ /^[a-zA-Z]/) {
				push(@errs, [$k, "\"$cap{$k}\"の先頭の文字は半角アルファベットとしてください。"]);
			} elsif($len > 15) {
				push(@errs, [$k, "\"$cap{$k}\"は15文字以内としてください。"]);
			} elsif(exists $items->{$v}) {
				my $escaped_v = CGI::Utils->new()->escapeHtml($v);
				push(@errs, [$k, "\"$cap{$k}\"に指定した '${escaped_v}' はすでに登録されています。"]);
			} else {
				my @ng_names = keys %{$self->{conf}};
				push(@ng_names, "xml_declaration", "err", "err_loop", "lang", "ctype", "static_url", "form", "form_cgi_url", "hidden", "back_url", "A8FLY");
				push(@ng_names, "RECEPTION_DATE", "RECEPTION_DATE_Y", "RECEPTION_DATE_m", "RECEPTION_DATE_d", "RECEPTION_DATE_H", "RECEPTION_DATE_i", "RECEPTION_DATE_s", "RECEPTION_DATE_O", "RECEPTION_DATE_e", "RECEPTION_DATE_I");
				push(@ng_names, "REMOTE_ADDR", "REMOTE_HOST", "HTTP_USER_AGENT", "SERIAL", "SIRIAL");
				for my $word (@ng_names) {
					if($v =~ /^\E${word}\Q/i) {
						my $escaped_v = CGI::Utils->new()->escapeHtml($v);
						push(@errs, [$k, "\"$cap{$k}\"に指定した '${escaped_v}' は予約語のため登録することはできません。"]);
						last;
					}
				}
			}
			$in->{$k} = $v;
		#項目名
		} elsif($k eq "caption") {
			if($v eq "") {
				push(@errs, [$k, "\"$cap{$k}\"は必須です。"]);
			} elsif($len > 255) {
				push(@errs, [$k, "\"$cap{$k}\"は255文字以内で指定してください。"]);
			}
		#説明文
		} elsif($k eq "desc") {
			if($len > 1024) {
				push(@errs, [$k, "\"$cap{$k}\"は1024文字以内で指定してください。"]);
			}
		#コントロール種別
		} elsif($k eq "type") {
			if($v eq "") {
				push(@errs, [$k, "\"$cap{$k}\"は必須です。"]);
			} elsif($v !~ /^(1|2|3|4|5|6|7|8)$/) {
				push(@errs, [$k, "\"$cap{$k}\"に不正な値が送信されました。"]);
			}
		#必須指定
		} elsif($k eq "required") {
			if($v ne "" && $v ne "1") {
				push(@errs, [$k, "\"$cap{$k}\"に不正な値が送信されました。"]);
			}
		}
		####
		#テキスト入力フィールド
		if($in->{type} eq "1") {
			my $net_dns_available = 1;
			eval{ require Net::DNS; };
			if($@) { $net_dns_available = 0; }
			#
			my $lwp_available = 1;
			eval{ require LWP::UserAgent; };
			if($@) { $lwp_available = 0; }
			#横幅のサイズ
			if($k eq "type_1_width") {
				if($v ne "") {
					if($v =~ /[^a-zA-Z0-9\%\.\-\_]/) {
						push(@errs, [$k, "\"$cap{$k}\"に不適切な文字が含まれています。"]);
					} elsif($len > 16) {
						push(@errs, [$k, "\"$cap{$k}\"は16文字以内で指定してください。"]);
					}
				}
			#最小入力文字数
			} elsif($k eq "type_1_minlength") {
				if($v eq "") {
					
				} elsif($v =~ /[^\d]/) {
					push(@errs, [$k, "\"$cap{$k}\"は半角数字で指定してください。"]);
				} elsif($v == 0) {
					push(@errs, [$k, "\"$cap{$k}\"に0を指定することはできません。"]);
				} elsif($v > 1024) {
					push(@errs, [$k, "\"$cap{$k}\"は1024以下の数値を指定してください。"]);
				}
			#最大入力文字数
			} elsif($k eq "type_1_maxlength") {
				if($v eq "") {
					push(@errs, [$k, "\"$cap{$k}\"は必須です。"]);
				} elsif($v =~ /[^\d]/) {
					push(@errs, [$k, "\"$cap{$k}\"は半角数字で指定してください。"]);
				} elsif($v == 0) {
					push(@errs, [$k, "\"$cap{$k}\"に0を指定することはできません。"]);
				} elsif($v > 1024) {
					push(@errs, [$k, "\"$cap{$k}\"は1024以下の数値を指定してください。"]);
				} elsif($in->{type_1_minlength} && $v < $in->{type_1_minlength}) {
					push(@errs, [$k, "\"$cap{$k}\"は\"$cap{type_1_minlength}\"より大きい値を指定してください。"]);
				}
			#入力値変換
			} elsif($k =~ /^type_1_convert_\d+$/) {
				if($v ne "" && ! exists $converts->{$v}) {
					push(@errs, [$k, "\"$cap{$k}\"に不正な値が送信されました。"]);
				}
			#入力値制限
			} elsif($k =~ /^type_1_restrict_\d+$/) {
				if($v ne "" &&  ! exists $restricts->{$v}) {
					push(@errs, [$k, "\"$cap{$k}\"に不正な値が送信されました。"]);
				} elsif($v eq "en12" && ! $net_dns_available) {
					push(@errs, [$k, "サーバにPerlモジュール Net::DNS がインストールされていないため「メールアドレス - 文字列チェック + DNSによるドメインチェック」はご利用になれません。: $cap{$k}"]);
				} elsif($v eq "en22" && ! $lwp_available) {
					push(@errs, [$k, "サーバにPerlモジュール LWP::UserAgent がインストールされていないため「URL - 文字列チェック + HTTP通信による実在チェック」はご利用になれません。: $cap{$k}"]);
				}
			#デフォルト値
			} elsif($k eq "type_1_value") {
				if($v ne "") {
					if($len > 1024) {
						push(@errs, [$k, "\"$cap{$k}\"は1024文字以内で指定してください。"]);
					}
				}
			#メールアドレス入力欄
			} elsif($k eq "type_1_is_email") {
				if($v && $v ne "" && $v ne "1") {
					push(@errs, [$k, "\"$cap{$k}\"に不正な値が送信されました。"]);
				}
			#禁止メールアドレス
			} elsif($k eq "type_1_deny_emails") {
				if($v ne "") {
					if( length($v) > 65535 ) {
						push(@errs, [$k, "\"$cap{$k}\"は改行も含め65535文字以内で指定してください。"]);
					} else {
						my @lines = split(/\n+/, $v);
						my @recs;
						for my $v (@lines) {
							if($v eq "") { next; }
							if($v =~ /[^\x21-\x7e]/) {
								my $escaped_v = CGI::Utils->new()->escapeHtml($v);
								push(@errs, [$k, "\"$cap{$k}\"に指定した '${escaped_v}' に不適切な文字が含まれています。"]);
							}
							push(@recs, $v);
						}
						$in->{$k} = join("\n", @recs);
					}
				}
			}
		#パスワード入力フィールド
		} elsif($in->{type} eq "2") {
			#横幅のサイズ
			if($k eq "type_2_width") {
				if($v ne "") {
					if($v =~ /[^a-zA-Z0-9\%\.\-\_]/) {
						push(@errs, [$k, "\"$cap{$k}\"に不適切な文字が含まれています。"]);
					} elsif($len > 16) {
						push(@errs, [$k, "\"$cap{$k}\"は16文字以内で指定してください。"]);
					}
				}
			#最小入力文字数
			} elsif($k eq "type_2_minlength") {
				if($v eq "") {
					
				} elsif($v =~ /[^\d]/) {
					push(@errs, [$k, "\"$cap{$k}\"は半角数字で指定してください。"]);
				} elsif($v == 0) {
					push(@errs, [$k, "\"$cap{$k}\"に0を指定することはできません。"]);
				} elsif($v > 1024) {
					push(@errs, [$k, "\"$cap{$k}\"は1024以下の数値を指定してください。"]);
				}
			#最大入力文字数
			} elsif($k eq "type_2_maxlength") {
				if($v eq "") {
					push(@errs, [$k, "\"$cap{$k}\"は必須です。"]);
				} elsif($v =~ /[^\d]/) {
					push(@errs, [$k, "\"$cap{$k}\"は半角数字で指定してください。"]);
				} elsif($v == 0) {
					push(@errs, [$k, "\"$cap{$k}\"に0を指定することはできません。"]);
				} elsif($v > 1024) {
					push(@errs, [$k, "\"$cap{$k}\"は1024以下の数値を指定してください。"]);
				} elsif($in->{type_2_minlength} && $v < $in->{type_2_minlength}) {
					push(@errs, [$k, "\"$cap{$k}\"は\"$cap{type_2_minlength}\"より大きい値を指定してください。"]);
				}
			}
		#ラジオボタン
		} elsif($in->{type} eq "3") {
			#選択項目
			if($k eq "type_3_elements") {
				my @lines = split(/\n+/, $v);
				my @elms;
				my $asta = 0;
				for my $line (@lines) {
					$line =~ s/^\s+//;
					$line =~ s/\s+$//;
					if($line eq "") { next; }
					push(@elms, $line);
					if($line =~ /^\*/) {
						$asta ++;
					}
				}
				$v = join("\n", @elms);
				if( ! @elms) {
					push(@errs, [$k, "\"$cap{$k}\"は必須です。"]);
				} elsif(@elms > 255) {
					push(@errs, [$k, "\"$cap{$k}\"は255項目以内で指定してください。"]);
				} elsif($len > 65535) {
					push(@errs, [$k, "\"$cap{$k}\"は65535文字以内で指定してください。"]);
				} elsif($asta > 1) {
					push(@errs, [$k, "\"$cap{$k}\"のうちチェック状態を指定できるのは1つだけです。"]);
				}
				$in->{$k} = $v;
			#表示方法
			} elsif($k eq "type_3_arrangemen") {
				if($v eq "") {
					push(@errs, [$k, "\"$cap{$k}\"は必須です。"]);
				} elsif($v !~ /^(0|1)$/) {
					push(@errs, [$k, "\"$cap{$k}\"に不正な値が送信されました。"]);
				}
			}
		#チェックボックス
		} elsif($in->{type} eq "4") {
			#選択項目
			if($k eq "type_4_elements") {
				my @lines = split(/\n+/, $v);
				my @elms;
				for my $line (@lines) {
					$line =~ s/^\s+//;
					$line =~ s/\s+$//;
					if($line eq "") { next; }
					push(@elms, $line);
				}
				$v = join("\n", @elms);
				if( ! @elms) {
					push(@errs, [$k, "\"$cap{$k}\"は必須です。"]);
				} elsif(@elms > 255) {
					push(@errs, [$k, "\"$cap{$k}\"は255項目以内で指定してください。"]);
				} elsif($len > 1024) {
					push(@errs, [$k, "\"$cap{$k}\"は1024文字以内で指定してください。"]);
				}
				$in->{$k} = $v;
			#表示方法
			} elsif($k eq "type_4_arrangemen") {
				if($v eq "") {
					push(@errs, [$k, "\"$cap{$k}\"は必須です。"]);
				} elsif($v !~ /^(0|1)$/) {
					push(@errs, [$k, "\"$cap{$k}\"に不正な値が送信されました。"]);
				}
			#最小選択数
			} elsif($k eq "type_4_minlength") {
				if($v eq "") {

				} elsif($v =~ /[^\d]/) {
					push(@errs, [$k, "\"$cap{$k}\"は半角数字で指定してください。"]);
				} elsif($v == 0) {
					push(@errs, [$k, "\"$cap{$k}\"に0を指定することはできません。"]);
				} elsif($v > 255) {
					push(@errs, [$k, "\"$cap{$k}\"は255以下の数値を指定してください。"]);
				}
			#最大選択数
			} elsif($k eq "type_4_maxlength") {
				if($v eq "") {

				} elsif($v =~ /[^\d]/) {
					push(@errs, [$k, "\"$cap{$k}\"は半角数字で指定してください。"]);
				} elsif($v == 0) {
					push(@errs, [$k, "\"$cap{$k}\"に0を指定することはできません。"]);
				} elsif($v > 255) {
					push(@errs, [$k, "\"$cap{$k}\"は255以下の数値を指定してください。"]);
				} elsif($in->{type_4_minlength} && $v < $in->{type_4_minlength}) {
					push(@errs, [$k, "\"$cap{$k}\"は\"$cap{type_4_minlength}\"より大きい値を指定してください。"]);
				}
			}
		#セレクトメニュー
		} elsif($in->{type} eq "5") {
			#選択項目
			if($k eq "type_5_elements") {
				my @lines = split(/\n+/, $v);
				my @elms;
				my $asta = 0;
				for my $line (@lines) {
					$line =~ s/^\s+//;
					$line =~ s/\s+$//;
					if($line eq "") { next; }
					push(@elms, $line);
					if($line =~ /^\*/) {
						$asta ++;
					}
				}
				$v = join("\n", @elms);
				if( ! @elms) {
					push(@errs, [$k, "\"$cap{$k}\"は必須です。"]);
				} elsif(@elms > 255) {
					push(@errs, [$k, "\"$cap{$k}\"は255項目以内で指定してください。"]);
				} elsif($len > 1024) {
					push(@errs, [$k, "\"$cap{$k}\"は1024文字以内で指定してください。"]);
				} elsif($in->{type_5_multiple} ne "1" && $asta > 1) {
					push(@errs, [$k, "\"$cap{$k}\"のうち選択状態を指定できるのは1つだけです。"]);
				} elsif($in->{type_5_multiple} eq "1" && $in->{type_5_maxlength} && $in->{type_5_maxlength} < $asta) {
					push(@errs, [$k, "\"$cap{$k}\"のうち選択状態を指定できるのは最大選択数（$in->{type_5_maxlength}項目）までです。"]);
				}
				$in->{$k} = $v;
			#複数行選択
			} elsif($k eq "type_5_multiple") {
				if($v ne "" && $v ne "1") {
					push(@errs, [$k, "\"$cap{$k}\"に不正な値が送信されました。"]);
				}
			#最小選択数
			} elsif($k eq "type_5_minlength") {
				if($v eq "") {

				} elsif($v =~ /[^\d]/) {
					push(@errs, [$k, "\"$cap{$k}\"は半角数字で指定してください。"]);
				} elsif($v == 0) {
					push(@errs, [$k, "\"$cap{$k}\"に0を指定することはできません。"]);
				} elsif($v > 255) {
					push(@errs, [$k, "\"$cap{$k}\"は255以下の数値を指定してください。"]);
				}
			#最大選択数
			} elsif($k eq "type_5_maxlength") {
				if($v eq "") {

				} elsif($v =~ /[^\d]/) {
					push(@errs, [$k, "\"$cap{$k}\"は半角数字で指定してください。"]);
				} elsif($v == 0) {
					push(@errs, [$k, "\"$cap{$k}\"に0を指定することはできません。"]);
				} elsif($v > 255) {
					push(@errs, [$k, "\"$cap{$k}\"は255以下の数値を指定してください。"]);
				} elsif($in->{type_5_minlength} && $v < $in->{type_5_minlength}) {
					push(@errs, [$k, "\"$cap{$k}\"は\"$cap{type_5_minlength}\"より大きい値を指定してください。"]);
				}
			}
		#テキストエリア
		} elsif($in->{type} eq "6") {
			#横サイズ
			if($k eq "type_6_cols") {
				if($v eq "") {
					push(@errs, [$k, "\"$cap{$k}\"は必須です。"]);
				} elsif($v =~ /[^\d]/) {
					push(@errs, [$k, "\"$cap{$k}\"は半角数字で指定してください。"]);
				} elsif($v == 0) {
					push(@errs, [$k, "\"$cap{$k}\"に0を指定することはできません。"]);
				} elsif($v > 255) {
					push(@errs, [$k, "\"$cap{$k}\"は255以下の数値を指定してください。"]);
				}
			#縦サイズ
			} elsif($k eq "type_6_rows") {
				if($v eq "") {
					push(@errs, [$k, "\"$cap{$k}\"は必須です。"]);
				} elsif($v =~ /[^\d]/) {
					push(@errs, [$k, "\"$cap{$k}\"は半角数字で指定してください。"]);
				} elsif($v == 0) {
					push(@errs, [$k, "\"$cap{$k}\"に0を指定することはできません。"]);
				} elsif($v > 255) {
					push(@errs, [$k, "\"$cap{$k}\"は255以下の数値を指定してください。"]);
				}
			#最小入力文字数
			} elsif($k eq "type_6_minlength") {
				if($v eq "") {
					
				} elsif($v =~ /[^\d]/) {
					push(@errs, [$k, "\"$cap{$k}\"は半角数字で指定してください。"]);
				} elsif($v == 0) {
					push(@errs, [$k, "\"$cap{$k}\"に0を指定することはできません。"]);
				} elsif($v > 10000) {
					push(@errs, [$k, "\"$cap{$k}\"は10000以下の数値を指定してください。"]);
				}
			#最大入力文字数
			} elsif($k eq "type_6_maxlength") {
				if($v eq "") {
					push(@errs, [$k, "\"$cap{$k}\"は必須です。"]);
				} elsif($v =~ /[^\d]/) {
					push(@errs, [$k, "\"$cap{$k}\"は半角数字で指定してください。"]);
				} elsif($v == 0) {
					push(@errs, [$k, "\"$cap{$k}\"に0を指定することはできません。"]);
				} elsif($v > 10000) {
					push(@errs, [$k, "\"$cap{$k}\"は10000以下の数値を指定してください。"]);
				} elsif($in->{type_6_minlength} && $v < $in->{type_6_minlength}) {
					push(@errs, [$k, "\"$cap{$k}\"は\"$cap{type_6_minlength}\"より大きい値を指定してください。"]);
				}
			#入力値変換
			} elsif($k =~ /^type_6_convert_\d+$/) {
				if($v ne "" && ! exists $converts->{$v}) {
					push(@errs, [$k, "\"$cap{$k}\"に不正な値が送信されました。"]);
				}
			#デフォルト値
			} elsif($k eq "type_6_value") {
				if($v ne "") {
					if($len > 65535) {
						push(@errs, [$k, "\"$cap{$k}\"は65535文字以内で指定してください。"]);
					}
				}
			}
		#ファイル添付
		} elsif($in->{type} eq "7") {
			#添付ファイルのサイズ制限
			if($k eq "type_7_maxsize") {
				if($v eq "") {
					push(@errs, [$k, "\"$cap{$k}\"は必須です。"]);
				} elsif($v =~ /[^\d]/) {
					push(@errs, [$k, "\"$cap{$k}\"は半角数字で指定してください。"]);
				} elsif($v == 0) {
					push(@errs, [$k, "\"$cap{$k}\"に0を指定することはできません。"]);
				} elsif($v > 255) {
					push(@errs, [$k, "\"$cap{$k}\"は255以下の数値を指定してください。"]);
				}
			#添付ファイルの拡張子制限
			} elsif($k eq "type_7_allow_exts") {
				if( length($v) > 1024 ) {
					push(@errs, [$k, "\"$cap{$k}\"は改行も含め1024文字以内で指定してください。"]);
				} else {
					my @lines = split(/\n+/, $v);
					my @recs;
					for my $line (@lines) {
						if($line eq "") { next; }
						if($line !~ /^\.[a-z0-9]+$/) {
							my $escaped_line = CGI::Utils->new()->escapeHtml($line);
							push(@errs, [$k, "\"$cap{$k}\"に指定した '${escaped_line}' が正しくありません。"]);
						}
						push(@recs, $line);
					}
					$in->{$k} = join("\n", @recs);
				}
			}
		#非表示フィールド
		} elsif($in->{type} eq "8") {
			#パラメータ引き継ぎ
			if($k eq "type_8_handover") {
				if($v && $v ne "" && $v ne "1") {
					push(@errs, [$k, "\"$cap{$k}\"に不正な値が送信されました。"]);
				}

			#最小入力文字数
			} elsif($k eq "type_8_minlength") {
				if($v eq "") {
					
				} elsif($v =~ /[^\d]/) {
					push(@errs, [$k, "\"$cap{$k}\"は半角数字で指定してください。"]);
				} elsif($v == 0) {
					push(@errs, [$k, "\"$cap{$k}\"に0を指定することはできません。"]);
				} elsif($v > 255) {
					push(@errs, [$k, "\"$cap{$k}\"は255以下の数値を指定してください。"]);
				}
			#最大入力文字数
			} elsif($k eq "type_8_maxlength") {
				if($v eq "") {
					push(@errs, [$k, "\"$cap{$k}\"は必須です。"]);
				} elsif($v =~ /[^\d]/) {
					push(@errs, [$k, "\"$cap{$k}\"は半角数字で指定してください。"]);
				} elsif($v == 0) {
					push(@errs, [$k, "\"$cap{$k}\"に0を指定することはできません。"]);
				} elsif($v > 255) {
					push(@errs, [$k, "\"$cap{$k}\"は255以下の数値を指定してください。"]);
				} elsif($in->{type_8_minlength} && $v < $in->{type_8_minlength}) {
					push(@errs, [$k, "\"$cap{$k}\"は\"$cap{type_8_minlength}\"より大きい値を指定してください。"]);
				}
			#固定値
			} elsif($k eq "type_8_value") {
				if($len > 255) {
					push(@errs, [$k, "\"$cap{$k}\"は255文字以内で指定してください。"]);
				} elsif($in->{type_8_maxlength} && $len > $in->{type_8_maxlength}) {
					push(@errs, [$k, "\"$cap{$k}\"は最大入力文字数で指定した$in->{type_8_maxlength}文字以内で指定してください。"]);
				} elsif($in->{type_8_minlength} && $len < $in->{type_8_minlength}) {
					push(@errs, [$k, "\"$cap{$k}\"は最小大入力文字数で指定した$in->{type_8_minlength}文字以上で指定してください。"]);
				}
			}
		}
	}
	#
	return @errs;
}


1;
