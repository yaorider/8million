package FCC::View::Admin::TpledtcptView;
$VERSION = 1.00;
use strict;
use warnings;
use base qw(FCC::View::Admin::_SuperView);

sub dispatch {
	my($self, $context) = @_;
	if($context->{fatalerrs}) {
		$self->error($context->{fatalerrs});
	}
	my $t = $self->load_template();
	my $tid = $context->{proc}->{tid};
	$t->param("tid" => $tid);
	while( my($k, $v) = each %{$context->{proc}->{titles}->{$tid}} ) {
		if( defined $v ) {
			$t->param($k => CGI::Utils->new()->escapeHtml($v));
		}
	}
	while( my($k, $v) = each %{$context->{proc}->{meta}} ) {
		if( defined $v ) {
			$t->param($k => CGI::Utils->new()->escapeHtml($v));
		}
	}
	$self->print_html($t);
}

1;
