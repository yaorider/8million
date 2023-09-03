package FCC::Action::Form::CptsmtAction;
$VERSION = 1.00;
use strict;
use warnings;
use base qw(FCC::Action::Form::_SuperAction);
use Email::Valid;
use FCC::Class::Mail::Sendmail;
use FCC::Class::Date::Utils;
use FCC::Class::Mpfmec::TplMai;
use FCC::Class::Mpfmec::TplRpy;
use FCC::Class::String::WordWrap;
use FCC::Class::Mpfmec::Seq;
use FCC::Class::Mpfmec::Div;
use FCC::Class::Mpfmec::Log;

sub dispatch {
	my($self) = @_;
	my $context = {};
	#項目情報を取得
	my $items = $self->{items};
	#セッション
	my $sid = $self->{session}->{sid};
	#プロセスデータ
	my $proc = $self->{session}->{data}->{proc};
	if( ! defined $proc ) {
		$context->{fatalerrs} = ['system error'];
		return $context;
	}
	#入力値チェックを経ているかをチェック
	unless( $proc->{input_valid} ) {
		$context->{fatalerrs} = ['illegal access'];
		return $context;
	}
	#入力値
	my $in = $proc->{in};
	#現在の日時
	my $now = time;
	my %tm = FCC::Class::Date::Utils->new(time=>$now, tz=>$self->{conf}->{tz})->get_formated();
	my $now_rfc2822 = $tm{r};
	#受付シリアル番号
	my $serial = FCC::Class::Mpfmec::Seq->new(conf=>$self->{conf})->incr();
	$proc->{serial} = $serial;
	#リモートホスト
	my $remote_host = $self->get_remote_host();
	#送信先を決定
	my $send_to_list = $self->get_send_to_list($in);
	#テンポラリーディレクトリパス
	my $tmp_dir = $self->{session}->get_tmp_dir();
	#通知メールを送信
	my $attach_num = 0;
	if( defined $send_to_list->[0] && $send_to_list->[0]->{To} ) {
		#差出人アドレス
		my $from = $self->{conf}->{mai_from_default};
		my $mai_from_addr = "";
		if($self->{conf}->{mai_from}) {
			$mai_from_addr = $in->{$self->{conf}->{mai_from}};
		}
		if( $mai_from_addr && Email::Valid->address($mai_from_addr) ) {
			$from = $mai_from_addr;
		}
		#差出人名とサブジェクトを置換
		my $sender = $self->{conf}->{mai_sender};
		my $subject = $self->{conf}->{mai_subject};
		if( ! $sender ) { $sender = ""; }
		if( ! $subject ) { $subject = ""; }
		while( my($name, $ref) = each %{$items} ) {
			if($ref->{type} !~ /^(1|2|3|5|8)$/) { next; }
			if($ref->{type} == 5 && $ref->{type_5_multiple}) { next; }
			my $v = $in->{$name};
			if($ref->{type} == 5 && ref($v) eq "ARRAY") {
				my $elm = $v->[0];
				if( ! defined $elm ) { $elm = ""; }
				$sender =~ s/\%${name}\%/${elm}/g;
				$subject =~ s/\%${name}\%/${elm}/g;
			} else {
				if( ! defined $v ) { $v = ""; }
				$sender =~ s/\%${name}\%/${v}/g;
				$subject =~ s/\%${name}\%/${v}/g;
			}
		}
		$subject =~ s/\%SERIAL\%/$serial->{SERIAL}/g;
		#本文
		my @attachments;
		my $t = FCC::Class::Mpfmec::TplMai->new(conf=>$self->{conf})->get_for_render();
		while( my($name, $ref) = each %{$items} ) {
			my $v = $in->{$name};
			if( ! defined $v ) { $v = ""; }
			$t->param($name => $v);
			my $type = $ref->{type};
			if($type =~ /^(4|5)$/) {
				my @elms = split(/\n+/, $ref->{"type_${type}_elements"});
				my @element_loop;
				for my $elm (@elms) {
					$elm =~ s/^\*//;
					if( my $n = grep(/^\Q${elm}\E$/, @{$v}) ) {
						my %hash;
						$hash{element} = $elm;
						$hash{br} = "\n";
						push(@element_loop, \%hash);
					}
				}
				$t->param("${name}_element_loop" => \@element_loop);
			} elsif($type eq "2") { # パスワードフィールド
				my $v_secret = '*' x length($v);
				$t->param("${name}_secret" => $v_secret);
			} elsif($type eq "7") {
				if($v) {
					$t->param("${name}_filename" => $v->{filename});
					push(@attachments, $v);
					$attach_num ++;
				}
			}
		}
		while( my($k, $v) = each %tm ) {
			$t->param("RECEPTION_DATE_${k}" => $v);
		}
		$t->param("REMOTE_HOST" => $remote_host);
		$t->param("REMOTE_ADDR" => $ENV{REMOTE_ADDR});
		$t->param("HTTP_USER_AGENT" => $ENV{HTTP_USER_AGENT});
		$t->param("SERIAL" => $serial->{SERIAL});
		my $body = $t->output();
		#ワードラップ
		my $wrap_num = $self->{conf}->{mai_word_wrap};
		if( ! defined $wrap_num || $wrap_num eq "") {
			$wrap_num = 0;
		}
		if($wrap_num >= 50) {
			$body = FCC::Class::String::WordWrap->new($body)->word_wrap($wrap_num);
		}
		#メール送信
		for my $send_to (@{$send_to_list}) {
			#ヘッダー
			my $hdrs = {
				To => $send_to->{To},
				Cc => $send_to->{Cc},
				Bcc => $send_to->{Bcc},
				From => $from,
				Sender => $sender,
				Subject => $subject,
				Date => $now_rfc2822
			};
			if( $self->{conf}->{mai_addon_headers} ) {
				my @lines = split(/\n+/, $self->{conf}->{mai_addon_headers});
				for my $line (@lines) {
					if($line =~ /^([^\:\s]+)\s*\:\s*(.+)/) {
						$hdrs->{$1} = $2;
					}
				}
			}
			#メール送信
			my $mail = new FCC::Class::Mail::Sendmail(
				sendmail => $self->{conf}->{sendmail_path},
				smtp_host => $self->{conf}->{smtp_host},
				smtp_port => $self->{conf}->{smtp_port},
				smtp_auth_user => $self->{conf}->{smtp_auth_user},
				smtp_auth_pass => $self->{conf}->{smtp_auth_pass},
				body => $body,
				hdrs => $hdrs,
				attachments => \@attachments,
				tmp_dir => $tmp_dir
			);
			$mail->mailsend();
			if( my $error = $mail->error() ) {
				$context->{fatalerrs} = ["メール送信処理が失敗しました。 : ${error}"];
				return $context;
			}
		}
	}
	#自動返信
	my $rpy_to = $self->get_rpy_to($in);
	if( $self->{conf}->{rpy_enable} && $rpy_to ) {
		#サブジェクトを置換
		my $subject = $self->{conf}->{rpy_subject};
		if( ! $subject ) { $subject = ""; }
		while( my($name, $ref) = each %{$items} ) {
			if($ref->{type} !~ /^(1|2|3|5|8)$/) { next; }
			if($ref->{type} == 5 && $ref->{type_5_multiple}) { next; }
			my $v = $in->{$name};
			if($ref->{type} == 5 && ref($v) eq "ARRAY") {
				my $elm = $v->[0];
				if( ! defined $elm ) { $elm = ""; }
				$subject =~ s/\%${name}\%/${elm}/g;
			} else {
				if( ! defined $v ) { $v = ""; }
				$subject =~ s/\%${name}\%/${v}/g;
			}
		}
		$subject =~ s/\%SERIAL\%/$serial->{SERIAL}/g;
		#本文
		my @attachments;
		my $t = FCC::Class::Mpfmec::TplRpy->new(conf=>$self->{conf})->get_for_render();
		while( my($name, $ref) = each %{$items} ) {
			my $v = $in->{$name};
			if( ! defined $v ) { $v = ""; }
			$t->param($name => $v);
			my $type = $ref->{type};
			if($type =~ /^(4|5)$/) {
				my @elms = split(/\n+/, $ref->{"type_${type}_elements"});
				my @element_loop;
				for my $elm (@elms) {
					$elm =~ s/^\*//;
					if( my $n = grep(/^\Q${elm}\E$/, @{$v}) ) {
						my %hash;
						$hash{element} = $elm;
						$hash{br} = "\n";
						push(@element_loop, \%hash);
					}
				}
				$t->param("${name}_element_loop" => \@element_loop);
			} elsif($type eq "2") { # パスワードフィールド
				my $v_secret = '*' x length($v);
				$t->param("${name}_secret" => $v_secret);
			} elsif($type eq "7") {
				if($v) {
					$t->param("${name}_filename" => $v->{filename});
					push(@attachments, $v);
				}
			}
		}
		while( my($k, $v) = each %tm ) {
			$t->param("RECEPTION_DATE_${k}" => $v);
		}
		my $remote_host = $self->get_remote_host();
		$t->param("REMOTE_HOST" => $remote_host);
		$t->param("REMOTE_ADDR" => $ENV{REMOTE_ADDR});
		$t->param("HTTP_USER_AGENT" => $ENV{HTTP_USER_AGENT});
		$t->param("SERIAL" => $serial->{SERIAL});
		my $body = $t->output();
		#ワードラップ
		my $wrap_num = $self->{conf}->{rpy_word_wrap};
		if( ! defined $wrap_num || $wrap_num eq "") {
			$wrap_num = 0;
		}
		if($wrap_num >= 50) {
			$body = FCC::Class::String::WordWrap->new($body)->word_wrap($wrap_num);
		}
		#メールの重要度
		my $x_priority = $self->{conf}->{rpy_priority};
		my $x_msmail_priority;
		if($x_priority =~ /^(1|2)$/) {
			$x_msmail_priority = "High";
		} elsif($x_priority eq "3") {
			$x_msmail_priority = "Normal";
		} elsif($x_priority =~ /^(4|5)$/) {
			$x_msmail_priority = "Low";
		}
		#ヘッダー
		my $hdrs = {
			To => $rpy_to,
			Cc => $self->{conf}->{rpy_cc},
			Bcc => $self->{conf}->{rpy_bcc},
			From => $self->{conf}->{rpy_from},
			Sender => $self->{conf}->{rpy_sender},
			Subject => $subject,
			Date => $now_rfc2822,
			"Error-To" => $self->{conf}->{rpy_error_to},
			"X-Priority" => $x_priority,
			"X-MSMail-Priority" => $x_msmail_priority
		};
		#開封メッセージの要求
		if($self->{conf}->{rpy_notification}) {
			$hdrs->{"Disposition-Notification-To"} = $self->{conf}->{rpy_from};
		}
		#添付ファイル
		my $rpy_attachments = FCC::Class::Mpfmec::TplRpy->new(conf=>$self->{conf})->get_atc_file_list();
		if($self->{conf}->{rpy_atc_reply} && @attachments) {
			push(@{$rpy_attachments}, @attachments);
		}
		#メール送信
		my $mail = new FCC::Class::Mail::Sendmail(
			sendmail => $self->{conf}->{sendmail_path},
			smtp_host => $self->{conf}->{smtp_host},
			smtp_port => $self->{conf}->{smtp_port},
			smtp_auth_user => $self->{conf}->{smtp_auth_user},
			smtp_auth_pass => $self->{conf}->{smtp_auth_pass},
			body => $body,
			hdrs => $hdrs,
			attachments => $rpy_attachments,
			tmp_dir => $tmp_dir
		);
		$mail->mailsend();
		if( my $error = $mail->error() ) {
			$context->{fatalerrs} = ['failed to send a mail.'];
			return $context;
		}
	}
	#ログ出力
	if($self->{conf}->{log_enable}) {
		my $meta = {
			SERIAL           => $serial->{SERIAL},
			SEQ              => $serial->{SEQ},
			ATTACHMENTS      => $attach_num,
			RECEPTION_DATE   => $now,
			RECEPTION_DATE_Y => $tm{Y},
			RECEPTION_DATE_m => $tm{m},
			RECEPTION_DATE_d => $tm{d},
			RECEPTION_DATE_H => $tm{H},
			RECEPTION_DATE_i => $tm{i},
			RECEPTION_DATE_s => $tm{s},
			RECEPTION_DATE_e => $tm{e},
			RECEPTION_DATE_i => $tm{i},
			RECEPTION_DATE_O => $tm{O},
			HTTP_USER_AGENT  => $ENV{HTTP_USER_AGENT},
			REMOTE_HOST      => $remote_host,
			REMOTE_ADDR      => $ENV{REMOTE_ADDR}
		};
		FCC::Class::Mpfmec::Log->new(conf=>$self->{conf}, items=>$self->{items})->loging($meta, $in);
	}
	#セッションをアップデート
	$self->{session}->update( { proc => $proc } );
	#
	$context->{proc} = $proc;
	return $context;
}

