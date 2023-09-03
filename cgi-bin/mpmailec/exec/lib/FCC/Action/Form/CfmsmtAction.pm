package FCC::Action::Form::CfmsmtAction;
$VERSION = 1.00;
use strict;
use warnings;
use base qw(FCC::Action::Form::_SuperAction);
use FCC::Class::Mpfmec::Txt;
use FCC::Class::Mpfmec::Check;
use FCC::Class::String::Checker;
use Unicode::Japanese;

sub dispatch {
	my($self) = @_;
	my $context = {};
	#プロセスセッション
	my $proc = $self->{session}->{data}->{proc};
	if( ! $proc ) {
		$context->{fatalerrs} = ['no process session'];
		return $context;
	}
	#項目情報を取得
	my $items = $self->{items};
	#セッション
	my $sid = $self->{session}->{sid};
	#FCC::Class::Mpfmec::Txtのインスタンス
	my $otxt = new FCC::Class::Mpfmec::Txt(conf=>$self->{conf}, items=>$items);
	#入力値を取得
	my $in = {};
	my @errs;
	my $atc_total_size = 0;
	my $emsgs = $self->{emsgs};
	for my $name ( sort { $items->{$a}->{offset} <=> $items->{$b}->{offset} } keys %{$items} ) {
		my $item = $items->{$name};
		my $type = $item->{type};
		my $caption = $item->{caption};
		my $required = $item->{required};
		# テキスト入力フィールド
		if($type eq "1") {
			my $minlength = $item->{type_1_minlength} ? $item->{type_1_minlength} : 0;
			my $maxlength = $item->{type_1_maxlength} ? $item->{type_1_maxlength} : 0;
			my($v) = $self->get_values($name);
			$v = $otxt->convert_value($name, $v);
			my $len = FCC::Class::String::Checker->new($v, "utf8")->get_char_num();
			if( $v eq "" ) {
				if($required) {
					#「%caption%」は必須です。
					my $e = $emsgs->{item_required};
					$e =~ s/\%caption\%/${caption}/g;
					push(@errs, [$name, $e]);
				}
			} elsif( $minlength && $len < $minlength ) {
				#「%caption%」は%type_1_minlength%文字以上で入力してください。
				my $e = $emsgs->{item_1_minlength};
				$e =~ s/\%caption\%/${caption}/g;
				$e =~ s/\%type_1_minlength\%/${minlength}/g;
				push(@errs, [$name, $e]);
			} elsif( $maxlength && $len > $maxlength ) {
				#「%caption%」は%type_1_maxlength%文字以内で入力してください。
				my $e = $emsgs->{item_1_maxlength};
				$e =~ s/\%caption\%/${caption}/g;
				$e =~ s/\%type_1_maxlength\%/${maxlength}/g;
				push(@errs, [$name, $e]);
			} else {
				my @ng_rules = $otxt->restrict_check($name, $v);
				if(@ng_rules) {
					my $rule = $ng_rules[0];
					my $e = $emsgs->{"restrict_$ng_rules[0]"};
					$e =~ s/\%caption\%/${caption}/g;
					push(@errs, [$name, $e]);
				} elsif($item->{type_1_is_email} && $item->{type_1_deny_emails}) {
					my @deny_emails = split(/\n+/, $item->{type_1_deny_emails});
					for my $deny (@deny_emails) {
						if($v =~ /\Q${deny}\E$/) {
							#「%caption%」に指定したメールアドレスは受け付けられません。
							my $e = $emsgs->{deny_emails};
							$e =~ s/\%caption\%/${caption}/g;
							push(@errs, [$name, $e]);
							last;
						}
					}
				}
			}
			$in->{$name} = $v;
		# パスワード入力フィールド
		} elsif($type eq "2") {
			my $minlength = $item->{type_2_minlength} ? $item->{type_2_minlength} : 0;
			my $maxlength = $item->{type_2_maxlength} ? $item->{type_2_maxlength} : 0;
			my($v) = $self->get_values($name);
			my $len = FCC::Class::String::Checker->new($v, "utf8")->get_char_num();
			if($required && ! $v) {
				#「%caption%」は必須です。
				my $e = $emsgs->{item_required};
				$e =~ s/\%caption\%/${caption}/g;
				push(@errs, [$name, $e]);
			} elsif( $minlength && $len < $minlength ) {
				#「%caption%」は%type_2_minlength%文字以上で入力してください。
				my $e = $emsgs->{item_2_minlength};
				$e =~ s/\%caption\%/${caption}/g;
				$e =~ s/\%type_2_minlength\%/${minlength}/g;
				push(@errs, [$name, $e]);
			} elsif( $maxlength && $len > $maxlength ) {
				#「%caption%」は%type_2_maxlength%文字以内で入力してください。
				my $e = $emsgs->{item_2_maxlength};
				$e =~ s/\%caption\%/${caption}/g;
				$e =~ s/\%type_2_maxlength\%/${maxlength}/g;
				push(@errs, [$name, $e]);
			}
			$in->{$name} = $v;
		# ラジオボタン
		} elsif($type eq "3") {
			my($v) = $self->get_values($name);
			if( ! defined $v ) { $v = ""; }
			my @elements = split(/\n+/, $item->{type_3_elements});
			if($v ne "") {
				unless( my $n = grep(/^\*?\Q${v}\E$/, @elements) ) {
					$v = "";
				}
			}
			if($v eq "") {
				if($required) {
					#「%caption%」は必須です。
					my $e = $emsgs->{item_required};
					$e =~ s/\%caption\%/${caption}/g;
					push(@errs, [$name, $e]);
				}
			}
			$in->{$name} = $v;
		# チェックボックス
		} elsif($type eq "4") {
			my @in_vals = $self->get_values($name);
			my @elements = split(/\n+/, $item->{type_4_elements});
			my @vals;
			for my $elm (@elements) {
				$elm =~ s/^\*//;
				if( my $n = grep(/^\Q${elm}\E$/, @in_vals) ) {
					push(@vals, $elm);
				}
			}
			my $checked = scalar @vals;
			if($checked == 0 ) {
				if($required) {
					#「%caption%」は必須です。
					my $e = $emsgs->{item_required};
					$e =~ s/\%caption\%/${caption}/g;
					push(@errs, [$name, $e]);
				}
			} else {
				my $min = $item->{type_4_minlength} ? $item->{type_4_minlength} : 0;
				my $max = $item->{type_4_maxlength} ? $item->{type_4_maxlength} : 0;
				if($min && $checked < $min) {
					#「%caption%」は%type_4_minlength%個以上を選択してください。
					my $e = $emsgs->{item_4_minlength};
					$e =~ s/\%caption\%/${caption}/g;
					$e =~ s/\%type_4_minlength\%/${min}/g;
					push(@errs, [$name, $e]);
				} elsif($max && $checked > $max) {
					#「%caption%」は%type_4_maxlength%個以内で選択してください。
					my $e = $emsgs->{item_4_maxlength};
					$e =~ s/\%caption\%/${caption}/g;
					$e =~ s/\%type_4_maxlength\%/${max}/g;
					push(@errs, [$name, $e]);
				}
			}
			$in->{$name} = \@vals;
		# セレクトメニュー
		} elsif($type eq "5") {
			my @in_vals = $self->get_values($name);
			my @elements = split(/\n+/, $item->{type_5_elements});
			my @vals;
			for my $elm (@elements) {
				$elm =~ s/^\*//;
				if( my $n = grep(/^\Q${elm}\E$/, @in_vals) ) {
					push(@vals, $elm);
				}
			}
			my $selected = scalar @vals;
			if($selected == 0 ) {
				if($required) {
					#「%caption%」は必須です。
					my $e = $emsgs->{item_required};
					$e =~ s/\%caption\%/${caption}/g;
					push(@errs, [$name, $e]);
				}
			} else {
				if( $item->{type_5_multiple} ) {
					my $min = $item->{type_5_minlength} ? $item->{type_5_minlength} : 0;
					my $max = $item->{type_5_maxlength} ? $item->{type_5_maxlength} : 0;
					if($min && $selected < $min) {
						#「%caption%」は%type_5_minlength%個以上を選択してください。
						my $e = $emsgs->{item_5_minlength};
						$e =~ s/\%caption\%/${caption}/g;
						$e =~ s/\%type_5_minlength\%/${min}/g;
						push(@errs, [$name, $e]);
					} elsif($max && $selected > $max) {
						#「%caption%」は%type_5_maxlength%個以内で選択してください。
						my $e = $emsgs->{item_5_maxlength};
						$e =~ s/\%caption\%/${caption}/g;
						$e =~ s/\%type_5_maxlength\%/${max}/g;
						push(@errs, [$name, $e]);
					}
				}
			}
			$in->{$name} = \@vals;
		# テキストエリア
		} elsif($type eq "6") {
			my $minlength = $item->{type_6_minlength} ? $item->{type_6_minlength} : 0;
			my $maxlength = $item->{type_6_maxlength} ? $item->{type_6_maxlength} : 0;
			my($v) = $self->get_values($name, 1);
			$v = $otxt->convert_value($name, $v);
			my $len = FCC::Class::String::Checker->new($v, "utf8")->get_char_num();
			if($required && ! $v) {
				#「%caption%」は必須です。
				my $e = $emsgs->{item_required};
				$e =~ s/\%caption\%/${caption}/g;
				push(@errs, [$name, $e]);
			} elsif( $minlength && $len < $minlength ) {
				#「%caption%」は%type_6_minlength%文字以上で入力してください。
				my $e = $emsgs->{item_6_minlength};
				$e =~ s/\%caption\%/${caption}/g;
				$e =~ s/\%type_6_minlength\%/${minlength}/g;
				push(@errs, [$name, $e]);
			} elsif( $maxlength && $len > $maxlength ) {
				#「%caption%」は%type_6_maxlength%文字以内で入力してください。
				my $e = $emsgs->{item_6_maxlength};
				$e =~ s/\%caption\%/${caption}/g;
				$e =~ s/\%type_6_maxlength\%/${maxlength}/g;
				push(@errs, [$name, $e]);
			}
			$in->{$name} = $v;
		# ファイル添付
		} elsif($type eq "7") {
			my $atc_file = $self->{q}->param($name);
			if( $atc_file ) {
				my $meta = $self->{session}->save_file($name);
				if($meta) {
					if($meta->{size} > $item->{type_7_maxsize} * 1024 * 1024) {
						#「%caption%」に指定したファイルのサイズが大きすぎます。アップロードできるファイルのサイズは%type_7_maxsize%MBまでです。
						my $e = $emsgs->{item_7_maxsize};
						$e =~ s/\%caption\%/${caption}/g;
						$e =~ s/\%type_7_maxsize\%/$item->{type_7_maxsize}/g;
						push(@errs, [$name, $e]);
						#
						$self->{session}->remove_file($name);
						$meta = undef;
					} elsif($meta->{size} > $self->{conf}->{atc_max_total_size} * 1024 * 1024) {
						#アップロードしたファイルの合計サイズが大きすぎます。アップロードできるファイルのサイズの合計は%atc_max_total_size%MBまでです。
						my $e = $emsgs->{atc_max_total_size};
						$e =~ s/\%caption\%/${caption}/g;
						$e =~ s/\%atc_max_total_size\%/$self->{conf}->{atc_max_total_size}/g;
						push(@errs, [$name, $e]);
						#
						$self->{session}->remove_file($name);
						$meta = undef;
					} elsif( $atc_total_size + $meta->{size}  > $self->{conf}->{atc_max_total_size} * 1024 * 1024 ) {
						#アップロードしたファイルの合計サイズが大きすぎます。アップロードできるファイルのサイズの合計は%atc_max_total_size%MBまでです。
						my $e = $emsgs->{atc_max_total_size};
						$e =~ s/\%caption\%/${caption}/g;
						$e =~ s/\%atc_max_total_size\%/$self->{conf}->{atc_max_total_size}/g;
						push(@errs, [$name, $e]);
						#
						$self->{session}->remove_file($name);
						$meta = undef;
					}
				}
				if($meta && $item->{type_7_allow_exts}) {
					my @allow_exts = split(/\n+/, $item->{type_7_allow_exts});
					my $allow = 0;
					for my $ext (@allow_exts) {
						if($meta->{filename} =~ /\Q${ext}\E$/) {
							$allow = 1;
							last;
						}
					}
					unless($allow) {
						#「%caption%」にご指定のファイルは許可されていないファイルタイプです。
						my $e = $emsgs->{item_7_allow_exts};
						$e =~ s/\%caption\%/${caption}/g;
						$e =~ s/\%atc_max_total_size\%/$self->{conf}->{atc_max_total_size}/g;
						push(@errs, [$name, $e]);
						#
						$self->{session}->remove_file($name);
						$meta = undef;
					}
				}
				if($meta) {
					$in->{$name} = $meta;
					$atc_total_size += $meta->{size};
				}
			} else {
				if($required) {
					#「%caption%」は必須です。
					my $e = $emsgs->{item_required};
					$e =~ s/\%caption\%/${caption}/g;
					push(@errs, [$name, $e]);
				}
				#
				$in->{$name} = $self->{session}->{data}->{proc}->{in}->{$name};
			}
		# 非表示フィールド
		} elsif($type eq "8") {
			my($v) = $self->get_values($name);
			my $minlength = $item->{type_8_minlength} ? $item->{type_8_minlength} : 0;
			my $maxlength = $item->{type_8_maxlength} ? $item->{type_8_maxlength} : 0;
			if(defined $v && $v ne "") {
				my $len = FCC::Class::String::Checker->new($v, "utf8")->get_char_num();
				if( $minlength && $len < $minlength ) {
					$context->{fatalerrs} = ['parameter error'];
					return $context;
				} elsif( $maxlength && $len > $maxlength ) {
					$context->{fatalerrs} = ['parameter error'];
					return $context;
				}
			} else {
				if($required) {
					$context->{fatalerrs} = ['parameter error'];
					return $context;
				}
			}
			$in->{$name} = $v;
		}
	}
	#再入力設定チェック
	my $chk = FCC::Class::Mpfmec::Check->new(conf=>$self->{conf})->get();
	for my $no ( sort { $a<=>$b } keys %{$chk} ) {
		my $name1 = $chk->{$no}->{item_1};
		my $name2 = $chk->{$no}->{item_2};
		if( $in->{$name1} ne $in->{$name2} ) {
			my $cap1 = $items->{$name1}->{caption};
			my $cap2 = $items->{$name2}->{caption};
			my $e = $emsgs->{chk_mismatched};
			$e =~ s/\%caption1\%/${cap1}/g;
			$e =~ s/\%caption2\%/${cap2}/g;
			push(@errs, [$name1, $e]);
		}
	}
	#
	$proc->{in} = $in;
	$proc->{errs} = \@errs;
	#
	if(@errs) {
		$proc->{input_valid} = 0;
	} else {
		$proc->{input_valid} = 1;
	}
	#セッションをアップデート
	$self->{session}->update( { proc => $proc } );
	#
	$context->{proc} = $proc;
	return $context;
}

