package FCC::Action::Install::P2shwAction;
$VERSION = 1.00;
use strict;
use warnings;
use base qw(FCC::Action::Install::_SuperAction);

sub dispatch {
	my($self) = @_;
	my $context = {};
	#
	my $parent_dir_path = $self->{conf}->{BASE_DIR};
	$parent_dir_path =~ s/\/exec$//;
	$self->{parent_dir_path} = $parent_dir_path;
	#
	my $static_url = $self->{q}->param("static_url");
	unless($static_url) {
		$static_url = "./static";
	}
	$static_url =~ s/^[\s\t]+//;
	$static_url =~ s/[\s\t]$//;
	$static_url =~ s/\/$//;
	my @errs;
	if( ! $static_url ) {
		$context->{fatalerrs} = ["パラメーターエラー(1)"];
		return $context;
	} elsif($static_url =~ /[^a-zA-Z0-9\/\.\_\-\:]/) {
		$context->{fatalerrs} = ["パラメーターエラー(2)"];
		return $context;
	}
	#
	my $stat = $self->{q}->param("stat");
	unless($stat) { $stat = 0; }
	if($stat !~ /^(0|1)$/) {
		$context->{fatalerrs} = ["パラメーターエラー(3)"];
		return $context;
	}
	#診断処理
	my $stat_errs = [];
	if($stat) {
		$stat_errs = $self->shindan();
		unless(@{$stat_errs}) {
			#設定データインポート
			eval {
				require FCC::Class::Syscnf;
				FCC::Class::Syscnf->new(conf=>$self->{conf})->set({static_url=>$static_url});
				require FCC::Class::Mpfmec::Dump;
				my $serialized = $self->read_file("$self->{conf}->{BASE_DIR}/default/sample.config.cgi");
				FCC::Class::Mpfmec::Dump->new(conf=>$self->{conf})->deserialize($serialized);
			};
			if($@) {
				$context->{fatalerrs} = ["設定初期化に失敗しました。: $@"];
				return $context;
			}
		}
	}
	#
	my $proc = {};
	$proc->{errs} = \@errs;
	$proc->{stat_errs} = $stat_errs;
	#
	my $in = {};
	$in->{static_url} = $static_url;
	$in->{stat} = $stat;
	if($stat) {
		if(@{$stat_errs}) {
			$in->{stat_ng} = 1;
		} else {
			$in->{stat_ok} = 1;
		}
	}
	$proc->{in} = $in;
	#
	$context->{proc} = $proc;
	return $context;
}

