package FCC::View::Admin::TplrpyfrmView;
$VERSION = 1.00;
use strict;
use warnings;
use base qw(FCC::View::Admin::_SuperView);
use CGI::Utils;
use FCC::Class::Date::Utils;
use FCC::Class::String::Conv;

sub dispatch {
	my($self, $context) = @_;
	#エラーの評価
	if($context->{fatalerrs}) {
		$self->error($context->{fatalerrs});
		exit;
	}
	#
	my $t = $self->load_template();
	$t->param("pkey" => $context->{proc}->{pkey});
	my $tid = $context->{proc}->{in}->{tid};
	#プロセスエラー
	if( @{$context->{proc}->{errs}} ) {
		my $errs = "<ul>";
		for my $e (@{$context->{proc}->{errs}}) {
			$t->param("$e->[0]_err" => "err");
			$errs .= "<li>$e->[1]</li>";
		}
		$errs .= "</ul>";
		$t->param('errs' => $errs);
	}
	#データのプリセット
	while( my($k, $v) = each %{$context->{proc}->{in}} ) {
		if( defined $v ) {
			$t->param($k => CGI::Utils->new()->escapeHtml($v));
		}
	}
	#添付ファイルの一覧
	my $atc_file_list = $context->{proc}->{atc_file_list};
	my @atc_file_loop;
	for my $ref (@{$atc_file_list}) {
		my %hash;
		$hash{name} = CGI::Utils->new()->escapeHtml($ref->{name});
		$hash{size} = $ref->{size};
		$hash{size_with_comma} = FCC::Class::String::Conv->new($ref->{size})->comma_format($ref->{size});
		$hash{mtime} = $ref->{mtime};
		$hash{mtype} = $ref->{mtype};
		$hash{name_hex} = $ref->{name_hex};
		my %tm = FCC::Class::Date::Utils->new(time=>$ref->{mtime}, tz=>$self->{conf}->{tz})->get_formated();
		while( my($k, $v) = each %tm ) {
			$hash{"mtime_${k}"} = $v;
		}
		push(@atc_file_loop, \%hash);
	}
	$t->param("atc_file_loop" => \@atc_file_loop);
	my $atc_file_num = scalar @{$atc_file_list};
	$t->param("atc_file_num" => $atc_file_num);
	#
	$t->param("rpy_atc_max_total_size" => $self->{conf}->{rpy_atc_max_total_size});
	#
	$self->print_html($t);
}

1;
