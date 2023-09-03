package FCC::Action::Admin::TopAction;
$VERSION = 1.00;
use strict;
use warnings;
use base qw(FCC::Action::Admin::_SuperAction);
use FCC::Class::Passwd;

sub dispatch {
	my($self) = @_;
	my $context = {};
	#ログオンアカウント情報を取得
	my $pw = new FCC::Class::Passwd(conf=>$self->{conf});
	unless($pw) {
		$context->{fatalerrs} = [$!];
		return $context;
	}
	$context->{acnt} = $pw->get($self->{session}->{data}->{id});
#
	return $context;
}

1;