sub shindan {
	my($self) = @_;
	#CGI実行権限
	my $ex_uid = $>;
	my @stats = stat("./install.cgi");
	my $owner_uid = $stats[4];
	my $executer;
	if($ex_uid eq $owner_uid) {
		$executer = 'owner';
	} else {
		$executer = 'other';
	}
	#改行コード
	my $rc = $self->get_return_code("./install.cgi");
	#Perlパス
	my $perl_path = $self->get_perl_path("./install.cgi");
	#パーミッション
	my $permission = sprintf("%o",(stat("./install.cgi"))[2] & 0777);
	#
	my @errs;
	#CGIファイル
	{
		my @files = (
			"$self->{parent_dir_path}/form.cgi",
			"$self->{parent_dir_path}/admin.cgi"
		);
		for my $f (@files) {
			if( my $e = $self->exist_check($f) ) {
				push(@errs, $e);
			} else {
				if( my $e = $self->return_code_check($f, $rc) ) {
					push(@errs, $e);
				}
				if( my $e = $self->perl_path_check($f, $perl_path) ) {
					push(@errs, $e);
				}
				if( my $e = $self->permission_check($f, $executer, $permission) ) {
					push(@errs, $e);
				}
			}
		}
	}
	#ディレクトリの存在
	{
		my @dirs = (
			"$self->{conf}->{BASE_DIR}",
			"$self->{conf}->{BASE_DIR}/data",
			"$self->{conf}->{BASE_DIR}/default",
			"$self->{conf}->{BASE_DIR}/default/msg",
			"$self->{conf}->{BASE_DIR}/default/tpl",
			"$self->{conf}->{BASE_DIR}/lib",
			"$self->{conf}->{BASE_DIR}/lib/CGI",
			"$self->{conf}->{BASE_DIR}/lib/Config",
			"$self->{conf}->{BASE_DIR}/lib/Data",
			"$self->{conf}->{BASE_DIR}/lib/Date",
			"$self->{conf}->{BASE_DIR}/lib/DB_File",
			"$self->{conf}->{BASE_DIR}/lib/Digest",
			"$self->{conf}->{BASE_DIR}/lib/Email",
			"$self->{conf}->{BASE_DIR}/lib/FCC",
			"$self->{conf}->{BASE_DIR}/lib/FCC/Action",
			"$self->{conf}->{BASE_DIR}/lib/FCC/Action/Admin",
			"$self->{conf}->{BASE_DIR}/lib/FCC/Action/Form",
			"$self->{conf}->{BASE_DIR}/lib/FCC/Action/Install",
			"$self->{conf}->{BASE_DIR}/lib/FCC/Class",
			"$self->{conf}->{BASE_DIR}/lib/FCC/Class/Date",
			"$self->{conf}->{BASE_DIR}/lib/FCC/Class/HTTP",
			"$self->{conf}->{BASE_DIR}/lib/FCC/Class/Image",
			"$self->{conf}->{BASE_DIR}/lib/FCC/Class/Mail",
			"$self->{conf}->{BASE_DIR}/lib/FCC/Class/Mpfmec",
			"$self->{conf}->{BASE_DIR}/lib/FCC/Class/String",
			"$self->{conf}->{BASE_DIR}/lib/FCC/View",
			"$self->{conf}->{BASE_DIR}/lib/FCC/View/Admin",
			"$self->{conf}->{BASE_DIR}/lib/FCC/View/Form",
			"$self->{conf}->{BASE_DIR}/lib/FCC/View/Install",
			"$self->{conf}->{BASE_DIR}/lib/File",
			"$self->{conf}->{BASE_DIR}/lib/FindBin",
			"$self->{conf}->{BASE_DIR}/lib/HTML",
			"$self->{conf}->{BASE_DIR}/lib/List",
			"$self->{conf}->{BASE_DIR}/lib/LockFile",
			"$self->{conf}->{BASE_DIR}/lib/Mail",
			"$self->{conf}->{BASE_DIR}/lib/MIME",
			"$self->{conf}->{BASE_DIR}/lib/Net",
			"$self->{conf}->{BASE_DIR}/lib/Scalar",
			"$self->{conf}->{BASE_DIR}/lib/Text",
			"$self->{conf}->{BASE_DIR}/lib/Time",
			"$self->{conf}->{BASE_DIR}/lib/Unicode",
			"$self->{conf}->{BASE_DIR}/template",
			"$self->{conf}->{BASE_DIR}/template/Admin",
			"$self->{conf}->{BASE_DIR}/template/Install"
		);
		for my $d (@dirs) {
			if( my $e = $self->dir_exist_check($d) ) {
				push(@errs, $e);
			}
		}
	}
	#dataディレクトリの書き込みチェック
	my $data_dir = "$self->{conf}->{BASE_DIR}/data";
	if(-d $data_dir) {
		if( my $e = $self->dir_write_check($data_dir) ) {
			push(@errs, $e);
		} else {
			my $htaccess = "${data_dir}/.htaccess";
			unless( -e $htaccess ) {
				if( open my $fh, ">", $htaccess ) {
					print $fh "deny from all";
					close($fh);
				} else {
					push(@errs, "${htaccess} の生成に失敗しました。: $!");
				}
			}
		}
	}
	#各種ファイルの存在
	{
		my @files = (
			"$self->{conf}->{BASE_DIR}/default/sample.config.cgi",
			"$self->{conf}->{BASE_DIR}/lib/Unicode/Japanese.pm"
		);
		for my $f (@files) {
			if( my $e = $self->exist_check($f) ) {
				push(@errs, $e);
			}
		}
	}
	#Unicode/Japanese.pmが壊れていないかをチェック
	{
		my $pm = "$self->{conf}->{BASE_DIR}/lib/Unicode/Japanese.pm";
		my $size = -s $pm;
		if($size != 498416) {
			push(@errs, "${pm} が壊れています。FTPでアップロードする際にASCII（テキスト）モードで転送した可能性があります。mpmailecフォルダを削除し、再度、BINARYモードでアップロードし直した上でセットアップをやり直してください。");
		}
	}
	#dataディレクトリのパーミッション変更(suExecが有効な場合のみ）
	if($self->{conf}->{SUEXEC}) {
		chmod 0700, "$self->{conf}->{BASE_DIR}/data";
	}
	#
	return \@errs;
}

sub permission_check {
	my($self, $file, , $executer, $permission) = @_;
	unless(-e $file) { return ''; }
	my $permission2 = sprintf("%o",(stat("$file"))[2] & 0777);
	my $err_str;
	my $err_flag = 0;
	if($executer eq 'owner') {
		unless($permission2 =~ /^(7|5)/) {
			unless($^O =~ /MSWin32/i) {
				my $p = $permission;
				if( chmod(oct($permission), $file) ) { return ''; }
			}
			$file =~ s/^$self->{parent_dir_path}\///;
			return "${file} に実行権限がありません。パーミッションを ${permission} に変更してください。";
		}
	} elsif($executer eq 'other') {
		unless($permission2 =~ /(7|5)$/) {
			$file =~ s/^$self->{parent_dir_path}\///;
			return "${file} に実行権限がありません。パーミッションを ${permission} に変更してください。";
		}
	}
	return '';
}

