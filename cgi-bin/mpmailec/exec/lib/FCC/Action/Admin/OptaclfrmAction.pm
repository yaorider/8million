package FCC::Action::Admin::OptaclfrmAction;
$VERSION = 1.00;
use strict;
use warnings;
use base qw(FCC::Action::Admin::_SuperAction);
use FCC::Class::Syscnf;

sub dispatch {
	my($self) = @_;
	my $context = {};
	#プロセスセッション
	my $pkey = $self->{q}->param("pkey");
	my $proc = $self->get_proc_session_data($pkey, "optacl");
	unless($proc) {
		$proc = $self->create_proc_session_data("optacl");
		my @key_list = (
			'acl_deny_hosts',
			'acl_post_deny_sec'
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
