package FCC::View::Admin::OptrpyfrmView;
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
			if($k =~ /^(rpy_enable|rpy_priority|rpy_notification|rpy_atc_reply)$/) {
				$t->param("${k}_${v}_checked" => 'checked="checked"');
			}
		}
	}
	#フォーム項目のセレクトメニュー
	my @item_loop;
	my $items = $context->{proc}->{items};
	my $rpy_item = $context->{proc}->{in}->{rpy_item};
	if( ! defined $rpy_item ) { $rpy_item = ""; }
	for my $nm ( sort { $items->{$a}->{offset} <=> $items->{$b}->{offset} } keys %{$items} ) {
		my %hash;
		while( my($k, $v) = each %{$items->{$nm}} ) {
			if( ! defined $v ) { $v = ""; }
			$hash{$k} = CGI::Utils->new()->escapeHtml($v);
		}
		if($nm eq $rpy_item) {
			$hash{selected} = 'selected="selected"';
		}
		push(@item_loop, \%hash);
	}
	$t->param("item_loop" => \@item_loop);
	#
	$self->print_html($t);
}

1;
