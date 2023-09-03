package FCC::Action::Admin::LogdwnsmtAction;
$VERSION = 1.00;
use strict;
use warnings;
use base qw(FCC::Action::Admin::_SuperAction);
use Date::Pcalc qw(Days_in_Month);
use FCC::Class::Mpfmec::Item;
use FCC::Class::Mpfmec::Log;
use FCC::Class::Syscnf;
use FCC::Class::Date::Utils;

sub dispatch {
	my($self) = @_;
	my $context = {};
	#検索条件を取得
	my $cond_names = [
		'sdatey',
		'sdatem',
		'sdated',
		'edatey',
		'edatem',
		'edated',
		'log_download_delimiter',
		'log_download_charcode',
		'log_download_rc',
		'log_download_rc_replace'
	];
	my $cond = $self->get_input_data($cond_names);
	my @log_download_item = $self->{q}->param("log_download_item");
	$cond->{log_download_item} = \@log_download_item;
	#
	my @tm = FCC::Class::Date::Utils->new(time=>time, tz=>$self->{conf}->{tz})->get(1);
	my $items = FCC::Class::Mpfmec::Item->new(conf=>$self->{conf})->get();
	my $olog = new FCC::Class::Mpfmec::Log(conf=>$self->{conf}, items=>$items);
	my($min_date, $max_date) = $olog->get_date_range();
	unless($min_date && $max_date) {
		$min_date = "$tm[0]$tm[1]$tm[2]";
		$max_date = $min_date;
	}
	my $min_y = substr($min_date, 0, 4);
	my $max_y = substr($max_date, 0, 4);
	for my $k ("sdatey", "edatey") {
		unless($cond->{$k}) {
			$cond->{$k} = "";
			next;
		}
		if($cond->{$k} !~ /^\d{4}$/ || $cond->{$k} < $min_y || $cond->{$k} > $max_y) {
			$cond->{$k} = "";
		}
	}
	for my $k ("sdatem", "edatem") {
		unless($cond->{$k}) {
			$cond->{$k} = "";
			next;
		}
		if($cond->{$k} !~ /^\d{2}$/ || $cond->{$k} < 1 || $cond->{$k} > 12) {
			$cond->{$k} = "";
		}
	}
	for my $k ("sdated", "edated") {
		unless($cond->{$k}) {
			$cond->{$k} = "";
			next;
		}
		if($cond->{$k} !~ /^\d{2}$/ || $cond->{$k} < 1 || $cond->{$k} > 31) {
			$cond->{$k} = "";
		}
	}
	if( ! $cond->{sdatey} || ! $cond->{sdatem} || ! $cond->{sdated} || ! $cond->{edatey} || ! $cond->{edatem} || ! $cond->{edated}) {
		($cond->{sdatey}, $cond->{sdatem}, $cond->{sdated}) = $min_date =~ /^(\d{4})(\d{2})(\d{2})/;
		($cond->{edatey}, $cond->{edatem}, $cond->{edated}) = $max_date =~ /^(\d{4})(\d{2})(\d{2})/;
	}
	my $sdate = "$cond->{sdatey}$cond->{sdatem}$cond->{sdated}";
	my $edate = "$cond->{edatey}$cond->{edatem}$cond->{edated}";
	if($sdate gt $edate) {
		($cond->{sdatey}, $cond->{sdatem}, $cond->{sdated}) = $edate =~ /^(\d{4})(\d{2})(\d{2})/;
		($cond->{edatey}, $cond->{edatem}, $cond->{edated}) = $sdate =~ /^(\d{4})(\d{2})(\d{2})/;
	}
	if( ! $cond->{offset} || $cond->{offset} =~ /[^\d]/) {
		$cond->{offset} = 0;
	}
	if( ! $cond->{limit} || $cond->{limit} =~ /[^\d]/) {
		$cond->{limit} = 10;
	} elsif($cond->{offset} > 100) {
		$cond->{limit} = 100;
	}
	#
	if( ! defined $cond->{log_download_delimiter} || $cond->{log_download_delimiter} !~ /^(1|2|3)$/ ) {
		$cond->{log_download_delimiter} = "1";
	}
	if( ! defined $cond->{log_download_rc_replace} ) {
		$cond->{log_download_rc_replace} = "";
	}
	if( ! defined $cond->{log_download_charcode} || $cond->{log_download_charcode} !~ /^(1|2|3)$/ ) {
		$cond->{log_download_charcode} = "1";
	}
	if( ! defined $cond->{log_download_rc} || $cond->{log_download_rc} !~ /^(1|2|3)$/ ) {
		$cond->{log_download_rc} = "1";
	}
	#ダウンロード用のログファイルを生成
	my $path = $olog->make_download_file({
		sdate      => "$cond->{sdatey}$cond->{sdatem}$cond->{sdated}",
		edate      => "$cond->{edatey}$cond->{edatem}$cond->{edated}",
		delimiter  => $cond->{log_download_delimiter},
		rc_replace => $cond->{log_download_rc_replace},
		charcode   => $cond->{log_download_charcode},
		rc         => $cond->{log_download_rc},
		names      => $cond->{log_download_item}
	});
	#ファイル名を決定
	my $filename = "${sdate}_${edate}";
	if($cond->{log_download_delimiter} eq "1") {
		$filename .= ".csv";
	} elsif($cond->{log_download_delimiter} eq "2") {
		$filename .= ".ssv";
	} elsif($cond->{log_download_delimiter} eq "3") {
		$filename .= ".tsv";
	}
	#オプションを設定データとして保存
	my %u = (
		log_download_delimiter  => $cond->{log_download_delimiter},
		log_download_charcode   => $cond->{log_download_charcode},
		log_download_rc         => $cond->{log_download_rc},
		log_download_rc_replace => $cond->{log_download_rc_replace}
	);
	FCC::Class::Syscnf->new(conf=>$self->{conf})->set(\%u);
	#
	$context->{filename} = $filename;
	$context->{path} = $path;
	return $context;
}

1;
