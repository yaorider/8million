package FCC::View::Admin::_SuperView;
$VERSION = 1.00;
use strict;
use warnings;
use base qw(FCC::View::_SuperView);

sub error {
	my($self, $errs) = @_;
	my @list = @{$errs};
	my $n = scalar @list;
	my $msg;
	if($n == 1) {
		$msg = $list[0];
	} else {
		$msg .= "<ul>";
		for my $s (@list) {
			$msg .= "<li>${s}</li>";
		}
		$msg .= "</ul>";
	}
	my $t = $self->load_template("$self->{conf}->{BASE_DIR}/template/$self->{conf}->{FCC_SELECTOR}/error.tpl");
	$t->param('error' => $msg);
	$self->print_html($t);
}

1;
