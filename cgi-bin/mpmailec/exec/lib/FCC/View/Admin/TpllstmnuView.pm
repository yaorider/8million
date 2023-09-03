package FCC::View::Admin::TpllstmnuView;
$VERSION = 1.00;
use strict;
use warnings;
use base qw(FCC::View::Admin::_SuperView);
use CGI::Utils;

sub dispatch {
	my($self, $context) = @_;
	#ƒGƒ‰[‚Ì•]‰¿
	if($context->{fatalerrs}) {
		$self->error($context->{fatalerrs});
		exit;
	}
	#
	my $t = $self->load_template();
	while( my($k, $v) = each %{$self->{conf}} ) {
		if( defined $v && ! ref($v) ) {
			$t->param($k => CGI::Utils->new()->escapeHtml($v));
		}
	}
	$self->print_html($t);
}

1;
