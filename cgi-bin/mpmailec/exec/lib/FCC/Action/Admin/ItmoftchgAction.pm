package FCC::Action::Admin::ItmoftchgAction;
$VERSION = 1.00;
use strict;
use warnings;
use base qw(FCC::Action::Admin::_SuperAction);
use CGI::Utils;
use FCC::Class::Mpfmec::Item;

sub dispatch {
	my($self) = @_;
	my $context = {};
	#全フォーム項目情報を取得
	my $items = FCC::Class::Mpfmec::Item->new(conf=>$self->{conf})->get();
	my $item_num = scalar keys %{$items};
	#入力値を取得
	my $name = $self->{q}->param("name");
	my $offset = $self->{q}->param("offset");
	$offset += 0;
	#
	my @errs;
	if($name eq "") {
		push(@errs, "項目が指定されておりません。");
	} elsif( ! exists $items->{$name} ) {
		push(@errs, "指定の項目は登録されておりません。");
	}
	if($offset eq "") {
		push(@errs, "オフセットが指定されておりません。");
	} elsif($offset < 0 || $offset >= $item_num) {
		push(@errs, "オフセットの値が不適切です。");
	}
	if(@errs) {
		$context->{fatalerrs} = \@errs;
		return $context;
	}
	#オフセット変更処理
	FCC::Class::Mpfmec::Item->new(conf=>$self->{conf})->offset_update($name, $offset);
	#
	$context->{item} = $items->{$name};
	return $context;
}


1;
