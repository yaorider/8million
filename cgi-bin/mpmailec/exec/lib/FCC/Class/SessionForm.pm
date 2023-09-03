package FCC::Class::SessionForm;
################################################################################
# Copyright(C) futomi 2008
# http://www.futomi.com/
###############################################################################
$VERSION = 1.00;
use strict;
use warnings;
use Carp;
use Digest::MD5;
use File::Remove;
use Data::Serializer;
use Data::Random::String;
use MIME::Types;
use CGI::Cookie;
use FCC::Class::Image::Thumbnail;
use FCC::Class::String::Checker;

sub new {
	my($caller, %args) = @_;
	my $class = ref($caller) || $caller;
	my $self = {};
	#引数
	$self->{conf} = $args{conf};
	$self->{expire} = $args{expire};	#セッション有効期間（秒）
	$self->{q} = $args{q};	#CGI.pmのインスタンス
	#
	$self->{error}  = undef;	#エラーメッセージ
	#$self->{serializer} = Data::Serializer->new(raw => 1);	#Data::Serializer
	$self->{serializer} = Data::Serializer->new();	#Data::Serializer
	$self->{data} = undef;	#セッション格納用オブジェクト
	$self->{sid} = undef;	#セッションID
	#セッションディレクトリのチェック
	my $session_dir = "$args{conf}->{BASE_DIR}/data/session";
	unless(-d $session_dir) {
		mkdir($session_dir, 0777) or croak "failed to make directory '${session_dir}'. : $!";
		if($args{conf}->{SUEXEC}) {
			chmod 0700, $session_dir;
		} else {
			chmod 0777, $session_dir;
		}
	}
	$self->{directory} = "${session_dir}/Form";
	unless(-d $self->{directory}) {
		mkdir "$self->{directory}", 0700 or croak "failed to make directory '$self->{directory}'. : $!";
		if($args{conf}->{SUEXEC}) {
			chmod 0700, $self->{directory};
		} else {
			chmod 0777, $self->{directory};
		}
	}
	#セッションファイル削除までの有効期限（秒）のチェック
	if( ! $self->{expire} || $self->{expire} =~ /[^\d]/) {
		$self->{expire} = 3600; # 1時間
	}
	#
	bless $self, $class;
	return $self;
}

sub error {
	my($self) = @_;
	return $self->{error};
}

#---------------------------------------------------------------------
#■pidを振り直してセッションを保存する
#---------------------------------------------------------------------
#[引数]
#	なし
#[戻り値]
#	振り直したpid
#---------------------------------------------------------------------
sub renew_pid {
	my($self) = @_;
	my $pid = $self->generate_sid();
	$self->{data}->{pid} = $pid;
	$self->update( { pid => $pid } );
	return $pid;
}

#---------------------------------------------------------------------
#■テンポラリーファイル格納ディレクトリパスを返す
#---------------------------------------------------------------------
#[引数]
#	なし
#[戻り値]
#	ディレクトリパス
#---------------------------------------------------------------------
sub get_tmp_dir {
	my($self) = @_;
	return "$self->{directory}/$self->{sid}/tmp";
}

#---------------------------------------------------------------------
#■クライアントからセッション情報を取得
#---------------------------------------------------------------------
#[引数]
#	なし
#[戻り値]
#	1.セッションキー。セッションがなければundefを返す。
#	2.Cookieフラグ（Cookieから取得した場合に1がセットされる。）
#
#	セッションキーは、Cookieの情報を優先する。もしCookieにセッション
#	キーがなければ、GETパラメータから取得する。
#---------------------------------------------------------------------
sub get_sid_from_client {
	my($self) = @_;
	my $sid;
	#Cookieから取得
	my %cookies = fetch CGI::Cookie;
	if( $cookies{'sid'} && $cookies{'sid'}->value ) {
		$sid = $cookies{'sid'}->value;
		if($sid =~ /^[a-fA-F0-9]{32}$/) {
			return $sid, 1;
		}
	}
	#GETパラメータから取得
	unless($sid) {
    	$sid = $self->{q}->param('sid');
		if($sid && $sid =~ /^[a-fA-F0-9]{32}$/) {
			return $sid, 0;
		}
	}
	#
	return undef;
}

