package FCC::Action::Admin::ItmmodsetAction;
$VERSION = 1.00;
use strict;
use warnings;
use base qw(FCC::Action::Admin::_SuperAction);
use CGI::Utils;
use FCC::Class::String::Checker;
use FCC::Class::Mpfmec::Item;

sub dispatch {
	my($self) = @_;
	my $context = {};
	#プロセスセッション
	my $pkey = $self->{q}->param("pkey");
	my $proc = $self->get_proc_session_data($pkey, "itmmod");
	if( ! $proc) {
		$context->{fatalerrs} = ["不正なリクエストです。"];
		return $context;
	}
	#入力値のname属性値のリスト
	my $in_names = [
		'caption',
		'desc',
		'type',
		'required'
	];
	my $name = $proc->{in}->{name};
	my $type = $proc->{in}->{type};

	#全フォーム項目情報を取得
	my $items = FCC::Class::Mpfmec::Item->new(conf=>$self->{conf})->get();
	if( ! exists $items->{$name} ) {
		$context->{fatalerrs} = ["不正なリクエストです。"];
		return $context;
	}
	#
	if($type eq "1") {		#テキスト入力フィールド
		push(@{$in_names}, 'type_1_width', 'type_1_minlength', 'type_1_maxlength', 'type_1_value', 'type_1_is_email', 'type_1_deny_emails');
		for( my $i=1; $i<=5; $i++ ) {
			push(@{$in_names}, "type_1_convert_${i}");
		}
		for( my $i=1; $i<=3; $i++ ) {
			push(@{$in_names}, "type_1_restrict_${i}");
		}
	} elsif($type eq "2") {	#パスワード入力フィールド
		push(@{$in_names}, 'type_2_width', 'type_2_minlength', 'type_2_maxlength');
	} elsif($type eq "3") {	#ラジオボタン
		push(@{$in_names}, 'type_3_elements', 'type_3_arrangement');
	} elsif($type eq "4") {	#チェックボックス
		push(@{$in_names}, 'type_4_elements', 'type_4_arrangement', 'type_4_minlength', 'type_4_maxlength');
	} elsif($type eq "5") {	#セレクトメニュー
		push(@{$in_names}, 'type_5_elements', 'type_5_multiple', 'type_5_minlength', 'type_5_maxlength');
	} elsif($type eq "6") {	#テキストエリア
		push(@{$in_names}, 'type_6_cols', 'type_6_rows', 'type_6_minlength', 'type_6_maxlength', 'type_6_value');
		for( my $i=1; $i<=5; $i++ ) {
			push(@{$in_names}, "type_6_convert_${i}");
		}
	} elsif($type eq "7") {	#ファイル添付
		push(@{$in_names}, 'type_7_width', 'type_7_maxsize', 'type_7_allow_exts');
	} elsif($type eq "8") {	#非表示フィールド
		push(@{$in_names}, 'type_8_handover', 'type_8_minlength', 'type_8_maxlength', 'type_8_value');
	}
	#入力値を取得
	$proc->{in} = $self->get_input_data($in_names);
	$proc->{in}->{name} = $name;
	$proc->{in}->{type} = $type;
	$proc->{in}->{offset} = $items->{$name}->{offset};
	#入力値チェック
	my @errs = FCC::Class::Mpfmec::Item->new(conf=>$self->{conf})->input_check($in_names, $proc->{in});
	#エラーハンドリング
	if(@errs) {
		$proc->{errs} = \@errs;
	} else {
		$proc->{errs} = [];
		my $type = $proc->{in}->{type};
		my %u;
		while( my($k, $v) = each %{$proc->{in}} ) {
			if($k =~ /^type_(\d+)_/) {
				if($1 ne $type) { next; }
			}
			$u{$k} = $v;
		}
		FCC::Class::Mpfmec::Item->new(conf=>$self->{conf})->set(\%u);
	}
	#
	$self->set_proc_session_data($proc);
	$context->{proc} = $proc;
	return $context;
}

1;
