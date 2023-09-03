package FCC::Action::Admin::ItmaddfrmAction;
$VERSION = 1.00;
use strict;
use warnings;
use base qw(FCC::Action::Admin::_SuperAction);
use FCC::Class::Mpfmec::Txt;

sub dispatch {
	my($self) = @_;
	my $context = {};
	#プロセスセッション
	my $pkey = $self->{q}->param("pkey");
	my $proc = $self->get_proc_session_data($pkey, "itmadd");
	unless($proc) {
		$proc = $self->create_proc_session_data("itmadd");
		my %default_values = (
			type_1_width => '100%',
			type_1_maxlength => '255',
			type_2_width => '100%',
			type_2_maxlength => '255',
			type_3_arrangement => '1',
			type_4_arrangement => '1',
			type_6_cols => '40',
			type_6_rows => '3',
			type_6_maxlength => '500',
			type_7_maxsize => '1',
			type_8_maxlength => '255'
		);
		while( my($k, $v) = each %default_values ) {
			$proc->{in}->{$k} = $v;
		}
		#
		$proc->{net_dns_available} = 1;
		eval{ require Net::DNS; };
		if($@) { $proc->{net_dns_available} = 0; }
		#
		$proc->{lwp_available} = 1;
		eval{ require LWP::UserAgent; };
		if($@) { $proc->{lwp_available} = 0; }
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
