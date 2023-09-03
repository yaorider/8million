package FCC::Action::Admin::OptlogfrmAction;
$VERSION = 1.00;
use strict;
use warnings;
use base qw(FCC::Action::Admin::_SuperAction);

sub dispatch {
	my($self) = @_;
	my $context = {};
	#プロセスセッション
	my $pkey = $self->{q}->param("pkey");
	my $proc = $self->get_proc_session_data($pkey, "optlog");
	unless($proc) {
		$proc = $self->create_proc_session_data("optlog");
		my @key_list = (
			'log_enable',
			'log_dir',
			'log_atc_save',
			'log_save_days'
		);
		for my $k (@key_list) {
			my $v = $self->{conf}->{$k};
			if( ! defined $v ) { $v = ""; }
			$proc->{in}->{$k} = $v;
		}
		if($proc->{in}->{log_dir} eq "") {
			$proc->{in}->{log_dir} = $self->{conf}->{BASE_DIR} . "/data/logs";
		}
	}
	#
	$context->{proc} = $proc;
	return $context;
}

1;
