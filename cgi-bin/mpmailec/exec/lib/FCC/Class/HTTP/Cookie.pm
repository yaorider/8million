package FCC::Class::HTTP::Cookie;
$VERSION = 1.00;
use strict;
use warnings;
use CGI::Cookie;

sub new {
	my($caller, %args) = @_;
	my $class = ref($caller) || $caller;
	my $self = {};
	$self->{name} = $args{"-name"};
	$self->{value} = $args{"-value"};
	$self->{expires} = $args{"-expires"};
	$self->{domain} = $args{"-domain"};
	$self->{path} = $args{"-path"};
	$self->{secure} = $args{"-secure"};
	bless $self, $class;
	return $self;
}

sub as_string {
	my($self) = @_;
	my $c = new CGI::Cookie(
		-name    =>  $self->{name},
		-value   =>  $self->{value},
		-expires =>  $self->{expires},
		-domain  =>  $self->{domain},
		-path    =>  $self->{path},
		-secure  =>  $self->{secure}
	);
	my $s = $c->as_string();
	my @pairs = split(/\;\s*/, $s);
	my @ary;
	for my $p (@pairs) {
		unless($p) { next; }
		my($k, $v) = split(/\=/, $p);
		if($self->{$k} || $k eq $self->{name}) {
			push(@ary, $p);
		}
	}
	my $cs = join("; ", @ary);
	return $cs;
}


1;
