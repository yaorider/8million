package FCC::View::Admin::ItmaddfrmView;
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
			if($k =~ /^(required|type_1_is_email|type_3_arrangement|type_4_arrangement|type_5_multiple|type_8_handover)$/) {
				$t->param("${k}_${v}_checked" => 'checked="checked"');
			} elsif($k =~ /^(type|type_\d+_convert_\d+|type_\d+_restrict_\d+)$/) {
				$t->param("${k}_${v}_selected" => 'selected="selected"');
			}
		}
	}
	#入力値制限のリスト
	my $net_dns_available = $context->{proc}->{net_dns_available};
	my $lwp_available = $context->{proc}->{lwp_available};
	for my $type ("1") {
		for( my $i=1; $i<=3; $i++ ) {
			my $selected_code = $context->{proc}->{in}->{"type_${type}_restrict_${i}"};
			my @loop;
			for my $ref (@{$context->{proc}->{restricts}}) {
				my %hash = %{$ref};
				if( defined $hash{code} && $hash{code} ne "" && defined $selected_code && $hash{code} eq $selected_code ) {
					$hash{selected} = 'selected="selected"';
				}
				if($ref->{code} eq "en12" && ! $net_dns_available) {
					$hash{disabled} = 'disabled="disabled"';
				} elsif($ref->{code} eq "en22" && ! $lwp_available) {
					$hash{disabled} = 'disabled="disabled"';
				}
				push(@loop, \%hash);
			}
			$t->param("type_${type}_restrict_loop_${i}" => \@loop);
		}
	}
	$t->param("net_dns_available" => $net_dns_available);
	$t->param("lwp_available" => $lwp_available);
	#入力値変換のリスト
	for my $type ("1", "6") {
		for( my $i=1; $i<=5; $i++ ) {
			my $selected_code = $context->{proc}->{in}->{"type_${type}_convert_${i}"};
			my @loop;
			for my $ref (@{$context->{proc}->{converts}}) {
				my %hash = %{$ref};
				if( defined $hash{code} && $hash{code} ne "" && defined $selected_code && $hash{code} eq $selected_code ) {
					$hash{selected} = 'selected="selected"';
				}
				push(@loop, \%hash);
			}
			$t->param("type_${type}_convert_loop_${i}" => \@loop);
		}
	}
	#
	$self->print_html($t);
}

1;
