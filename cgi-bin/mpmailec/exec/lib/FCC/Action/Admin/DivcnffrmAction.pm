package FCC::Action::Admin::DivcnffrmAction;
$VERSION = 1.00;
use strict;
use warnings;
use base qw(FCC::Action::Admin::_SuperAction);
use FCC::Class::Mpfmec::Item;
use FCC::Class::Mpfmec::Div;

sub dispatch {
	my($self) = @_;
	my $context = {};
	#全フォーム項目情報を取得
	my $items = FCC::Class::Mpfmec::Item->new(conf=>$self->{conf})->get();
	#振り分けもとになることができない項目を除外
	while( my($k, $v) = each %{$items} ) {
		if($v->{type} !~ /^(3|4|5)$/) {
			delete $items->{$k};
		}
	}
	#振り分けデータを取得
	my $divs = FCC::Class::Mpfmec::Div->new(conf=>$self->{conf})->get();
	#パラメータ
	my $name = $self->{q}->param("name");
	if($name) {
		if($name =~ /[^a-zA-Z0-9\-\_]/) {
			$name = "";
		} else {
			if( ! exists($items->{$name}) ) {
				$name = "";
			}
		}
	} elsif($divs->{name}) {
		$name = $divs->{name};
	} else {
		$name = "";
	}
	#プロセスセッション
	my $pkey = $self->{q}->param("pkey");
	my $proc = $self->get_proc_session_data($pkey, "divcnf");
	if($proc) {
		if($name ne "") {
			if( ! $divs->{name} || $divs->{name} ne $name ) {
				$proc->{in} = {};
				$proc->{in}->{name} = $name;
				$proc->{in}->{data} = {};
			}
		}
	} else {
		$proc = $self->create_proc_session_data("divcnf");
		if( $divs->{name} && $divs->{name} eq $name) {
			$proc->{in} = $divs;
		} else {
			$proc->{in}->{name} = $name;
		}
	}
	$self->set_proc_session_data($proc);
	#
	$context->{proc} = $proc;
	$context->{items} = $items;
	$context->{divs} = $divs;
	return $context;
}

1;
