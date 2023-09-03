package FCC::View::Admin::TplmaifrmView;
$VERSION = 1.00;
use strict;
use warnings;
use base qw(FCC::View::Admin::_SuperView);
use CGI::Utils;

sub dispatch {
	my($self, $context) = @_;
	#エラーの評価
	if($context->{fatalerrs}) {
		$self->error($context->{fatalerrs});
		exit;
	}
	#
	my $t = $self->load_template();
	$t->param("pkey" => $context->{proc}->{pkey});
	my $tid = $context->{proc}->{in}->{tid};
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
	#データのプリセット
	while( my($k, $v) = each %{$context->{proc}->{in}} ) {
		if( defined $v ) {
			$t->param($k => CGI::Utils->new()->escapeHtml($v));
		}
	}
	#
	$self->print_html($t);
}

1;