#---------------------------------------------------------------------
#■セッションIDを生成
#---------------------------------------------------------------------
#[引数]
#	なし
#[戻り値]
#	セッションキー
#---------------------------------------------------------------------
sub generate_sid {
	my($self) = @_;
	for( my $i=0; $i<10; $i++ ) {
		my $seed = $ENV{REMOTE_ADDR} . $ENV{REMOTE_PORT} . $ENV{HTTP_USER_AGENT} . Data::Random::String->create_random_string(length=>'32', contains=>'alphanumeric') . time;
		my $sid = Digest::MD5::md5_hex(Digest::MD5::md5_hex($seed));
		unless(-d "$self->{directory}/${sid}") {
			return $sid;
		}
	}
	croak "failed to generate sid.";
}

#---------------------------------------------------------------------
#■セッション削除
#---------------------------------------------------------------------
#[引数]
#	なし
#[戻り値]
#	成功すればセッションを削除し1を返す。
#	失敗すればundefを返す。失敗理由は $self->{error} にセットされる。
#---------------------------------------------------------------------
sub remove {
	my($self) = @_;
	#セッションファイルのお掃除
	$self->_sweep();
	#
	if( ! $self->{sid} || ! -d "$self->{directory}/$self->{sid}" ) {
		$self->{error} =  "no session.";
		return undef;
	}
	my $d = "$self->{directory}/$self->{sid}";
	my $deleted = File::Remove::remove(\1, $d);
	unless($deleted) {
		$self->{error} =  "no session or faield to delete a session directory.";
		return undef;
	}
	return $deleted;
}

#---------------------------------------------------------------------
#■セッションデータ更新
#---------------------------------------------------------------------
#[引数]
#	1.セッションデータに追加もしくは変更したい値を格納したハッシュリフ
#	ァレンス。キーの先頭に_を加えると、該当のデータを削除することがで
#	きる。
#[戻り値]
#	成功すれば更新後のセッションデータを格納したハッシュリファレンスを返す。
#	失敗すればundefを返す。失敗理由は $self->{error} にセットされる。
#---------------------------------------------------------------------
sub update {
	my($self, $in) = @_;
	if( ! $self->{sid} || ! -d "$self->{directory}/$self->{sid}" ) {
		$self->{error} =  "no session.";
		return undef;
	}
	my $f = "$self->{directory}/$self->{sid}/data.cgi";
	my $data = $self->{serializer}->retrieve($f);
	unless($data) {
		$self->{error} = "System Error. Can't open ${f} : $!";
		return undef;
	}
	while( my($k, $v) = each %{$in} ) {
		if($k =~ /^_(.+)/) {
			delete $self->{data}->{$1};
		} else {
			$self->{data}->{$k} = $v;
		}
	}
	my $epoch = time;
	$self->{data}->{_mtime} = $epoch;
	unlink $f;	# 更新のためにData::Serializerのstoreメソッドを使うと壊れる。そのため、事前にファイルを削除
	$self->{serializer}->store($self->{data}, $f);
	return $self->{data};
}

