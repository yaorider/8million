package FCC::View::Form::FrmshwView;
$VERSION = 1.00;
use strict;
use warnings;
use base qw(FCC::View::Form::_SuperView);
use CGI::Utils;
use FCC::Class::HTTP::Cookie;
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
	my($t, $meta) = $self->load_template("frm");
	#項目
	my $items = $self->{items};
	#データのプリセット
	while( my($name, $v) = each %{$context->{proc}->{in}} ) {
		if( ! defined $v ) { $v = ""; }
		my $itm = $items->{$name};
		if($itm->{type} =~ /^(1|2|6)$/) {
			$t->param($name => CGI::Utils->new()->escapeHtml($v));
		} elsif($itm->{type} eq "3") {
			my @elements = split(/\n+/, $itm->{type_3_elements});
			my $idx = 1;
			for my $elm (@elements) {
				$elm =~ s/^\*//;
				if( $elm eq $v ) {
					$t->param("${name}_${idx}_checked" => 'checked="checked"');
					last;
				}
				$idx ++;
			}
		} elsif($itm->{type} eq "4" && ref($v) eq "ARRAY" && @{$v}) {
			my @elements = split(/\n+/, $itm->{type_4_elements});
			my $idx = 1;
			for my $elm (@elements) {
				$elm =~ s/^\*//;
				if( my $n = grep(/^\Q${elm}\E$/, @{$v}) ) {
					$t->param("${name}_${idx}_checked" => 'checked="checked"');
				}
				$idx ++;
			}
		} elsif($itm->{type} eq "5" && ref($v) eq "ARRAY" && @{$v}) {
			my @elements = split(/\n+/, $itm->{type_5_elements});
			my $idx = 1;
			for my $elm (@elements) {
				$elm =~ s/^\*//;
				if( my $n = grep(/^\Q${elm}\E$/, @{$v}) ) {
					$t->param("${name}_${idx}_selected" => 'selected="selected"');
				}
				$idx ++;
			}
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
	#エラー
	if( my $errs = @{$context->{proc}->{errs}} ) {
		$t->param("errs" => $errs);
		my @err_loop;
		for my $ref ( @{$context->{proc}->{errs}} ) {
			my $name = $ref->[0];
			$t->param("${name}-err" => "err");
			my $err = CGI::Utils->new()->escapeHtml($ref->[1]);
			push(@err_loop, { err => $err });
			$t->param("${name}-err-msg" => $err);
		}
		$t->param("err_loop" => \@err_loop);
	}
	#form.cgiのURL
	my $carrier = FCC::Class::HTTP::MobileAgent->new()->carrier();
	if($carrier eq "DoCoMo") {
		$t->param("form_cgi_url" => "$self->{conf}->{CGI_URL_PATH}?guid=ON");
	} else {
		$t->param("form_cgi_url" => $self->{conf}->{CGI_URL_PATH});
	}
	#Cookie
	my $secure = 0;
	if( $self->{conf}->{CGI_URL} =~ /^https\:\/\// ) {
		$secure = 1;
	}
	my $cookie = new FCC::Class::HTTP::Cookie(
		-name   => 'sid',
		-value  => $sid,
		-secure => $secure
	);
	my $hdrs = {
		'Set-Cookie' => $cookie->as_string,
		'Cache-Control' => 'no-cache',
		'Pragma' => 'no-cache',
		'content-type' => $meta->{ctype}
	};
	#
	$self->print_html($t, $hdrs);
}

1;
