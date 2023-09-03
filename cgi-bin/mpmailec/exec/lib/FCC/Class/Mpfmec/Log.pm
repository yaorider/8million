package FCC::Class::Mpfmec::Log;
$VERSION = 1.00;
use strict;
use warnings;
use base qw(FCC::_Super);
use Carp;
use Unicode::Japanese;
use Data::Serializer;
use File::Remove;
use FCC::Class::Date::Utils;

#---------------------------------------------------------------------
#■ログのhashref
#---------------------------------------------------------------------
#{
#	info => {
#		SERIAL           => シリアル番号,
#		SEQ              => シーケンス番号,
#		ATTACHMENTS      => 添付ファイルの数,
#		RECEPTION_DATE   => 受付日時を表すepoch秒,
#		RECEPTION_DATE_Y => 受付日時の西暦4桁,
#		RECEPTION_DATE_m => 受付日時の月2桁,
#		RECEPTION_DATE_d => 受付日時の日2桁,
#		RECEPTION_DATE_H => 受付日時の時2桁,
#		RECEPTION_DATE_i => 受付日時の分2桁,
#		RECEPTION_DATE_s => 受付日時の秒2桁,
#		RECEPTION_DATE_e => 受付日時のタイムゾーン識別子 例: Atlantic/Azores,
#		RECEPTION_DATE_i => 受付日時のサマータイム中か否か 1ならサマータイム中。 0ならそうではない。,
#		RECEPTION_DATE_O => 受付日時のグリニッジ標準時 (GMT) との時差 例: +0200
#		HTTP_USER_AGENT  => ユーザーエージェント,
#		REMOTE_HOST      => リモートホスト,
#		REMOTE_ADDR      => IPアドレス
#	},
#	rec => {
#		name属性 => 値,
#		name属性 => [...], # select, checkboxの場合
#		name属性 => {      # fileの場合
#			filename => ファイル名,
#			size => ファイルサイズ(byte),
#			mtype => MIMEタイプ,
#			path => ファイルの保存パス
#		}
#	}
#}
#---------------------------------------------------------------------

sub init {
	my($self, %args) = @_;
	$self->{conf} = $args{conf};
	$self->{items} = $args{items};
	#
	my $dir = $self->{conf}->{log_dir};
	if( ! $dir || ! -d $dir ) {
		croak "the log directory does not exist.";
	}
	#
	if( ! $self->{items} || ref($self->{items}) ne "HASH") {
		croak "the items parameter must be a hashref.";
	}
	#
	$self->{serializer} = Data::Serializer->new();	#Data::Serializer
	#古いログを削除
	$self->clean();
}

#---------------------------------------------------------------------
#■ 古いログを削除
#---------------------------------------------------------------------
#[引数]
#	なし
#[戻り値]
#	削除した日付ディレクトリの数
#	失敗するとcroakする
#---------------------------------------------------------------------
sub clean {
	my($self) = @_;
	my $log_save_days = $self->{conf}->{log_save_days};
	unless( $log_save_days ) {
		$log_save_days = 0;
	}
	#削除対象の日付を特定
	my $epoch = time - 86400 * $log_save_days;
	my @tm = FCC::Class::Date::Utils->new(time=>$epoch, tz=>$self->{conf}->{tz})->get(1);
	my $date = "$tm[0]$tm[1]$tm[2]";
	#削除処理
	my $based = $self->{conf}->{log_dir};
	my @dirs = $self->_readdir($based);
	my @list;
	my $deleted = 0;
	for my $dname (@dirs) {
		if($dname !~ /^\d{8}$/) {next;}
		if($dname lt $date) {
			my $n = File::Remove::remove(\1, "${based}/${dname}");
			$deleted += $n;
		}
	}
	#
	return $deleted;
}

#---------------------------------------------------------------------
#■ ログ詳細を取得
#---------------------------------------------------------------------
#[引数]
#	1.ログの日付(YYYYMMDD)
#	2.シーケンス番号(シリアルのSEQ値)
#[戻り値]
#	成功したら該当のログデータのhashrefを返す。
#	失敗するとcroakする
#---------------------------------------------------------------------
sub get {
	my($self, $date, $seq) = @_;
	my $f = "$self->{conf}->{log_dir}/${date}/${seq}/data.cgi";
	my $rec;
	eval { $rec = $self->{serializer}->retrieve($f); };
	if($@) {
		croak "failed to retrieve log data from ${f}. : $@";
	}
	return $rec;
}

