package FCC::Action::Admin::OptexpfrmAction;
$VERSION = 1.00;
use strict;
use warnings;
use base qw(FCC::Action::Admin::_SuperAction);

sub dispatch {
	my($self) = @_;
	my $context = {};
	#プロセスセッション
	my $pkey = $self->{q}->param("pkey");
	my $proc = $self->get_proc_session_data($pkey, "optexp");
	unless($proc) {
		$proc = $self->create_proc_session_data("optexp");
	}
	#
	$context->{proc} = $proc;
	return $context;
}

1;
