package FCC::Action::Admin::OptrpyfrmAction;
$VERSION = 1.00;
use strict;
use warnings;
use base qw(FCC::Action::Admin::_SuperAction);
use FCC::Class::Mpfmec::Item;

sub dispatch {
	my($self) = @_;
	my $context = {};
	#�v���Z�X�Z�b�V����
	my $pkey = $self->{q}->param("pkey");
	my $proc = $self->get_proc_session_data($pkey, "optrpy");
	unless($proc) {
		$proc = $self->create_proc_session_data("optrpy");
		my @key_list = (
			'rpy_enable',
			'rpy_item',
			'rpy_from',
			'rpy_sender',
			'rpy_subject',
			'rpy_cc',
			'rpy_bcc',
			'rpy_error_to',
			'rpy_word_wrap',
			'rpy_priority',
			'rpy_notification',
			'rpy_atc_reply'
		);
		for my $k (@key_list) {
			$proc->{in}->{$k} = $self->{conf}->{$k};
		}
	}
	#�S�t�H�[�����ڏ����擾
	my $items = FCC::Class::Mpfmec::Item->new(conf=>$self->{conf})->get();
	#�e�L�X�g�t�B�[���h�̂������[���A�h���X���Ƃ��ė��p���鍀�ڂ݂̂��c��
	while( my($k, $ref) = each %{$items} ) {
		if($ref->{type} eq "1" && $ref->{type_1_is_email}) { next }
		delete $items->{$k};
	}
	$proc->{items} = $items;
	#
	$context->{proc} = $proc;
	return $context;
}

1;