#---------------------------------------------------------------------
#■ ログを削除
#---------------------------------------------------------------------
#[引数]
#	1.ログの日付(YYYYMMDD)
#	2.シーケンス番号(シリアルのSEQ値)
#[戻り値]
#	成功したら削除したディレクトリの数を返す。
#	通常は1を返すが、もし該当のディレクトリがなければ0を返す。
#	失敗するとcroakする
#---------------------------------------------------------------------
sub del {
	my($self, $date, $seq) = @_;
	if( ! defined $date || $date !~ /^\d{8}$/ ) {
		croak "the 1st argument must be YYYYMMDD format.";
	}
	if( ! defined $seq || $seq !~ /^\d+$/ ) {
		croak "the 2nd argument is invalid.";
	}
	my $d = "$self->{conf}->{log_dir}/${date}/${seq}";
	my $deleted = 0;
	if( -d $d ) {
		$deleted = File::Remove::remove(\1, $d);
	}
	return $d;
}

#---------------------------------------------------------------------
#■ ダウンロード用のファイルを指定場所に生成
#	ブラウザーには出力しない。
#---------------------------------------------------------------------
#[引数]
#	1.検索パラメータを格納したhashref
#	{
#		sdate      => 開始日 YYYY-MM-DD,
#		edate      => 終了日 YYYY-MM-DD,
#		path       => ダウンロード用ファイルの出力先(指定がなければ "$self->{conf}->{log_dir}/download.tmp.cgi" ）,
#		names      => ダウンロード対象のカラム名のarrayref（指定がなければすべて）,
#		delimiter  => 区切り文字（1:カンマ(CSV), 2:スペース, 3:タブ(TSV))
#		rc_replace => 改行の扱い(改行を置き換える文字列),
#		charcode   => 文字コード(1:UTF-8, 2:Shift_JIS, 3:EUC-JP),
#		rc         => ダウンロードファイルの改行コード(1:LF, 2:CR, 3:CRLF)
#	}
#[戻り値]
#	ダウンロード用ファイルの出力先
#---------------------------------------------------------------------
sub make_download_file {
	my($self, $param) = @_;
	#ファイル生成
	my $path = $param->{path};
	unless($path) {
		$path = "$self->{conf}->{log_dir}/download.tmp.cgi";
	}
	open my $fh, ">", $path or croak "failed to open $path : $!";
	#その他のパラメータ
	my $log_rc = $param->{rc};
	my $rc = "\x0a";
	if( $log_rc ) {
		if($log_rc eq "1") {
			$rc = "\x0a";
		} elsif($log_rc eq "2") {
			$rc = "\x0d";
		} elsif($log_rc eq "3") {
			$rc = "\x0d\x0a";
		}
	}
	#カラム一覧
	my @all_cols = ('SERIAL', 'RECEPTION_DATE');
	my $items = $self->{items};
	for my $name ( sort { $items->{$a}->{offset} <=> $items->{$b}->{offset} } keys %{$items} ) {
		push(@all_cols, $name);
	}
	push(@all_cols, 'HTTP_USER_AGENT', 'REMOTE_HOST', 'REMOTE_ADDR');
	#対象のカラムを抽出
	my @cols;
	if( $param->{names} && ref($param->{names}) eq "ARRAY" && @{$param->{names}} > 0 ) {
		for my $name (@all_cols) {
			if( my $n = grep(/^\Q${name}\E$/,  @{$param->{names}}) ) {
				push(@cols, $name);
			}
		}
	} else {
		@cols = @all_cols;
	}
	#ログディレクトリ検索
	my @dir_list = $self->_search_log_dirs($param);
	#ヘッダー行生成
	my @hdrs;
	for my $name (@cols) {
		my $cap = $name;
		if($items->{$name} && $items->{$name}->{caption}) {
			$cap = $items->{$name}->{caption};
		}
		push(@hdrs, $cap);
	}
	my $hdr_line = $self->_make_download_line($param, \@hdrs);
	print $fh "${hdr_line}${rc}";
	#レコード行を生成
	my @list;
	for my $dir (@dir_list) {
		my $f = "${dir}/data.cgi";
		my $rec;
		eval { $rec = $self->{serializer}->retrieve($f); };
		if($@) {
			croak "failed to retrieve log data from ${f}. : $@";
		}
		my @rec_cols;
		for my $name (@cols) {
			my $v = $rec->{rec}->{$name};
			if($name =~ /^[A-Z\_\-]+$/) {
				$v = $rec->{info}->{$name};
			}
			if($name eq "RECEPTION_DATE") {
				$v = "$rec->{info}->{RECEPTION_DATE_Y}-$rec->{info}->{RECEPTION_DATE_m}-$rec->{info}->{RECEPTION_DATE_d} $rec->{info}->{RECEPTION_DATE_H}:$rec->{info}->{RECEPTION_DATE_i}:$rec->{info}->{RECEPTION_DATE_s}";
			}
			if( ! defined $v ) { $v = ""; }
			push(@rec_cols, $v);
		}
		my $line = $self->_make_download_line($param, \@rec_cols);
		print $fh "${line}${rc}";
	}
	#
	close($fh);
	return $path;
}

