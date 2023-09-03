package FCC::Action::Admin::OptimpsetAction;
$VERSION = 1.00;
use strict;
use warnings;
use base qw(FCC::Action::Admin::_SuperAction);
use FCC::Class::Mpfmec::Dump;

sub dispatch {
	my($self) = @_;
	my $context = {};
	#プロセスセッション
	my $pkey = $self->{q}->param("pkey");
	my $proc = $self->get_proc_session_data($pkey, "optimp");
	if( ! $proc) {
		$context->{fatalerrs} = ["不正なリクエストです。"];
		return $context;
	}
	#ファイルを取得
	my @errs;
	my $export_file = $self->{q}->param("export_file");
	if($export_file) {
		my $fh = $self->{q}->upload('export_file');
		binmode($fh);
		my $serialized;
		if($fh) {
			while (<$fh>) {
				$serialized .= $_;
			}
			#チェックサム
			my($checksum) = $serialized =~ /\x0A([a-fA-F0-9]{32})$/;
			$serialized =~ s/\x0A([a-fA-F0-9]{32})$//;
			if( $checksum && $checksum eq Digest::MD5::md5_hex($serialized) ) {
				eval {
					FCC::Class::Mpfmec::Dump->new(conf=>$self->{conf})->deserialize($serialized);
				};
				if($@) {
					push(@errs, ["export_file", "エクスポートに失敗しました。: $@"]);
				}
			} else {
				push(@errs, ["export_file", "アップロードされたエクスポートファイルのデータが正しくありません。: CHECKSUM ERROR."]);
			}
		} else {
			push(@errs, ["export_file", "エクスポートファイルは必須です。"]);
		}
	} else {
		push(@errs, ["export_file", "エクスポートファイルは必須です。"]);
	}
	#エラーハンドリング
	if(@errs) {
		$proc->{errs} = \@errs;
	} else {
		$proc->{errs} = [];
	}
	#
	$self->set_proc_session_data($proc);
	$context->{proc} = $proc;
	return $context;
}

1;
