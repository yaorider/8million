package FCC::View::Install::P2shwView;
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
		$t->param($k => $v);
	}
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
	#診断エラー
	if( @{$context->{proc}->{stat_errs}} ) {
		my $stat_errs = "<ul>";
		for my $e (@{$context->{proc}->{stat_errs}}) {
			$stat_errs .= "<li>${e}</li>";
		}
		$stat_errs .= "</ul>";
		$t->param('stat_errs' => $stat_errs);
	}
	#
	$self->print_html($t);
}

1;