sub perl_path_check {
	my($self, $file, $perl_path) = @_;
	unless(-e $file) { return ''; }
	my $perl_path2 = $self->get_perl_path($file);
	if($perl_path2 ne $perl_path) {
		if( my $err = $self->rewrite_perl_path($file, $perl_path) ) {
			$file =~ s/^$self->{parent_dir_path}\///;
			return "${file} のPerlパスが正しく設定されていません。${file} の1行目を ${perl_path} に書き換えてください。";
		} else {
			return '';
		}
	}
	return '';
}

sub rewrite_perl_path {
	my($self, $file, $perl_path) = @_;
	unless(-e $file) { return $!; }
	my $data = $self->read_file($file);
	my @lines = split(/\n/, $data);
	if($lines[0] =~ /^\#\!/) {
		$lines[0] = $perl_path;
	}
	$data = join("\n", @lines);
	open my $fh, ">", $file or return "${file} のPerlパス書き換えに失敗しました。: $!";
	binmode($fh);
	print $fh $data;
	close($fh);
	return '';
}

sub read_file {
	my($self, $file) = @_;
	my $size = -s $file;
	open my $fh, "<", $file or die "${file} をオープンできませんでした。 : $!";
	binmode($fh);
	my $filestr;
	sysread($fh, $filestr, $size);
	close($fh);
	return $filestr;
}

sub write_check {
	my($self, $file) = @_;
	if( open my $fh, ">>", $file ) {
		close($fh);
	} else {
		$file =~ s/^$self->{parent_dir_path}\///;
		return "${file} のパーミッションが正しくありません。606 もしくは 666 に変更してください。";
	}
	return '';
}

sub dir_write_check {
	my($self, $dir) = @_;
	my $test_file = "${dir}/check.txt";
	if(-e $dir) {
		if( open my $fh, ">", $test_file ) {
			close($fh);
			unlink $test_file;
		} else {
			$dir =~ s/^$self->{parent_dir_path}\///;
			return "ディレクトリ ${dir} のパーミッションが正しくありません。707 もしくは 777 に変更してください。";
		}
	} else {
		return "ディレクトリ ${dir} がありません。。";
	}
	return '';
}

sub dir_exist_check {
	my($self, $dir) = @_;
	if(opendir(DIR, $dir)) {
		closedir(DIR);
	} else {
		$dir =~ s/^$self->{parent_dir_path}\///;
		return "ディレクトリ ${dir} がありません。サーバに ${dir} をアップロードしてください。";
	}
	return '';
}

sub exist_check {
	my($self, $file) = @_;
	unless(-e $file) {
		$file =~ s/^$self->{parent_dir_path}\///;
		return "${file} がありません。サーバに ${file} を アップロードしてください。";
	}
	return '';
}

sub return_code_check {
	my($self, $file, $rc) = @_;
	unless(-e $file) { return ''; }
	my $rc2 = $self->get_return_code($file);
	if($rc2 ne $rc) {
		eval {
			my $data = $self->read_file($file);
			$data =~ s/\x0D\x0A|\x0D|\x0A/${rc}/g;
			open my $fh, ">", $file or die "failed to create ${file} : $!";
			binmode($fh);
			print $fh $data;
			close($fh);
		};
		if($@) {
			$file =~ s/^$self->{parent_dir_path}\///;
			my $rc_cap;
			if($rc eq "\x0D\x0A") {
				$rc_cap = "CRLF";
			} elsif($rc eq "\x0D") {
				$rc_cap = "CR";
			} elsif($rc eq "\x0A") {
				$rc_cap = "LF";
			}
			return "${file} の改行コードが正しくありません。${file} の改行コードを ${rc_cap} に変換した上で、上書きアップロードしてください。";
		}
	}
	return '';
}

sub get_return_code {
	my($self, $file) = @_;
	my $size = -s $file;
	my $str;
	if( open my $fh, "<", $file ) {
		sysread($fh, $str, $size);
		close($fh);
	} else {
		return '';
	}
	my $return_code;
	if($str =~ /\x0D\x0A/) {
		$return_code = "\x0D\x0A";
	} elsif($str =~ /\x0D/) {
		$return_code = "\x0D";
	} elsif($str =~ /\x0A/) {
		$return_code = "\x0A";
	}
	return $return_code;
}

sub get_perl_path {
	my($self, $file) = @_;
	if( open my $fh, "<", $file ) {
		my @lines = <$fh>;
		my $perl_path = shift @lines;
		chop $perl_path;
		close($fh);
		return $perl_path;
	} else {
		return '';
	}
}


1;
