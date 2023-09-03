package FCC::Class::Mpfmec::Tpl;
$VERSION = 1.00;
use strict;
use warnings;
use base qw(FCC::_Super);
use Carp;
use File::Read;
use HTML::Template;
use CGI::Utils;
use Unicode::Japanese;
use FCC::Class::Mpfmec::Item;

sub init {
	my($self, %args) = @_;
	$self->{conf} = $args{conf};
	$self->{dir} = "$args{conf}->{BASE_DIR}/data/tpl";
	$self->{default_dir} = "$args{conf}->{BASE_DIR}/default/tpl";
	unless(-d $self->{dir}) {
		mkdir $self->{dir}, 0777 or croak "failed to make a directory \"$self->{dir}\". : $!";
		if($args{conf}->{SUEXEC}) {
			chmod 0700, $self->{dir};
		} else {
			chmod 0777, $self->{dir};
		}
	}
	$self->{titles} = {
		#HTML画面 - PC用
		frm00 => {
			title1 => "HTML画面",
			title2 => "PC用",
			title3 => "入力画面"
		},
		cfm00 => {
			title1 => "HTML画面",
			title2 => "PC用",
			title3 => "確認画面"
		},
		cpt00 => {
			title1 => "HTML画面",
			title2 => "PC用",
			title3 => "完了画面"
		},
		err00 => {
			title1 => "HTML画面",
			title2 => "PC用",
			title3 => "エラー画面"
		},
		#HTML画面 - 携帯用
		frm10 => {
			title1 => "HTML画面",
			title2 => "携帯用",
			title3 => "入力画面"
		},
		cfm10 => {
			title1 => "HTML画面",
			title2 => "携帯用",
			title3 => "確認画面"
		},
		cpt10 => {
			title1 => "HTML画面",
			title2 => "携帯用",
			title3 => "完了画面"
		},
		err10 => {
			title1 => "HTML画面",
			title2 => "携帯用",
			title3 => "エラー画面"
		},
		#HTML画面 - DoCoMo用
		frm11 => {
			title1 => "HTML画面",
			title2 => "DoCoMo用",
			title3 => "入力画面"
		},
		cfm11 => {
			title1 => "HTML画面",
			title2 => "DoCoMo用",
			title3 => "確認画面"
		},
		cpt11 => {
			title1 => "HTML画面",
			title2 => "DoCoMo用",
			title3 => "完了画面"
		},
		err11 => {
			title1 => "HTML画面",
			title2 => "DoCoMo用",
			title3 => "エラー画面"
		},
		#HTML画面 - au用
		frm12 => {
			title1 => "HTML画面",
			title2 => "au用",
			title3 => "入力画面"
		},
		cfm12 => {
			title1 => "HTML画面",
			title2 => "au用",
			title3 => "確認画面"
		},
		cpt12 => {
			title1 => "HTML画面",
			title2 => "au用",
			title3 => "完了画面"
		},
		err12 => {
			title1 => "HTML画面",
			title2 => "au用",
			title3 => "エラー画面"
		},
		#HTML画面 - Softbank用
		frm13 => {
			title1 => "HTML画面",
			title2 => "Softbank用",
			title3 => "入力画面"
		},
		cfm13 => {
			title1 => "HTML画面",
			title2 => "Softbank用",
			title3 => "確認画面"
		},
		cpt13 => {
			title1 => "HTML画面",
			title2 => "Softbank用",
			title3 => "完了画面"
		},
		err13 => {
			title1 => "HTML画面",
			title2 => "Softbank用",
			title3 => "エラー画面"
		}
	};
	$self->{encoding_map} = {
		"0" => "UTF-8",
		"1" => "Shift_JIS",
		"2" => "EUC-JP",
		"3" => "ISO-2022-JP"
	};
	$self->{doctype_map} = {
		"0011" => "HTML 4.01 Transitional",
		"0012" => "HTML 4.01 Strict",
		"0013" => "XHTML 1.0 Transitional",
		"0014" => "XHTML 1.0 Strict",
		"0015" => "XHTML 1.1",
		"1001" => "XHTML Mobile Profile 1.0",
		"1111" => "i-XHTML 1.1",
		"1210" => "OPENWAVE XHTML 1.0",
		"1310" => "J-PHONE XHTML Basic 1.0",
	};
	$self->{ctype_map} = {
		"0011" => "text/html",             # HTML 4.01 Transitional
		"0012" => "text/html",             # HTML 4.01 Strict",
		"0013" => "text/html",             # XHTML 1.0 Transitional",
		"0014" => "text/html",             # XHTML 1.0 Strict",
		"0015" => "application/xhtml+xml", # XHTML 1.1",
		"1001" => "application/xhtml+xml", # XHTML Mobile Profile 1.0",
		"1111" => "application/xhtml+xml", # i-XHTML 1.1",
		"1210" => "text/html",             # OPENWAVE XHTML 1.0",
		"1310" => "text/html",             # J-PHONE XHTML Basic 1.0",
	}
}

