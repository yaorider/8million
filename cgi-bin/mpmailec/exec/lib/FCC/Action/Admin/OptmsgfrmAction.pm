package FCC::Action::Admin::OptmsgfrmAction;
$VERSION = 1.00;
use strict;
use warnings;
use base qw(FCC::Action::Admin::_SuperAction);
use FCC::Class::Mpfmec::Msg;

sub dispatch {
	my($self) = @_;
	my $context = {};
	#プロセスセッション
	my $pkey = $self->{q}->param("pkey");
	my $proc = $self->get_proc_session_data($pkey, "optmsg");
	unless($proc) {
		$proc = $self->create_proc_session_data("optmsg");
		$proc->{in} = FCC::Class::Mpfmec::Msg->new(conf=>$self->{conf})->get_all();
	}
	#
	$context->{proc} = $proc;
	return $context;
}

1;
