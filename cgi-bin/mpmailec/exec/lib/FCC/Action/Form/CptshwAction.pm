package FCC::Action::Form::CptshwAction;
$VERSION = 1.00;
use strict;
use warnings;
use base qw(FCC::Action::Form::_SuperAction);
use FCC::Class::Mpfmec::Iplock;
use CGI::Utils;

sub dispatch {
	my($self) = @_;
	my $context = {};
	#プロセスセッション
	my $sid = $self->{session}->{sid};
	my $proc = $self->{session}->{data}->{proc};
	#A8FLY
	my $a8fly = {};
	if($self->{conf}->{a8f_enable}) {
		$a8fly->{a8f_enable} = 1;
		#シリアル
		my $a8fly_so = CGI::Utils->new()->urlEncode($proc->{serial}->{SERIAL});
		#プログラムID
		my $a8fly_pid = $self->{conf}->{a8f_pid};
		#商品情報
		my $a8fly_item_price = $self->{conf}->{a8f_item_price};
		my $a8fly_item_code = CGI::Utils->new()->urlEncode($self->{conf}->{a8f_item_code});
		my $a8fly_item_num = 0;
		if($self->{conf}->{a8f_type} eq '1') {	#売上型
			$a8fly_item_num = $self->{conf}->{a8f_item_num};
		} elsif($self->{conf}->{a8f_type} eq '2') {	#申込型
			$a8fly_item_num = 1;
		}
		my $a8fly_item_price_sum = $a8fly_item_price * $a8fly_item_num;
		#タグ生成、置換
		my $a8fly_url = "$self->{conf}->{a8f_url}?pid=${a8fly_pid}&amp;so=${a8fly_so}&amp;si=${a8fly_item_price}.${a8fly_item_num}.${a8fly_item_price_sum}.${a8fly_item_code}";
		my $a8tag = "<img src=\"${a8fly_url}\" width=\"1\" height=\"1\" alt=\"\" />";
		$a8fly->{A8FLY} = $a8tag;
		#個別のパラメータ置換
		$a8fly->{A8FLY_URL} = $self->{conf}->{a8f_url};
		$a8fly->{A8FLY_PID} = $a8fly_pid;
		$a8fly->{A8FLY_ITEM_PRICE} = $a8fly_item_price;
		$a8fly->{A8FLY_ITEM_NUM} = $a8fly_item_num;
		$a8fly->{A8FLY_ITEM_PRICE_SUM} = $a8fly_item_price_sum;
		$a8fly->{A8FLY_ITEM_CODE} = $a8fly_item_code;
		$a8fly->{A8FLY_SIRIAL} = $a8fly_so;
		$a8fly->{A8FLY_SERIAL} = $a8fly_so;
		$a8fly->{A8FLY_SO} = $a8fly_so;
		$a8fly->{A8FLY_SI} = "${a8fly_item_price}.${a8fly_item_num}.${a8fly_item_price_sum}.${a8fly_item_code}";
	}
	$proc->{a8fly} = $a8fly;
	#連続投稿禁止のIPアドレスロックデータに追加
	if( $proc->{input_valid} && $self->{conf}->{acl_post_deny_sec}) {
		FCC::Class::Mpfmec::Iplock->new(conf=>$self->{conf})->append($ENV{REMOTE_ADDR});
	}
	#
	$context->{proc} = $proc;
	return $context;
}

1;