#---------------------------------------------------------------------
#■ エクスポート用データを取得
#---------------------------------------------------------------------
#[引数]
#	1.なし
#[戻り値]
#	エクスポート用のhashref
#	tplフォルダ内のすべてのファイルを対象とする。
#---------------------------------------------------------------------
sub export_data {
	my($self) = @_;
	my %data;
	opendir(DIR, $self->{dir}) or croak "failed to open $self->{dir} : $!";
	my @files = readdir(DIR);
	closedir(DIR);
	for my $f (@files) {
		if($f !~ /^[a-zA-Z0-9\_]+\.tpl$/) { next; }
		my $path = "$self->{dir}/${f}";
		eval { $data{$f} = File::Read::read_file($path); };
		if($@) { croak "failed to read ${path} : $@"; }
	}
	return \%data;
}

#---------------------------------------------------------------------
#■ インポート
#---------------------------------------------------------------------
#[引数]
#	1.エクスポートしたhashref
#[戻り値]
#	なし
#---------------------------------------------------------------------
sub import_data {
	my($self, $ref) = @_;
	if( ! defined $ref || ref($ref) ne "HASH" ) {
		croak "the 1st argument must be hashref.";
	}
	while( my($f, $d) = each %{$ref} ) {
		if($f !~ /^[a-zA-Z0-9\_]+\.tpl$/) { next; }
		if( ! defined $d || $d eq "" ) { next; }
		my $path = "$self->{dir}/${f}";
		open my $fh, ">", $path or croak "failed to open ${path} : $!";
		print $fh $d;
		close($fh);
	}
}

#---------------------------------------------------------------------
#■ ブラウザに出力
#---------------------------------------------------------------------
#[引数]
#	1.テンプレートID（必須）
#	2.HTML::Templateオブジェクト（必須）
#[戻り値]
#	なし
#---------------------------------------------------------------------
sub show {
	my($self, $tid, $t) = @_;
	if( ! $self->{titles}->{$tid} ) {
		croak "invalid tid.";
	}
	#メタ情報
	my $meta = $self->get_meta($tid);
	#Content-Type置換
	$t->param("ctype" => $meta->{ctype});
	#HTMLデータ生成
	my $html = $t->output();
	#文字コード変換
	my $charset = $meta->{charset};
	if($charset =~ /Shift_JIS/i) {
		$html = Unicode::Japanese->new($html, "utf8")->sjis();
	} elsif($charset =~ /EUC\-JP/i) {
		$html = Unicode::Japanese->new($html, "utf8")->euc();
	} elsif($charset =~ /ISO\-2022\-JP/i) {
		$html = Unicode::Japanese->new($html, "utf8")->jis();
	}
	#出力
	my $clen = length $html;
	my $ctype = $meta->{ctype};
	print STDOUT "Content-Type: ${ctype}; charset=${charset}\n";
	print STDOUT "Content-Length: ${clen}\n";
	print STDOUT "\n";
	print STDOUT $html;
}

