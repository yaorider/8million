package FCC::Class::Mpfmec::Dump;
$VERSION = 1.00;
use strict;
use warnings;
use base qw(FCC::_Super);
use Carp;
use Data::Dumper;
use MIME::Base64::Perl;
use FCC::Class::Mpfmec::Item;
use FCC::Class::Mpfmec::Msg;
use FCC::Class::Mpfmec::Check;
use FCC::Class::Mpfmec::Div;
use FCC::Class::Mpfmec::Tpl;
use FCC::Class::Mpfmec::TplRpy;
use FCC::Class::Syscnf;

sub init {
	my($self, %args) = @_;
	$self->{conf} = $args{conf};

}

#---------------------------------------------------------------------
#■ 設定エクスポート
#---------------------------------------------------------------------
#[引数]
#	なし
#[戻り値]
#	設定情報を格納したhashrefのDUMPデータ
#---------------------------------------------------------------------
sub serialize {
	my($self) = @_;
	my $h = {};
	$h->{product} = {
		name => $self->{conf}->{product_name},
		version => $self->{conf}->{product_version}
	};
	#システム設定
	$h->{syscnf} = FCC::Class::Syscnf->new(conf=>$self->{conf})->get();
	while( my($k, $v) = each %{$h->{syscnf}} ) {
		if($k =~ /^(log_|static_url|sendmail_path|smtp_)/) {
			delete $h->{syscnf}->{$k};
		}
	}
	#項目設定
	$h->{item} = FCC::Class::Mpfmec::Item->new(conf=>$self->{conf})->get();
	#メッセージ設定
	$h->{msg} = FCC::Class::Mpfmec::Msg->new(conf=>$self->{conf})->get_all();
	#再入力チェック設定
	$h->{check} = FCC::Class::Mpfmec::Check->new(conf=>$self->{conf})->get();
	#振り分け設定
	$h->{div} = FCC::Class::Mpfmec::Div->new(conf=>$self->{conf})->get();
	#テンプレート
	$h->{tpl} = FCC::Class::Mpfmec::Tpl->new(conf=>$self->{conf})->export_data();
	#自動返信の添付ファイル
	my $rpy_atc_file_list = FCC::Class::Mpfmec::TplRpy->new(conf=>$self->{conf})->get_atc_file_list();
	if(@{$rpy_atc_file_list}) {
		$h->{rpy_atc_files} = {};
		for my $ref (@{$rpy_atc_file_list}) {
			my $fname = $ref->{name};
			my $path = $ref->{path};
			my $data;
			eval { $data = File::Read::read_file($path); };
			if($@) { croak "failed to read ${path} : $@"; }
			$h->{rpy_atc_files}->{$fname} = MIME::Base64::Perl::encode_base64($data);
			undef $data;
		}
	}
	#ダンプ
    my $d = Data::Dumper->new([$h]);
	#$d->Indent(1)->Purity(1)->Terse(1)->Sortkeys(1);
	$d->Indent(1)->Purity(1)->Terse(1);
	return $d->Dump();
}

#---------------------------------------------------------------------
#■ 設定インポート
#---------------------------------------------------------------------
#[引数]
#	DUMPデータ
#[戻り値]
#	なし
#---------------------------------------------------------------------
sub deserialize {
	my($self, $serialized) = @_;
    my $h = eval $serialized;
	if($@) {
		croak "failed to deserialize the specified data. : $@";
	}
	if(ref($h) ne "HASH") {
		croak "invalid format.";
	}
	#システム設定
	if($h->{syscnf} && ref($h->{syscnf}) eq "HASH") {
		while( my($k, $v) = each %{$h->{syscnf}} ) {
			if($k =~ /^(log_|static_url|sendmail_path|smtp_)/) {
				delete $h->{syscnf}->{$k};
			}
		}
		if( my $n = scalar keys %{$h->{syscnf}} ) {
			FCC::Class::Syscnf->new(conf=>$self->{conf})->set($h->{syscnf});
		}
	}
	#項目設定
	if($h->{item} && ref($h->{item}) eq "HASH") {
		if( my $n = scalar keys %{$h->{item}} ) {
			FCC::Class::Mpfmec::Item->new(conf=>$self->{conf})->set_all($h->{item});
		}
	}
	#メッセージ設定
	if($h->{msg} && ref($h->{msg}) eq "HASH") {
		if( my $n = scalar keys %{$h->{msg}} ) {
			FCC::Class::Mpfmec::Msg->new(conf=>$self->{conf})->set_all($h->{msg});
		}
	}
	#再入力チェック設定
	if($h->{check} && ref($h->{check}) eq "HASH") {
		if( my $n = scalar keys %{$h->{check}} ) {
			FCC::Class::Mpfmec::Check->new(conf=>$self->{conf})->set_all($h->{check});
		}
	}
	#振り分け設定
	if($h->{div} && ref($h->{div}) eq "HASH") {
		if( my $n = scalar keys %{$h->{div}} ) {
			FCC::Class::Mpfmec::Div->new(conf=>$self->{conf})->set($h->{div});
		}
	}
	#テンプレート
	if($h->{tpl} && ref($h->{tpl}) eq "HASH") {
		if( my $n = scalar keys %{$h->{tpl}} ) {
			FCC::Class::Mpfmec::Tpl->new(conf=>$self->{conf})->import_data($h->{tpl});
		}
	}
	#自動返信の添付ファイル
	if($h->{rpy_atc_files}) {
		my $orpy = new FCC::Class::Mpfmec::TplRpy(conf=>$self->{conf});
		while( my($fname, $base64) = each %{$h->{rpy_atc_files}} ) {
			my $data = MIME::Base64::Perl::decode_base64($base64);
			$orpy->ad_atc_file($fname, $data);
		}
	}
}

1;
