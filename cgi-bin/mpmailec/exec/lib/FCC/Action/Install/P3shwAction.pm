package FCC::Action::Install::P3shwAction;
$VERSION = 1.00;
use strict;
use warnings;
use base qw(FCC::Action::Install::_SuperAction);
use Email::Valid;
use CGI::Utils;
use FCC::Class::String::Checker;

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
	my @errs;
	if($smt) {
		my @names = ("sendmail_path", "smtp_host", "smtp_port", "smtp_auth_user", "smtp_auth_pass", "mai_to");
		for my $k (@names) {
			my $v = $self->{q}->param($k);
			if( ! defined $v ) { $v = ""; }
			$in->{$k} = $v;
		}
		for my $k (@names) {
			my $v = $in->{$k};
			#sendmailのパス
			if($k eq "sendmail_path") {
				if($v) {
					if($v =~ /[^a-zA-Z\/\.\_\-\:]/) {
						push(@errs, [$k, "\"sendmailのパス\"に不正な文字が含まれています。"]);
					} elsif($v !~ /\/send/) {
						push(@errs, [$k, "\"sendmailのパス\"にsendmailコマンド以外の名前を指定することはできません。"]);
					} elsif( ! -e $v) {
						push(@errs, [$k, "\"sendmailのパス\"に指定したパスにsendmailコマンドが見つかりませんでした。"]);
					} elsif( ! -x $v) {
						push(@errs, [$k, "\"sendmailのパス\"に指定したsendmailコマンドに実行権限がありません。"]);
					}
				}
			#SMTPサーバ
			} elsif($k eq "smtp_host") {
				if($in->{sendmail_path}) {
					if($v ne "") {
						push(@errs, [$k, "\"SMTPサーバ\"を指定する場合は、\"sendmailのパス\"に何も指定しないでください。"]);
					}
				} else {
					if($v ne "") {
						if($v =~ /[^0-9a-zA-Z\-\.]/) {
							push(@errs, [$k, "\"SMTPサーバ\"が正しくありません。"]);
						}
					}
				}
			#SMTPポート番号
			} elsif($k eq "smtp_port") {
				if($in->{smtp_host} && $v eq "") {
					push(@errs, [$k, "\"SMTPポート番号\"を指定してください。"]);
				} elsif($v =~ /[^\d]/) {
					push(@errs, [$k, "\"SMTPポート番号\"は半角数字で指定してください。"]);
				}
			#SMTP認証のユーザー名
			} elsif($k eq "smtp_auth_user") {
				if($v ne "") {
					if($v =~ /[^\x21-\x7e]/) {
						push(@errs, [$k, "\"SMTP認証のユーザー名\"は半角文字で指定してください。"]);
					}
				} elsif($v eq "" && $in->{smtp_auth_pass} ne "") {
					push(@errs, [$k, "\"SMTP認証のユーザー名\"を指定してください。"]);
				}
			#SMTP認証のパスワード
			} elsif($k eq "smtp_auth_pass") {
				if($v ne "") {
					if($v =~ /[^\x21-\x7e]/) {
						push(@errs, [$k, "\"SMTP認証のパスワード\"は半角文字で指定してください。"]);
					}
				} elsif($v eq "" && $in->{smtp_auth_user} ne "") {
					push(@errs, [$k, "\"SMTP認証のパスワード\"を指定してください。"]);
				}
			#受信アドレス
			} elsif($k eq "mai_to") {
				$v =~ s/\s//g;
				my $n = FCC::Class::String::Checker->new($v, "utf8")->get_char_num();
				if($v eq "") {
					push(@errs, [$k, "\"受信アドレス\"は必須です。"]);
				} elsif($n > 1024) {
					push(@errs, [$k, "\"受信アドレス\"は1024文字以内で指定してください。"]);
				} else {
					my @parts = split(/,/, $v);
					my @list;
					for my $p (@parts) {
						if($p eq "") { next; }
						if( ! Email::Valid->rfc822($p) ) {
							my $escaped_v = CGI::Utils->new()->escapeHtml($p);
							push(@errs, [$k, "\"受信アドレス\"に指定した '${escaped_v}' はメールアドレスとして不適切です。"]);
						}
						push(@list, $p);
					}
					$v = join(",", @list);
				}
			}
			#
			$in->{$k} = $v;
		}
		unless(@errs) {
			eval {
				require FCC::Class::Syscnf;
				$in->{mai_from_default} = $in->{mai_to};
				FCC::Class::Syscnf->new(conf=>$self->{conf})->set($in);
			};
			if($@) {
				$context->{fatalerrs} = ["設定に失敗しました。: $@"];
				return $context;
			}
		}
	} else {
		$in->{sendmail_path} = $self->get_command_path("sendmail");
	}
	#
	my $proc = {};
	$proc->{errs} = \@errs;
	$proc->{in} = $in;
	$context->{proc} = $proc;
	return $context;
}

sub get_command_path {
	my($self, $command) = @_;
	my @pathes;
	if($command eq '') {return @pathes;}
	if($command =~ /[^a-zA-Z0-9\.\_\-]/) {return @pathes;}
	if($^O =~ /MSWin32/i) {return @pathes;}
	my @whereis_list = ('whereis', '/usr/bin/whereis', '/usr/ucb/whereis');
	for my $whereis (@whereis_list) {
		my $res = `$whereis $command`;
		if($res eq '') {
			next;
		} else {
			my @locations = split(/\s/, $res);
			for my $path (@locations) {
				if($path =~ /\/${command}$/) {
					push(@pathes, $path);
				}
			}
			last;
		}
	}
	my $num = scalar @pathes;
	unless($num) {
		my $path = `which $command`;
		if($path =~ /$command$/) {
			push(@pathes, $path);
		}
	}
	return $pathes[0];
}

1;
