package FCC::View::Admin::LogadmmnuView;
$VERSION = 1.00;
use strict;
use warnings;
use base qw(FCC::View::Admin::_SuperView);
use CGI::Utils;
use FCC::Class::String::Conv;

sub dispatch {
	my($self, $context) = @_;
	#システムエラーの評価
	if($context->{fatalerrs}) {
		$self->error($context->{fatalerrs});
		exit;
	}
	#テンプレートのロード
	my $t = $self->load_template();
	#検索条件
	my $cond = $context->{cond};
	my @cond_key = ("sdatey", "sdatem", "sdated", "edatey", "edatem", "edated");
	for my $k (@cond_key) {
		$t->param($k => $cond->{$k});
		my @loop;
		for my $v (@{$context->{"${k}_list"}}) {
			my %hash;
			$hash{$k} = $v;
			if($v eq $cond->{$k}) {
				$hash{selected} = 'selected="selected"';
			}
			push(@loop, \%hash);
		}
		$t->param("${k}_loop" => \@loop);
	}
	#ログ検索結果一覧
	my $items = $context->{items};
	my @log_loop;
	for my $ref (@{$context->{res}->{list}}) {
		my $info = $ref->{info};
		my %hash;
		while( my($k, $v) = each %{$info} ) {
			if(ref($v) ne "ARRAY") {
				$hash{$k} = CGI::Utils->new()->escapeHtml($v);
			}
		}
		#
		my @item_loop;
		for my $name ( sort { $items->{$a}->{offset} <=> $items->{$b}->{offset} } keys %{$items} ) {
			my $item = $items->{$name};
			my $type = $item->{type};
			my %h;
			$h{name} = $name;
			$h{caption} = CGI::Utils->new()->escapeHtml($item->{caption});
			$h{"type_${type}"} = 1;
			my $v = $ref->{rec}->{$name};
			if( ! defined $v ) { $v = ""; }
			if($type eq "7") {
				if($v) {
					$h{filename} = CGI::Utils->new()->escapeHtml($v->{filename});
					$h{size} = $v->{size};
					$h{size_with_comma} = FCC::Class::String::Conv->new($v->{size})->comma_format();
					if($v->{path}) {
						$h{file_saved} = 1;
					}
				}
			} else {
				my @elms;
				if(ref($v) eq "ARRAY") {
					for my $elm (@{$v}) {
						if($elm eq "") {
							$elm = "&nbsp;";
						} else {
							$elm = CGI::Utils->new()->escapeHtml($elm);
						}
						push(@elms, $elm);
					}
				} else {
					if($v eq "") {
						$v = "&nbsp;";
					} else {
						$v = CGI::Utils->new()->escapeHtml($v);
						$v =~ s/\n/<br \/>/g;
					}
					push(@elms, $v);
				}
				my @element_loop;
				for my $element (@elms) {
					push(@element_loop, { element => $element });
				}
				$h{element_loop} = \@element_loop;
			}
			while( my($k, $v) = each %{$info} ) {
				if(ref($v) ne "ARRAY") {
					$h{$k} = CGI::Utils->new()->escapeHtml($v);
				}
			}
			$h{RECEPTION_DATE_YYYYMMDD} = $info->{RECEPTION_DATE_Y} . $info->{RECEPTION_DATE_m} . $info->{RECEPTION_DATE_d};
			push(@item_loop, \%h);
		}
		$hash{item_loop} = \@item_loop;
		#
		$hash{RECEPTION_DATE_YYYYMMDD} = $info->{RECEPTION_DATE_Y} . $info->{RECEPTION_DATE_m} . $info->{RECEPTION_DATE_d};
		$hash{CGI_URL} = $self->{conf}->{CGI_URL};
		$hash{static_url} = $self->{conf}->{static_url};
		push(@log_loop, \%hash);
	}
	$t->param("LOG_LOOP" => \@log_loop);
	#
	$t->param("total" => $context->{res}->{total});
	$t->param("hit" => $context->{res}->{hit});
	$t->param("fetch" => $context->{res}->{fetch});
	$t->param("start" => $context->{res}->{start});
	$t->param("end" => $context->{res}->{end});
	$t->param("offset" => $context->{res}->{offset});
	$t->param("limit" => $context->{res}->{limit});
	#ページナビゲーション
	while( my($k, $v) = each %{$context->{navi}} ) {
		$t->param($k => $v);
	}
	#ログダウンロード欄
	my @log_download_items;
	if($self->{conf}->{log_download_item}) {
		@log_download_items = split(/\s+/, $self->{conf}->{log_download_item});
	}
	my @log_download_item_loop;
	for my $name ( sort { $items->{$a}->{offset} <=> $items->{$b}->{offset} } keys %{$items} ) {
		my $item = $items->{$name};
		my %hash;
		$hash{name} = $name;
		$hash{caption} = CGI::Utils->new()->escapeHtml($item->{caption});
		if(@log_download_items) {
			if( my $n = grep(/^\Q${name}\E$/, @log_download_items) ) {
				$hash{checked} = 'checked="checked"';
			}
		} else {
			$hash{checked} = 'checked="checked"';
		}
		push(@log_download_item_loop, \%hash);
	}
	$t->param("log_download_item_loop" => \@log_download_item_loop);
	for my $name ("SERIAL", "RECEPTION_DATE", "HTTP_USER_AGENT", "REMOTE_HOST", "REMOTE_ADDR") {
		if(@log_download_items) {
			if( my $n = grep(/^\Q${name}\E$/, @log_download_items) ) {
				$t->param("log_download_item_${name}_checked" => 'checked="checked"');
			}
		} else {
			$t->param("log_download_item_${name}_checked" => 'checked="checked"');
		}
	}
	$t->param("log_download_item_loop" => \@log_download_item_loop);
	$t->param("log_download_delimiter_$self->{conf}->{log_download_delimiter}_selected" => 'selected="selected"');
	$t->param("log_download_charcode_$self->{conf}->{log_download_charcode}_selected" => 'selected="selected"');
	$t->param("log_download_rc_$self->{conf}->{log_download_rc}_selected" => 'selected="selected"');
	$t->param("log_download_rc_replace" => CGI::Utils->new()->escapeHtml($self->{conf}->{log_download_rc_replace}));
	#
	$self->print_html($t);
}

1;
