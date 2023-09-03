package FCC::Class::Mpfmec::TplRpy;
$VERSION = 1.00;
use strict;
use warnings;
use base qw(FCC::_Super);
use Carp;
use File::Read;
use HTML::Template;
use CGI::Utils;
use Unicode::Japanese;
use MIME::Types;
use FCC::Class::Mpfmec::Item;
use FCC::Class::Date::Utils;

sub init {
	my($self, %args) = @_;
	$self->{conf} = $args{conf};
	$self->{dir} = "$args{conf}->{BASE_DIR}/data/tpl";
	$self->{default_dir} = "$args{conf}->{BASE_DIR}/default/tpl";
	unless(-d $self->{dir}) {
		mkdir $self->{dir}, 0700 or croak "failed to make a directory \"$self->{dir}\". : $!";
		if($args{conf}->{SUEXEC}) {
			chmod 0700, $self->{dir};
		} else {
			chmod 0777, $self->{dir};
		}
	}
	$self->{atc_dir} = "$args{conf}->{BASE_DIR}/data/rpyatc";
	unless(-d $self->{atc_dir}) {
		mkdir $self->{atc_dir}, 0700 or croak "failed to make a directory \"$self->{atc_dir}\". : $!";
		if($args{conf}->{SUEXEC}) {
			chmod 0700, $self->{atc_dir};
		} else {
			chmod 0777, $self->{atc_dir};
		}
	}
}

#---------------------------------------------------------------------
#■ 添付するファイルを追加
#---------------------------------------------------------------------
#[引数]
#	1.ファイル名
#	2.ファイルのデータ
#[戻り値]
#	なし
#	失敗するとcroak
#---------------------------------------------------------------------
sub ad_atc_file {
	my($self, $name, $data) = @_;
	if( ! defined $name || $name eq "" || ! defined $data || $data eq "") {
		croak "argument error.";
	}
	#ファイル名を16進数に変換
	my $name_hex = unpack("H*", $name);
	#ファイルを保存
	my $path = "$self->{atc_dir}/${name_hex}";
	open my $fh, ">", $path or croak "failed to create a file. : $!";
	binmode($fh);
	print $fh $data;
	close($fh);
	chmod 0600, $path;
}

#---------------------------------------------------------------------
#■ 添付するファイルを削除
#---------------------------------------------------------------------
#[引数]
#	16進数ファイル名を格納したarrayref
#[戻り値]
#	削除が成功した16進数ファイル名のarrayref
#---------------------------------------------------------------------
sub del_atc_file {
	my($self, $arrayref) = @_;
	if( ! defined $arrayref || ref($arrayref) ne "ARRAY") {
		croak "the 1st argument must be a arrayref.";
	}
	my @deleted;
	for my $name_hex (@{$arrayref}) {
		if($name_hex !~ /^[a-fA-F0-9]+$/) { next; }
		my $path = "$self->{atc_dir}/${name_hex}";
		if( unlink $path ) {
			push(@deleted, $name_hex);
		}
	}
	return \@deleted;
}

#---------------------------------------------------------------------
#■ 添付するファイルの一覧を取得
#---------------------------------------------------------------------
#[引数]
#	なし
#[戻り値]
#	ファイルの一覧を格納したarrayref
#	arrayrefの各要素は、ファイルの情報を格納したhashref
#	{
#		name => ファイル名,
#		filename => ファイル名（nameと同じ）,
#		size => サイズ(byte),
#		mtype => MIMEタイプ,
#		mtime => 最終更新日時(epoch秒),
#		path  => ファイル格納パス,
#		name_hex => ファイル名の16進数表記
#	}
#---------------------------------------------------------------------
sub get_atc_file_list {
	my($self) = @_;
	if( ! -d $self->{atc_dir} ) { return []; }
	opendir(DIR, $self->{atc_dir}) or croak "failed to open a directory. $self->{atc_dir} : $!";
	my @files = readdir(DIR);
	closedir(DIR);
	my $list = [];
	for my $name_hex (@files) {
		my %hash;
		if( $name_hex !~ /^[a-fA-F0-9]+$/ ) { next; }
		$hash{name_hex} = $name_hex;
		$hash{path} = "$self->{atc_dir}/${name_hex}";
		$hash{name} = pack("H*", $name_hex);
		$hash{filename} = $hash{name};
		my @stat = stat($hash{path});
		$hash{size} = $stat[7];
		$hash{mtime} = $stat[9];
		$hash{mtype} = MIME::Types->new()->mimeTypeOf($hash{name});
		push(@{$list}, \%hash);
	}
	return $list;
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
	my($self, $t, $items) = @_;
	#パラメータチェック
	unless($t && $t->param) {
		croak "the 2nd argument is not HTML::Template object.";
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
				$t->param($name => $v);
			}
		} elsif($type =~ /^(3|4|5)$/) {
			my @elms = split(/\n+/, $ref->{"type_${type}_elements"});
			my @element_loop;
			for my $elm (@elms) {
				if($elm =~ /^\*(.*)/) {
					my $element = $1;
					my %hash;
					$hash{element} = $element;
					$hash{br} = "\n";
					push(@element_loop, \%hash);
				}
			}
			$t->param("${name}_element_loop" => \@element_loop);
		} elsif($type eq "2") { # パスワードフィールド
			my $v = $ref->{"type_${type}_value"};
			if($v) {
				$t->param($name => $v);
				my $v_secret = '*' x length($v);
				$t->param("${name}_secret" => $v_secret);
			}
		} elsif($type eq "6") { # テキストエリア
			my $v = $ref->{"type_${type}_value"};
			if($v) {
				$t->param("${name}" => $v);
			}
		}
	}
	#
	$t->param("REMOTE_ADDR" => $ENV{REMOTE_ADDR});
	if($ENV{REMOTE_HOST}) {
		$t->param("REMOTE_HOST" => $ENV{REMOTE_HOST});
	} elsif($ENV{REMOTE_ADDR} =~ /^(\d{1,3})\.(\d{1,3})\.(\d{1,3})\.(\d{1,3})$/) {
		my $packed_addr = pack("C4", $1, $2, $3, $4);
		my($host) = gethostbyaddr($packed_addr, 2);
		$t->param("REMOTE_HOST" => $host);
	}
	$t->param("HTTP_USER_AGENT" => $ENV{HTTP_USER_AGENT});
	#
	my %tm = FCC::Class::Date::Utils->new(time=>time, tz=>$self->{conf}->{tz})->get_formated();
	while( my($k, $v) = each %tm ) {
		$t->param("RECEPTION_DATE_${k}" => $v);
	}
	#
	return $t;
}