#---------------------------------------------------------------------
#■ レンダリング用のテンプレートオブジェクトに入力初期値をセット
#   （管理メニューのプレビュー用）
#---------------------------------------------------------------------
#[引数]
#	1.テンプレートオブジェクト（必須）
#	2.入力項目オブジェクト
#[戻り値]
#	入力初期値をセットしたテンプレートオブジェクト
#---------------------------------------------------------------------
sub preset_default_values {
	my($self, $tid, $t, $items) = @_;
	#パラメータチェック
	if( ! $self->{titles}->{$tid} ) {
		croak "the 1st augument is not tid.";
	}
	unless($t && $t->param) {
		croak "the 2nd argument is not HTML::Template object.";
	}
	#Doctypeを特定
	my($ttype, $uatype) = $tid =~ /^([a-zA-Z]+)(\d+)/;
	my $doctype_code = $self->{conf}->{"html_${uatype}_doctype"};
	#brタグ
	my $br_tag;
	if($doctype_code =~ /^(0011|0012)$/) {
		$br_tag = "<br>";
	} else {
		$br_tag = "<br />";
	}
	#フォーム項目データを取得
	unless($items && ref($items) eq "HASH") {
		$items = FCC::Class::Mpfmec::Item->new(conf=>$self->{conf})->get();
	}
	#プリセット
	while( my($name, $ref) = each %{$items} ) {
		my $type = $ref->{type};
		if($type =~ /^(1|8)$/) {
			my $v = $ref->{"type_${type}_value"};
			if($v) {
				$t->param("${name}" => CGI::Utils->new()->escapeHtmlFormValue($v));
			}
		} elsif($type =~ /^(3|4|5)$/) {
			my @elms = split(/\n+/, $ref->{"type_${type}_elements"});
			my $no = 1;
			for my $elm (@elms) {
				if($elm =~ /^\*/) {
					if($type eq "5") {
						$t->param("${name}_${no}_selected" => 'selected="selected"');
					} else {
						$t->param("${name}_${no}_checked" => 'checked="checked"');
					}
				}
				$no ++;
			}
			my @element_loop;
			for my $elm (@elms) {
				if($elm =~ /^\*(.*)/) {
					my $element = $1;
					my %hash;
					$hash{element} = CGI::Utils->new()->escapeHtml($element);
					$hash{"type_${type}_arrangement"} = $ref->{"type_${type}_arrangement"};
					push(@element_loop, \%hash);
				}
			}
			$t->param("${name}_element_loop" => \@element_loop);
		} elsif($type eq "2") { # パスワードフィールド
			my $v = $ref->{"type_${type}_value"};
			if($v) {
				$t->param("${name}" => CGI::Utils->new()->escapeHtmlFormValue($v));
				my $v_secret = '*' x length($v);
				$t->param("${name}_secret" => CGI::Utils->new()->escapeHtml($v_secret));
			}
		} elsif($type eq "6") { # テキストエリア
			my $v = $ref->{"type_${type}_value"};
			if($v) {
				$t->param("${name}" => CGI::Utils->new()->escapeHtmlFormValue($v));
				my $v_with_br = CGI::Utils->new()->escapeHtml($v);
				$v_with_br =~ s|\n|${br_tag}|g;
				$t->param("${name}_with_br" => $v_with_br);
			}
		}
	}
	#
	return $t;
}

#---------------------------------------------------------------------
#■ レンダリング用のテンプレートオブジェクトをゲット
#---------------------------------------------------------------------
#[引数]
#	1.テンプレートID（必須）
#	2.テンプレートデータ ※管理メニューのプレビュー表示用に利用される
#[戻り値]
#	%form%などを置換した状態のテンプレートオブジェクトを返す
#---------------------------------------------------------------------
sub get_for_render {
	my($self, $tid, $tpl) = @_;
	if( ! $self->{titles}->{$tid} ) {
		croak "invalid tid.";
	}
	unless( defined $tpl && $tpl ne "" ) {
		$tpl = $self->get($tid);
	}
	if($tid =~ /^err/) {
		my $errs = $self->mk_err_errs_tpl($tid);
		$tpl =~ s/\%errs\%/${errs}/;
	} else {
		my($ttype, $uatype) = $tid =~ /^([a-zA-Z]+)(\d+)/;
		if($ttype eq "frm") {
			my $form = $self->mk_frm_form_tpl($tid);
			$tpl =~ s/\%form\%/${form}/;
		} elsif($ttype eq "cfm") {
			my $form = $self->mk_cfm_form_tpl($tid);
			$tpl =~ s/\%form\%/${form}/;
		} elsif($ttype eq "cpt") {
			my $form = $self->mk_cpt_form_tpl($tid);
			$tpl =~ s/\%form\%/${form}/;
		}
	}
	my $t = HTML::Template->new(
		scalarref => \$tpl,
		die_on_bad_params => 0,
		vanguard_compatibility_mode => 1,
		loop_context_vars => 1,
		case_sensitive => 1
	);
	return $t;
}

