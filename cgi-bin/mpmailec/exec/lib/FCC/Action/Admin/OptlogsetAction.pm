package FCC::Action::Admin::OptlogsetAction;
$VERSION = 1.00;
use strict;
use warnings;
use base qw(FCC::Action::Admin::_SuperAction);
use FCC::Class::Syscnf;
use FCC::Class::String::Checker;

sub dispatch {
	my($self) = @_;
	my $context = {};
	#プロセスセッション
	my $pkey = $self->{q}->param("pkey");
	my $proc = $self->get_proc_session_data($pkey, "optlog");
	if( ! $proc) {
		$context->{fatalerrs} = ["不正なリクエストです。"];
		return $context;
	}
	#入力値のname属性値のリスト
	my $in_names = [
		'log_enable',
		'log_dir',
		'log_atc_save',
		'log_save_days'
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
		my %u;
		if($proc->{in}->{log_enable} eq "1") {
			%u = %{$proc->{in}};
		} else {
			$u{log_enable} = "";
		}
		#システム設定情報をセット
		FCC::Class::Syscnf->new(conf=>$self->{conf})->set(\%u);
	}
	#
	$self->set_proc_session_data($proc);
	$context->{proc} = $proc;
	return $context;
}

sub input_check {
	my($self, $names, $in) = @_;
	my %cap = (
		log_enable        => 'ログ出力',
		log_dir           => 'ログファイル格納ディレクトリ',
		log_atc_save      => '添付ファイルの保存',
		log_save_days     => '保存日数'
	);
	my @errs;
	for my $k (@{$names}) {
		my $v = $in->{$k};
		#ログ出力
		if($k eq "log_enable") {
			if($v ne "" && $v ne "1") {
				push(@errs, [$k, "\"$cap{$k}\"に不正な値が送信されました。"]);
			} elsif($v ne "1") {
				last;
			}
		#ログファイル格納ディレクトリ
		} elsif($k eq "log_dir") {
			if($v eq "") {
				$v = $self->{conf}->{BASE_DIR} . "/data/logs";
			}
			$v =~ s/\/$//;
			if($v eq "") {
				push(@errs, [$k, "\"$cap{$k}\"は必須です。"]);
			} elsif(length($v) > 255) {
				push(@errs, [$k, "\"$cap{$k}\"は255文字以内で指定してください。"]);
			} elsif($v =~ /[^a-zA-Z0-9\/\.\_\-\:]/) {
				push(@errs, [$k, "\"$cap{$k}\"に不適切な文字が含まれています。"]);
			} else {
				unless( -d $v ) {
					if( mkdir $v, 0777 ) {
						if($self->{conf}->{SUEXEC}) {
							chmod 0700, $v;
						} else {
							chmod 0777, $v;
						}
					} else {
						push(@errs, [$k, "\"$cap{$k}\" (${v}) の自動生成に失敗しました。: $!"]);
					}
				}
				if( -d $v ) {
					if( open my $fh, ">", "${v}/test.txt" ) {
						unlink "${v}/test.txt";
					} else {
						push(@errs, [$k, "\"$cap{$k}\"に指定したディレクトリには書込権限がありません。: $!"]);
					}
					my $f1 = "${v}/.htaccess";
					unless( -e $f1 ) {
						open my $fh, ">", $f1;
						print $fh "deny form all";
						close($fh);
					}
					my $f2 = "${v}/index.html";
					unless( -e $f2 ) {
						open my $fh, ">", $f2;
						close($fh);
					}
				}
			}
			$in->{$k} = $v;
		#添付ファイルの保存
		} elsif($k eq "log_atc_save") {
			if($v ne "" && $v ne "1") {
				push(@errs, [$k, "\"$cap{$k}\"に不正な値が送信されました。"]);
			}
		#保存日数
		} elsif($k eq "log_save_days") {
			if($v eq "") {
				push(@errs, [$k, "\"$cap{$k}\"は必須です。"]);
			} elsif($v =~ /[^\d]/) {
				push(@errs, [$k, "\"$cap{$k}\"は半角数字で指定してください。"]);
			} elsif($v > 65535) {
				push(@errs, [$k, "\"$cap{$k}\"は65535以内で指定してください。"]);
			}
		}
	}
	#
	return @errs;
}

1;
