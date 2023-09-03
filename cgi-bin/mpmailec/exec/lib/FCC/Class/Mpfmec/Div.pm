package FCC::Class::Mpfmec::Div;
$VERSION = 1.00;
use strict;
use warnings;
use base qw(FCC::_Super);
use Carp;
use Data::Serializer;

sub init {
	my($self, %args) = @_;
	$self->{conf} = $args{conf};
	#
	$self->{file} = "$args{conf}->{BASE_DIR}/data/div.cgi";
	#$self->{serializer} = Data::Serializer->new(raw => 1);	#Data::Serializer
	$self->{serializer} = Data::Serializer->new();	#Data::Serializer
	if( ! -e $self->{file} ) {
		eval { $self->{serializer}->store({}, $self->{file}, "w", 0600); };
		if($@) {
			croak "failed to create $self->{file} : $@"; ;
		}
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
		croak "failed to retrieve configuration data from $self->{file}. : $@";
	}
	unless($data) {
		$data = {};
	}
	return $data;
}

#---------------------------------------------------------------------
#■セット
#---------------------------------------------------------------------
#[引数]
#	1.hashref
#		{
#			name => name属性名（必須）,
#			data => {
#				選択要素の値 => {
#					mai_to => Toのアドレス（必須）,
#					mai_cc => Ccのアドレス,
#					mai_bcc => Bccのアドレス
#				},
#				...
#			}
#		}
#[戻り値]
#	成功すれば1を返す。
#	失敗すればcroakする。
#---------------------------------------------------------------------
sub set {
	my($self, $ref) = @_;
	#引数のチェック
	if($ref) {
		if( ref($ref) ne "HASH") {
			croak "the 1st augument must be a hashref.";
		} elsif( ! exists $ref->{name} || $ref->{name} eq "" ) {
			croak "the 1st augument must be a hashref with 'name' attribute.";
		} elsif( ! exists $ref->{data} || ref($ref->{data}) ne "HASH" ) {
			croak "the 1st augument must be a hashref with 'data' attribute which is a hashref.";
		}
	} else {
		croak "auguments are lacking.";
	}
	#新しいデータ格納ファイルを生成
	eval { $self->{serializer}->store($ref, $self->{file}, "w", 0600); };
	if($@) {
		croak "failed to set configuration data. : $@"; ;
	}
	chmod 0600, $self->{file};
	return 1;
}

#---------------------------------------------------------------------
#■セット
#---------------------------------------------------------------------
#[引数]
#	なし
#[戻り値]
#	成功すれば1を返す。
#	失敗すればcroakする。
#---------------------------------------------------------------------
sub clear {
	my($self) = @_;
	eval { $self->{serializer}->store({}, $self->{file}, "w", 0600); };
	if($@) {
		croak "failed to clear configuration data. : $@"; ;
	}
	chmod 0600, $self->{file};
	return 1;
}

1;
