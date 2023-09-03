package FCC::Action::Admin::ItmmodfrmAction;
$VERSION = 1.00;
use strict;
use warnings;
use base qw(FCC::Action::Admin::_SuperAction);
use FCC::Class::Mpfmec::Item;
use FCC::Class::Mpfmec::Txt;

sub dispatch {
	my($self) = @_;
	my $context = {};
	#プロセスセッション
	my $pkey = $self->{q}->param("pkey");
	my $proc = $self->get_proc_session_data($pkey, "itmmod");
	unless($proc) {
		$proc = $self->create_proc_session_data("itmmod");
		#全フォーム項目情報を取得
		my $items = FCC::Class::Mpfmec::Item->new(conf=>$self->{conf})->get();
		#入力値を取得
		my $name = $self->{q}->param("name");
		#
		my @errs;
		if($name eq "") {
			push(@errs, "項目が指定されておりません。");
		} elsif( ! exists $items->{$name} ) {
			push(@errs, "指定の項目は登録されておりません。");
		}
		if(@errs) {
			$context->{fatalerrs} = \@errs;
			return $context;
		}
		#
		$proc->{in} = $items->{$name};
		#
		$proc->{net_dns_available} = 1;
		eval{ require Net::DNS; };
		if($@) { $proc->{net_dns_available} = 0; }
		#
		$proc->{lwp_available} = 1;
		eval{ require LWP::UserAgent; };
		if($@) { $proc->{lwp_available} = 0; }
		#
		$self->set_proc_session_data($proc);
	}
	my $type = $proc->{in}->{type};
	if($type =~ /^(3|4|5)$/ && $proc->{in}->{"type_${type}_elements"}) {
		my @elements = split(/\n+/, $proc->{in}->{"type_${type}_elements"});
		my $element = $elements[0];
		for my $cap (@elements) {
			if($cap =~ /^\*/) {
				$element = $cap;
				last;
			}
		}
		$element =~ s/^[\*\^]//;
		$proc->{in}->{element} = $element;
	}
	#FCC::Class::Mpfmec::Txtのインスタンス
	my $otxt = new FCC::Class::Mpfmec::Txt(conf=>$self->{conf});
	#入力値制限のリスト
	$proc->{restricts} = $otxt->get_restricts_for_select();
	#入力値変換のリスト
	$proc->{converts} = $otxt->get_converts_for_select();
	#
	$context->{proc} = $proc;
	return $context;
}

1;
