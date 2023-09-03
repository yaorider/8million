package FCC::View::Admin::OptdtlfrmView;
$VERSION = 1.00;
use strict;
use warnings;
use base qw(FCC::View::Admin::_SuperView);
use CGI::Utils;
use FCC::Class::Date::Utils;

sub dispatch {
	my($self, $context) = @_;
	#システムエラーの評価
	if($context->{fatalerrs}) {
		$self->error($context->{fatalerrs});
		exit;
	}
	#テンプレートのロード
	my $t = $self->load_template();
	$t->param("pkey" => $context->{proc}->{pkey});
	while( my($k, $v) = each %{$context->{proc}->{in}} ) {
		if( ! defined $v ) { $v = ""; }
		$t->param($k => CGI::Utils->new()->escapeHtmlFormValue($v));
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
	#データのプリセット
	if($context->{proc}->{in} && ref($context->{proc}->{in}) eq "HASH") {
		while( my($k, $v) = each %{$context->{proc}->{in}} ) {
			if( ! defined $v ) { $v = ""; }
			$t->param($k => CGI::Utils->new()->escapeHtmlFormValue($v));
			if($k =~ /^(atc_thumb_show)$/) {
				$t->param("${k}_${v}_checked" => 'checked="checked"');
			} elsif($k =~ /^(atc_thumb_module|atc_thumb_format)$/) {
				$t->param("${k}_${v}_selected" => 'selected="selected"');
			}
		}
	}
	#
	while( my($k, $v) = each %{$context->{proc}->{params}} ) {
		$t->param($k => $v);
	}
	#
	$self->print_html($t);
}

1;
