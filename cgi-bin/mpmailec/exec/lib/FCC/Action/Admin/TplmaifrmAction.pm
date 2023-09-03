package FCC::Action::Admin::TplmaifrmAction;
$VERSION = 1.00;
use strict;
use warnings;
use base qw(FCC::Action::Admin::_SuperAction);
use FCC::Class::Mpfmec::TplMai;

sub dispatch {
	my($self) = @_;
	my $context = {};
	#プロセスセッション
	my $pkey = $self->{q}->param("pkey");
	my $proc = $self->get_proc_session_data($pkey, "tplmai");
	unless($proc) {
		$proc = $self->create_proc_session_data("tplmai");
		#テンプレートロード
		my $tpltype = $self->{q}->param("tpltype");
		my $tpl;
		if(defined $tpltype && $tpltype =~ /^(1|2)$/) {
			$tpl = FCC::Class::Mpfmec::TplMai->new(conf=>$self->{conf})->get_default($tpltype);
		} else {
			$tpl = FCC::Class::Mpfmec::TplMai->new(conf=>$self->{conf})->get(1);
		}
		$proc->{in}->{tpl} = $tpl;
	}
	#
	$context->{proc} = $proc;
	return $context;
}

1;
