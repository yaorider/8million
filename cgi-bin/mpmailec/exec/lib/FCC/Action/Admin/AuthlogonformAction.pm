package FCC::Action::Admin::AuthlogonformAction;
$VERSION = 1.00;
use strict;
use warnings;
use base qw(FCC::Action::Admin::_SuperAction);
use FCC::Class::Passwd;

sub dispatch {
	my($self) = @_;
	my $context = {};
	#管理者ID/PWが登録されているかをチェック
	my $pw = new FCC::Class::Passwd(conf=>$self->{conf});
	unless($pw) { die $!; }
	$context->{password_num} = $pw->get_passwd_num();
	#
	return $context;
}

1;
