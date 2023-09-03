package FCC::View::Admin::DivcnffrmView;
$VERSION = 1.00;
use strict;
use warnings;
use base qw(FCC::View::Admin::_SuperView);
use CGI::Utils;
use FCC::Class::Date::Utils;

sub dispatch {
	my($self, $context) = @_;
	#システムエラーの評価
	if($context->{fatalerrs}) {
		$self->error($context->{fatalerrs});
		exit;
	}
	#テンプレートのロード
	my $t = $self->load_template();
	$t->param("pkey" => $context->{proc}->{pkey});
	while( my($k, $v) = each %{$context->{proc}->{in}} ) {
		if( ! defined $v ) { $v = ""; }
		$t->param($k => CGI::Utils->new()->escapeHtmlFormValue($v));
	}
	#プロセスエラー
	my %err_keys;
	if( @{$context->{proc}->{errs}} ) {
		my $errs = "<ul>";
		for my $e (@{$context->{proc}->{errs}}) {
			$t->param("$e->[0]_err" => "err");
			$errs .= "<li>$e->[1]</li>";
			$err_keys{$e->[0]} = "err";
		}
		$errs .= "</ul>";
		$t->param('errs' => $errs);
	}
	#データのプリセット
	my $name;
	if($context->{proc}->{in} && ref($context->{proc}->{in}) eq "HASH") {
		$name = $context->{proc}->{in}->{name};
		unless($name) { $name = ""; }
		my $items = $context->{items};
		#項目のセレクトメニュー
		my @item_loop;
		for my $nm ( sort { $items->{$a}->{offset} <=> $items->{$b}->{offset} } keys %{$items} ) {
			my %hash;
			while( my($k, $v) = each %{$items->{$nm}} ) {
				if( ! defined $v ) { $v = ""; }
				$hash{$k} = CGI::Utils->new()->escapeHtml($v);
			}
			if($nm eq $name) {
				$hash{selected} = 'selected="selected"';
			}
			push(@item_loop, \%hash);
		}
		$t->param("item_loop" => \@item_loop);
		#選択された項目の属性
		while( my($k, $v) = each %{$items->{$name}} ) {
			$t->param($k => CGI::Utils->new()->escapeHtml($v));
		}
		#設定内容
		if($name) {
			my @div_loop;
			my $type = $items->{$name}->{type};
			my @elements = split(/\n/, $items->{$name}->{"type_${type}_elements"});
			my $no = 1;
			for my $elm (@elements) {
				my %hash;
				my $elm_tmp = $elm;
				$elm_tmp =~ s/^[\*\^]//;
				$hash{element} = CGI::Utils->new()->escapeHtmlFormValue($elm_tmp);
				$hash{no} = $no;
				$hash{mai_to} = CGI::Utils->new()->escapeHtmlFormValue($context->{proc}->{in}->{data}->{$elm}->{mai_to});
				$hash{mai_cc} = CGI::Utils->new()->escapeHtmlFormValue($context->{proc}->{in}->{data}->{$elm}->{mai_cc});
				$hash{mai_bcc} = CGI::Utils->new()->escapeHtmlFormValue($context->{proc}->{in}->{data}->{$elm}->{mai_bcc});
				$hash{mai_to_err} = $err_keys{"mai_to_${no}"};
				$hash{mai_cc_err} = $err_keys{"mai_cc_${no}"};
				$hash{mai_bcc_err} = $err_keys{"mai_bcc_${no}"};
				push(@div_loop, \%hash);
				$no ++;
			}
			$t->param("div_loop" => \@div_loop);
		}
		$t->param("settedname" => $context->{divs}->{name});
		#その他
		$t->param("mai_to" => CGI::Utils->new()->escapeHtml($self->{conf}->{mai_to}));
		$t->param("mai_cc" => CGI::Utils->new()->escapeHtml($self->{conf}->{mai_cc}));
		$t->param("mai_bcc" => CGI::Utils->new()->escapeHtml($self->{conf}->{mai_bcc}));
	}
	#
	$self->print_html($t);
}

1;
