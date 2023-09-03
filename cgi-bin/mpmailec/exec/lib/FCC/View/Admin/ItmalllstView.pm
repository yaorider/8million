package FCC::View::Admin::ItmalllstView;
$VERSION = 1.00;
use strict;
use warnings;
use base qw(FCC::View::Admin::_SuperView);
use CGI::Utils;

sub dispatch {
	my($self, $context) = @_;
	#システムエラーの評価
	if($context->{fatalerrs}) {
		$self->error($context->{fatalerrs});
		exit;
	}
	#テンプレートのロード
	my $t = $self->load_template();
	#フォーム項目を置換
	my @item_loop;
	my $items = $context->{items};
	for my $name ( sort { $items->{$a}->{offset} <=> $items->{$b}->{offset} } keys %{$items} ) {
		my %hash;
		while( my($k, $v) = each %{$items->{$name}} ) {
			if( ! defined $v ) { $v = ""; }
			$hash{$k} = CGI::Utils->new()->escapeHtml($v);
			if($k =~ /^(type)$/) {
				$hash{"${k}_${v}"} = 1;
			} elsif($k eq "name") {
				$hash{"${k}_urlenc"} = CGI::Utils->new()->urlEncode($v);
			}
		}
		$hash{CGI_URL} = $self->{conf}->{CGI_URL};
		$hash{static_url} = $self->{conf}->{static_url};
		push(@item_loop, \%hash);
	}
	$t->param("ITEM_LOOP" => \@item_loop);
	#
	$self->print_html($t);
}

1;
