package FCC::Action::Form::CfmshwAction;
$VERSION = 1.00;
use strict;
use warnings;
use base qw(FCC::Action::Form::_SuperAction);

sub dispatch {
	my($self) = @_;
	my $context = {};
	#プロセスセッション
	my $sid = $self->{session}->{sid};
	my $pid = $self->{session}->{data}->{pid};
	my $proc = $self->{session}->{data}->{proc};
	if( defined $proc ) {
		$proc->{hidden}->{m} = "cptsmt";
		$proc->{hidden}->{pid} = $pid;
		if($self->{conf}->{cookie_available}) {
			delete $proc->{hidden}->{sid};
		}
		$context->{proc} = $proc;
		#セッションをアップデート
		$self->{session}->update( { proc => $proc } );
	} else {
		$context->{fatalerrs} = ['system error'];
		return $context;
	}
	#
	return $context;
}

1;
