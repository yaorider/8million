package FCC::Action::Admin::TpledtcptAction;
$VERSION = 1.00;
use strict;
use warnings;
use base qw(FCC::Action::Admin::_SuperAction);
use FCC::Class::Mpfmec::Tpl;

sub dispatch {
	my($self) = @_;
	my $context = {};
	#�e���v���[�g�̃^�C�g�����擾
	my $titles = FCC::Class::Mpfmec::Tpl->new(conf=>$self->{conf})->get_titles();
	#�e���v���[�gID���擾
	my $tid = $self->{q}->param("tid");
	if( ! defined $tid || $tid eq "" || $tid =~ /[^a-zA-Z0-9]/ || ! $titles->{$tid}) {
		$context->{fatalerrs} = ['�s���ȃp�����[�^�����M����܂����B'];
		return $context;
	}
	#�v���Z�X�Z�b�V�������폜
	$self->del_proc_session_data();
	#���^���
	my $meta = FCC::Class::Mpfmec::Tpl->new(conf=>$self->{conf})->get_meta($tid);
	#
	my $proc = {};
	$proc->{titles} = $titles;
	$proc->{meta} = $meta;
	$proc->{tid} = $tid;
	#
	$context->{proc} = $proc;
	return $context;
}

1;
