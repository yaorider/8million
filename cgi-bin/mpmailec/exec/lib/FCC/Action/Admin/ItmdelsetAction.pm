package FCC::Action::Admin::ItmdelsetAction;
$VERSION = 1.00;
use strict;
use warnings;
use base qw(FCC::Action::Admin::_SuperAction);
use CGI::Utils;
use FCC::Class::Mpfmec::Item;
use FCC::Class::Mpfmec::Check;
use FCC::Class::Mpfmec::Div;

sub dispatch {
	my($self) = @_;
	my $context = {};
	#全フォーム項目情報を取得
	my $items = FCC::Class::Mpfmec::Item->new(conf=>$self->{conf})->get();
	#全再入力設定情報を取得
	my $checks = FCC::Class::Mpfmec::Check->new(conf=>$self->{conf})->get();
	#振り分けデータを取得
	my $divs = FCC::Class::Mpfmec::Div->new(conf=>$self->{conf})->get();
	#削除できない項目
	my %undeletables;
	while( my($no, $ref) = each %{$checks} ) {
		$undeletables{$ref->{item_1}} = 1;
		$undeletables{$ref->{item_2}} = 1;
	}
	if($divs->{name}) {
		$undeletables{$divs->{name}} = 1;
	}
	if( defined $self->{conf}->{rpy_item} && $self->{conf}->{rpy_item} ne "") {
		$undeletables{$self->{conf}->{rpy_item}} = 1;
	}
	#入力値を取得
	my @names = $self->{q}->param("name");
	#
	my @errs;
	if(! @names) {
		push(@errs, "項目が指定されておりません。");
	} else {
		for my $name (@names) {
			if( ! exists $items->{$name} ) {
				push(@errs, "指定の項目 ${name} は登録されておりません。");
			} elsif( exists $undeletables{$name} ) {
				push(@errs, "指定の項目 ${name} は再入力設定で定義されているため削除できません。削除したい場合は、事前に再入力設定を解除してください。");
			}
		}
	}
	if(@errs) {
		$context->{fatalerrs} = \@errs;
		return $context;
	}
	#削除処理
	my $oitm = new FCC::Class::Mpfmec::Item(conf=>$self->{conf});
	my @deleted_items;
	for my $name (@names) {
		$oitm->del($name);
		push(@deleted_items, $items->{$name});
	}
	#
	$context->{items} = \@deleted_items;
	return $context;
}


1;
