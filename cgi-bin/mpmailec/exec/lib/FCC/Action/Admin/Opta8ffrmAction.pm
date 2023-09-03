package FCC::Action::Admin::Opta8ffrmAction;
$VERSION = 1.00;
use strict;
use warnings;
use base qw(FCC::Action::Admin::_SuperAction);

sub dispatch {
	my($self) = @_;
	my $context = {};
	#プロセスセッション
	my $pkey = $self->{q}->param("pkey");
	my $proc = $self->get_proc_session_data($pkey, "opta8f");
	unless($proc) {
		$proc = $self->create_proc_session_data("opta8f");
		my @key_list = (
			'a8f_enable',
			'a8f_type',
			'a8f_url',
			'a8f_pid',
			'a8f_item_price',
			'a8f_item_num',
			'a8f_item_code'
		);
		for my $k (@key_list) {
			$proc->{in}->{$k} = $self->{conf}->{$k};
		}
	}
	#
	$context->{proc} = $proc;
	return $context;
}

1;
