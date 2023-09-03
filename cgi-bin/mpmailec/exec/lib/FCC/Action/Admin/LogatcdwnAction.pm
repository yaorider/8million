package FCC::Action::Admin::LogatcdwnAction;
$VERSION = 1.00;
use strict;
use warnings;
use base qw(FCC::Action::Admin::_SuperAction);
use Date::Pcalc qw(Days_in_Month);
use FCC::Class::Mpfmec::Item;
use FCC::Class::Mpfmec::Log;

sub dispatch {
	my($self) = @_;
	my $context = {};
	#パラメーターチェック
	my $target = $self->{q}->param("target");
	my $name = $self->{q}->param("name");
	if( ! $target || $target !~ /^\d{8}_\d+$/ || ! $name || $name =~ /[^\da-zA-Z\-\_]/ ) {
		$context->{fatalerrs} = ["不正なリクエストです。"];
		return $context;
	}
	#全フォーム項目情報を取得
	my $items = FCC::Class::Mpfmec::Item->new(conf=>$self->{conf})->get();
	if( ! $items->{$name} ) {
		$context->{fatalerrs} = ["不正なリクエストです。"];
		return $context;
	}
	#FCC::Class::Mpfmec::Log
	my $olog = new FCC::Class::Mpfmec::Log(conf=>$self->{conf}, items=>$items);
	#対象のログデータを取得
	my($date, $seq) = split(/_/, $target);
	my $rec = $olog->get($date, $seq);
	unless($rec->{rec}->{$name}) {
		$context->{fatalerrs} = ["不正なリクエストです。"];
		return $context;
	}
	#該当の添付ファイル
	my $path = $rec->{rec}->{$name}->{path};
	if( ! $path || ! -e $path) {
		$context->{fatalerrs} = ["不正なリクエストです。"];
		return $context;
	}
	#
	$context->{filename} = $rec->{rec}->{$name}->{filename};
	$context->{path} = $path;
	return $context;
}

1;
