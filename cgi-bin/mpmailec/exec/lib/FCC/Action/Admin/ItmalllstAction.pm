package FCC::Action::Admin::ItmalllstAction;
$VERSION = 1.00;
use strict;
use warnings;
use base qw(FCC::Action::Admin::_SuperAction);
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
	if( defined $self->{conf}->{mai_from} && $self->{conf}->{mai_from} ne "") {
		$undeletables{$self->{conf}->{mai_from}} = 1;
	}
	if( defined $self->{conf}->{rpy_item} && $self->{conf}->{rpy_item} ne "") {
		$undeletables{$self->{conf}->{rpy_item}} = 1;
	}
	#登録項目数
	my $num = scalar keys %{$items};
	#
	while( my($name, $ref) = each %{$items} ) {
		my $type = $ref->{type};
		if($type =~ /^(3|4|5)$/) {
			if($ref->{"type_${type}_elements"}) {
				my @elements = split(/\n+/, $ref->{"type_${type}_elements"});
				my $element = $elements[0];
				for my $cap (@elements) {
					if($cap =~ /^\*/) {
						$element = $cap;
						last;
					}
				}
				$element =~ s/^[\*\^]//;
				$ref->{element} = $element;
			}
		}
		my $offset = $ref->{offset};
		if($offset > 0) {
			if($offset == 1) {
				$ref->{offset_up} = '0E0';
			} else {
				$ref->{offset_up} = $offset - 1;
			}
		}
		if($offset < $num - 1) {
			$ref->{offset_dn} = $offset + 1;
		}
		if($undeletables{$name}) {
			$ref->{deletable} = 0;
		} else {
			$ref->{deletable} = 1;
		}
	}
	#
	$context->{items} = $items;
	return $context;
}

1;
