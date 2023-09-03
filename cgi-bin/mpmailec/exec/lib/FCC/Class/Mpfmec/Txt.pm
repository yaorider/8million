package FCC::Class::Mpfmec::Txt;
$VERSION = 1.00;
use strict;
use warnings;
use base qw(FCC::_Super);
use Carp;
use Unicode::Japanese;
use Email::Valid;
use FCC::Class::Mpfmec::Item;
use FCC::Class::String::Checker;

sub init {
	my($self, %args) = @_;
	$self->{conf} = $args{conf};
	$self->{items} = $args{items};
	#
	if( ! defined $self->{items} || ref($self->{items}) ne "HASH" ) {
		#入力項目設定データを取得
		$self->{items} = FCC::Class::Mpfmec::Item->new(conf=>$self->{conf})->get();
	}
	# 入力値制限のリスト
	$self->{restricts} = [
		'en01	半角数字のみ (0-9)',
		'en02	半角英字のみ (a-zA-Z)',
		'en03	半角英数字のみ (0-9a-zA-Z)',
		'	--',
		'en11	メールアドレス - 文字列チェックのみ',
		'en12	メールアドレス - 文字列チェック + DNSによるドメインチェック',
		'	--',
		'en21	URL - 文字列チェックのみ',
		'en22	URL - 文字列チェック + HTTP通信による実在チェック',
		'	--',
		'en31	電話番号（日本国内向け）- 半角/固定電話/ハイフンなし (例:0312345678)',
		'en32	電話番号（日本国内向け）- 半角/固定電話/ハイフンあり (例:03-1234-5678)',
		'en33	電話番号（日本国内向け）- 半角/携帯・PHS/ハイフンなし (例:09012345678)',
		'en34	電話番号（日本国内向け）- 半角/携帯・PHS/ハイフンあり (例:090-1234-5678)',
		'en35	電話番号（日本国内向け）- 半角/電話全般/ハイフンなし',
		'en36	電話番号（日本国内向け）- 半角/電話全般/ハイフンあり',
		'	--',
		'en41	郵便番号（日本国内向け） - 半角/ハイフンなし (例：1234567)',
		'en42	郵便番号（日本国内向け） - 半角/ハイフンあり (例：123-4567)',
		'	--',
		'ja01	全角数字のみ (０-９)',
		'ja02	全角アルファベットのみ (ａ-ｚＡ-Ｚ)',
		'ja03	全角英数のみ (０-９ａ-ｚＡ-Ｚ)',
		'ja04	全角ひらがなのみ',
		'ja05	全角カタカナのみ'

	];
	# 入力値変換のリスト
	$self->{converts} = [
		'en01	半角アルファベット小文字(a-z)を大文字(A-Z)に変換',
		'en02	半角アルファベット大文字(A-Z)を小文字(a-z)に変換',
		'	--',
		'en11	半角スペースををすべて削除',
		'en12	連続した半角スペースをひとつにまとめる',
		'en13	最初と最後の連続した半角スペースを削除',
		'	--',
		'ja21	半角ハイフンをすべて削除',
		'	--',
		'ja01	半角アルファベット(a-zA-Z)を全角(ａ-ｚＡ-Ｚ)に変換',
		'ja02	半角カナを全角カナに変換',
		'ja03	半角文字のうち全角にできるものはすべて変換',
		'	--',
		'ja11	全角アルファベット(ａ-ｚＡ-Ｚ)を半角(a-zA-Z)に変換',
		'ja12	全角カナを半角カナに変換',
		'ja13	全角文字のうち半角にできるものはすべて変換',
		'ja14	全角カタカナを全角ひらがなに変換',
		'ja15	全角ひらがなを全角カタカナに変換'
	];
}

#---------------------------------------------------------------------
#■ 入力値制限リストをゲット（管理メニューのselect用）
#---------------------------------------------------------------------
#[引数]
#	なし
#[戻り値]
#	ARRAYREF
#---------------------------------------------------------------------
sub get_restricts_for_select {
	my($self) = @_;
	my @ary;
	for my $line (@{$self->{restricts}}) {
		my @parts = split(/\t/, $line);
		push(@ary, { code=>$parts[0], label=>$parts[1] });
	}
	return \@ary;
}

#---------------------------------------------------------------------
#■ 入力値制限リストをゲット
#---------------------------------------------------------------------
#[引数]
#	なし
#[戻り値]
#	HASHREF
#---------------------------------------------------------------------
sub get_restricts {
	my($self) = @_;
	my %hash;
	for my $line (@{$self->{restricts}}) {
		if($line =~ /^([a-z]{2}\d{2})\t(.+)/) {
			$hash{$1} = $2;
		}
	}
	return \%hash;
}

