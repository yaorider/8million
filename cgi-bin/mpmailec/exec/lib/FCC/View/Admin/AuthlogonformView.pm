package FCC::View::Admin::AuthlogonformView;
$VERSION = 1.00;
use strict;
use warnings;
use base qw(FCC::View::Admin::_SuperView);

sub dispatch {
	my($self, $context) = @_;
	#不正アクセスエラーの評価
	if($context->{fatalerrs}) {
		$self->error($context->{fatalerrs});
		exit;
	}
	#
	if( ! defined $context->{password_num} || $context->{password_num} == 0) {
		my $url = $self->{conf}->{CGI_URL} . "?m=authinitform";
		print STDOUT "Location: ${url}\n\n";
	} else {
		my $t = $self->load_template();
		$t->param('auto_logon' => $self->{conf}->{auto_logon});
		$self->print_html($t);
	}
}

1;