sub get_values {
	my($self, $name, $break_enable) = @_;
	my @vals = $self->{q}->param($name);
	unless(@vals) {
		@vals = ();
		return @vals;
	}
	for( my $i=0; $i<@vals; $i++ ) {
		my $v = $vals[$i];
		#文字コードをUTF-8に変換
		if($self->{conf}->{target_encoding} eq "1") {
			$v = Unicode::Japanese->new($v, "sjis")->get();
		} elsif($self->{conf}->{target_encoding} eq "2") {
			$v = Unicode::Japanese->new($v, "euc")->get();
		} elsif($self->{conf}->{target_encoding} eq "3") {
			$v = Unicode::Japanese->new($v, "jis")->get();
		}
		#ASCII制御コードは改行(0x0a, 0x0d)と水平タブ(0x09)を除いて除外
		$v =~ s/[\x00-\x08]//g;
		$v =~ s/[\x0b-\x0c]//g;
		$v =~ s/[\x0e-\x1f]//g;
		$v =~ s/[\x7f]//g;
		#改行をLFに統一
		if(defined $v) {
			$v =~ s/\x0D\x0A|\x0D|\x0A/\n/g;
		} else {
			$v = "";
		}
		#改行を削除
		if( ! $break_enable) {
			$v =~ s/\n//g;
		}
		$vals[$i] = $v;
	}
	return @vals;
}

1;