#---------------------------------------------------------------------
#■ 入力値変換リストをゲット（管理メニューのselect用）
#---------------------------------------------------------------------
#[引数]
#	なし
#[戻り値]
#	ARRAYREF
#---------------------------------------------------------------------
sub get_converts_for_select {
	my($self) = @_;
	my @ary;
	for my $line (@{$self->{converts}}) {
		my @parts = split(/\t/, $line);
		push(@ary, { code=>$parts[0], label=>$parts[1] });
	}
	return \@ary;
}

#---------------------------------------------------------------------
#■ 入力値変換リストをゲット
#---------------------------------------------------------------------
#[引数]
#	なし
#[戻り値]
#	HASHREF
#---------------------------------------------------------------------
sub get_converts {
	my($self) = @_;
	my %hash;
	for my $line (@{$self->{converts}}) {
		if($line =~ /^([a-z]{2}\d{2})\t(.+)/) {
			$hash{$1} = $2;
		}
	}
	return \%hash;
}

#---------------------------------------------------------------------
#■ 入力値制限チェック
#---------------------------------------------------------------------
#[引数]
#	1. name属性
#	2. 値
#[戻り値]
#	入力値制限に引っかかったルールコードを格納した配列
#	テキスト入力フィールドのみに摘要する。それ以外のフォームコントロー
#	ルでは何も行われない。
#---------------------------------------------------------------------
sub restrict_check {
	my($self, $name, $str) = @_;
	my @ng;
	#項目情報
	my $ref = $self->{items}->{$name};
	if( ! defined $ref || $ref->{type} ne "1") {
		return @ng;
	}
	#ルール
	my @rules;
	for( my $i=1; $i<=3; $i++ ) {
		my $rule = $ref->{"type_1_restrict_${i}"};
		if( $rule ) {
			push(@rules, $rule);
		}
	}
	unless(@rules) {return @ng }
	#ルールをチェック
	for my $rule (@rules) {
		# en01	半角数字のみ (0-9)
		if($rule eq "en01") {
			if($str !~ /^\d+$/) { push(@ng, $rule); }
		# en02	半角英字のみ (a-zA-Z)
		} elsif($rule eq "en02") {
			if($str !~ /^[a-zA-Z]+$/) { push(@ng, $rule); }
		# en03	半角英数字のみ (0-9a-zA-Z)
		} elsif($rule eq "en03") {
			if($str !~ /^[0-9a-zA-Z]+$/) { push(@ng, $rule); }
		# en11	メールアドレス - 文字列チェックのみ
		} elsif($rule eq "en11") {
			unless( Email::Valid->address($str) ) { push(@ng, $rule); }
		# en12	メールアドレス - 文字列チェック + DNSによるドメインチェック
		} elsif($rule eq "en12") {
			my $addr;
			eval {
				$addr = Email::Valid->address( -address => $str, -mxcheck => 1 );
			};
			if($@) {
				unless( Email::Valid->address($str) ) { push(@ng, $rule); }
			} else {
				unless($addr) { push(@ng, $rule); }
			}
		# en21	URL - 文字列チェックのみ
		} elsif($rule eq "en21") {
			unless( FCC::Class::String::Checker->new($str, "utf8")->is_url() ) {
				push(@ng, $rule);
			}
		# en22	URL - 文字列チェック + HTTP通信による実在チェック
		} elsif($rule eq "en22") {
			if( ! FCC::Class::String::Checker->new($str, "utf8")->is_url() ) {
				push(@ng, $rule);
			} else {
				eval { require LWP::UserAgent; };
				unless($@) {
					my $ua = LWP::UserAgent->new;
					$ua->agent($ENV{HTTP_USER_AGENT});
					$ua->timeout(10);
					my $req = HTTP::Request->new(GET => $str);
					my $res = $ua->request($req);
					unless($res->is_success) {
						push(@ng, $rule);
					}
				}
			}
		# en31	電話番号（日本国内向け）- 半角/固定電話/ハイフンなし (例:0312345678)
		} elsif($rule eq "en31") {
			if($str =~ /\-/) {
				push(@ng, $rule);
			} elsif( ! FCC::Class::String::Checker->new($str, "utf8")->is_tel() ) {
				push(@ng, $rule);
			} else {
				my $len = length $str;
				if($len != 9 && $len != 10) {
					push(@ng, $rule);
				} elsif($str =~ /^0(7|8|9)0[1-9]/ || $str =~ /^0120/ || $str =~ /^0800/) {
					push(@ng, $rule);
				}
			}
		# en32	電話番号（日本国内向け）- 半角/固定電話/ハイフンあり (例:03-1234-5678)
		} elsif($rule eq "en32") {
			if( ! FCC::Class::String::Checker->new($str, "utf8")->is_tel() ) {
				push(@ng, $rule);
			} elsif($str !~ /^0[0-9]+\-[0-9]+\-[0-9]+$/) {
				push(@ng, $rule);
			} else {
				my $len = length $str;
				if($len != 11 && $len != 12) {
					push(@ng, $rule);
				} elsif($str =~ /^0(7|8|9)0[1-9]/ || $str =~ /^0120/ || $str =~ /^0800/) {
					push(@ng, $rule);
				}
			}
		# en33	電話番号（日本国内向け）- 半角/携帯・PHS/ハイフンなし (例:09012345678)
		} elsif($rule eq "en33") {
			if($str =~ /\-/) {
				push(@ng, $rule);
			} elsif( ! FCC::Class::String::Checker->new($str, "utf8")->is_tel() ) {
				push(@ng, $rule);
			} else {
				my $len = length $str;
				if($len != 11) {
					push(@ng, $rule);
				} elsif($str !~ /^0[7-9]0[0-9]{8}$/) {
					push(@ng, $rule);
				}
			}
		# en34	電話番号（日本国内向け）- 半角/携帯・PHS/ハイフンあり (例:090-1234-5678)
		} elsif($rule eq "en34") {
			if( ! FCC::Class::String::Checker->new($str, "utf8")->is_tel() ) {
				push(@ng, $rule);
			} else {
				my $len = length $str;
				if($len != 13) {
					push(@ng, $rule);
				} elsif($str !~ /^0[7-9]0\-[0-9]+\-[0-9]+$/) {
					push(@ng, $rule);
				}
			}
		# en35	電話番号（日本国内向け）- 半角/電話全般/ハイフンなし
		} elsif($rule eq "en35") {
			if($str =~ /\-/) {
				push(@ng, $rule);
			} elsif( ! FCC::Class::String::Checker->new($str, "utf8")->is_tel() ) {
				push(@ng, $rule);
			}
		# en36	電話番号（日本国内向け）- 半角/電話全般/ハイフンあり
		} elsif($rule eq "en36") {
			if($str !~ /^0[0-9]+\-[0-9]+\-[0-9]+$/) {
				push(@ng, $rule);
			} elsif( ! FCC::Class::String::Checker->new($str, "utf8")->is_tel() ) {
				push(@ng, $rule);
			}
		# en41	郵便番号（日本国内向け） - 半角/ハイフンなし (例：1234567)
		} elsif($rule eq "en41") {
			if($str !~ /^\d{7}$/) { push(@ng, $rule); }
		# en42	郵便番号（日本国内向け） - 半角/ハイフンあり (例：123-4567)
		} elsif($rule eq "en42") {
			if($str !~ /^\d{3}\-\d{4}$/) { push(@ng, $rule); }
		# ja01	全角数字のみ (０-９)
		} elsif($rule eq "ja01") {
			$str =~ s/\xef\xbc[\x90-\x99]//g;	# ０-９
			if($str ne '') { push(@ng, $rule); }
		# ja02	全角アルファベットのみ (ａ-ｚＡ-Ｚ)
		} elsif($rule eq "ja02") {
			$str =~ s/\xef\xbc[\xa1-\xba]//g;	# Ａ-Ｚ
			$str =~ s/\xef\xbd[\x81-\x9a]//g;	# ａ-ｚ
			if($str ne '') { push(@ng, $rule); }
		# ja03	全角英数のみ (０-９ａ-ｚＡ-Ｚ)
		} elsif($rule eq "ja03") {
			$str =~ s/\xef\xbc[\x90-\x99]//g;	# ０-９
			$str =~ s/\xef\xbc[\xa1-\xba]//g;	# Ａ-Ｚ
			$str =~ s/\xef\xbd[\x81-\x9a]//g;	# ａ-ｚ
			if($str ne '') { push(@ng, $rule); }
		# ja04	全角ひらがなのみ
		#	　	E38080
		#	、	E38081
		#	。	E38082
		#	～	E3809C
		#	～	EFBD9E
		#	－	E28892	マイナス
		#	―	E28095	ダッシュ
		#	‐	E28090	ハイフン
		#	ー	E383BC	長音記号
		} elsif($rule eq "ja04") {
			$str =~ s/\xe3((\x81[\x81-\xBF])|(\x82[\x80-\x93]))//g;
			$str =~ s/\xe3(\x80([\x80-\x82]|\x9C))//g;
			$str =~ s/(\xEF\xBD\x9E|\xE2\x88\x92|\xE2\x80\x95|\xE2\x80\x90|\xE3\x83\xBC)//g;
			if($str ne '') { push(@ng, $rule); }
		# ja05	全角カタカナのみ
		#	　	E38080
		#	、	E38081
		#	。	E38082
		#	～	E3809C
		#	～	EFBD9E
		#	－	E28892	マイナス
		#	―	E28095	ダッシュ
		#	‐	E28090	ハイフン
		#	ー	E383BC	長音記号
		} elsif($rule eq "ja05") {
			$str =~ s/\xe3((\x82[\xA1-\xBF])|(\x83[\x80-\xB6]))//g;
			$str =~ s/\xe3(\x80([\x80-\x82]|\x9C))//g;
			$str =~ s/(\xEF\xBD\x9E|\xE2\x88\x92|\xE2\x80\x95|\xE2\x80\x90|\xE3\x83\xBC)//g;
			if($str ne '') { push(@ng, $rule); }
		}
	}
	#
	return @ng;
}

