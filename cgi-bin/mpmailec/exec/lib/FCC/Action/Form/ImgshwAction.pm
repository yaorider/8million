package FCC::Action::Form::ImgshwAction;
$VERSION = 1.00;
use strict;
use warnings;
use base qw(FCC::Action::Form::_SuperAction);

sub dispatch {
	my($self) = @_;
	my $context = {};
	#項目情報を取得
	my $items = $self->{items};
	#セッション情報を取得
	my $sid = $self->{session}->{sid};
	my $proc = $self->{session}->{data}->{proc};
	#name属性を取得
	my $name = $self->{q}->param("name");
	if( ! defined $name || $name eq "" || ! $items->{$name} || $items->{$name}->{type} ne "7" || ! $proc->{in}->{$name} || ! $proc->{in}->{$name}->{thumb} ) {
		$proc->{fatalerrs} = ["no image"];
		$context->{proc} = $proc;
		return $context;
	}
	#サムネイル画像情報
	my $thumb = $proc->{in}->{$name};
	#
	$context->{thumb} = $thumb;
	return $context;
}

1;
