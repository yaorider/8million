package FCC::Class::Syscnf;
$VERSION = 1.00;
use strict;
use warnings;
use base qw(FCC::_Super);
use Carp;
use Data::Serializer;
use FCC::Class::Iprestriction;

sub init {
	my($self, %args) = @_;
	$self->{conf} = $args{conf};
	$self->{file} = "$args{conf}->{BASE_DIR}/data/syscnf.cgi";
	#$self->{serializer} = Data::Serializer->new(raw => 1);	#Data::Serializer
	$self->{serializer} = Data::Serializer->new();	#Data::Serializer
	#
	unless(-e $self->{file}) {
		if( open(F, ">$self->{file}") ) {
			close(F);
		} else {
			croak "failed to make system configuration file \"$self->{file}\". : $@";
		}
	}
	my $cnf;
	eval { $cnf = $self->{serializer}->retrieve($self->{file}); };
	if($@) {
		croak "failed to retrieve system configuration data from $self->{file}. : $@";
	}
	unless( $cnf && ref($cnf) eq "HASH" ) {
		unlink $self->{file};
		eval { $self->{serializer}->store({}, $self->{file}, "w", 0600); };
		if($@) {
			croak "failed to initialize $self->{file}. : $@";
		}
		chmod 0600, $self->{file};
	}
}

#---------------------------------------------------------------------
#■一括セット
#---------------------------------------------------------------------
#[引数]
#	1.設定情報を格納したhashref（必須）
#[戻り値]
#	成功すれば引数に与えたhashrefを返す。
#	失敗すればcroakする。
#---------------------------------------------------------------------
sub set {
	my($self, $ref) = @_;
	#引数チェック
	unless($ref && ref($ref) eq "HASH") { return undef; }
	#現在の設定情報を取得
	my $cnf = $self->get();
	#新しい値をマージ
	while( my($k, $v) = each %{$ref} ) {
		$cnf->{$k} = $v;
	}
	#古いデータ格納ファイルを削除
	unlink $self->{file};
	#新しいデータ格納ファイルを生成
	eval { $self->{serializer}->store($cnf, $self->{file}, "w", 0600); };
	if($@) {
		croak "failed to set system configuration data. : $@"; ;
	}
	chmod 0600, $self->{file};
	#hosts.allowをセット
	if( exists $ref->{hosts_allow} ) {
		FCC::Class::Iprestriction->new(conf=>$self->{conf})->set($ref->{hosts_allow});
	}
	#
	return $ref;
}

#---------------------------------------------------------------------
#■全設定情報を一括取得
#---------------------------------------------------------------------
#[引数]
#	なし
#[戻り値]
#	全設定情報を格納したhashrefを返す。
#	失敗すればcroakする。
#---------------------------------------------------------------------
sub get {
	my($self) = @_;
	my $cnf;
	eval { $cnf = $self->{serializer}->retrieve($self->{file}); };
	if($@) { croak "failed to retrieve system configuration data from $self->{file} : $@"; }
	if($cnf && ref($cnf) eq "HASH") {
		$cnf->{hosts_allow} = FCC::Class::Iprestriction->new(conf=>$self->{conf})->get();
		return $cnf;
	} else {
		croak "failed to retrieve system configuration data. maybe, $self->{file} is broken."; ;
	}
}


1;
