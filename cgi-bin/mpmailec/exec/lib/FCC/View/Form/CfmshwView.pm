package FCC::View::Form::CfmshwView;
$VERSION = 1.00;
use strict;
use warnings;
use base qw(FCC::View::Form::_SuperView);
use CGI::Utils;
use FCC::Class::HTTP::MobileAgent;

sub dispatch {
	my($self, $context) = @_;
	#システムエラーの評価
	if($context->{fatalerrs}) {
		$self->error($context->{fatalerrs});
		exit;
	}
	#セッションID
	my $sid = $self->{session}->{sid};
	my $pid = $self->{session}->{data}->{pid};
	#テンプレートのロード
	my($t, $meta) = $self->load_template("cfm");
	#
	$t->param("sid" => $self->{session}->{sid});
	#項目
	my $items = $self->{items};
	#データのプリセット
	while( my($name, $v) = each %{$context->{proc}->{in}} ) {
		if( ! defined $v ) { $v = ""; }
		my $itm = $items->{$name};
		#テキスト入力フィールド
		if($itm->{type} eq "1") {
			$t->param($name => CGI::Utils->new()->escapeHtml($v));
		#パスワード入力フィールド
		} elsif($itm->{type} eq "2") {
			$t->param($name => CGI::Utils->new()->escapeHtml($v));
			my $secret = '*' x length($v);
			$t->param("${name}_secret" => $secret);
		#ラジオボタン
		} elsif($itm->{type} eq "3") {
			my @elements = split(/\n+/, $itm->{type_3_elements});
			for my $elm (@elements) {
				$elm =~ s/^\*//;
				if( $elm eq $v ) {
					$t->param("${name}" => CGI::Utils->new()->escapeHtml($v));
					last;
				}
			}
		#チェックボックス
		} elsif($itm->{type} eq "4" && ref($v) eq "ARRAY" && @{$v}) {
			my @elements = split(/\n+/, $itm->{type_4_elements});
			my @element_loop;
			for my $elm (@elements) {
				$elm =~ s/^\*//;
				if( my $n = grep(/^\Q${elm}\E$/, @{$v}) ) {
					my %hash;
					$hash{element} = CGI::Utils->new()->escapeHtml($elm);
					$hash{type_4_arrangement} = $itm->{type_4_arrangement};
					push(@element_loop, \%hash);
				}
			}
			$t->param("${name}_element_loop" => \@element_loop);
			if( defined $v->[0] ) {
				$t->param($name => CGI::Utils->new()->escapeHtml($v->[0]));
			}
		#セレクトメニュー
		} elsif($itm->{type} eq "5" && ref($v) eq "ARRAY" && @{$v}) {
			my @elements = split(/\n+/, $itm->{type_5_elements});
			my @element_loop;
			for my $elm (@elements) {
				$elm =~ s/^\*//;
				if( my $n = grep(/^\Q${elm}\E$/, @{$v}) ) {
					my %hash;
					$hash{element} = CGI::Utils->new()->escapeHtml($elm);
					$hash{type_5_arrangement} = $itm->{type_5_arrangement};
					push(@element_loop, \%hash);
				}
			}
			$t->param("${name}_element_loop" => \@element_loop);
			if( defined $v->[0] ) {
				$t->param($name => CGI::Utils->new()->escapeHtml($v->[0]));
			}
		#テキストエリア
		} elsif($itm->{type} eq "6") {
			my $escaped = CGI::Utils->new()->escapeHtml($v);
			$t->param($name => $escaped);
			$escaped =~ s/\n/<br \/>/g;
			$t->param("${name}_with_br" => $escaped);
		#ファイル添付
		} elsif($itm->{type} eq "7" && ref($v) eq "HASH") {
			while( my($key, $value) = each %{$v} ) {
				$t->param("${name}_${key}" => CGI::Utils->new()->escapeHtml($value));
			}
			$t->param($name => CGI::Utils->new()->escapeHtml($v->{name}));
			my $thumb_src = "$self->{conf}->{CGI_URL}?m=imgshw&amp;pid=${pid}&amp;name=${name}&amp;tm=" . time;
			if( ! $self->{session}->{data}->{cookie_available} ) {
				$thumb_src .= "&amp;sid=${sid}";
			}
			$t->param("${name}_thumb_src" => $thumb_src);
			$t->param($name => CGI::Utils->new()->escapeHtml($v->{filename}));
		}
	}
	#hiddenタグ
	my $hidden_tag;
	while( my($k, $v) = each %{$context->{proc}->{hidden}} ) {
		if($meta->{doctype} =~ /XHTML/i) {
			$hidden_tag .= "<input type=\"hidden\" name=\"${k}\" value=\"${v}\" />";
		} else {
			$hidden_tag .= "<input type=\"hidden\" name=\"${k}\" value=\"${v}\">";
		}
	}
	$t->param("hidden" => $hidden_tag);
	#back url
	my $back_url = "$self->{conf}->{CGI_URL}?m=frmshw";
	$back_url .= "&amp;pid=${pid}";
	if( ! $self->{session}->{data}->{cookie_available} ) {
		$back_url .= "&amp;sid=${sid}";
	}
	my $carrier = FCC::Class::HTTP::MobileAgent->new()->carrier();
	if($carrier eq "DoCoMo") {
		$back_url .= "&amp;guid=ON";
	}
	$t->param("back_url" => $back_url);
	#form.cgiのURL
	if($carrier eq "DoCoMo") {
		$t->param("form_cgi_url" => "$self->{conf}->{CGI_URL_PATH}?guid=ON");
	} else {
		$t->param("form_cgi_url" => $self->{conf}->{CGI_URL_PATH});
	}
	#
	my $hdrs = {
		'Cache-Control' => 'no-cache',
		'Pragma' => 'no-cache',
		'content-type' => $meta->{ctype}
	};
	$self->print_html($t, $hdrs);
}

1;