#---------------------------------------------------------------------
#■セッション生成
#---------------------------------------------------------------------
#[引数]
#	1.セッションデータに追加したい値を格納したハッシュリファレンス
#		※ハッシュキーの先頭が_であれば無視される。
#[戻り値]
#	成功すればセッションIDを返す。
#	失敗すればundefを返す。失敗理由は $self->{error} にセットされる。
#---------------------------------------------------------------------
sub create {
	my($self, $in) = @_;
	#セッションファイルのお掃除
	$self->_sweep();
	#
	for( my $i=0; $i<10; $i++ ) {
		#セッションID生成
		my $sid = $self->generate_sid();
		#プロセスID生成
		my $pid = $self->generate_sid();
		#セッションディレクトリ作成
		my $d = "$self->{directory}/${sid}";
		if(-d $d) { next; }
		mkdir $d, 0777 or croak "failed to make directory '${d}'. : $!";
		if($self->{conf}->{SUEXEC}) {
			chmod 0700, $d;
		} else {
			chmod 0777, $d;
		}
		#添付ファイル格納用ディレクトリ生成
		my $atcd = "${d}/files";
		mkdir $atcd, 0777 or croak "failed to make directory '${atcd}'. : $!";
		if($self->{conf}->{SUEXEC}) {
			chmod 0700, $atcd;
		} else {
			chmod 0777, $atcd;
		}
		#サムネイル格納用ディレクトリ生成
		my $thumbd = "${d}/thumbs";
		mkdir $thumbd, 0777 or croak "failed to make directory '${thumbd}'. : $!";
		if($self->{conf}->{SUEXEC}) {
			chmod 0700, $thumbd;
		} else {
			chmod 0777, $thumbd;
		}
		#テンポラリーファイル格納用ディレクトリ生成
		my $tmpd = "${d}/tmp";
		mkdir $tmpd, 0777 or croak "failed to make directory '${tmpd}'. : $!";
		if($self->{conf}->{SUEXEC}) {
			chmod 0700, $tmpd;
		} else {
			chmod 0777, $tmpd;
		}
		#セッションデータファイルを生成
		my $f = "${d}/data.cgi";
		my $epoch = time;
		my $data = {};
		$data->{_mtime} = $epoch;
		$data->{_ctime} = $epoch;
		$data->{_sid} = $sid;
		if($in) {
			while( my($k, $v) = each %{$in} ) {
				$data->{$k} = $v;
			}
		}
		$data->{sid} = $sid;
		$data->{pid} = $pid;
		#
		$self->{data} = {};
		while( my($k, $v) = each %{$data} ) {
			$self->{data}->{$k} = $v;
		}
		$self->{serializer}->store($self->{data}, $f);
		$self->{sid} = $sid;
		return $sid;
	}
	$self->{error} = "Failed to generate a session id. Try again. : $!";
	return undef;
}

#---------------------------------------------------------------------
#■セッション認証
#---------------------------------------------------------------------
#セッションIDを与えると、それに該当するセッションファイルの存在、セッ
#ションタイムアウトをチェックし、認証結果を返す。
#第2引数にハッシュリファレンスを与えると、セッションIDだけではなく、
#その他の値をセッションデータと比較する処理を追加することができる。
#[引数]
#	1.セッションID。
#	2.認証に使いたいデータを格納したハッシュリファレンス
#[戻り値]
#	認証に成功すればセッションデータのハッシュリファレンスを返す
#	認証に失敗すればundefを返す。失敗理由は $self->{error} にセットされる。
#---------------------------------------------------------------------
sub auth {
	my($self, $sid, $in) = @_;
	if( ! $sid || $sid !~ /^[a-zA-Z0-9]{32}$/ ) {
		$self->{error} = "invalid sid";
		return undef;
	}
	if( ! -d "$self->{directory}/${sid}" ) {
		$self->{error} = "You've already logoffed.  : $!";
		return undef;
	}
	$self->{sid} = $sid;
	my $f = "$self->{directory}/${sid}/data.cgi";
	unless(-e $f) {
		$self->remove();
		$self->{error} = "You've already logoffed.  : $!";
		return undef;
	}
	my $data = $self->{serializer}->retrieve($f);
	unless($data && ref $data) {
		$self->remove();
		unlink $f;
		$self->{error} = "System Error. Can't open ${f} : $!";
		return undef;
	}
	my $epoch = time;
	if($epoch - $data->{_mtime} > $self->{expire}) {
		$self->remove();
		$self->{error} = "Session Expired. Logon again.";
		return undef;
	}
	if($in) {
		while( my($k, $v) = each %{$in} ) {
			$data->{$k} = $v;
		}
	}
	$data->{_mtime} = $epoch;
	while( my($k, $v) = each %{$data} ) {
		$self->{data}->{$k} = $v;
	}
	unlink $f;	# 更新のためにData::Serializerのstoreメソッドを使うと壊れる。そのため、事前にファイルを削除
	$self->{serializer}->store($self->{data}, $f);
	#
	$self->{sid} = $sid;
	return $self->{data};
}