sub _make_download_line {
	my($self, $param, $ary) = @_;
	if( ! defined $ary || ref($ary) ne "ARRAY" ) {
		return "";
	}
	#区切り文字
	my $delim = ",";
	if($param->{delimiter}) {
		if($param->{delimiter} eq "1") {
			$delim = ",";
		} elsif($param->{delimiter} eq "2") {
			$delim = " ";
		} elsif($param->{delimiter} eq "3") {
			$delim = "\t";
		}
	}
	#改行の扱い
	my $rc_replace = $param->{rc_replace};
	if( ! defined $rc_replace ) {
		$rc_replace = "";
	}
	#文字コード
	my $charcode = "utf8";
	if($param->{charcode}) {
		if($param->{charcode} eq "2") {
			$charcode = "sjis";
		} elsif($param->{charcode} eq "3") {
			$charcode = "euc";
		}
	}
	#
	my @vlist;
	for my $v (@{$ary}) {
		if(ref($v) eq "ARRAY") {
			my $str = join(" ", @{$v});
			$v = $str;
		} elsif(ref($v) eq "HASH") {
			if($v->{filename}) {
				$v = $v->{filename};
			} else {
				$v = "";
			}
		}
		#改行を変換
		$v =~ s/\n/${rc_replace}/g;
		#クォート
		$v =~ s/\"/\"\"/g;
		$v = "\"${v}\"";
		#
		push(@vlist, $v);
	}
	my $line = join($delim, @vlist);
	#文字コード変換
	if($charcode ne "utf8") {
		$line = Unicode::Japanese->new($line, "utf8")->conv($charcode);
	}
	#
	return $line;
}


#---------------------------------------------------------------------
#■ ログ一覧を取得
#---------------------------------------------------------------------
#[引数]
#	1.検索パラメータを格納したhashref
#	{
#		sdate  => 開始日 YYYYMMDD,
#		edate  => 終了日 YYYYMMDD,
#		offset => オフセット値,
#		limit  => リミット値
#	}
#[戻り値]
#	検索結果を格納したhashref
#	{
#		list   => 検索対象のログデータを格納したarrayref(新しい順に格納される),
#		hit    => 対象件数,
#		fetch  => 取り出したレコード数,
#		start  => 取り出した開始レコード番号,
#		end    => 取り出した最終レコード番号,
#		sdate  => 開始日 YYYYMMDD,
#		edate  => 終了日 YYYYMMDD,
#		offset => オフセット値,
#		limit  => リミット値(0は制限なしを意味する)
#	}
#---------------------------------------------------------------------
sub get_list {
	my($self, $param) = @_;
	#ログディレクトリ検索
	my @dir_list = $self->_search_log_dirs($param);
	#
	my $res = {};
	$res->{list} = [];
	$res->{sdate} = $param->{sdate};
	$res->{edate} = $param->{edate};
	$res->{offset} = $param->{offset};
	$res->{limit} = $param->{limit};
	#
	my $hit = scalar @dir_list;
	#
	my @target_dir_list;
	if($param->{limit}) {
		@target_dir_list = splice @dir_list, $param->{offset}, $param->{limit};
	} else {
		@target_dir_list = splice @dir_list, $param->{offset};
	}
	#
	my @list;
	for my $dir (@target_dir_list) {
		my $f = "${dir}/data.cgi";
		my $rec;
		eval { $rec = $self->{serializer}->retrieve($f); };
		if($@) {
			croak "failed to retrieve log data from ${f}. : $@";
		}
		push(@list, $rec);
	}
	$res->{list} = \@list;
	$res->{hit} = $hit + 0;
	$res->{fetch} = scalar @list;
	if($hit == 0) {
		$res->{start} = 0;
		$res->{end} = 0;
	} else {
		$res->{start} = $res->{offset} + 1;
		$res->{end} = $res->{offset} + $res->{fetch};
	}
	#トータルのログ数を調べる
	$res->{total} = $self->get_total_num();
	#
	return $res;
}

