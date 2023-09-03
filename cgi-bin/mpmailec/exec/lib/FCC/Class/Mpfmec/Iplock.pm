package FCC::Class::Mpfmec::Iplock;
$VERSION = 1.00;
use strict;
use warnings;
use base qw(FCC::_Super);
use Carp;
use LockFile::Simple qw(lock unlock);

sub init {
	my($self, %args) = @_;
	$self->{conf} = $args{conf};
	#
	$self->{file} = "$args{conf}->{BASE_DIR}/data/iplock.cgi";
	if( ! -e $self->{file} ) {
		if( open my $fh, ">", $self->{file} ) {
			close($fh);
			chmod 0600, $self->{file};
		} else {
			croak "failed to create $self->{file} : $@"; ;
		}
	}
	#
	$self->{expire} = $self->{conf}->{acl_post_deny_sec};
	if( ! defined $self->{expire} ) {
		$self->{expire} = 0;
	}
	if($self->{expire} =~ /[^\d]/) {
		croak "parameter error. : acl_post_deny_sec";
	}
}

#---------------------------------------------------------------------
#■ ロックデータにIPアドレスを追加
#---------------------------------------------------------------------
#[引数]
#	1.IPアドレス（指定がなければ $ENV{REMOTE_ADDR}を適用）
#[戻り値]
#	ロック中だったら1を返し、未ロックだったら0を返す。
#	処理に失敗するとcroakする。
#---------------------------------------------------------------------
sub append {
	my($self, $ip) = @_;
	my $result = $self->is_locked($ip, 1);
	return $result;
}

#---------------------------------------------------------------------
#■ ロック中かどうかをチェック
#---------------------------------------------------------------------
#[引数]
#	1.IPアドレス（指定がなければ $ENV{REMOTE_ADDR}を適用）
#	2.アップデートフラグ
#[戻り値]
#	ロック中であれば1を、そうでなければ0を返す。
#	処理に失敗するとcroakする。
#	アップデートフラグがセットされ、もしロックされていなければ、該当の
#	IPアドレスをロックデータに追加する。
#---------------------------------------------------------------------
sub is_locked {
	my($self, $ip, $update_flag) = @_;
	if($self->{expire} == 0) { return 0; }
	if( ! defined $ip || $ip eq "" ) {
		$ip = $ENV{REMOTE_ADDR};
	}
	if( $ip !~ /^\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}$/ ) {
		croak "invalid ip address.";
	}
	#ロック中のデータを読み出す
	my $now = time;
	#データファイルをロック
	LockFile::Simple::lock($self->{file}) or croak "can't lock $self->{file} : $!\n";
	#データファイルを読み取る
	my %data;
	open my $fh, "<", $self->{file} or croak "failed to open $self->{file} : $!";
	my $deleted = 0;
	while( my $line = <$fh> ) {
		chomp $line;
		my($addr, $tm) = split(/\t/, $line);
		unless($addr && $tm) { next; }
		if($tm < $now - $self->{expire}) {
			$deleted ++;
			next;
		}
		$data{$addr} = $tm;
	}
	close($fh);
	#ロック中かどうかを評価
	my $result = 0;
	if( $data{$ip} ) {
		$result = 1;
	}
	#
	if($update_flag) {
		#該当のIPアドレスを追加
		unless($data{$ip}) {
			$data{$ip} = $now;
		}
		#データファイルを更新
		if($deleted > 0 || ! $result) {
			open my $fh, ">", $self->{file} or croak "failed to open $self->{file} : $!";
			while( my($k, $v) = each %data ) {
				print $fh "${k}\t${v}\n";
			}
			close($fh);
		}
	}
	#データファイルを解放
	LockFile::Simple::unlock($self->{file});
	#
	return $result;
}

1;