#---------------------------------------------------------------------
#■フォームから投稿された添付ファイルを保存
#---------------------------------------------------------------------
#[引数]
#	1.name属性
#[戻り値]
#	成功すれば、保存したファイルのメタ情報を格納したhashrefを返す。
#	{
#		name         => name属性,
#		filename     => ファイル名
#		size         => サイズ(byte),
#		mtype        => MIMEタイプ,
#		path         => ファイル格納パス,
#		thumb        => サムネイル生成フラグ（0:未生成、1:生成済み)
#		thumb_path   => サムネイルのパス（サムネイル生成時のみ）,
#		thumb_mtype  => サムネイルのMIMEタイプ（サムネイル生成時のみ）,
#		thumb_size   => サムネイルのファイルサイズ（サムネイル生成時のみ）,
#		thumb_width  => サムネイルの横幅（サムネイル生成時のみ）,
#		thumb_height => サムネイルの縦幅（サムネイル生成時のみ）,
#		width        => もとの画像の横幅（サムネイル生成時のみ）,
#		height       => もとの画像の縦幅（サムネイル生成時のみ）
#	}
#	失敗すればundefを返す。失敗理由は $self->{error} にセットされる。
#---------------------------------------------------------------------
sub save_file {
	my($self, $name) = @_;
	if( ! $self->{sid} || ! -d "$self->{directory}/$self->{sid}" ) {
		$self->{error} =  "no session.";
		return undef;
	}
	#ファイル保存ディレクトリ
	my $atcd = "$self->{directory}/$self->{sid}/files";
	if( ! -d $atcd ) {
		$self->{error} =  "${atcd} is not found.";
		return undef;
	}
	#ファイル名
	my $atc_file = $self->{q}->param($name);
	my $filename;
	if( $atc_file ) {
		($filename) = $atc_file =~ m/([^\/\\]+)$/;
		if( ! defined $filename || $filename eq "" ) {
			$filename = "unknown";
		}
	} else {
		$self->{error} =  "no file.";
		return undef;
	}
	#ファイル名の長さをチェック
	my $filename_len = FCC::Class::String::Checker->new($filename, "utf8")->get_char_num();
	my $filename_max_len = 50;
	if($filename_len > $filename_max_len) {
		my @parts = split(/\./, $filename);
		my $ext = pop @parts;
		$filename = join(".", @parts);
		if($ext =~ /[^a-zA-Z0-9]/) {
			$filename .= ".${ext}";
		}
		my $ext_len = length $ext;
		my $allow_len = $filename_max_len - $ext_len;
		$filename = FCC::Class::String::Conv($filename, "utf8")->truncate_chars(0, $allow_len);
		$filename .= $ext;
	}
	#添付ファイルのファイルハンドル
	my $fh = $self->{q}->upload($name);
	unless($fh) {
		$self->{error} =  "failed to get a file handle.";
		return undef;
	}
	#ファイルハンドルからファイルを保存する
	my $f = "${atcd}/${name}.cgi";
	open my $fh2, ">", $f or croak "failed to open ${f}. : $!";
	binmode($fh2);
	my $len = 102400;
	my $chunk;
	while( my $byte = sysread($fh, $chunk, $len) ) {
		print $fh2 $chunk;
	}
	close($fh2);
	chmod 0600, $f;
	#ファイルのMIMEタイプ
	my $mtype = MIME::Types->new()->mimeTypeOf($filename);
	#メタ情報を生成
	my $meta = {};
	$meta->{name} = $name;
	$meta->{filename} = $filename;
	$meta->{size} = -s $f;
	$meta->{mtype} = $mtype;
	$meta->{path} = $f;
	$meta->{thumb} = 0;
	#サムネイル
	if( defined $mtype && $mtype =~ /^image/ && $self->{conf}->{atc_thumb_show} ) {
		my $thumbd = "$self->{directory}/$self->{sid}/thumbs";
		if( ! -d $thumbd ) {
			$self->{error} =  "${thumbd} is not found.";
			return undef;
		}
		my $thumb = new FCC::Class::Image::Thumbnail();
		$meta->{thumb_path} = "${thumbd}/${name}.cgi";
		my $thumb_meta = $thumb->make(
			in_file      => $f,
			out_file     => $meta->{thumb_path},
			frame_width  => $self->{conf}->{atc_thumb_w},
			frame_height => $self->{conf}->{atc_thumb_h},
			out_format   => $self->{conf}->{atc_thumb_format},
			quality      => 100,
			module       => $self->{conf}->{atc_thumb_module}
		);
		if( my $err = $thumb->error() ) {
			unlink $meta->{thumb_path};
			delete $meta->{thumb_path};
		} else {
			$meta->{thumb} = 1;
			$meta->{thumb_mtype} = $thumb_meta->{out_mtype};
			$meta->{thumb_size} = $thumb_meta->{out_size};
			$meta->{thumb_width} = $thumb_meta->{out_width};
			$meta->{thumb_height} = $thumb_meta->{out_height};
			$meta->{width} = $thumb_meta->{in_width};
			$meta->{height} = $thumb_meta->{in_height};
			chmod 0600, $meta->{thumb_path};
		}
	}
	#
	return $meta;
}

