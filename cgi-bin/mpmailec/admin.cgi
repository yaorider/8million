#!/usr/bin/perl
################################################################################
# MP Form Mail CGI eCommerce版 管理メニュー
# Ver 2.0.5
# Copyright(C) futomi 2001 - 2009
# http://www.futomi.com/
###############################################################################
use strict;
use warnings;
BEGIN {
	use FindBin;
	if($FindBin::Bin && $FindBin::Bin ne "/") {
		push(@INC, "$FindBin::Bin/exec/lib");
	} else {
		push(@INC, "./exec/lib");
	}
	use CGI::Carp qw(carpout fatalsToBrowser);
	if($FindBin::Bin && $FindBin::Bin ne "/") {
		if( open(ERRORLOG, ">>$FindBin::Bin/exec/data/error_log.cgi") ) {
			carpout(\*ERRORLOG);
		}
	} else {
		if( open(ERRORLOG, ">>./exec/data/error_log.cgi") ) {
			carpout(\*ERRORLOG);
		}
	}
}
use FCC::Controller;
#$| = 1;

{
	my $params = {};
	$params->{FCC_SELECTOR} = 'Admin';
	require FindBin::Real;
	$params->{CGI_DIR} = FindBin::Real::Bin();
	$params->{CGI_FILE} = FindBin::Real::Bin() . '/' . $0;
	$params->{BASE_DIR} = FindBin::Real::Bin() . '/exec';
	if(-e $params->{CGI_FILE} && -o $params->{CGI_FILE}) {
		$params->{SUEXEC} = 1;
	} else {
		$params->{SUEXEC} = 0;
	}
	my $c = new FCC::Controller(params=>$params);
	$c->dispatch();
}
exit;