#---------------------------------------------------------------------
#■ HTMLのメタ情報をゲット
#---------------------------------------------------------------------
#[引数]
#	1.テンプレートID（必須）
#[戻り値]
#	hashrefを返す。
#---------------------------------------------------------------------
sub get_meta {
	my($self, $tid) = @_;
	if( ! $self->{titles}->{$tid} ) {
		croak "invalid tid.";
	}
	my($ttype, $uatype) = $tid =~ /^([a-zA-Z]+)(\d+)/;
	my $encoding = $self->{conf}->{"html_${uatype}_encoding"};
	my $charset = $self->{encoding_map}->{$encoding};
	my $doctype_code = $self->{conf}->{"html_${uatype}_doctype"};
	my $doctype = $self->{doctype_map}->{$doctype_code};
	my $ctype = $self->{ctype_map}->{$doctype_code};
	if( ! $ctype ) { $ctype = "text/html"; }
	if( defined $self->{conf}->{html_auto_ctype} && $self->{conf}->{html_auto_ctype} eq "1" ) {
		my $ua = $ENV{HTTP_USER_AGENT};
		if( $self->_ua_is_msie() ) {
			$ctype = "text/html";
		} elsif($doctype_code =~ /^1/) {
			if( $self->_ua_is_docomo() ) {
				if( $self->_ua_is_docomo_foma() ) {
					$ctype = "application/xhtml+xml";
				} else {
					$ctype = "text/html";
				}
			} else {
				$ctype = "text/html";
			}
		}
	}
	$ctype .= "; charset=${charset}";
	my %meta = (
		"lang" => $self->{conf}->{"lang"},
		"encoding" => $encoding,
		"charset" => $charset,
		"doctype" => $doctype,
		"ctype" => $ctype
	);
	return \%meta;
}

sub _ua_is_docomo {
	my($self) = @_;
	my $ua = $ENV{HTTP_USER_AGENT};
	if($ua =~ m|DoCoMo/\d|) {
		return 1;
	} else {
		return 0;
	}
}

sub _ua_is_docomo_foma {
	my($self) = @_;
	my $ua = $ENV{HTTP_USER_AGENT};
	if($ua =~ m|DoCoMo/(\d)|) {
		my $ver = $1;
		if($ver >=2) {
			return 1;
		} else {
			return 0;
		}
	} else {
		return 0;
	}
}

sub _ua_is_msie {
	my($self) = @_;
	my $ua = $ENV{HTTP_USER_AGENT};
	if($ua =~ /MSIE/i) {
		return 1;
	} else {
		return 0;
	}
}

#---------------------------------------------------------------------
#■ すべてのタイトルをゲット
#---------------------------------------------------------------------
#[引数]
#	なし
#[戻り値]
#	hashrefを返す。
#---------------------------------------------------------------------
sub get_titles {
	my($self) = @_;
	return $self->{titles};
}

#---------------------------------------------------------------------
#■ テンプレートをセット
#---------------------------------------------------------------------
#[引数]
#	1.hashref
#		{
#			tid => テンプレートID（必須）,
#			tpl => テンプレート内容（必須）
#		}
#[戻り値]
#	成功すれば1を返す。
#	失敗すればcroakする。
#---------------------------------------------------------------------
sub set {
	my($self, $ref) = @_;
	#引数のチェック
	unless(defined $ref && defined $ref->{tid} && defined $ref->{tpl}) {
		croak "the 1st argument is invalid.";
	}
	my $tid = $ref->{tid};
	my $tpl = $ref->{tpl};
	if( ! $self->{titles}->{$tid} ) {
		croak "invalid tid.";
	}
	#テンプレートを保存
	my($ttype, $uatype) = $tid =~ /^([a-zA-Z]+)(\d+)/;
	my $doctype  = $self->{conf}->{"html_${uatype}_doctype"};
	my $lang = $self->{conf}->{"lang"};
	my $f = "$self->{dir}/${lang}_${doctype}_${ttype}.tpl";
	if($tpl eq "") {
		unlink $f;
	} else {
		open my $fh, ">", $f or croak "failed to open ${f} : $!";
		binmode($fh);
		print $fh $tpl;
		close($fh);
		chmod 0600, $f;
	}
	return 1;
}

