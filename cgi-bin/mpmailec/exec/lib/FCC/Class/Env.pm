package FCC::Class::Env;
$VERSION = 1.00;
use strict;
use warnings;
use base qw(FCC::_Super);
use Carp;
use File::Basename;

sub init {
	my($self, %args) = @_;
	$self->{q} = $args{q};
}

#---------------------------------------------------------------------
#■CGIのURLを取得
#---------------------------------------------------------------------
#[引数]
#	なし
#[戻り値]
#	hashref
#	{
#		CGI_URL => "http://www.futomi.com/framework/admin.cgi",
#		CGI_URL_PATH => "/framework/admin.cgi",
#		CGI_DIR_URL => "http://www.futomi.com/framework",
#		CGI_DIR_URL_PATH => "/framework"
#	}
#---------------------------------------------------------------------
sub get_url_path {
	my($self) = @_;
	my $c = {};
	$c->{CGI_URL} = $self->{q}->url();	# http://www.futomi.com/framework/admin.cgi
	$c->{CGI_URL_PATH} = $self->{q}->url(-absolute=>1);	# /framework/admin.cgi
	$c->{CGI_DIR_URL} = File::Basename::dirname($c->{CGI_URL});	# http://www.futomi.com/framework
	$c->{CGI_DIR_URL_PATH} = File::Basename::dirname($c->{CGI_URL_PATH});	# /framework
	#
	my @cgi_path_parts = split(/\//, $ENV{SCRIPT_FILENAME});
	my $cgi_file_name = pop @cgi_path_parts;
	#TurboLinux系のレンタルサーバ（例：ドメインキーパーblueBlock、ドメインキーパーblueBlock共有SSL）
	if($ENV{REDIRECT_SCRIPT_URI} && $ENV{REDIRECT_SCRIPT_URI} =~ /^https?\:\/\//) {
		my $cgi_url = $ENV{REDIRECT_SCRIPT_URI};
		$cgi_url =~ s/\?.*$//;
		$c->{CGI_URL} = $cgi_url;
		($c->{CGI_URL_PATH}) = $c->{CGI_URL} =~ /^https?\:\/\/[^\/]+(.*)/;
		$c->{CGI_DIR_URL} = File::Basename::dirname($cgi_url);
		$c->{CGI_DIR_URL_PATH} = File::Basename::dirname($c->{CGI_URL_PATH});
		if($c->{CGI_DIR_URL_PATH} eq "/") {
			$c->{CGI_DIR_URL_PATH} = "";
		}
	#リバースプロクシー（例：チカッパ！の共有SSL）
	} elsif($ENV{HTTP_X_FORWARDED_HOST} || $ENV{HTTP_X_FORWARDED_SERVER}) {
		$c->{CGI_URL} = $cgi_file_name;
		$c->{CGI_URL_PATH} = $cgi_file_name;
		$c->{CGI_DIR_URL} = ".";
		$c->{CGI_DIR_URL_PATH} = ".";
	#リバースプロクシー（例：さくらインターネットのレンタルサーバの共有SSL）
	} elsif($ENV{HTTP_X_FORWARDED_FOR} && $ENV{REMOTE_ADDR} && $ENV{HTTP_X_FORWARDED_FOR} =~ /^[\d\.]+$/ && $ENV{HTTP_X_FORWARDED_FOR} eq $ENV{REMOTE_ADDR} ) {
		$c->{CGI_URL} = $cgi_file_name;
		$c->{CGI_URL_PATH} = $cgi_file_name;
		$c->{CGI_DIR_URL} = ".";
		$c->{CGI_DIR_URL_PATH} = ".";
	}
	#
	return $c;
}

1;
