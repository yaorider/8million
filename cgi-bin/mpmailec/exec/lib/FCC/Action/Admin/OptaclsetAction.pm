package FCC::Action::Admin::OptaclsetAction;
$VERSION = 1.00;
use strict;
use warnings;
use base qw(FCC::Action::Admin::_SuperAction);
use Net::Netmask;
use CGI::Utils;
use FCC::Class::Syscnf;
use FCC::Class::String::Checker;

sub dispatch {
	my($self) = @_;
	my $context = {};
	#プロセスセッション
	my $pkey = $self->{q}->param("pkey");
	my $proc = $self->get_proc_session_data($pkey, "optacl");
	if( ! $proc) {
		$context->{fatalerrs} = ["不正なリクエストです。"];
		return $context;
	}
	#入力値のname属性値のリスト
	my $in_names = [
		'acl_deny_hosts',
		'acl_post_deny_sec'
	];
	#入力値を取得
	$proc->{in} = $self->get_input_data($in_names);
	#入力値チェック
	my @errs = $self->input_check($in_names, $proc->{in});
	#エラーハンドリング
	if(@errs) {
		$proc->{errs} = \@errs;
	} else {
		$proc->{errs} = [];
		#システム設定情報をセット
		FCC::Class::Syscnf->new(conf=>$self->{conf})->set($proc->{in});
	}
	#
	$self->set_proc_session_data($proc);
	$context->{proc} = $proc;
	return $context;
}

sub input_check {
	my($self, $names, $in) = @_;
	my %cap = (
		acl_deny_hosts      => '利用禁止ホスト',
		acl_post_deny_sec   => '連続投稿禁止設定'
	);
	my @errs;
	for my $k (@{$names}) {
		my $v = $in->{$k};
		#利用禁止ホスト
		if($k eq "acl_deny_hosts") {
			if( length($v) > 65535 ) {
				push(@errs, [$k, "\"$cap{$k}\"は改行も含め65535文字以内で指定してください。"]);
			} else {
				my @lines = split(/\n+/, $v);
				my @recs;
				for my $v (@lines) {
					if($v eq "") { next; }
					my $escaped_v = CGI::Utils->new()->escapeHtml($v);
					if($v =~ /[^a-zA-Z0-9\.\-\/]/) {
						push(@errs, [$k, "\"$cap{$k}\"に指定した '${escaped_v}' には不適切な文字が含まれています。"]);
					} elsif($v =~ /^[\d\.]+$/) {
						my @parts = split(/\./, $v);
						for my $p (@parts) {
							if($p eq "" || $p > 255) {
								push(@errs, [$k, "\"$cap{$k}\"に指定した '${escaped_v}' はIPアドレスとして不適切です。"]);
								last;
							}
						}
					} elsif($v =~ /\//) {
						if($v =~ /^\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}\/\d{1,2}$/) {
							my $nm = new2 Net::Netmask($v);
							if($nm) {
								my $base = $nm->base();
								if($v !~ /^\Q${base}\E\//) {
									my $correct = $v;
									$correct =~ s/^[^\/]+/${base}/;
									push(@errs, [$k, "\"$cap{$k}\"に指定した '${escaped_v}' はIPアドレスブロックとして不適切です。恐らく '${correct}' ではないでしょうか。"]);
								}
							} else {
								push(@errs, [$k, "\"$cap{$k}\"に指定したアドレスブロック '${escaped_v}' が正しくありません。"]);
							}
						} else {
							push(@errs, [$k, "\"$cap{$k}\"に指定した '${escaped_v}' はIPアドレスブロックとして不適切です。"]);
						}
					}
					push(@recs, $v);
				}
				$in->{$k} = join("\n", @recs);
			}
		#連続投稿禁止設定
		} elsif($k eq "acl_post_deny_sec") {
			if($v ne "") {
				if($v =~ /[^\d]/) {
					push(@errs, [$k, "\"$cap{$k}\"は半角数字で指定してください。"]);
				} elsif($v > 4294967295) {
					push(@errs, [$k, "\"$cap{$k}\"は4294967295より大きい値を指定することはできません。"]);
				} else {
					$v += 0;
				}
			}
		}
	}
	#
	return @errs;
}

1;
