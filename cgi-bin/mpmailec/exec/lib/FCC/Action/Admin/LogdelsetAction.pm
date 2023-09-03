package FCC::Action::Admin::LogdelsetAction;
$VERSION = 1.00;
use strict;
use warnings;
use base qw(FCC::Action::Admin::_SuperAction);
use FCC::Class::Mpfmec::Log;
use FCC::Class::Mpfmec::Item;

sub dispatch {
	my($self) = @_;
	my $context = {};
	#パラメーターチェック
	my @targets = $self->{q}->param("target");
	unless(@targets) {
		$context->{fatalerrs} = ["不正なリクエストです。"];
		return $context;
	}
	for my $target (@targets) {
		if( ! $target || $target !~ /^\d{8}_\d+$/ ) {
			$context->{fatalerrs} = ["不正なリクエストです。"];
			return $context;
		}
	}
	#全フォーム項目情報を取得
	my $items = FCC::Class::Mpfmec::Item->new(conf=>$self->{conf})->get();
	#FCC::Class::Mpfmec::Log
	my $olog = new FCC::Class::Mpfmec::Log(conf=>$self->{conf}, items=>$items);
	#対象のログデータを削除
	for my $target (@targets) {
		my($date, $seq) = split(/_/, $target);
		$olog->del($date, $seq);
	}
	#
	return $context;
}

1;
