package FCC::Action::Admin::OptexpsetAction;
$VERSION = 1.00;
use strict;
use warnings;
use base qw(FCC::Action::Admin::_SuperAction);
use Digest::MD5;
use FCC::Class::Mpfmec::Dump;

sub dispatch {
	my($self) = @_;
	my $context = {};
	#プロセスセッション
	my $pkey = $self->{q}->param("pkey");
	my $proc = $self->get_proc_session_data($pkey, "optexp");
	if( ! $proc) {
		$context->{fatalerrs} = ["不正なリクエストです。"];
		return $context;
	}
	#ダンプ
	my $dumpdata = FCC::Class::Mpfmec::Dump->new(conf=>$self->{conf})->serialize();
	#改行コードをLFに統一
	$dumpdata =~ s/\x0D\x0A|\x0D|\x0A/\x0A/go;
	#チェックサムを算出して、最後に追加
	my $checksum = Digest::MD5::md5_hex($dumpdata);
	$dumpdata .= "\x0A${checksum}";
	#
	$proc->{dumpdata} = $dumpdata;
	$context->{proc} = $proc;
	return $context;
}

1;