sub get_total_num() {
	my($self) = @_;
	my $n = 0;
	opendir(DIR, $self->{conf}->{log_dir});
	my @dirs = readdir(DIR);
	closedir(DIR);
	for my $date (@dirs) {
		if($date !~ /^\d{8}$/) { next; }
		my $datedir = "$self->{conf}->{log_dir}/${date}";
		opendir(DATEDIR, $datedir);
		my @seqdirs = readdir(DATEDIR);
		closedir(DATEDIR);
		for my $seq (@seqdirs) {
			if($seq !~ /^\d+$/) { next; }
			$n ++;
		}
	}
	return $n;
}

sub _search_log_dirs {
	my($self, $param) = @_;
	if( ! $param || ref($param) ne "HASH") {
		$param = {};
	}
	my $sdate = $param->{sdate};
	my $edate = $param->{edate};
	my $offset = $param->{offset};
	my $limit = $param->{limit};
	#
	if( $sdate ) {
		if($sdate !~ /^\d{8}$/) {
			croak "the 1st argument must be YYYYMMDD format.";
		}
	} else {
		$sdate = "00000000";
	}
	if( $edate ) {
		if($edate !~ /^\d{8}$/) {
			croak "the 2nd argument must be YYYYMMDD format.";
		}
	} else {
		$edate = "99999999";
	}
	#
	if( ! $offset || $offset !~ /^\d+$/) {
		$offset = 0;
	}
	if( ! $limit || $limit !~ /^\d+$/) {
		$limit = 20;
	}
	#
	my $all_date_list = $self->_get_date_list();
	my @date_list;
	for my $date (@{$all_date_list}) {
		if($date < $sdate) {next;}
		if($date > $edate) {next;}
		push(@date_list, $date);
	}
	my @dir_list;
	unless(@date_list) {
		return @dir_list;
	}
	#
	for my $date ( sort { $b cmp $a } @date_list ) {
		my $dir = "$self->{conf}->{log_dir}/${date}";
		my @dirs = $self->_readdir($dir);
		for my $seq ( sort { $b <=> $a } @dirs ) {
			if($seq !~ /^\d+$/) {next;}
			my $f = "${dir}/${seq}/data.cgi";
			unless( -e $f ) { next; }
			push(@dir_list, "${dir}/${seq}");
		}
	}
	#
	if($sdate eq "00000000") {
		$sdate = "";
	}
	if($edate eq "99999999") {
		$edate = "";
	}
	$param->{sdate} = $sdate;
	$param->{edate} = $edate;
	$param->{offset} = $offset;
	$param->{limit} = $limit;
	#
	return @dir_list;
}

sub _get_date_list {
	my($self) = @_;
	my $based = $self->{conf}->{log_dir};
	my @dirs = $self->_readdir($based);
	my @list;
	for my $d (@dirs) {
		if($d !~ /^\d{8}$/) {next;}
		push(@list, $d);
	}
	return \@list;
}

sub _readdir {
	my($self, $dir) = @_;
	opendir(DIR, $dir) or croak "failed to open ${dir} : $!";
	my @elms = readdir(DIR);
	close(DIR);
	my @files;
	for my $elm (@elms) {
		if($elm =~ /^\.+$/) { next; }
		push(@files, $elm);
	}
	return @files;
}

#---------------------------------------------------------------------
#■ ログの期間を取得
#---------------------------------------------------------------------
#[引数]
#	1.なし
#[戻り値]
#	開始日と終了日をリストで返す。YYYYMMDD形式。
#	失敗すればcroakする。
#---------------------------------------------------------------------
sub get_date_range {
	my($self) = @_;
	my $dir = $self->{conf}->{log_dir};
	my $min = 99999999;
	my $max = 0;
	opendir(DIR, $dir) or croak "failed to open ${dir} : $!";
	my @dirs = readdir(DIR);
	closedir(DIR);
	for my $d (@dirs) {
		if($d !~ /^\d+$/) { next; }
		if($d >= $max) {
			$max = $d;
		}
		if($d <= $min) {
			$min = $d;
		}
	}
	if($min == 99999999 || $max == 0) {
		$max = undef;
		$min = undef;
	}
	return $min, $max;
}


