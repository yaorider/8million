#---------------------------------------------------------------------#
#■英文ワードラップ・禁則処理モジュール
#
#・使い方
#
#	my $ww = new FCC::Class::String::WordWrap($str);
#
#	#英文ワードラップ・禁則処理
#	$wrapped_str = $ww->word_wrap($fold_len);
#
#	※ $fold_len は折り返し文字数（50以上。50未満の場合は何もしない。）
#	※ 文字列はUTF-8のみに対応。他の文字コードでは文字化けるので注意。
#---------------------------------------------------------------------#

package FCC::Class::String::WordWrap;
$VERSION = 1.00;
use strict;
use warnings;

sub new {
	my($caller, $str, $icode) = @_;
	my $class = ref($caller) || $caller;
	my $self = {};
	unless(defined $str) { $str = ''; }
	unless(defined $icode) { $icode = ''; }
	$self->{str} = $str;
	bless $self, $class;
	return $self;
}

sub word_wrap {
	my($self, $fold_len) = @_;
	my $european_wordwrap_flag = 1;	#英文ワードラップを有効
	my $kinsoku_flag = 1;	#禁則処理を有効
	my $zen_char_len_flag = 1;	#全角文字を2文字と解釈する
	#
	unless( defined $fold_len && $fold_len =~ /^\d+$/ && $fold_len >= 50 ) {
		return $self->{str};
	}
	#行頭禁則文字
	my @non_head_chars = ('、', '。', '，', '．', '・', '？', '！', '゛', '゜', 'ヽ', 'ヾ', 'ゝ', 'ゞ', '々', 'ー', '）', '］', '｝', '」', '』', '!', ')', ',', '.', ':', ';', '?', ']', '}', '｡', '｣', '､', '･', 'ｰ', 'ﾞ', 'ﾟ');
	#行末禁則文字
	my @non_end_chars = ('（', '［', '｛', '「', '『', '(', '[', '{', '｢');
	#
	my @wraped_lines;
	my @lines = split(/\n/, $self->{str});
	for my $line (@lines) {
		if(length($line) <= $fold_len) {
			push(@wraped_lines, $line);
			next;
		}
		#ラテン文字のスペースをASCIIの半角スペースに変換
		$line =~ s/\xc2\xa0/\x20/g;
		#行を文字種別ごとの固まりに分割
		my @line_chars = $self->_split_to_chars($line);
		my @words;
		my $word = "";
		my $char_type = 0;
		for my $c (@line_chars) {
			my $type = 0;
			if($c =~ /^([\x21-\x7E]|\xc2[\xa1-\xbf]|[\xc3-\xdf][\x80-\xbf]|\xe2\x80\x99)$/) {
				$type = 1;
			} elsif($c eq "\x20") {
				$type = 2;
			} else {
				$type = 3;
			}
			if($type == $char_type) {
				$word .= $c;
			} else {
				push(@words, $word);
				$word = $c;
				$char_type = $type;
			}
		}
		if($word ne "") {
			push(@words, $word);
		}
		my $wraped_line;
		my $wraped_line_len = 0;
		for my $word (@words) {
			my @word_chars = $self->_split_to_chars($word);
			my $word_len = scalar @word_chars;
			if($zen_char_len_flag) {
				my $len = 0;
				for my $c (@word_chars) {
					$len += $self->_get_char_len($c);
				}
				$word_len = $len;
			}
			if($wraped_line_len + $word_len < $fold_len) {
				$wraped_line .= $word;
				$wraped_line_len += $word_len;
			} elsif($wraped_line_len + $word_len == $fold_len) {
				push(@wraped_lines, "${wraped_line}${word}");
				$wraped_line = '';
				$wraped_line_len = 0;
			} else {
				if($european_wordwrap_flag && $word =~ m/^([\x21-\x7E]|\xc2[\xa1-\xbf]|[\xc3-\xdf][\x80-\xbf]|\xe2\x80\x99)+$/ && $word_len < $fold_len) {
					push(@wraped_lines, "${wraped_line}");
					$wraped_line = $word;
					$wraped_line_len = $word_len;
				} else {
					for my $char (@word_chars) {
						if($kinsoku_flag && $wraped_line_len == 0 && grep(/^\Q$char\E$/, @non_head_chars)) {
							my $line_num = scalar @wraped_lines;
							$wraped_lines[$line_num - 1] .= $char;
							next;
						}
						my $char_len = 1;
						if($zen_char_len_flag) {
							$char_len = $self->_get_char_len($char);
						}
						if($wraped_line_len + $char_len < $fold_len) {
							$wraped_line .= $char;
							$wraped_line_len += $char_len;
						} elsif($wraped_line_len + $char_len == $fold_len) {
							if($kinsoku_flag && grep(/^\Q$char\E$/, @non_end_chars)) {
								push(@wraped_lines, "${wraped_line}");
								$wraped_line = $char;
								$wraped_line_len = $char_len;
							} else {
								push(@wraped_lines, "${wraped_line}${char}");
								$wraped_line = '';
								$wraped_line_len = 0;
							}
						} else {
							my @line_chars = $self->_split_to_chars($wraped_line);
							my $line_end_char = pop @line_chars;
							if($kinsoku_flag && grep(/^\Q${char}\E$/, @non_head_chars)) {
								push(@wraped_lines, "${wraped_line}${char}");
								$wraped_line = '';
								$wraped_line_len = 0;
							} elsif($kinsoku_flag && grep(/^\Q$line_end_char\E$/, @non_end_chars)) {
								$wraped_line =~ s/\Q${line_end_char}\E$//;
								push(@wraped_lines, "${wraped_line}");
								$wraped_line = "${line_end_char}${char}";
								$wraped_line_len = length($wraped_line);
							} else {
								push(@wraped_lines, "${wraped_line}");
								$wraped_line = $char;
								$wraped_line_len = $char_len;
							}
						}
					}
				}
			}
		}
		if($wraped_line ne '') {
			push(@wraped_lines, "${wraped_line}");
		}
	}
	#行頭、行末の半角スペースを削除
	for(my $i=0; $i<@wraped_lines; $i++) {
		my $line = $wraped_lines[$i];
		$line =~ s/^\s//;
		$line =~ s/\s$//;
		$wraped_lines[$i] = $line;
	}
	#
	my $wraped_string = join("\n", @wraped_lines);
	return $wraped_string;
}

sub _get_char_len {
	my($self, $c) = @_;
	if( ! defined $c || $c eq "") {
		return 0;
	} elsif($c =~ m/^([\x20-\x7E]|\xc2[\xa1-\xbf]|[\xc3-\xdf][\x80-\xbf]|\xef\xbd[\xa1-\xbf]|\xef\xbe[\x80-\x9e])$/) {
		return 1;
	} else {
		return 2;
	}
}

sub _split_to_chars {
	my($self, $str) = @_;
	my @chars;
	eval { require Encode; };
	if($@) {
		use utf8;
		@chars = split(//, $str);
	} else {
		$str = Encode::decode("utf-8", $str);
		@chars = split(//, $str);
		for( my $i=0; $i<@chars; $i++ ) {
			my $char = $chars[$i];
			$char = Encode::encode("utf-8", $char);
			$chars[$i] = $char;
		}
	}
	return @chars;
}

1;
