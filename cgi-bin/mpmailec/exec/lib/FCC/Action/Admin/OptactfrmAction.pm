package FCC::Action::Admin::OptactfrmAction;
$VERSION = 1.00;
use strict;
use warnings;
use base qw(FCC::Action::Admin::_SuperAction);

sub dispatch {
	my($self) = @_;
	my $context = {};
	#プロセスセッション
	my $pkey = $self->{q}->param("pkey");
	my $proc = $self->get_proc_session_data($pkey, "optact");
	unless($proc) {
		$proc = $self->create_proc_session_data("optact");
		my @key_list = (
			'lang',
			'html_00_encoding',
			'html_00_doctype',
			'html_mobi_selectable',
			'html_mobi_carrier_selectable',
			'html_auto_ctype',
			'html_10_doctype',
			'html_10_encoding',
			'html_11_doctype',
			'html_11_encoding',
			'html_12_doctype',
			'html_12_encoding',
			'html_13_doctype',
			'html_13_encoding',
			'confirm_enable',
			'thx_redirect_enable',
			'thx_redirect_url'
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