#---------------------------------------------------------------------
#■添付ファイルを削除
#---------------------------------------------------------------------
#[引数]
#	1.name属性
#[戻り値]
#	成功すれば、削除したファイルのメタ情報を格納したhashrefを返す。
#	{
#		name => name属性,
#		size => ファイルサイズ,
#		mtype => MIMEタイプ,
#		path  => ファイル格納パス
#	}
#	失敗すればundefを返す。失敗理由は $self->{error} にセットされる。
#---------------------------------------------------------------------
sub remove_file {
	my($self, $name) = @_;
	if( ! $self->{sid} || ! -d "$self->{directory}/$self->{sid}" ) {
		$self->{error} =  "no session.";
		return undef;
	}
	#ファイル保存ディレクトリ
	my $atcd = "$self->{directory}/$self->{sid}/files";
	if( ! -d $atcd ) {
		$self->{error} =  "${atcd} is not found.";
		return undef;
	}
	#ファイルパス
	my $f = "${atcd}/${name}.cgi";
	unless( -e $f ) {
		$self->{error} = "${f} is not found.";
		return undef;
	}
	#メタ情報を生成
	my $meta = {};
	$meta->{name} = $name;
	$meta->{size} = -s $f;
	$meta->{mtype} = MIME::Types->new()->mimeTypeOf($name);;
	$meta->{path} = $f;
	#ファイルを削除
	unless( unlink $f ) {
		$self->{error} = "failed to delete ${f}. : $!";
		return undef;
	}
	#サムネイルを削除
	my $thumbf = "$self->{directory}/$self->{sid}/thumbs/${name}.cgi";
	if( -e $thumbf ) {
		unless( unlink $thumbf ) {
			$self->{error} = "failed to delete ${thumbf}. : $!";
			return undef;
		}
	}
	#
	return $meta;
}

#---------------------------------------------------------------------
#■セッションディレクトリのお掃除
#---------------------------------------------------------------------
sub _sweep {
	my($self) = @_;
	opendir(DIR, "$self->{directory}");
	my @files = readdir(DIR);
	closedir(DIR);
	my $now = time;
	my $deleted = 0;
	for my $dname (@files) {
		if($dname !~ /^[a-fA-F0-9]{32}$/) { next; }
		my $d = "$self->{directory}/${dname}";
		unless( -d $d ) { next; }
		my $mtime = (stat($d))[9];
		if($now - $mtime > $self->{expire}) {
			my $n = File::Remove::remove(\1, $d);
			$deleted += $n;
		}
	}
	return $deleted;
}

1;
