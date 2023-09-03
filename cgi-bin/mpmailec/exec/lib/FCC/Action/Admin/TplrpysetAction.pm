package FCC::Action::Admin::TplrpysetAction;
$VERSION = 1.00;
use strict;
use warnings;
use base qw(FCC::Action::Admin::_SuperAction);
use CGI::Utils;
use HTML::Template;
use FCC::Class::Mpfmec::TplRpy;
use FCC::Class::String::Checker;

sub dispatch {
	my($self) = @_;
	my $context = {};
	#プロセスセッション
	my $pkey = $self->{q}->param("pkey");
	my $proc = $self->get_proc_session_data($pkey, "tplrpy");
	if( ! $proc) {
		$context->{fatalerrs} = ["不正なリクエストです。"];
		return $context;
	}
	#入力値のname属性値のリスト
	my $in_names = ['tpl'];
	#入力値を取得
	$proc->{in} = $self->get_input_data($in_names);
	#入力値チェック
	my @errs = $self->input_check($in_names, $proc->{in});
	#
	my $otplrpy = new FCC::Class::Mpfmec::TplRpy(conf=>$self->{conf});
	#添付ファイルの削除
	my @del_file_hex_list = $self->{q}->param("atc_file_del");
	if(@del_file_hex_list) {
		$otplrpy->del_atc_file(\@del_file_hex_list);
	}
	#添付ファイルの追加
	my $atc_name = "";
	my $atc_data = "";
	my $atc_file = $self->{q}->param("atc_file");
	if( $atc_file ) {
		my($atc_name) = $atc_file =~ m/([^\/\\]+)$/;
		if($atc_name) {
			#ファイル名の長さをチェック
			my $len = FCC::Class::String::Checker->new($atc_name, "utf8")->get_char_num();
			if($len > 30) {
				$atc_name = "";
				push(@errs, ["atc_file", "添付ファイル名は30文字以内としてください。"]);
			}
		} else {
			push(@errs, ["atc_file", "添付ファイル名を認識できませんでした。"]);
		}
		if($atc_name) {
			#現在登録されているファイルの合計サイズを算出
			my $list = $otplrpy->get_atc_file_list();
			my $total_size = 0;
			for my $ref (@{$list}) {
				$total_size += $ref->{size};
			}
			#ファイルデータを抽出
			my $fh = $self->{q}->upload('atc_file');
			if($fh) {
				while (<$fh>) {
					$atc_data .= $_;
				}
			}
			#ファイルの合計サイズをチェック
			my $size = length $atc_data;
			if($size == 0) {
				$atc_name = "";
				push(@errs, ["atc_file", "添付ファイルが空のファイルです。"]);
			} elsif($total_size + $size > $self->{conf}->{rpy_atc_max_total_size} * 1024 * 1024) {
				$atc_name = "";
				push(@errs, ["atc_file", "添付ファイルは合計で$self->{conf}->{rpy_atc_max_total_size}MB以内としてください。"]);
			}
		}
		#ファイルを保存
		if($atc_name && $atc_data) {
			$otplrpy->ad_atc_file($atc_name, $atc_data);
		}
	}

	#エラーハンドリング
	if(@errs) {
		$proc->{errs} = \@errs;
		$self->set_proc_session_data($proc);
	} else {
		$proc->{errs} = [];
		$otplrpy->set($proc->{in}->{tpl});
	}
	#
	$context->{proc} = $proc;
	return $context;
}

sub input_check {
	my($self, $names, $in) = @_;
	my %cap = (
		tpl      => 'テンプレート内容'
	);
	my @errs;
	for my $k (@{$names}) {
		my $v = $in->{$k};
		if( ! defined $v ) { $v = ""; }
		$v =~ s/\x0d\x0a/\n/g;
		$v =~ s/\x0d/\n/g;
		$v =~ s/\x0a/\n/g;
		$v =~ s/^\n+//;
		$v =~ s/\n+$//;
		#テンプレート内容
		if($k eq "tpl" && $v ne "") {
			eval {
				my $t = HTML::Template->new(
					scalarref => \$v,
					die_on_bad_params => 0,
					vanguard_compatibility_mode => 1,
					loop_context_vars => 1
				);
			};
			if($@) {
				my $err = CGI::Utils->new()->escapeHtml($@);
				push(@errs, [$k, "\"$cap{$k}\"にテンプレート記述ミスがあります。: ${err}"]);
			}
		}
		$in->{$k} = $v;
	}
	#
	return @errs;
}

1;
