package FCC::Class::Mpfmec::Msg;
$VERSION = 1.00;
use strict;
use warnings;
use base qw(FCC::_Super);
use Carp;
use File::Read;

sub init {
	my($self, %args) = @_;
	$self->{conf} = $args{conf};
	#
	my $lang = $self->{conf}->{lang};
	if( ! defined $lang || $lang !~ /[a-z]{2}/) {
		$lang = "en";
	}
	#
	$self->{file} = "$args{conf}->{BASE_DIR}/data/msg.cgi";
	$self->{default_file} = "$args{conf}->{BASE_DIR}/default/msg/${lang}.cgi";
	unless( -e $self->{default_file} ) {
		$self->{default_file} = "$args{conf}->{BASE_DIR}/default/msg/en.cgi";
	}
	$self->{key_list} = [
		'acl_deny_hosts',
		'acl_post_deny',
		'item_required',
		'item_1_minlength',
		'item_1_maxlength',
		'item_1_deny_emails',
		'item_2_minlength',
		'item_2_maxlength',
		'item_4_minlength',
		'item_4_maxlength',
		'item_5_minlength',
		'item_5_maxlength',
		'item_6_minlength',
		'item_6_maxlength',
		'item_7_allow_exts',
		'item_7_maxsize',
		'atc_max_total_size',
		'restrict_en01',
		'restrict_en02',
		'restrict_en03',
		'restrict_en11',
		'restrict_en12',
		'restrict_en21',
		'restrict_en22',
		'restrict_en31',
		'restrict_en32',
		'restrict_en33',
		'restrict_en34',
		'restrict_en35',
		'restrict_en36',
		'restrict_en41',
		'restrict_en42',
		'restrict_ja01',
		'restrict_ja02',
		'restrict_ja03',
		'restrict_ja04',
		'restrict_ja05',
		'chk_mismatched'
	];
	#

}

#---------------------------------------------------------------------
#■メッセージ識別キーのリストをゲット
#---------------------------------------------------------------------
#[引数]
#	なし
#[戻り値]
#	成功すればメッセージ識別キーのarrayrefを返す。
#---------------------------------------------------------------------
sub get_key_list {
	my($self) = @_;
	my @list = @{$self->{key_list}};
	return \@list;
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
	#ファイルのパス
	my $f = $self->{file};
	#古いファイルを削除
	unlink $f;
	#新たに生成
	open my $fh, ">", $f or croak "failed to create \"${f}\". : $!";
	for my $key (@{$self->{key_list}}) {
		my $v = $ref->{$key};
		$v =~ s/[\r\n]//g;
		print $fh "${key}\t${v}\n";
	}
	close($fh);
	chmod 0600, $f;
	return 1;
}

#---------------------------------------------------------------------
#■一括ゲット
#---------------------------------------------------------------------
#[引数]
#	なし
#[戻り値]
#	全メッセージのhashref
#	失敗すればcroakする。
#---------------------------------------------------------------------
sub get_all {
	my($self) = @_;
	#デフォルトデータを読み取る
	open my $fh, "<", $self->{default_file} or croak "failed to open \"$self->{default_file}\". : $!";
	my %defaults;
	for my $key (@{$self->{key_list}}) {
		$defaults{$key} = "";
	}
	while( my $line = <$fh> ) {
		chomp $line;
		if($line =~ /^([^\t]+)\t+(.+)/) {
			my $k = $1;
			my $v = $2;
			if( exists $defaults{$k} ) {
				$defaults{$k} = $v;
			}
		}
	}
	close($fh);
	#設定データを読み取る
	if(-e $self->{file}) {
		open my $fh, "<", $self->{file} or croak "failed to open \"$self->{file}\". : $!";
		my %msgs;
		while( my $line = <$fh> ) {
			chomp $line;
			if($line =~ /^([^\t]+)\t+(.+)/) {
				$msgs{$1} = $2;
			}
		}
		close($fh);
		for my $key (@{$self->{key_list}}) {
			if( ! exists $msgs{$key} || $msgs{$key} eq "") {
				$msgs{$key} = $defaults{$key};
			}
		}
		return \%msgs;
	} else {
		return \%defaults;
	}
}

1;
