package FCC::View::_SuperView;
$VERSION = 1.00;
use strict;
use warnings;
use base qw(FCC::_Super);
use HTML::Template;
use File::Read;
use CGI;
use CGI::Utils;

sub load_template {
	my($self, $f) = @_;
	unless($f) {
		if($self =~ /^FCC::View::([\w\:]+)/) {
			my $v = $1;
			$v =~ s/\:\:/\//g;
			$v =~ s/View$//;
			if($v =~ /\/Default$/) {
				my $m = $self->{q}->param('m');
				if($m) {
					if($m =~ /[^a-zA-Z0-9]/) {
						$self->error404();
					} else {
						$m = ucfirst $m;
						$v =~ s/\/Default$/\/${m}/;
					}
				} else {
					$v =~ s/\/Default$/\/Index/;
				}
			}
			$f = "$self->{conf}->{BASE_DIR}/template/${v}.tpl";
			unless( -e $f ) {
				$f = "$self->{conf}->{BASE_DIR}/template/${v}.html";
			}
		} else {
			$self->error404();
		}
	}
	unless( -e $f ) {
		$self->error404();
	}
	#テンプレートファイルをロード
	my $tmpl = File::Read::read_file($f);
	#HTML::Templateオブジェクトを生成
	my $params = {};
	my $filter = sub {
		my $text_ref = shift;
		my $regexpfilter = sub {
			my($name,$paramstr) = @_;
			my @ary = split(/\s+/, $paramstr);
			for my $pair (@ary) {
				if( my($k, $v) = $pair =~ /^([A-Z\_]+)\=\"([\d\,]+)\"/ ) {
					$params->{$name}->{$k} = $v;
				}
			}
			return "<TMPL_LOOP NAME=\"${name}\">";
		};
		$$text_ref =~ s/<TMPL_LOOP\s+NAME=\"([^\s\t]+)\"\s+([^\>\<]+)>/&{$regexpfilter}($1,$2)/eg;
	};
	my $t = HTML::Template->new(
		scalarref => \$tmpl,
		die_on_bad_params => 0,
		vanguard_compatibility_mode => 1,
		loop_context_vars => 1,
		case_sensitive => 1,
		filter => $filter
	);
	unless($self->{q}) {
		$self->{q} = new CGI;
	}
	$t->param('CGI_URL' => $self->{conf}->{CGI_URL});
	$t->param('static_url' => $self->{conf}->{static_url});
	$t->param('product_version' => $self->{conf}->{product_version});
	$t->param('product_name' => CGI::Utils->new()->escapeHtml($self->{conf}->{product_name}));
	$t->param('copyright_flag' => $self->{conf}->{copyright_flag});
	$t->param('copyright_caption' => CGI::Utils->new()->escapeHtml($self->{conf}->{copyright_caption}));
	$t->param('product_author_url' => $self->{conf}->{product_author_url});
	my $product_info_url = $self->{conf}->{product_info_url};
	if($self->{conf}->{CGI_URL} =~ /^https\:/ || $self->{conf}->{CGI_URL} !~ /^http/) {
		$product_info_url =~ s/^http\:/https\:/;
	}
	$t->param('product_info_url' => $product_info_url);
	return $t;
}

sub print_html {
	my($self, $t, $hdrs_ref) = @_;
	my %hdrs;
	if($hdrs_ref) {
		while( my($k, $v) = each %{$hdrs_ref} ) {
			$k = lc $k;
			$hdrs{$k} = $v;
		}
	}
 	#ヘッダー初期値
	unless($hdrs{"content-type"}) {
 		$hdrs{"content-type"} = "text/html; charset=utf-8";
 	}
 	#テンプレートを展開
 	my $body = $t->output();
	#ヘッダーにContent-Lengthをセット
	$hdrs{"content-length"} = length $body;
	#出力
	while( my($k, $v) = each %hdrs ) {
		my $name = $k;
		$name =~ s/^([a-z]+)\-([a-z]+)$/\u$1\-\u$2/;
		if( ref($v) && ref($v) eq "ARRAY") {
			for my $str (@{$v}) {
				print STDOUT "${name}: ${str}\n";
			}
		} else {
			print STDOUT "${name}: ${v}\n";
		}
	}
	print STDOUT "\n";
	print STDOUT $body;
	exit;
}

sub error404 {
	my($self) = @_;
	my $body=<<EOM;
<!DOCTYPE HTML PUBLIC "-//IETF//DTD HTML 2.0//EN">
<html><head>
<title>404 Not Found</title>
</head><body>
<h1>Not Found</h1>
<p>The requested URL $ENV{REQUEST_URI} was not found on this server.</p>
</body></html>
EOM
	my $content_length = length $body;
	unless($self->{q}) {
		$self->{q} = new CGI;
	}
	print $self->{q}->header(
		-status         => '404 Not Found',
		-type           => 'text/html; charset=iso-8859-1',
		-Content_length => $content_length
	);
	print $body;
	exit;
}

1;
