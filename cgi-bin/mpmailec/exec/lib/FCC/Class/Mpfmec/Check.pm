package FCC::Class::Mpfmec::Check;
$VERSION = 1.00;
use strict;
use warnings;
use base qw(FCC::_Super);
use Carp;
use Data::Serializer;
use File::Copy;

sub init {
	my($self, %args) = @_;
	$self->{conf} = $args{conf};
	#
	$self->{file} = "$args{conf}->{BASE_DIR}/data/check.cgi";
	$self->{default_file} = "$args{conf}->{BASE_DIR}/default/check.cgi";
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
#■ 全項目リストをゲット
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
#■ 項目をセット
#---------------------------------------------------------------------
#[引数]
#	1.設定情報を格納したhashref
#[戻り値]
#	成功すれば挿入後の全項目のhashrefを返す。
#	失敗すればcroakする。
#	項目1および項目2の組み合わせが同じものが存在すれば上書きし、そうで
#	なければ、追加する。
#---------------------------------------------------------------------
sub set {
	my($self, $in) = @_;
	#引数のチェック
	if($in) {
		if( ref($in) ne "HASH") {
			croak "the 1st augument must be a hashref.";
		} elsif( ! $in->{item_1} || ! $in->{item_2} ) {
			croak "the 1st augument must be a hashref including item_1 attribute and item_2 attribute.";
		}
	} else {
		croak "auguments are lacking.";
	}
	#設定情報を読み取る
	my $data = $self->get();
	#項目1および項目2が同一のレコードがないかをチェック
	my $new_no;
	my $max_no = 0;
	for my $no ( sort { $a <=> $b } keys %{$data} ) {
		my $n1 = $data->{$no}->{item_1};
		my $n2 = $data->{$no}->{item_2};
		if( ($n1 eq $in->{item_1} && $n2 eq $in->{item_2}) || ($n1 eq $in->{item_2} && $n2 eq $in->{item_1}) ) {
			$new_no = $no;
		}
		$max_no = $no;
	}
	if( ! $new_no ) { $new_no = $max_no + 1; }
	#一括セット
	$data->{$new_no} = $in;
	$self->set_all($data);
	#
	return $data;
}

#---------------------------------------------------------------------
#■ 項目を削除
#---------------------------------------------------------------------
#[引数]
#	1.レコードNo.
#[戻り値]
#	成功すれば削除後の全項目のhashrefを返す。
#	失敗すればcroakする。
#---------------------------------------------------------------------
sub del {
	my($self, $no) = @_;
	#引数のチェック
	if($no eq "") {
		croak "auguments are lacking.";
	} elsif($no =~ /[^\d]/) {
		croak "the 1st augument must be a number.";
	}
	#設定情報を読み取る
	my $data = $self->get();
	#指定のnoの項目がなければcroak
	if( ! exists $data->{$no} ) {
		croak "the specified no is not found.";
	}
	#削除
	delete $data->{$no};
	#一括セット
	$self->set_all($data);
	#
	return $data;
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


1;
