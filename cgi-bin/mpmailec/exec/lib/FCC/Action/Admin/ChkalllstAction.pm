package FCC::Action::Admin::ChkalllstAction;
$VERSION = 1.00;
use strict;
use warnings;
use base qw(FCC::Action::Admin::_SuperAction);
use FCC::Class::Mpfmec::Item;
use FCC::Class::Mpfmec::Check;

sub dispatch {
	my($self) = @_;
	my $context = {};
	#プロセスセッション
	my $pkey = $self->{q}->param("pkey");
	my $proc = $self->get_proc_session_data($pkey, "chkadd");
	unless($proc) {
		$proc = $self->create_proc_session_data("chkadd");
	}
	#全フォーム項目情報を取得
	my $items = FCC::Class::Mpfmec::Item->new(conf=>$self->{conf})->get();
	#選択項目
	my @item_1_list;
	my @item_2_list;
	for my $name ( sort { $items->{$a}->{offset} <=> $items->{$b}->{offset} } keys %{$items} ) {
		my $item = $items->{$name};
		if($item->{type} =~ /^(1|2)$/) {
			push(@item_1_list, $item);
			push(@item_2_list, $item);
		}
	}
	#
	$context->{proc} = $proc;
	$context->{item_1_list} = \@item_1_list;
	$context->{item_2_list} = \@item_2_list;
	#再入力設定情報を取得
	$context->{checks} = FCC::Class::Mpfmec::Check->new(conf=>$self->{conf})->get();
	$context->{items} = $items;
	#
	return $context;
}

1;
