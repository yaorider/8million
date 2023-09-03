package FCC::Action::Admin::DivcnfsetAction;
$VERSION = 1.00;
use strict;
use warnings;
use base qw(FCC::Action::Admin::_SuperAction);
use Email::Valid;
use FCC::Class::Mpfmec::Item;
use FCC::Class::Mpfmec::Div;
use FCC::Class::String::Checker;

sub dispatch {
	my($self) = @_;
	my $context = {};
	#プロセスセッション
	my $pkey = $self->{q}->param("pkey");
	my $proc = $self->get_proc_session_data($pkey, "divcnf");
	if( ! $proc) {
		$context->{fatalerrs} = ["不正なリクエストです。"];
		return $context;
	}
	#全フォーム項目情報を取得
	my $items = FCC::Class::Mpfmec::Item->new(conf=>$self->{conf})->get();
	#振り分けもとになることができない項目を除外
	while( my($k, $v) = each %{$items} ) {
		if($v->{type} !~ /^(3|4|5)$/) {
			delete $items->{$k};
		}
	}
	#パラメータ
	my @fatalerrs;
	my $name = $self->{q}->param("name");
	if($name) {
		if($name =~ /[^a-zA-Z0-9\-\_]/) {
			push(@fatalerrs, "不正な値が送信されました。");
		} else {
			if( ! exists($items->{$name}) ) {
				push(@fatalerrs, "不正な値が送信されました。");
			}
		}
	} else {
		push(@fatalerrs, "項目が指定されていません。");
	}
	if(@fatalerrs) {
		$context->{fatalerrs} = \@fatalerrs;
		return $context;
	}
	#指定の項目の要素リストを取得
	my $item = $items->{$name};
	my $type = $item->{type};
	my @elements = split(/\n+/, $item->{"type_${type}_elements"});
	my $element_num = scalar @elements;
	#入力値のname属性値のリスト
	my $in_names = [];
	for( my $i=1; $i<=${element_num}; $i++ ) {
		push(@{$in_names}, "mai_to_${i}");
		push(@{$in_names}, "mai_cc_${i}");
		push(@{$in_names}, "mai_bcc_${i}");
	}
	#入力値を取得
	$proc->{in} = $self->get_input_data($in_names);
	$proc->{in}->{name} = $name;
	#入力値チェック
	my @errs = $self->input_check($in_names, $proc->{in}, \@elements);
	#エラーハンドリング
	if(@errs) {
		$proc->{errs} = \@errs;
	} else {
		$proc->{errs} = [];
		FCC::Class::Mpfmec::Div->new(conf=>$self->{conf})->set($proc->{in});
	}
	#
	$self->set_proc_session_data($proc);
	$context->{proc} = $proc;
	return $context;
}

sub input_check {
	my($self, $names, $in, $elms) = @_;
	my @errs;
	for my $k (@{$names}) {
		my $v = $in->{$k};
		if($v eq "") { next; }
		if($k =~ /^mai_(to|cc|bcc)_(\d+)/) {
			my $cap = ucfirst $1;
			my $i = $2;
			my $elm = $elms->[$i-1];
			my $n = FCC::Class::String::Checker->new($v, "utf8")->get_char_num();
			if($n > 1024) {
				push(@errs, [$k, "\"${elm}\"の${cap}は1024文字以内で指定してください。"]);
			} else {
				my @parts = split(/,/, $v);
				my @list;
				for my $p (@parts) {
					if($p eq "") { next; }
					if( ! Email::Valid->rfc822($p) ) {
						my $escaped_v = CGI::Utils->new()->escapeHtml($p);
						push(@errs, [$k, "\"${elm}\"の${cap}に指定した '${escaped_v}' はメールアドレスとして不適切です。"]);
					}
					push(@list, $p);
				}
				$in->{$k} = join(",", @list);
			}
		}
	}
	#入力データをコンバート
	my $name = $in->{name};
	my $data = {};
	while( my($k, $v) = each %{$in} ) {
		if($k =~ /^mai_(to|cc|bcc)_(\d+)/) {
			my $key = "mai_" . $1;
			my $i = $2;
			my $elm = $elms->[$i-1];
			$data->{$elm}->{$key} = $v;
		}
	}
	$in->{name} = $name;
	$in->{data} = $data;
	while( my($k, $v) = each %{$in} ) {
		if($k !~ /^(name|data)$/) {
			delete $in->{$k};
		}
	}
	#
	return @errs;
}

1;