#---------------------------------------------------------------------
#■ テンプレートをゲット
#---------------------------------------------------------------------
#[引数]
#	1.テンプレートID（必須）
#	2.デフォルトを除外するフラグ：1
#	通常は該当のテンプレートがセットされていればそれを返し、セットされ
#	ていなければデフォルトテンプレートを返す。もしフラグに1がセットさ
#	れると、セットされているテンプレートのみを返す。セットされていなけ
#	れば、空を返す。（管理メニュー用）
#[戻り値]
#	成功すればテンプレートのデータを返す。
#	失敗すればcroakする。
#---------------------------------------------------------------------
sub get {
	my($self, $tid, $ignore_default_flag) = @_;
	if( ! $self->{titles}->{$tid} ) {
		croak "invalid tid.";
	}
	my($ttype, $uatype) = $tid =~ /^([a-zA-Z]+)(\d+)/;
	my $doctype  = $self->{conf}->{"html_${uatype}_doctype"};
	my $lang = $self->{conf}->{"lang"};
	my $f = "$self->{dir}/${lang}_${doctype}_${ttype}.tpl";
	my $tpl;
	if(-e $f) {
		eval { $tpl = File::Read::read_file($f); };
		if($@) { croak "failed to read ${f} : $@"; }
	} elsif(! $ignore_default_flag) {
		$tpl = $self->get_default($tid);
	} else {
		$tpl = "";
	}
	return $tpl;
}

#---------------------------------------------------------------------
#■ デフォルトテンプレートをゲット
#---------------------------------------------------------------------
#[引数]
#	1.テンプレートID（必須）
#	2.モード（1：簡単モード、2：エキスパートモード）
#[戻り値]
#	成功すればテンプレートのデータを返す。
#	失敗すればcroakする。
#---------------------------------------------------------------------
sub get_default {
	my($self, $tid, $mode) = @_;
	if( ! $self->{titles}->{$tid} ) {
		croak "invalid tid.";
	}
	my($ttype, $uatype) = $tid =~ /^([a-zA-Z]+)(\d+)/;
	my $doctype  = $self->{conf}->{"html_${uatype}_doctype"};
	my $lang = $self->{conf}->{"lang"};
	#簡単モード用
	my $f = "$self->{default_dir}/${lang}_${doctype}_${ttype}.tpl";
	unless(-e $f) {
		$f = "$self->{default_dir}/en_${doctype}_${ttype}.tpl";
	}
	unless(-e $f) {
		$f = "$self->{default_dir}/ja_${doctype}_${ttype}.tpl";
	}
	unless(-e $f) {
		croak "not found ${f}";
	}
	my $tpl;
	eval { $tpl = File::Read::read_file($f); };
	if($@) { croak "failed to read ${f} : $@"; }
	#エキスパートモード用
	if(defined $mode && $mode eq "2") {
		if($ttype eq "frm") {
			my $form = $self->mk_frm_form_tpl($tid);
			$tpl =~ s/\%form\%/${form}/;
		} elsif($ttype eq "cfm") {
			my $form = $self->mk_cfm_form_tpl($tid);
			$tpl =~ s/\%form\%/${form}/;
		} elsif($ttype eq "cpt") {
			my $form = $self->mk_cpt_form_tpl($tid);
			$tpl =~ s/\%form\%/${form}/;
		} elsif($ttype eq "err") {
			my $errs = $self->mk_err_errs_tpl($tid);
			$tpl =~ s/\%errs\%/${errs}/;
		}
	}
	$tpl =~ s/\%CGI_URL\%/$self->{conf}->{CGI_URL}/g;
	$tpl =~ s/\%static_url\%/$self->{conf}->{static_url}/g;
	#メタ情報
	my $meta = $self->get_meta($tid);
	$tpl =~ s/\%lang\%/$meta->{lang}/g;
	$tpl =~ s/\%encoding\%/$meta->{encoding}/g;
	$tpl =~ s/\%charset\%/$meta->{charset}/g;
	$tpl =~ s/\%ctype\%/$meta->{ctype}/g;
	#
	if($meta->{encoding}) { # UTF-8以外の場合
		my $xml_declaration = "<?xml version=\"1.0\" encoding=\"$meta->{charset}\"?>";
		$tpl =~ s/\%xml_declaration\%/${xml_declaration}/g;
	} else {
		$tpl =~ s/\%xml_declaration\%//g;
	}
	#
	return $tpl;
}

sub mk_err_errs_tpl {
	my($self, $tid) = @_;
	my($ttype, $uatype) = $tid =~ /^([a-zA-Z]+)(\d+)/;
	my $doctype  = $self->{conf}->{"html_${uatype}_doctype"};
	my $lang = $self->{conf}->{"lang"};
	#テンプレートファイルをロード
	my $f = "$self->{default_dir}/${lang}_${doctype}_err_errs.tpl";
	unless(-e $f) {
		$f = "$self->{default_dir}/en_${doctype}_err_errs.tpl";
	}
	unless(-e $f) {
		$f = "$self->{default_dir}/ja_${doctype}_err_errs.tpl";
	}
	my $errs;
	eval { $errs = File::Read::read_file($f); };
	if($@) { croak "failed to read ${f} : $@"; }
	#
	return $errs;
}

