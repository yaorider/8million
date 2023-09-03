package FCC::Action::Admin::SeqcnfsetAction;
$VERSION = 1.00;
use strict;
use warnings;
use base qw(FCC::Action::Admin::_SuperAction);
use CGI::Utils;
use FCC::Class::Syscnf;
use FCC::Class::String::Checker;
use FCC::Class::Mpfmec::Seq;

sub dispatch {
	my($self) = @_;
	my $context = {};
	#プロセスセッション
	my $pkey = $self->{q}->param("pkey");
	my $proc = $self->get_proc_session_data($pkey, "seqcnf");
	if( ! $proc) {
		$context->{fatalerrs} = ["不正なリクエストです。"];
		return $context;
	}
	#入力値のname属性値のリスト
	my $in_names = [
		'seq_fmt',
		'seq_fmt_tpl',
		'seq_reset'
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
		my %update = %{$proc->{in}};
		delete $update{seq_reset};
		FCC::Class::Syscnf->new(conf=>$self->{conf})->set(\%update);
		#受付シリアル番号をリセット
		if($proc->{in}->{seq_reset} eq "1") {
			$proc->{seq} = FCC::Class::Mpfmec::Seq->new(conf=>$self->{conf})->rset();
		}
	}
	#
	$self->set_proc_session_data($proc);
	$context->{proc} = $proc;
	return $context;
}

sub input_check {
	my($self, $names, $in) = @_;
	my %cap = (
		seq_fmt     => '受付シリアル番号のフォーマット',
		seq_fmt_tpl => '受付シリアル番号の雛形'
	);
	my @errs;
	for my $k (@{$names}) {
		my $v = $in->{$k};
		#受付シリアル番号のフォーマット
		if($k eq "seq_fmt") {
			if($v eq "") {
				push(@errs, [$k, "\"$cap{$k}\"は必須です。"]);
			} elsif($v !~ /^[0-9]$/) {
				push(@errs, [$k, "\"$cap{$k}\"に不正な値が送信されました。"]);
			}
		#受付シリアル番号の雛形
		} elsif($k eq "seq_fmt_tpl") {
			my $n = FCC::Class::String::Checker->new($v, "utf8")->get_char_num();
			if($v eq "") {
				push(@errs, [$k, "\"$cap{$k}\"は必須です。"]);
			} elsif($n > 64) {
				push(@errs, [$k, "\"$cap{$k}\"は64文字以内で指定してください。"]);
			} elsif($v =~ /\%(SEQ|SEQY|SEQM|SEQD)(\d+)\%/) {
				my $seq_name = $1;
				my $digit_length = $2;
				if($digit_length < 1 || $digit_length > 9) {
					my $identifer = "\%${seq_name}${digit_length}\%";
					push(@errs, [$k, "\"$cap{$k}\"に指定した ${identifer} が正しくありません。連番の桁数は1～9のいずれかを指定してください。"]);
				}
			}
		}
	}
	#
	return @errs;
}

1;
