package FCC::View::Admin::TplpvwshwView;
$VERSION = 1.00;
use strict;
use warnings;
use base qw(FCC::View::Admin::_SuperView);

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
	my $tid = $context->{proc}->{in}->{tid};
	#
	if(@{$context->{proc}->{errs}}) {
		$self->error($context->{fatalerrs});
	} else {
		my $tplobj = $context->{proc}->{tplobj};
		my $t = $context->{proc}->{t};
		my $tid = $context->{proc}->{in}->{tid};
		#$tplobj->show($tid, $t, 1);
		$tplobj->show($tid, $t);
	}
}

1;
