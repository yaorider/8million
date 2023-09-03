package FCC::Action::Admin::OptmaifrmAction;
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
	my $proc = $self->get_proc_session_data($pkey, "optmai");
	unless($proc) {
		$proc = $self->create_proc_session_data("optmai");
		my @key_list = (
			'mai_to',
			'mai_cc',
			'mai_bcc',
			'mai_from',
			'mai_from_default',
			'mai_sender',
			'mai_subject',
			'mai_word_wrap',
			'mai_addon_headers'
		);
		for my $k (@key_list) {
			$proc->{in}->{$k} = $self->{conf}->{$k};
		}
	}
	#全フォーム項目情報を取得
	my $items = FCC::Class::Mpfmec::Item->new(conf=>$self->{conf})->get();
	#テキストフィールドのみを残す
	while( my($k, $ref) = each %{$items} ) {
		if($ref->{type} ne "1" || $ref->{type_1_is_email} ne "1") { delete $items->{$k}; }
	}
	$proc->{items} = $items;
	#
	$context->{proc} = $proc;
	return $context;
}

1;
