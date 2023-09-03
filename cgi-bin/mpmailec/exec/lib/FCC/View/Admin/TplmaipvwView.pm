package FCC::View::Admin::TplmaipvwView;
$VERSION = 1.00;
use strict;
use warnings;
use base qw(FCC::View::Admin::_SuperView);
use FCC::Class::Date::Utils;
use FCC::Class::String::WordWrap;

sub dispatch {
	my($self, $context) = @_;
	#システムエラーの評価
	if($context->{fatalerrs}) {
		$self->error($context->{fatalerrs});
		exit;
	}
	#プロセスキー
	my $pkey = $context->{proc}->{pkey};
	#
	if(@{$context->{proc}->{errs}}) {
		$self->error($context->{fatalerrs});
	} else {
		my $bodyt = $context->{proc}->{t};
		my $body = $bodyt->output();
		#ワードラップ
		my $wrap_num = $self->{conf}->{mai_word_wrap};
		if( ! defined $wrap_num || $wrap_num eq "") {
			$wrap_num = 0;
		}
		if($wrap_num >= 50) {
			$body = FCC::Class::String::WordWrap->new($body)->word_wrap($wrap_num);
		}
		#
		my $t = $self->load_template();
		$t->param("body" => CGI::Utils->new()->escapeHtml($body));
		$t->param("mai_subject" => CGI::Utils->new()->escapeHtml($self->{conf}->{mai_subject}));
		$t->param("mai_to" => CGI::Utils->new()->escapeHtml($self->{conf}->{mai_to}));
		$t->param("mai_cc" => CGI::Utils->new()->escapeHtml($self->{conf}->{mai_cc}));
		$t->param("mai_bcc" => CGI::Utils->new()->escapeHtml($self->{conf}->{mai_bcc}));
		my $mai_from = $self->{conf}->{mai_from};
		if($mai_from) {
			$t->param("mai_from" => "\%${mai_from}\%");
		} else {
			my $mai_from_default = $self->{conf}->{mai_from_default};
			$t->param("mai_from" => CGI::Utils->new()->escapeHtml($mai_from_default));
		}
		$t->param("mai_sender" => CGI::Utils->new()->escapeHtml($self->{conf}->{mai_sender}));
		$t->param("mai_addon_headers" => CGI::Utils->new()->escapeHtml($self->{conf}->{mai_addon_headers}));
		if($self->{conf}->{mai_addon_headers}) {
			my @mai_addon_headers_loop;
			my @lines = split(/\n+/, $self->{conf}->{mai_addon_headers});
			for my $line (@lines) {
				if($line =~ /^([^\:\s]+)\s*\:\s*(.+)/) {
					my %hash;
					$hash{key} = CGI::Utils->new()->escapeHtml($1);
					$hash{value} = CGI::Utils->new()->escapeHtml($2);
					push(@mai_addon_headers_loop, \%hash);
				}
			}
			$t->param("mai_addon_headers_loop" => \@mai_addon_headers_loop);
		}
		#出力
		$self->print_html($t);
	}
}

1;