sub mk_cpt_form_tpl {
	my($self, $tid) = @_;
	my($ttype, $uatype) = $tid =~ /^([a-zA-Z]+)(\d+)/;
	my $doctype  = $self->{conf}->{"html_${uatype}_doctype"};
	my $doctype_code = $self->{conf}->{"html_${uatype}_doctype"};
	my $lang = $self->{conf}->{"lang"};
	#フォーム項目データを取得
	my $items = FCC::Class::Mpfmec::Item->new(conf=>$self->{conf})->get();
	#テンプレートファイルをロード
	my $f = "$self->{default_dir}/${lang}_${doctype}_cpt_form.tpl";
	unless(-e $f) {
		$f = "$self->{default_dir}/en_${doctype}_cpt_form.tpl";
	}
	unless(-e $f) {
		$f = "$self->{default_dir}/ja_${doctype}_cpt_form.tpl";
	}
	my $form;
	eval { $form = File::Read::read_file($f); };
	if($@) { croak "failed to read ${f} : $@"; }
	#テンプレートオブジェクト
	my $t = HTML::Template->new(
		scalarref => \$form,
		die_on_bad_params => 0,
		vanguard_compatibility_mode => 1,
		loop_context_vars => 1,
		case_sensitive =>1
	);
	#brタグ
	my $br_tag;
	if($doctype_code =~ /^(0011|0012)$/) {
		$br_tag = "<br>";
	} else {
		$br_tag = "<br />";
	}
	#置換
	my @item_loop;
	for my $name ( sort { $items->{$a}->{offset} <=> $items->{$b}->{offset} } keys %{$items} ) {
		my $itm = $items->{$name};
		my $type = $itm->{type};
		if($type eq "8") { next; }
		my %hash;
		while( my($k, $v) = each %{$itm} ) {
			$hash{$k} = CGI::Utils->new()->escapeHtml($v);
			if($k =~ /^(type|type_5_multiple)$/) {
				$hash{"${k}_${v}"} = 1;
			}
		}
		$hash{value} = "\%${name}\%";
		$hash{value_with_br} = "\%${name}_with_br\%";
		if($type eq "2") {
			$hash{value_secret} = "\%${name}_secret\%";
		} elsif($type eq "3") {
			my $element_loop = '<TMPL_LOOP NAME="element_loop"><span class="radioelement">%element%</span>';
			if($itm->{type_3_arrangement}) {
				$element_loop .= $br_tag;
			}
			$element_loop .= '</TMPL_LOOP>';
			$element_loop =~ s|<br />|${br_tag}|g;
			$element_loop =~ s|element_loop|${name}_element_loop|s;
			$hash{element_loop} = $element_loop;
		} elsif($type eq "4") {
			my $element_loop = '<TMPL_LOOP NAME="element_loop"><span class="checkelement">%element%</span>';
			if($itm->{type_4_arrangement}) {
				$element_loop .= $br_tag;
			}
			$element_loop .= '</TMPL_LOOP>';
			$element_loop =~ s|<br />|${br_tag}|g;
			$element_loop =~ s|element_loop|${name}_element_loop|s;
			$hash{element_loop} = $element_loop;
		} elsif($type eq "5") {
			my $element_loop = '<TMPL_LOOP NAME="element_loop"><span class="checkelement">%element%</span>';
			if($itm->{type_5_arrangement}) {
				$element_loop .= $br_tag;
			}
			$element_loop .= '</TMPL_LOOP>';
			$element_loop =~ s|<br />|${br_tag}|g;
			$element_loop =~ s|element_loop|${name}_element_loop|s;
			$hash{element_loop} = $element_loop;
		} elsif($type eq "7") {
			$hash{filename} = "\%${name}_filename\%";
		}
		push(@item_loop, \%hash);
	}
	$t->param("item_loop" => \@item_loop);
	$t->param("CGI_URL" => $self->{conf}->{CGI_URL});
	$t->param("static_url" => $self->{conf}->{static_url});
	$t->param("sid" => '%sid%');
	#
	my $template = $t->output();
	$template = $self->unify_return_code($template);
	$template =~ s/\n+/\n/g;
	return $template;
}

