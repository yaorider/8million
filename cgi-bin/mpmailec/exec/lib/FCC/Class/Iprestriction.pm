package FCC::Class::Iprestriction;
$VERSION = 1.00;
use strict;
use warnings;
use base qw(FCC::_Super);
use Carp;
use Net::Netmask;

sub init {
	my($self, %args) = @_;
	$self->{conf} = $args{conf};
	$self->{file} = "$args{conf}->{BASE_DIR}/data/hosts.allow.cgi";
}

#---------------------------------------------------------------------
#■IPアドレスがhosts.allowに一致するかどうかをチェック
#---------------------------------------------------------------------
#[引数]
#	1.IPアドレス（必須）
#[戻り値]
#	成功すれば結果を返す。一致すれば1を、一致しなければ0を返す。
#	失敗すればcroakする。
#---------------------------------------------------------------------
sub match {
	my($self, $ip) = @_;
	my $str;
	if($self->{conf}->{hosts_allow}) {
		$str = $self->{conf}->{hosts_allow};
	} elsif( -e $self->{file} ) {
		open(F, "$self->{file}") or croak "failed to open $self->{file}. : $!";
		while(<F>) {
			$str .= $_;
		}
		close(F);
	}
	if($str) {
		my @blocks = split(/\n+/, $str);
		for my $block (@blocks) {
			my $nm = new2 Net::Netmask($block);
			if($nm &&  Net::Netmask->new($block)->match($ip)) {
				return 1;
			}
		}
		return 0;
	} else {
		return 1;
	}
}

#---------------------------------------------------------------------
#■hosts.allowをセット
#---------------------------------------------------------------------
#[引数]
#	1.hosts.allowのデータ（必須）
#[戻り値]
#	成功すれば引数の値を返す
#	失敗すればcroakする。
#---------------------------------------------------------------------
sub set {
	my($self, $str) = @_;
	if($str) {
		open(F, ">$self->{file}") or croak "failed to open $self->{file}. : $!";
		print F $str;
		close(F);
		chmod 0600, $self->{file};
	} else {
		if( -e $self->{file} ) {
			unlink $self->{file} or croak "failed to delete $self->{file}. : $!";
		}
	}
	return $str;
}

#---------------------------------------------------------------------
#■hosts.allowを読み取る
#---------------------------------------------------------------------
#[引数]
#	なし
#[戻り値]
#	成功すればhosts.allowの内容を返す
#	失敗すればcroakする。
#---------------------------------------------------------------------
sub get {
	my($self) = @_;
	unless( -e $self->{file} ) { return ""; }
	my $str;
	open(F, "$self->{file}") or croak "failed to open $self->{file}. : $!";
	while( <F> ) {
		$str .= $_;
	}
	close(F);
	return $str;
}

1;