#---------------------------------------------------------------------
#■ 書き込み
#---------------------------------------------------------------------
#[引数]
#	1.ログのメタ情報を格納したhashref
#	2.入力値を格納したhashref
#
#	ログのメタ情報を格納したhashrefの内容は以下の通り。全ての項目は必須。
#	{
#		SERIAL           => シリアル番号,
#		SEQ              => シーケンス番号,
#		ATTACHMENTS      => 添付ファイルの数,
#		RECEPTION_DATE   => 受付日時を表すepoch秒,
#		RECEPTION_DATE_Y => 受付日時の西暦4桁,
#		RECEPTION_DATE_m => 受付日時の月2桁,
#		RECEPTION_DATE_d => 受付日時の日2桁,
#		RECEPTION_DATE_H => 受付日時の時2桁,
#		RECEPTION_DATE_i => 受付日時の分2桁,
#		RECEPTION_DATE_s => 受付日時の秒2桁,
#		RECEPTION_DATE_e => 受付日時のタイムゾーン識別子 例: Atlantic/Azores,
#		RECEPTION_DATE_i => 受付日時のサマータイム中か否か 1ならサマータイム中。 0ならそうではない。,
#		RECEPTION_DATE_O => 受付日時のグリニッジ標準時 (GMT) との時差 例: +0200
#		HTTP_USER_AGENT  => ユーザーエージェント,
#		REMOTE_HOST      => リモートホスト,
#		REMOTE_ADDR      => IPアドレス
#	}
#
#[戻り値]
#	成功すれば1を返す。
#	失敗すればcroakする。
#---------------------------------------------------------------------
sub loging {
	my($self, $info, $rec) = @_;
	if( ! $info || ref($info) ne "HASH" ) {
		croak "the 1st argument must be a hashref.";
	}
	if( ! $rec || ref($rec) ne "HASH" ) {
		croak "the 2nd argument must be a hashref.";
	}
	#ログディレクトリの用意
	my $d = $self->_prepare_target_directory($info);
	#入力値格納ファイル
	my $f = "${d}/data.cgi";
	#入力値をコピー
	my $out = {};
	$out->{info} = {};
	$out->{rec} = {};
	my $attachments = {};
	while( my($name, $ref) = each %{$self->{items}} ) {
		my $v = $rec->{$name};
		if( ! $v ) { next; }
		if($ref->{type} eq "7") {
			if( ref($v) ne "HASH" ) { next; }
			my $path = $v->{path};
			unless( -e $path ) { next; }
			$out->{rec}->{$name} = {
				filename => $v->{filename},
				size => $v->{size},
				mtype => $v->{mtype}
			};
			if($self->{conf}->{log_atc_save}) {
				my $outpath = "${d}/files/${name}.cgi";
				open my $fh_in, "<", $path or croak "faield to copy ${path} to ${outpath} : $!";
				binmode($fh_in);
				open my $fh_out, ">", $outpath or croak "faield to copy ${path} to ${outpath} : $!";
				binmode($fh_out);
				my $chunk;
				while( my $byte = sysread $fh_in, $chunk, 1048576 ) {
					print $fh_out $chunk;
				}
				close($fh_out);
				close($fh_in);
				chmod 0600, $outpath;
				$out->{rec}->{$name}->{path} = $outpath
			}
		} else {
			$out->{rec}->{$name} = $v;
		}
	}
	#メタ情報をコピー
	while( my($k, $v) = each %{$info} ) {
		$out->{info}->{$k} = $v;
	}
	#ロギング
	eval { $self->{serializer}->store($out, $f, "w", 0600); };
	if($@) {
		croak "failed to write a log to ${f} : $@"; ;
	}
	chmod 0600, $f;
	#
	return 1;
}

sub _prepare_target_directory {
	my($self, $meta) = @_;
	my $Y = $meta->{RECEPTION_DATE_Y};
	my $M = $meta->{RECEPTION_DATE_m};
	my $D = $meta->{RECEPTION_DATE_d};
	if( ! $Y || $Y !~ /^\d{4}$/ || ! $M || $M !~ /^\d{2}$/ || ! $D || $D !~ /^\d{2}$/ ) {
		croak "invalid parameters.";
	}
	my $SEQ = $meta->{SEQ};
	if( ! $SEQ || $SEQ !~ /^\d+$/ ) {
		croak "invalid parameters.";
	}
	#
	my $dir = "$self->{conf}->{log_dir}/${Y}${M}${D}";
	$self->_make_directory($dir);
	$dir .= "/${SEQ}";
	$self->_make_directory($dir);
	$self->_make_directory("${dir}/files");
	#
	return $dir;
}

sub _make_directory {
	my($self, $d) = @_;
	unless(-d $d) {
		mkdir $d, 0700 or croak "failed to make a directory \"${d}\". : $!";
		if($self->{conf}->{SUEXEC}) {
			chmod 0700, $d;
		} else {
			chmod 0777, $d;
		}
	}
}

1;