sub mk_cfm_form_tpl {
	my($self, $tid) = @_;
	my($ttype, $uatype) = $tid =~ /^([a-zA-Z]+)(\d+)/;
	my $doctype  = $self->{conf}->{"html_${uatype}_doctype"};
	my $doctype_code = $self->{conf}->{"html_${uatype}_doctype"};
	my $lang = $self->{conf}->{"lang"};
	#フォーム項目データを取得
	my $items = FCC::Class::Mpfmec::Item->new(conf=>$self->{conf})->get();
	#テンプレートファイルをロード
	my $f = "$self->{default_dir}/${lang}_${doctype}_cfm_form.tpl";
	unless(-e $f) {
		$f = "$self->{default_dir}/en_${doctype}_cfm_form.tpl";
	}
	unless(-e $f) {
		$f = "$self->{default_dir}/ja_${doctype}_cfm_form.tpl";
	}
	my $form;
	eval { $form = File::Read::read_file($f); };
	if($@) { croak "failed to read ${f} : $@"; }
	#テンプレートオブジェクト
	my $t = HTML::Template->new(
		scalarref => \$form,
		die_on_bad_params => 0,
		vanguard_compatibility_mode => 1,
		loop_context_vars => 1,
		case_sensitive =>1
	);
	#brタグ
	my $br_tag;
	if($doctype_code =~ /^(0011|0012)$/) {
		$br_tag = "<br>";
	} else {
		$br_tag = "<br />";
	}
	#置換
	my @item_loop;
	for my $name ( sort { $items->{$a}->{offset} <=> $items->{$b}->{offset} } keys %{$items} ) {
		my $itm = $items->{$name};
		my $type = $itm->{type};
		if($type eq "8") { next; }
		my %hash;
		while( my($k, $v) = each %{$itm} ) {
			$hash{$k} = CGI::Utils->new()->escapeHtml($v);
			if($k =~ /^(type|type_5_multiple)$/) {
				$hash{"${k}_${v}"} = 1;
			}
		}
		$hash{value} = "\%${name}\%";
		$hash{value_with_br} = "\%${name}_with_br\%";
		if($type eq "2") {
			$hash{value_secret} = "\%${name}_secret\%";
		} elsif($type eq "4") {
			my $element_loop = '<TMPL_LOOP NAME="element_loop"><span class="checkelement">%element%</span>';
			if($itm->{type_4_arrangement}) {
				$element_loop .= $br_tag;
			}
			$element_loop .= '</TMPL_LOOP>';
			$element_loop =~ s|<br />|${br_tag}|g;
			$element_loop =~ s|element_loop|${name}_element_loop|s;
			$hash{element_loop} = $element_loop;
		} elsif($type eq "5") {
			my $element_loop = '<TMPL_LOOP NAME="element_loop"><span class="selectlement">%element%</span>';
			if($itm->{type_5_arrangement}) {
				$element_loop .= $br_tag;
			}
			$element_loop .= '</TMPL_LOOP>';
			$element_loop =~ s|<br />|${br_tag}|g;
			$element_loop =~ s|element_loop|${name}_element_loop|s;
			$hash{element_loop} = $element_loop;
		} elsif($type eq "7") {
			my $tag = "";
			$tag .= "<TMPL_IF NAME=\"${name}_filename\">";
			$tag .= "<div>\n";
			$tag .= "<div>\%${name}_filename\%</div>\n";
			$tag .= "<TMPL_IF NAME=\"${name}\_thumb\"><img src=\"\%${name}_thumb_src\%\" width=\"\%${name}_thumb_width\%\" height=\"\%${name}_thumb_height\%\" alt=\"\%${name}_filename\%\" /></TMPL_IF>\n";
			$tag .= "</div>\n";
			$tag .= "</TMPL_IF>";
			$hash{filename} = $tag;
		}
		push(@item_loop, \%hash);
	}
	$t->param("hidden" => '%hidden%');
	$t->param("item_loop" => \@item_loop);
	$t->param("CGI_URL" => $self->{conf}->{CGI_URL});
	$t->param("static_url" => $self->{conf}->{static_url});
	$t->param("sid" => '%sid%');
	$t->param("back_url" => '%back_url%');
	$t->param("form_cgi_url" => '%form_cgi_url%');
	#
	my $template = $t->output();
	$template = $self->unify_return_code($template);
	$template =~ s/\n+/\n/g;
	return $template;
}

