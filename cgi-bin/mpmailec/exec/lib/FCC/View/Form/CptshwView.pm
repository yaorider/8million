package FCC::View::Form::CptshwView;
$VERSION = 1.00;
use strict;
use warnings;
use base qw(FCC::View::Form::_SuperView);
use CGI::Utils;
use FCC::Class::HTTP::Cookie;

sub dispatch {
	my($self, $context) = @_;
	#システムエラーの評価
	if($context->{fatalerrs}) {
		$self->error($context->{fatalerrs});
		exit;
	}
	#セッションID
	my $sid = $self->{session}->{sid};
	#テンプレートのロード
	my($t, $meta) = $self->load_template("cpt");
	#
	if( $context->{proc}->{input_valid} ) {
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
				$t->param("${name}_url_encoded" => CGI::Utils->new()->urlEncode($v));
			#パスワード入力フィールド
			} elsif($itm->{type} eq "2") {
				$t->param($name => CGI::Utils->new()->escapeHtml($v));
				my $secret = '*' x length($v);
				$t->param("${name}_secret" => $secret);
				$t->param("${name}_url_encoded" => CGI::Utils->new()->urlEncode($v));
			#ラジオボタン
			} elsif($itm->{type} eq "3") {
				my @elements = split(/\n+/, $itm->{type_3_elements});
				for my $elm (@elements) {
					$elm =~ s/^\*//;
					if( $elm eq $v ) {
						$t->param("${name}" => CGI::Utils->new()->escapeHtml($v));
						$t->param("${name}_url_encoded" => CGI::Utils->new()->urlEncode($v));
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
					$t->param("${name}_url_encoded" => CGI::Utils->new()->urlEncode($v->[0]));
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
					$t->param("${name}_url_encoded" => CGI::Utils->new()->urlEncode($v->[0]));
				}
			#テキストエリア
			} elsif($itm->{type} eq "6") {
				my $escaped = CGI::Utils->new()->escapeHtml($v);
				$t->param($name => $escaped);
				$escaped =~ s/\n/<br \/>/g;
				$t->param("${name}_with_br" => $escaped);
				$t->param("${name}_url_encoded" => CGI::Utils->new()->urlEncode($v));
			#ファイル添付
			} elsif($itm->{type} eq "7" && ref($v) eq "HASH") {
				while( my($key, $value) = each %{$v} ) {
					$t->param("${name}_${key}" => CGI::Utils->new()->escapeHtml($value));
				}
				$t->param($name => CGI::Utils->new()->escapeHtml($v->{filename}));
				$t->param("${name}_url_encoded" => CGI::Utils->new()->urlEncode($v->{name}));
			}
		}
		#受付シリアル番号
		$t->param("SERIAL" => $context->{proc}->{serial}->{SERIAL});
		$t->param("SERIAL_url_encoded" => CGI::Utils->new()->urlEncode($context->{proc}->{serial}->{SERIAL}));
		#A8FLY
		if($context->{proc}->{a8fly} && $context->{proc}->{a8fly}->{a8f_enable}) {
			while( my($k, $v) = each %{$context->{proc}->{a8fly}} ) {
				$t->param($k => $v);
			}
		}
		#セッションを削除
		$self->{session}->remove();
	}
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
		'Set-Cookie' => $cookie->as_string,
		'Cache-Control' => 'no-cache',
		'Pragma' => 'no-cache',
		'content-type' => $meta->{ctype}
	};
	#
	if( $context->{proc}->{input_valid} ) {
		#指定URLへリダイレクト
		if($self->{conf}->{thx_redirect_enable}) {
			print "Location: $self->{conf}->{thx_redirect_url}\n\n";
		#テンプレートを使ってCGIが出力
		} else {
			$self->print_html($t, $hdrs);
		}
	} else {
		print "Location: $self->{conf}->{CGI_URL}?m=frmshw\n\n";
	}
}

1;
