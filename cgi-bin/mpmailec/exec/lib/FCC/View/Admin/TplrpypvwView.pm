package FCC::View::Admin::TplrpypvwView;
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
		my $wrap_num = $self->{conf}->{rpy_word_wrap};
		if( ! defined $wrap_num || $wrap_num eq "") {
			$wrap_num = 0;
		}
		if($wrap_num >= 50) {
			$body = FCC::Class::String::WordWrap->new($body)->word_wrap($wrap_num);
		}
		#
		my $t = $self->load_template();
		$t->param("body" => CGI::Utils->new()->escapeHtml($body));
		$t->param("rpy_item" => "\%$self->{conf}->{rpy_item}\%");
		$t->param("rpy_from" => CGI::Utils->new()->escapeHtml($self->{conf}->{rpy_from}));
		$t->param("rpy_sender" => CGI::Utils->new()->escapeHtml($self->{conf}->{rpy_sender}));
		$t->param("rpy_subject" => CGI::Utils->new()->escapeHtml($self->{conf}->{rpy_subject}));
		$t->param("rpy_cc" => CGI::Utils->new()->escapeHtml($self->{conf}->{rpy_cc}));
		$t->param("rpy_bcc" => CGI::Utils->new()->escapeHtml($self->{conf}->{rpy_bcc}));
		$t->param("rpy_priority" => $self->{conf}->{rpy_priority});
		$t->param("rpy_priority_$self->{conf}->{rpy_priority}" => 1);
		$t->param("rpy_notification" => $self->{conf}->{rpy_notification});
		#出力
		$self->print_html($t);
	}
}

1;
