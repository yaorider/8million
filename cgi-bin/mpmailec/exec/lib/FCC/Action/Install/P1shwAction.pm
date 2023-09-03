package FCC::Action::Install::P1shwAction;
$VERSION = 1.00;
use strict;
use warnings;
use base qw(FCC::Action::Install::_SuperAction);

sub dispatch {
	my($self) = @_;
	my $context = {};
	#
	my $static_url = $self->{q}->param("static_url");
	unless($static_url) {
		$static_url = "./static";
	}
	$static_url =~ s/^[\s\t]+//;
	$static_url =~ s/[\s\t]$//;
	$static_url =~ s/\/$//;
	my @errs;
	if( ! $static_url ) {
		push(@errs, ["static_url", "\"staticディレクトリのURL\"は必須です。"]);
	} elsif($static_url =~ /[^a-zA-Z0-9\/\.\_\-\:]/) {
		push(@errs, ["static_url", "\"staticディレクトリのURL\"に不正な文字が含まれています。"]);
	}
	#
	my $proc = {};
	$proc->{errs} = \@errs;
	$proc->{in} = {};
	$proc->{in}->{static_url} = $static_url;
	$context->{proc} = $proc;
	return $context;
}

1;
