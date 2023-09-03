package FCC::Action::Admin::LogadmmnuAction;
$VERSION = 1.00;
use strict;
use warnings;
use base qw(FCC::Action::Admin::_SuperAction);
use Date::Pcalc qw(Days_in_Month);
use FCC::Class::Mpfmec::Item;
use FCC::Class::Mpfmec::Log;
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
		'offset',
		'limit'
	];
	my $cond = $self->get_input_data($cond_names);
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
	#日付の範囲
	my @sdatem_list;
	my @edatem_list;
	for( my $i=1; $i<=12; $i++ ) {
		my $m = sprintf("%02d", $i);
		push(@sdatem_list, $m);
		push(@edatem_list, $m);
	}
	my @sdated_list;
	my @edated_list;
	for( my $i=1; $i<=31; $i++ ) {
		my $m = sprintf("%02d", $i);
		push(@sdated_list, $m);
		push(@edated_list, $m);
	}
	#ログの期間を取得
	my @sdatey_list;
	my @edatey_list;
	if($min_date && $max_date) {
		my $min_y = substr($min_date, 0, 4);
		my $max_y = substr($max_date, 0, 4);
		@sdatey_list = (${min_y}..${max_y});
		@edatey_list = (${min_y}..${max_y});
	} else {
		push(@sdatey_list, $tm[0]);
		push(@edatey_list, $tm[0]);
	}
	#ログを取得
	my $res = $olog->get_list({
		sdate => "$cond->{sdatey}$cond->{sdatem}$cond->{sdated}",
		edate => "$cond->{edatey}$cond->{edatem}$cond->{edated}",
		offset => $cond->{offset},
		limit => $cond->{limit},
	});
	#ページナビゲーション
	my $navi = {};
	my @navi_params;
	while( my($k, $v) = each %{$cond} ) {
		if($k eq "offset") { next; }
		push(@navi_params, "${k}=${v}");
	}
	my $navi_params_str = join("&amp;", @navi_params);
	if($res->{hit}) {
		#次へ
		my $next_offset = $res->{offset} + $res->{limit};
		if($next_offset < $res->{hit}) {
			$navi->{next_url} = "$self->{conf}->{CGI_URL}?m=logadmmnu&amp;offset=${next_offset}&amp;${navi_params_str}";
			if($res->{hit} - $next_offset > $res->{limit}) {
				$navi->{next_num} = $res->{limit};
			} else {
				$navi->{next_num} = $res->{hit} - $next_offset;
			}
		}
		#前へ
		my $prev_offset = $res->{offset} - $res->{limit};
		if($prev_offset >= 0) {
			$navi->{prev_url} = "$self->{conf}->{CGI_URL}?m=logadmmnu&amp;offset=${prev_offset}&amp;${navi_params_str}";
			$navi->{prev_num} = $res->{limit};
		}
		#ページ番号リスト
		my $this_page = int( ($res->{offset} + 1) / $res->{limit} ) + 1;
		my $disp_page_num = 11;
		my $page_range = int($res->{hit} / $res->{limit});
		if($res->{hit} % $res->{limit}) {
			$page_range ++;
		}
		if($disp_page_num < $page_range) {
			$disp_page_num = $page_range;
		}
		my $start_page = $this_page - int($disp_page_num / 2);
		if($start_page < 1) { $start_page = 1; }
		my $end_page = $start_page + $disp_page_num;
		if($end_page > $page_range) { $end_page = $page_range; }
		my @page_loop;
		for( my $p=$start_page; $p<=$end_page; $p++ ) {
			my $offset = ($p - 1) * $res->{limit};
			my %hash;
			$hash{page} = $p;
			$hash{url} = "$self->{conf}->{CGI_URL}?m=logadmmnu&amp;offset=${offset}&amp;${navi_params_str}";
			if($p == $this_page) {
				$hash{current} = 1;
			}
			push(@page_loop, \%hash);
		}
		$navi->{page_loop} = \@page_loop;
	}
	#
	$context->{res} = $res;
	$context->{items} = $items;
	$context->{cond} = $cond;
	$context->{sdatey_list} = \@sdatey_list;
	$context->{sdatem_list} = \@sdatem_list;
	$context->{sdated_list} = \@sdated_list;
	$context->{edatey_list} = \@edatey_list;
	$context->{edatem_list} = \@edatem_list;
	$context->{edated_list} = \@edated_list;
	$context->{navi} = $navi;
	#
	return $context;
}

1;
