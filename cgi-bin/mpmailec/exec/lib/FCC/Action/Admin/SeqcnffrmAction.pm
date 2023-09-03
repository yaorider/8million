package FCC::Action::Admin::SeqcnffrmAction;
$VERSION = 1.00;
use strict;
use warnings;
use base qw(FCC::Action::Admin::_SuperAction);
use FCC::Class::Mpfmec::Seq;

sub dispatch {
	my($self) = @_;
	my $context = {};
	#プロセスセッション
	my $pkey = $self->{q}->param("pkey");
	my $proc = $self->get_proc_session_data($pkey, "seqcnf");
	unless($proc) {
		$proc = $self->create_proc_session_data("seqcnf");
		my @key_list = (
			'seq_fmt',
			'seq_fmt_tpl',
			'seq_reset'
		);
		for my $k (@key_list) {
			$proc->{in}->{$k} = $self->{conf}->{$k};
		}
	}
	#受付シリアルデータを取得
	$proc->{seq} = FCC::Class::Mpfmec::Seq->new(conf=>$self->{conf})->get();
	#
	$context->{proc} = $proc;
	return $context;
}

1;