sub get_rpy_to {
	my($self, $in) = @_;
	my $rpy_item = $self->{conf}->{rpy_item};
	if( ! $rpy_item || $rpy_item eq "" || ! $self->{items}->{$rpy_item} ) {
		return undef;
	}
	my $rpy_to = $in->{$rpy_item};
	if( $rpy_to &&  Email::Valid->address($rpy_to) ) {
		return $rpy_to;
	} else {
		return undef;
	}
}

sub get_send_to_list {
	my($self, $in) = @_;
	#デフォルトの宛先
	my $default = {
		To => $self->{conf}->{mai_to},
		Cc => $self->{conf}->{mai_cc},
		Bcc => $self->{conf}->{mai_bcc}
	};
	my $default_selected = 0;
	#振り分け設定情報を取得
	my $divs = FCC::Class::Mpfmec::Div->new(conf=>$self->{conf})->get();
	my $name = $divs->{name};
	if( ! defined $name || $name eq "" || ! $self->{items}->{$name} ) {
		return [$default];
	}
	my $itm = $self->{items}->{$name};
	if($itm->{type} !~ /^(3|4|5)$/) {
		return [$default];
	}
	#該当の入力項目を取得
	my @vlist;
	if($itm->{type} eq "3") {
		my $v = $in->{$name};
		if( defined $in->{$name} && $in->{$name} ne "" ) {
			push(@vlist, $in->{$name});
		}
	} else {
		for my $v (@{$in->{$name}}) {
			if( defined $v && $v ne "" ) {
				push(@vlist, $v);
			}
		}
	}
	#振り分け先決定
	my @list;
	for my $v (@vlist) {
		my $data = $divs->{data}->{$v};
		if( $data && $data->{mai_to} ) {
			my %hash;
			$hash{To} = $data->{mai_to};
			$hash{Cc} = $data->{mai_cc};
			$hash{Bcc} = $data->{mai_bcc};
			push(@list, \%hash);
		} else {
			unless($default_selected) {
				push(@list, $default);
			}
			$default_selected = 1;
		}
	}
	#もし振り分け先がなければデフォルトを適用
	unless(@list) {
		push(@list, $default);
	}
	#
	return \@list;
}

sub get_remote_host {
	my($self) = @_;
	if($ENV{REMOTE_HOST}) {
		return $ENV{REMOTE_HOST};
	} elsif($ENV{REMOTE_ADDR} =~ /^(\d{1,3})\.(\d{1,3})\.(\d{1,3})\.(\d{1,3})$/) {
		my $packed_addr = pack("C4", $1, $2, $3, $4);
		my($host) = gethostbyaddr($packed_addr, 2);
		if($host) {
			return $host;
		}
	}
	return $ENV{REMOTE_ADDR};
}
1;
