package FCC::View::Install::P3shwView;
$VERSION = 1.00;
use strict;
use warnings;
use base qw(FCC::View::Install::_SuperView);
use CGI::Utils;

sub dispatch {
	my($self, $context) = @_;
	if($context->{fatalerrs}) {
		$self->error($context->{fatalerrs});
	}
	#
	my $t = $self->load_template();
	while( my($k, $v) = each %{$context->{proc}->{in}} ) {
		$t->param($k => CGI::Utils->new()->escapeHtml($v));
	}
	#
	if( $context->{proc}->{in}->{smt} && ! @{$context->{proc}->{errs}} ) {
		print "Location: $self->{conf}->{CGI_URL}?m=p4shw\n\n";
	} else {
		if( @{$context->{proc}->{errs}} ) {
			my $errs = "<ul>";
			for my $e (@{$context->{proc}->{errs}}) {
				$t->param("$e->[0]_err" => "err");
				$errs .= "<li>$e->[1]</li>";
			}
			$errs .= "</ul>";
			$t->param('errs' => $errs);
		}
		$self->print_html($t);
	}
}

1;
