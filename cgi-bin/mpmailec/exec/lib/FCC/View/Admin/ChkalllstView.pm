package FCC::View::Admin::ChkalllstView;
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
	for my $i ("1", "2") {
		my $name = "";
		if($context->{proc}->{in} && ref($context->{proc}->{in}) eq "HASH") {
			if($context->{proc}->{in}->{"item_${i}"}) {
				$name = $context->{proc}->{in}->{"item_${i}"};
			}
		}
		my @item_loop;
		for my $ref (@{$context->{"item_${i}_list"}}) {
			my %hash;
			while( my($k, $v) = each %{$ref} ) {
				if( ! defined $v ) { $v = ""; }
				$hash{$k} = CGI::Utils->new()->escapeHtml($v);
			}
			if($ref->{name} eq $name) {
				$hash{selected} = 'selected="selected"';
			}
			push(@item_loop, \%hash);
		}
		$t->param("item_${i}_loop" => \@item_loop);
	}
	#再入力設定一覧表示
	my $items = $context->{items};
	my $checks = $context->{checks};
	my @chk_loop;
	for my $no ( sort { $a<=>$b } keys %{$checks} ) {
		my %names = (
			"1" => $checks->{$no}->{item_1},
			"2" => $checks->{$no}->{item_2}
		);
		my %hash;
		for my $i ("1", "2") {
			my $name = $names{$i};
			while( my($k, $v) = each %{$items->{$name}} ) {
				if( ! defined $v ) { $v = ""; }
				$hash{"${k}_${i}"} = CGI::Utils->new()->escapeHtml($v);
			}
		}
		$hash{no} = $no;
		$hash{CGI_URL} = $self->{conf}->{CGI_URL};
		$hash{static_url} = $self->{conf}->{static_url};
		push(@chk_loop, \%hash);
	}
	if(@chk_loop) {
		$t->param("chk_loop" => \@chk_loop);
	}
	#
	$self->print_html($t);
}

1;
