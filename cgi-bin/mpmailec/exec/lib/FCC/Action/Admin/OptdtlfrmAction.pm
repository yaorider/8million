package FCC::Action::Admin::OptdtlfrmAction;
$VERSION = 1.00;
use strict;
use warnings;
use base qw(FCC::Action::Admin::_SuperAction);
use FCC::Class::Image::Thumbnail;

sub dispatch {
	my($self) = @_;
	my $context = {};
	#プロセスセッション
	my $pkey = $self->{q}->param("pkey");
	my $proc = $self->get_proc_session_data($pkey, "optdtl");
	unless($proc) {
		$proc = $self->create_proc_session_data("optdtl");
		my @key_list = (
			'atc_max_total_size',
			'atc_thumb_show',
			'atc_thumb_w',
			'atc_thumb_h',
			'atc_thumb_module',
			'atc_thumb_format'
		);
		for my $k (@key_list) {
			$proc->{in}->{$k} = $self->{conf}->{$k};
		}
	}
	#サムネイル機能が利用可能か
	my @modules = FCC::Class::Image::Thumbnail->new()->available_modules();
	$proc->{params} = {};
	$proc->{params}->{atc_thumb_available} = 0;
	if(@modules) {
		$proc->{params}->{atc_thumb_available} = 1;
		for my $module (@modules) {
			$proc->{params}->{"atc_thumb_module_${module}"} = 1;
		}
	}
	unless($proc->{params}->{atc_thumb_available}) {
		$proc->{in}->{atc_thumb_show} = 0;
	}
	#
	$context->{proc} = $proc;
	return $context;
}

1;
