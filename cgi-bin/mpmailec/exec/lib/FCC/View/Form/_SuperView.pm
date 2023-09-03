package FCC::View::Form::_SuperView;
$VERSION = 1.00;
use strict;
use warnings;
use base qw(FCC::View::_SuperView);
use CGI::Utils;
use Unicode::Japanese;
use FCC::Class::Mpfmec::Tpl;
use FCC::Class::HTTP::MobileAgent;
use FCC::Class::Mpfmec::Print;
use FCC::Class::HTTP::Cookie;

sub print_html {
	my($self, $t, $hdrs_ref) = @_;
	FCC::Class::Mpfmec::Print->new(conf=>$self->{conf})->print_html($t, $hdrs_ref);
}

sub load_template {
	my($self, $tcode) = @_;
	my($t, $meta) = FCC::Class::Mpfmec::Print->new(conf=>$self->{conf})->load_template($tcode);
	return $t, $meta;
}

sub error {
	my($self, $errs) = @_;
	if( ref($errs) ne "ARRAY" ) {
		$errs = [$errs];
	}
	#セッション削除
	$self->{session}->remove();
	#Cookie
	my $secure = 0;
	if( $self->{conf}->{CGI_URL} =~ /^https\:\/\// ) {
		$secure = 1;
	}
	my $cookie = new FCC::Class::HTTP::Cookie(
		-name   => 'sid',
		-value  => 'dummy',
		-expires =>  '-1M',
		-secure => $secure
	);
	my $hdrs = {
		'Set-Cookie' => $cookie->as_string
	};
	#エラー画面出力
	my $oprt = new FCC::Class::Mpfmec::Print(conf=>$self->{conf});
	my($t, $meta) = $oprt->load_template("err");
	my @err_loop;
	for my $err (@{$errs}) {
		push(@err_loop, { err => CGI::Utils->new()->escapeHtml($err) });
	}
	$t->param("err_loop" => \@err_loop);
	$oprt->print_html($t, $hdrs);
}

1;