#---------------------------------------------------------------------
#■ 入力値変換処理
#---------------------------------------------------------------------
#[引数]
#	1. name属性
#	2. 値
#[戻り値]
#	変換後の値
#	テキストフィールド、テキストエリア以外は何もしない。
#---------------------------------------------------------------------
sub convert_value {
	my($self, $name, $str) = @_;
	#項目情報
	my $ref = $self->{items}->{$name};
	if( ! defined $ref || $ref->{type} !~ /^(1|6)$/) {
		return $str;
	}
	#ルール
	my @rules;
	my $type = $ref->{type};
	for( my $i=1; $i<=5; $i++ ) {
		my $rule = $ref->{"type_${type}_convert_${i}"};
		if( $rule ) {
			push(@rules, $rule);
		}
	}
	unless(@rules) {return $str }
	#変換処理
	for my $rule (@rules) {
		# en01	半角アルファベット小文字(a-z)を大文字(A-Z)に変換
		if($rule eq "en01") {
			$str = uc $str;
		# en02	半角アルファベット大文字(A-Z)を小文字(a-z)に変換
		} elsif($rule eq "en02") {
			$str = lc $str;
		# en11	半角スペースををすべて削除
		} elsif($rule eq "en11") {
			$str =~ s/\s//g;
		# en12	連続した半角スペースをひとつにまとめる
		} elsif($rule eq "en12") {
			$str =~ s/\s+/ /g;
		# en13	最初と最後の連続した半角スペースを削除
		} elsif($rule eq "en13") {
			$str =~ s/^\s+//;
			$str =~ s/\s+$//;
		# ja21	半角ハイフンをすべて削除
		} elsif($rule eq "ja21") {
			$str =~ s/\-//g;
		# ja01	半角アルファベット(a-zA-Z)を全角(ａ-ｚＡ-Ｚ)に変換
		} elsif($rule eq "ja01") {
			$str = Unicode::Japanese->new($str, "utf8")->h2zAlpha()->get();
		# ja02	半角カナを全角カナに変換
		} elsif($rule eq "ja02") {
			$str = Unicode::Japanese->new($str, "utf8")->h2zKana()->get();
		# ja03	半角文字のうち全角にできるものはすべて変換
		} elsif($rule eq "ja03") {
			$str = Unicode::Japanese->new($str, "utf8")->h2z()->get();
		# ja11	全角アルファベット(ａ-ｚＡ-Ｚ)を半角(a-zA-Z)に変換
		} elsif($rule eq "ja11") {
			$str = Unicode::Japanese->new($str, "utf8")->z2hAlpha()->get();
		# ja12	全角カナを半角カナに変換
		} elsif($rule eq "ja12") {
			$str = Unicode::Japanese->new($str, "utf8")->z2hKana()->get();
		# ja13	全角文字のうち半角にできるものはすべて変換
		} elsif($rule eq "ja13") {
			$str = Unicode::Japanese->new($str, "utf8")->z2h()->get();
		# ja14	全角カタカナを全角ひらがなに変換
		} elsif($rule eq "ja14") {
			$str = Unicode::Japanese->new($str, "utf8")->kata2hira()->get();
		# ja15	全角ひらがなを全角カタカナに変換
		} elsif($rule eq "ja15") {
			$str = Unicode::Japanese->new($str, "utf8")->hira2kata()->get();
		}
	}
	#
	return $str;
}

1;
