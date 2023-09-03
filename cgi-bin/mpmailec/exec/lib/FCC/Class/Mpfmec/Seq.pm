package FCC::Class::Mpfmec::Seq;
$VERSION = 1.00;
use strict;
use warnings;
use base qw(FCC::_Super);
use Carp;
use LockFile::Simple;
use FCC::Class::Date::Utils;

sub init {
	my($self, %args) = @_;
	$self->{conf} = $args{conf};
	$self->{time} = $args{time};
	if( ! $self->{time} ) {
		$self->{time} = time;
	}
	#
	$self->{file} = "$args{conf}->{BASE_DIR}/data/seq.cgi";
	if( ! -e $self->{file} ) {
		open my $fh, ">", $self->{file} or croak "failed to create $self->{file} : $!";
		close($fh);
		chmod 0600, $self->{file};
	}
}

#---------------------------------------------------------------------
#■ 現在のシリアルデータを取得
#---------------------------------------------------------------------
#[引数]
#	なし
#[戻り値]
#	成功すればhashrefを返す。
#	失敗すればcroakする。
#
#	hashref = {
#		SEQ  => 累積カウンタ値,
#		SEQY => 当年のカウンタ値,
#		SEQM => 当月のカウンタ値,
#		SEQD => 当日のカウンタ値,
#		Y    => 当年(例：2010),
#		m    => 当月(例：08),
#		d    => 当日(例：31),
#		SERIAL => 受付シリアル番号
#	};
#---------------------------------------------------------------------
sub get {
	my($self) = @_;
	#カウンターファイルからデータを読み出す
	LockFile::Simple::lock($self->{file}) || croak "failed to lock $self->{file} : $!";
	my $data = $self->_get_raw_data();
	LockFile::Simple::unlock($self->{file});
	#
	return $data;
}

#---------------------------------------------------------------------
#■シリアルカウンタをインクリメント
#---------------------------------------------------------------------
#[引数]
#	なし
#[戻り値]
#	成功すればhashrefを返す。
#	失敗すればcroakする。
#
#	{
#		SEQ  => 累積カウンタ値,
#		SEQY => 当年のカウンタ値,
#		SEQM => 当月のカウンタ値,
#		SEQD => 当日のカウンタ値,
#		Y    => 当年(例：2010),
#		m    => 当月(例：08),
#		d    => 当日(例：31),
#		SERIAL => 受付シリアル番号
#	}
#---------------------------------------------------------------------
sub incr {
	my($self) = @_;
	#カウンタファイルをロック
	LockFile::Simple::lock($self->{file}) || croak "failed to lock $self->{file} : $!";
	#現在の値を読み取る
	my $data = $self->_get_raw_data();
	#インクリメント
	#ただし9桁を超えたら1にする
	for my $k ("SEQ", "SEQY", "SEQM", "SEQD") {
		$data->{$k} ++;
		if($data->{$k} > 999999999) {
			$data->{$k} = 1;
		}
	}
	#受付シリアル番号
	$data->{SERIAL} = $self->_mk_serial($data);
	#アップデート
	open my $fh, ">", $self->{file} or croak "failed to open $self->{file} : $!";
	while( my($k, $v) = each %{$data} ) {
		print $fh "${k}\t${v}\n";
	}
	close($fh);
	#カウンタファイルをアンロック
	LockFile::Simple::unlock($self->{file});
	#
	return $data;
}

#---------------------------------------------------------------------
#■シリアルカウンタをリセット
#---------------------------------------------------------------------
#[引数]
#	なし
#[戻り値]
#	成功すればhashrefを返す。
#	失敗すればcroakする。
#
#	{
#		SEQ  => 累積カウンタ値,
#		SEQY => 当年のカウンタ値,
#		SEQM => 当月のカウンタ値,
#		SEQD => 当日のカウンタ値,
#		Y    => 当年(例：2010),
#		m    => 当月(例：08),
#		d    => 当日(例：31),
#		SERIAL => 受付シリアル番号
#	}
#---------------------------------------------------------------------
sub rset {
	my($self) = @_;
	#カウンタファイルをロック
	LockFile::Simple::lock($self->{file}) || croak "failed to lock $self->{file} : $!";
	#現在の値を読み取る
	my $data = $self->_get_raw_data();
	#カウンタを0にする
	$data->{SEQ} = 0;
	$data->{SEQY} = 0;
	$data->{SEQM} = 0;
	$data->{SEQD} = 0;
	#受付シリアル番号
	$data->{SERIAL} = $self->_mk_serial($data);
	#アップデート
	open my $fh, ">", $self->{file} or croak "failed to open $self->{file} : $!";
	while( my($k, $v) = each %{$data} ) {
		print $fh "${k}\t${v}\n";
	}
	close($fh);
	#カウンタファイルをアンロック
	LockFile::Simple::unlock($self->{file});
	#
	return $data;
}

