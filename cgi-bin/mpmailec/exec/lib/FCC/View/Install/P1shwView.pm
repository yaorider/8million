package FCC::View::Install::P1shwView;
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
	$t->param("static_url" => $context->{proc}->{in}->{static_url});
	#プロセスエラー
	if( @{$context->{proc}->{errs}} ) {
		my $errs = "<ul>";
		for my $e (@{$context->{proc}->{errs}}) {
			$t->param("$e->[0]_err" => "err");
			$errs .= "<li>$e->[1]</li>";
		}
		$errs .= "</ul>";
		$t->param('errs' => $errs);
	}
	#
	$self->print_html($t);
}

1;
