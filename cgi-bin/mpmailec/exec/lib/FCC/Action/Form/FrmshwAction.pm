package FCC::Action::Form::FrmshwAction;
$VERSION = 1.00;
use strict;
use warnings;
use base qw(FCC::Action::Form::_SuperAction);
use CGI::Utils;
use FCC::Class::String::Checker;
use FCC::Class::HTTP::MobileAgent;

sub dispatch {
	my($self) = @_;
	my $context = {};
	#プロセスセッション
	my $sid = $self->{session}->{sid};
	my $pid = $self->{session}->{data}->{pid};
	my $proc = $self->{session}->{data}->{proc};
	if( defined $proc ) {
		$context->{proc} = $proc;
	} else {
		my $items = $self->{items};
		my $in = {};
		my $hidden = {};
		while( my($name, $ref) = each %{$items} ) {
			my $type = $ref->{type};
			#テキスト入力フィールド/テキストエリア
			if($type =~ /^(1|6)$/) {
				$in->{$name} = $ref->{"type_${type}_value"};
			#ラジオボタン
			} elsif($type eq "3") {
				my @elements = split(/\n+/, $ref->{type_3_elements});
				for my $elm (@elements) {
					if($elm =~ /^\*(.+)/) {
						$in->{$name} = $1;
						last;
					}
				}
			#チェックボックス/セレクトメニュー
			} elsif($type =~ /^(4|5)$/) {
				my @elements = split(/\n+/, $ref->{"type_${type}_elements"});
				my @checked;
				for my $elm (@elements) {
					if($elm =~ /^\*(.+)/) {
						push(@checked, $1);
					}
				}
				$in->{$name} = \@checked;
			#非表示フィールド
			} elsif($type eq "8") {
				my $default = $ref->{"type_${type}_value"};
				if( ! defined $default ) {
					$default = "";
				}
				if($ref->{type_8_handover}) {
					my $var = $self->{q}->param($name);
					if( ! defined $var || $var eq "" ) {
						$var = $ref->{type_8_value};
					}
					if($var) {
						my $len = FCC::Class::String::Checker->new($var, "utf8")->get_char_num();
						if($ref->{type_8_minlength} && $len < $ref->{type_8_minlength}) {
							$context->{fatalerrs} = ['parameter error'];
							return $context;
						} elsif($ref->{type_8_maxlength} && $len > $ref->{type_8_maxlength}) {
							$context->{fatalerrs} = ['parameter error'];
							return $context;
						} else {
							$in->{$name} = $var;
						}
					} elsif($ref->{required}) {
						$context->{fatalerrs} = ['parameter error'];
						return $context;
					}
				} else {
					$in->{$name} = $default;
				}
				$hidden->{$name} = CGI::Utils->new()->escapeHtml($in->{$name});
			}
		}
		#hidden
		$hidden->{pid} = $self->{session}->{data}->{pid};
		unless($self->{conf}->{cookie_available}) {
			$hidden->{sid} = $self->{session}->{sid};
		}
		$hidden->{m} = "cfmsmt";
		my $carrier = FCC::Class::HTTP::MobileAgent->new()->carrier();
		if($carrier eq "DoCoMo") {
			$hidden->{guid} = "ON";
		}
		#
		$context->{proc} = {
			in => $in,
			hidden => $hidden,
			errs => []
		};
	}
	if($self->{conf}->{cookie_available}) {
		delete $context->{proc}->{hidden}->{sid};
	}
	$context->{proc}->{hidden}->{m} = "cfmsmt";
	$context->{proc}->{hidden}->{pid} = $pid;
	#セッションをアップデート
	$self->{session}->update( { proc => $context->{proc} } );
	#
	return $context;
}

1;