#---------------------------------------------------------------------
#■ レンダリング用のテンプレートオブジェクトをゲット
#---------------------------------------------------------------------
#[引数]
#	1.テンプレートデータ ※管理メニューのプレビュー表示用に利用される
#[戻り値]
#	%form%などを置換した状態のテンプレートオブジェクトを返す
#---------------------------------------------------------------------
sub get_for_render {
	my($self, $tpl) = @_;
	unless( defined $tpl && $tpl ne "" ) {
		$tpl = $self->get();
	}
	if($tpl =~ /\%form\%/) {
		my $form = $self->mk_mai_form_tpl();
		$tpl =~ s/\%form\%/${form}/;
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
#■ テンプレートをセット
#---------------------------------------------------------------------
#[引数]
#	1.テンプレート内容（必須）
#[戻り値]
#	成功すれば1を返す。
#	失敗すればcroakする。
#---------------------------------------------------------------------
sub set {
	my($self, $tpl) = @_;
	#引数のチェック
	unless(defined $tpl) {
		croak "the 1st argument is invalid.";
	}
	#テンプレートを保存
	my $lang = $self->{conf}->{"lang"};
	my $f = "$self->{dir}/${lang}_0000_rpy.tpl";
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
#	1.デフォルトを除外するフラグ：1
#	通常は該当のテンプレートがセットされていればそれを返し、セットされ
#	ていなければデフォルトテンプレートを返す。もしフラグに1がセットさ
#	れると、セットされているテンプレートのみを返す。セットされていなけ
#	れば、空を返す。（管理メニュー用）
#[戻り値]
#	成功すればテンプレートのデータを返す。
#	失敗すればcroakする。
#---------------------------------------------------------------------
sub get {
	my($self, $ignore_default_flag) = @_;
	my $lang = $self->{conf}->{"lang"};
	my $f = "$self->{dir}/${lang}_0000_rpy.tpl";
	my $tpl;
	if(-e $f) {
		eval { $tpl = File::Read::read_file($f); };
		if($@) { croak "failed to read ${f} : $@"; }
	} elsif(! $ignore_default_flag) {
		$tpl = $self->get_default();
	} else {
		$tpl = "";
	}
	return $tpl;
}

#---------------------------------------------------------------------
#■ デフォルトテンプレートをゲット
#---------------------------------------------------------------------
#[引数]
#	1.モード（1：簡単モード、2：エキスパートモード）
#[戻り値]
#	成功すればテンプレートのデータを返す。
#	失敗すればcroakする。
#---------------------------------------------------------------------
sub get_default {
	my($self, $mode) = @_;
	my $lang = $self->{conf}->{"lang"};
	#簡単モード用
	my $f = "$self->{default_dir}/${lang}_0000_rpy.tpl";
	unless(-e $f) {
		$f = "$self->{default_dir}/en_0000_rpy.tpl";
	}
	unless(-e $f) {
		$f = "$self->{default_dir}/ja_0000_rpy.tpl";
	}
	unless(-e $f) { croak "not found ${f}"; }
	my $tpl;
	eval { $tpl = File::Read::read_file($f); };
	if($@) { croak "failed to read ${f} : $@"; }
	#エキスパートモード用
	if(defined $mode && $mode eq "2") {
		my $form = $self->mk_mai_form_tpl();
		$tpl =~ s/\%form\%/${form}/;
	}
	#
	return $tpl;
}

sub mk_mai_form_tpl {
	my($self) = @_;
	my $lang = $self->{conf}->{"lang"};
	#フォーム項目データを取得
	my $items = FCC::Class::Mpfmec::Item->new(conf=>$self->{conf})->get();
	#テンプレートファイルをロード
	my $f = "$self->{default_dir}/${lang}_0000_rpy_form.tpl";
	unless(-e $f) {
		$f = "$self->{default_dir}/en_0000_rpy_form.tpl";
	}
	unless(-e $f) {
		$f = "$self->{default_dir}/ja_0000_rpy_form.tpl";
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
		if($type eq "2") {
			#$hash{value} = "\%${name}_secret\%";
			$hash{value} = "\%${name}\%";
		} elsif($type =~ /^(4|5)$/) {
			my $element_loop = '<TMPL_LOOP NAME="element_loop">%element%' . "\n" . '</TMPL_LOOP>';
			$element_loop =~ s|element_loop|${name}_element_loop|s;
			$hash{value} = $element_loop;
		} elsif($type eq "7") {
			$hash{value} = "\%${name}_filename\%";
		} else {
			$hash{value} = "\%${name}\%";
		}
		push(@item_loop, \%hash);
	}
	$t->param("item_loop" => \@item_loop);
	#
	my $template = $t->output();
	$template = $self->unify_return_code($template);
	return $template;
}

sub unify_return_code {
	my($self, $str) = @_;
	$str =~ s/\x0D\x0A|\x0D|\x0A/\n/g;
	return $str;
}

1;
