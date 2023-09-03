package FCC::Action::Install::P4shwAction;
$VERSION = 1.00;
use strict;
use warnings;
use base qw(FCC::Action::Install::_SuperAction);
use FCC::Class::Passwd;

sub dispatch {
	my($self) = @_;
	my $context = {};
	#
	my $smt = $self->{q}->param("smt");
	unless($smt) { $smt = 0; }
	if($smt !~ /^(0|1)$/) {
		$context->{fatalerrs} = ["パラメーターエラー(1)"];
		return $context;
	}
	#
	my $in = {};
	$in->{smt} = $smt;
	$in->{id} = $self->{q}->param('id');
	$in->{pass1} = $self->{q}->param('pass1');
	$in->{pass2} = $self->{q}->param('pass2');
	#IDをチェック
	my $pw = new FCC::Class::Passwd(conf=>$self->{conf});
	my $id_chk = $pw->check_id($in->{id});
	#エラー
	my @errs;
	if($smt) {
		if($id_chk) {
			if($id_chk == 1) {
				push(@errs, ["id", "管理者IDを入力してください。"]);
			} elsif($id_chk == 2) {
				push(@errs, ["id", "管理者IDは3文字以上でなければいけません。"]);
			} elsif($id_chk == 3) {
				push(@errs, ["id", "管理者IDは255文字以下でなければいけません。"]);
			} elsif($id_chk == 4) {
				push(@errs, ["id", "管理者IDは半角英数字および半角記号で指定してください。"]);
			}
		}
		if($in->{pass1} && $in->{pass2}) {
			if($in->{pass1} ne $in->{pass2}) {
				push(@errs, ["pass2", "パスワードが違います。"]);
			} else {
				my $pw_chk = $pw->check_pass($in->{pass1});
				if($pw_chk) {
					if($pw_chk == 1) {
						push(@errs, ["pass1", "パスワードを入力してください。"]);
					} elsif($pw_chk == 2) {
						push(@errs, ["pass1", "パスワードは3文字以上でなければいけません。"]);
					} elsif($pw_chk == 3) {
						push(@errs, ["pass1", "パスワードは255文字以下でなければいけません。"]);
					} elsif($pw_chk == 4) {
						push(@errs, ["pass1", "パスワードは半角英数字および半角記号で指定してください。"]);
					}
				}
			}
		} else {
			push(@errs, ["pass1", "パスワードを入力してください。"]);
		}
		#
		if( ! @errs) {
			eval {
				$pw->add( $in->{id}, { pass=>$in->{pass1} } );
			};
			if($@) {
				$context->{fatalerrs} = ["設定に失敗しました。: $@"];
				return $context;
			}
		}
	}
	#
	my $proc = {};
	$proc->{errs} = \@errs;
	$proc->{in} = $in;
	$context->{proc} = $proc;
	return $context;
}

1;
