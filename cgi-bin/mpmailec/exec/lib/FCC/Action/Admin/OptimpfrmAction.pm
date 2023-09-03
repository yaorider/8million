package FCC::Action::Admin::OptimpfrmAction;
$VERSION = 1.00;
use strict;
use warnings;
use base qw(FCC::Action::Admin::_SuperAction);
use FCC::Class::Mpfmec::Item;

sub dispatch {
	my($self) = @_;
	my $context = {};
	#プロセスセッション
	my $pkey = $self->{q}->param("pkey");
	my $proc = $self->get_proc_session_data($pkey, "optimp");
	unless($proc) {
		$proc = $self->create_proc_session_data("optimp");
	}
	#
	$context->{proc} = $proc;
	return $context;
}

1;