sub mk_frm_form_tpl {
	my($self, $tid) = @_;
	my($ttype, $uatype) = $tid =~ /^([a-zA-Z]+)(\d+)/;
	my $doctype  = $self->{conf}->{"html_${uatype}_doctype"};
	my $lang = $self->{conf}->{"lang"};
	#フォーム項目データを取得
	my $items = FCC::Class::Mpfmec::Item->new(conf=>$self->{conf})->get();
	#テンプレートファイルをロード
	my $f = "$self->{default_dir}/${lang}_${doctype}_frm_form.tpl";
	unless(-e $f) {
		$f = "$self->{default_dir}/en_${doctype}_frm_form.tpl";
	}
	unless(-e $f) {
		$f = "$self->{default_dir}/ja_${doctype}_frm_form.tpl";
	}
	my $form;
	eval { $form = File::Read::read_file($f); };
	if($@) { croak "failed to read ${f} : $@"; }
	#テンプレートオブジェクト
	my $t = HTML::Template->new(
		scalarref => \$form,
		die_on_bad_params => 0,
		vanguard_compatibility_mode => 1,
		loop_context_vars => 1,
		case_sensitive =>1
	);
	#置換
	my @item_loop;
	my $with_atc = 0;
	my @hidden_items;
	for my $name ( sort { $items->{$a}->{offset} <=> $items->{$b}->{offset} } keys %{$items} ) {
		my $itm = $items->{$name};
		my $type = $itm->{type};
		if($type eq "8") {
			push(@hidden_items, $itm);
			next;
		}
		my %hash;
		while( my($k, $v) = each %{$itm} ) {
			$hash{$k} = CGI::Utils->new()->escapeHtml($v);
			if($k =~ /^(type|type_5_multiple)$/) {
				$hash{"${k}_${v}"} = 1;
			}
		}
		$hash{value} = "\%${name}\%";
		$hash{err} = "\%${name}-err\%";
		$hash{tmpl_if_class_err} = "<TMPL_IF NAME=\"${name}-err\">class=\"err\"</TMPL_IF>";
		if($type =~ /^(3|4|5)$/) {
			my @elements = split(/\n+/, $itm->{"type_${type}_elements"});
			my $no = 1;
			my @element_loop;
			for my $element (@elements) {
				my %h;
				$h{no} = $no;
				$element =~ s/^\*//;
				$h{element} = CGI::Utils->new()->escapeHtml($element);
				$h{value} = $h{element};
				if($type eq "5" && $element =~ /^\^/) {
					$element =~ s/^\^//;
					$h{element} = CGI::Utils->new()->escapeHtml($element);
					$h{value} = "";
				}
				$h{name} = $name;
				$h{checked} = "\%${name}_${no}_checked\%";
				$h{selected} = "\%${name}_${no}_selected\%";
				if($type =~ /^(3|4)$/) {
					my $ar = $itm->{"type_${type}_arrangement"};
					$h{"type_${type}_arrangement_${ar}"} = 1;
					$h{"type_${type}_arrangement"} = $ar;
				}
				push(@element_loop, \%h);
				$no ++;
			}
			$hash{element_loop} = \@element_loop;
			my $element_num = scalar @elements;
			$hash{element_num} = $element_num;
		} elsif($type eq "7") {
			my $tag = "";
			$tag .= "<TMPL_IF NAME=\"${name}_filename\">";
			$tag .= "<div>\n";
			$tag .= "<div>\%${name}_filename\%</div>\n";
			$tag .= "<TMPL_IF NAME=\"${name}\_thumb\"><img src=\"\%${name}_thumb_src\%\" width=\"\%${name}_thumb_width\%\" height=\"\%${name}_thumb_height\%\" alt=\"\%${name}_filename\%\" /></TMPL_IF>\n";
			$tag .= "</div>\n";
			$tag .= "</TMPL_IF>";
			$hash{filename} = $tag;
			$with_atc ++;
		}
		push(@item_loop, \%hash);
	}
	$t->param("item_loop" => \@item_loop);
	$t->param("hidden" => '%hidden%');
	$t->param("with_atc" => $with_atc);
	$t->param("errs" => '%errs%');
	$t->param("CGI_URL" => $self->{conf}->{CGI_URL});
	$t->param("static_url" => $self->{conf}->{static_url});
	$t->param("sid" => '%sid%');
	$t->param("confirm_enable" => $self->{conf}->{confirm_enable});
	$t->param("form_cgi_url" => '%form_cgi_url%');
	#
	my $template = $t->output();
	$template = $self->unify_return_code($template);
	$template =~ s/\n+/\n/g;
	return $template;
}

sub unify_return_code {
	my($self, $str) = @_;
	$str =~ s/\x0D\x0A|\x0D|\x0A/\n/g;
	return $str;
}

1;
