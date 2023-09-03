package FCC::Action::Admin::TplmaisetAction;
$VERSION = 1.00;
use strict;
use warnings;
use base qw(FCC::Action::Admin::_SuperAction);
use CGI::Utils;
use HTML::Template;
use FCC::Class::Mpfmec::TplMai;

sub dispatch {
	my($self) = @_;
	my $context = {};
	#プロセスセッション
	my $pkey = $self->{q}->param("pkey");
	my $proc = $self->get_proc_session_data($pkey, "tplmai");
	if( ! $proc) {
		$context->{fatalerrs} = ["不正なリクエストです。"];
		return $context;
	}
	#入力値のname属性値のリスト
	my $in_names = ['tpl'];
	#入力値を取得
	$proc->{in} = $self->get_input_data($in_names);
	#入力値チェック
	my @errs = $self->input_check($in_names, $proc->{in});
	#エラーハンドリング
	if(@errs) {
		$proc->{errs} = \@errs;
		$self->set_proc_session_data($proc);
	} else {
		$proc->{errs} = [];
		FCC::Class::Mpfmec::TplMai->new(conf=>$self->{conf})->set($proc->{in}->{tpl});
	}
	#
	$context->{proc} = $proc;
	return $context;
}

sub input_check {
	my($self, $names, $in) = @_;
	my %cap = (
		tpl      => 'テンプレート内容'
	);
	my @errs;
	for my $k (@{$names}) {
		my $v = $in->{$k};
		if( ! defined $v ) { $v = ""; }
		$v =~ s/\x0d\x0a/\n/g;
		$v =~ s/\x0d/\n/g;
		$v =~ s/\x0a/\n/g;
		$v =~ s/^\n+//;
		$v =~ s/\n+$//;
		#テンプレート内容
		if($k eq "tpl" && $v ne "") {
			eval {
				my $t = HTML::Template->new(
					scalarref => \$v,
					die_on_bad_params => 0,
					vanguard_compatibility_mode => 1,
					loop_context_vars => 1
				);
			};
			if($@) {
				my $err = CGI::Utils->new()->escapeHtml($@);
				push(@errs, [$k, "\"$cap{$k}\"にテンプレート記述ミスがあります。: ${err}"]);
			}
		}
		$in->{$k} = $v;
	}
	#
	return @errs;
}

1;
