#!/usr/bin/perl
################################################################################
# MP Form Mail CGI eCommerce版 インストーラー
# Ver 2.0.5
# Copyright(C) futomi 2001 - 2009
# http://www.futomi.com/
###############################################################################
use strict;
BEGIN {
	if($] < 5.006001) {
		print "Content-Type: text/html; charset=utf-8\n\n";
		print "サーバにインストールされているPerlのバージョンが 5.6.1 未満のため、本システムはご利用頂けません。";
		exit;
	}
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
use warnings;
use FCC::ControllerInstall;
#$| = 1;

{
	my $params = {};
	$params->{FCC_SELECTOR} = 'Install';
	require FindBin::Real;
	$params->{CGI_DIR} = FindBin::Real::Bin();
	$params->{CGI_FILE} = FindBin::Real::Bin() . '/' . $0;
	$params->{BASE_DIR} = FindBin::Real::Bin() . '/exec';
	if(-e $params->{CGI_FILE} && -o $params->{CGI_FILE}) {
		$params->{SUEXEC} = 1;
	} else {
		$params->{SUEXEC} = 0;
	}
	my $c = new FCC::ControllerInstall(params=>$params);
	$c->dispatch();
}
exit;
