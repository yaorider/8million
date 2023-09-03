package FCC::Action::Admin::ChkdelsetAction;
$VERSION = 1.00;
use strict;
use warnings;
use base qw(FCC::Action::Admin::_SuperAction);
use CGI::Utils;
use FCC::Class::Mpfmec::Check;

sub dispatch {
	my($self) = @_;
	my $context = {};
	#全情報を取得
	my $checks = FCC::Class::Mpfmec::Check->new(conf=>$self->{conf})->get();
	#入力値を取得
	my $no = $self->{q}->param("no");
	#
	my @errs;
	if($no eq "") {
		push(@errs, "項目が指定されておりません。");
	} elsif( ! exists $checks->{$no} ) {
		push(@errs, "指定の項目は登録されておりません。");
	}
	if(@errs) {
		$context->{fatalerrs} = \@errs;
		return $context;
	}
	#削除処理
	FCC::Class::Mpfmec::Check->new(conf=>$self->{conf})->del($no);
	#
	return $context;
}


1;
