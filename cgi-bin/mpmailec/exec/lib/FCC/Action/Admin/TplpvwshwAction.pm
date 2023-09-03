package FCC::Action::Admin::TplpvwshwAction;
$VERSION = 1.00;
use strict;
use warnings;
use base qw(FCC::Action::Admin::_SuperAction);
use FCC::Class::Mpfmec::Tpl;

sub dispatch {
	my($self) = @_;
	my $context = {};
	my $proc = {};
	#入力値のname属性値のリスト
	my $in_names = ['tid', 'tpl'];
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
		$proc->{tplobj} = new FCC::Class::Mpfmec::Tpl(conf=>$self->{conf});
		$proc->{t} = $proc->{tplobj}->get_for_render($proc->{in}->{tid}, $proc->{in}->{tpl});
		$proc->{tplobj}->preset_default_values($proc->{in}->{tid}, $proc->{t});
	}
	#
	$context->{proc} = $proc;
	return $context;
}

sub input_check {
	my($self, $names, $in) = @_;
	my %cap = (
		tid      => 'テンプレート識別ID',
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