#---------------------------------------------------------------------
# 以下内部関数
#---------------------------------------------------------------------

#---------------------------------------------------------------------
#■ 受付シリアル番号に変換
#---------------------------------------------------------------------
#[引数]
#	シリアルデータを格納したhashref
#	{
#		SEQ => 累積カウンタ値,
#		SEQY => 当年のカウンタ値,
#		SEQM => 当月のカウンタ値,
#		SEQD => 当日のカウンタ値,
#		Y    => 当年(例：2010),
#		m    => 当月(例：08),
#		d    => 当日(例：31)
#	}
#[戻り値]
#	成功すれば受付シリアル番号を返す。
#	失敗すればcroakする。
#
#---------------------------------------------------------------------
sub _mk_serial {
	my($self, $data) = @_;
	#受付シリアル番号の雛形
	my $serial = '%SEQ%';
	if( defined $self->{conf}->{seq_fmt_tpl} && $self->{conf}->{seq_fmt_tpl} ne "" ) {
		$serial = $self->{conf}->{seq_fmt_tpl};
	}
	#雛形を変換
	while( my($k, $v) = each %{$data} ) {
		if($k eq "SERIAL") { next; }
		$serial =~ s/\%${k}\%/${v}/g;
	}
	#桁固定の連番の置換
	$serial =~ s/\%(SEQ|SEQY|SEQM|SEQD)(\d)\%/sprintf("%0${2}d", $data->{$1} % (10**$2))/eg;
	#
	return $serial;
}


#---------------------------------------------------------------------
#■ 現在のシリアルデータを取得
#---------------------------------------------------------------------
#[引数]
#	なし
#[戻り値]
#	成功すればhashrefを返す。
#	失敗すればcroakする。
#
#	hashref = {
#		SEQ => 累積カウンタ値,
#		SEQY => 当年のカウンタ値,
#		SEQM => 当月のカウンタ値,
#		SEQD => 当日のカウンタ値,
#		Y    => 当年(例：2010),
#		m    => 当月(例：08),
#		d    => 当日(例：31),
#		SERIAL => 受付シリアル番号
#	};
#---------------------------------------------------------------------
sub _get_raw_data {
	my($self) = @_;
	#現在の日時
	my @tm = FCC::Class::Date::Utils->new(time=>$self->{time}, tz=>$self->{conf}->{tz})->get(1);
	#
	my $data = {
		SEQ  => 0,
		SEQM => 0,
		SEQY => 0,
		SEQD => 0,
		Y => $tm[0],
		m   => $tm[1],
		d   => $tm[2]
	};
	open my $fh, "<", $self->{file} or croak "failed to open $self->{file} : $!";
	while( my $line = <$fh> ) {
		chomp $line;
		if($line =~ /^([^\t]+)\t([^\t]+)/) {
			$data->{$1} = $2;
		}
	}
	close($fh);
	#記録日時が異なればカウンターをリセット
	if($data->{Y} ne $tm[0]) {
		$data->{SEQY} = 0;
		$data->{SEQM} = 0;
		$data->{SEQD} = 0;
	} elsif($data->{m} ne $tm[1]) {
		$data->{SEQM} = 0;
		$data->{SEQD} = 0;
	} elsif($data->{d} ne $tm[2]) {
		$data->{SEQD} = 0;
	}
	#
	$data->{Y} = $tm[0];
	$data->{m} = $tm[1];
	$data->{d} = $tm[2];
	#受付シリアル番号
	$data->{SERIAL} = $self->_mk_serial($data);
	#
	return $data;
}


1;
