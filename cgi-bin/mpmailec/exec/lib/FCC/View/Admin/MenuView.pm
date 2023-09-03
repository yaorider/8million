package FCC::View::Admin::MenuView;
$VERSION = 1.00;
use strict;
use warnings;
use base qw(FCC::View::Admin::_SuperView);

sub dispatch {
	my($self, $context) = @_;
	#ƒGƒ‰[‚Ì•]‰¿
	if($context->{fatalerrs}) {
		$self->error($context->{fatalerrs});
		exit;
	}
	#
	my $t = $self->load_template();
	$t->param('log_enable' => $self->{conf}->{log_enable});
	$self->print_html($t);
}

1;
