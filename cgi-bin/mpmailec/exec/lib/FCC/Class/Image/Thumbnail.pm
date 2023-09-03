package FCC::Class::Image::Thumbnail;
#---------------------------------------------------------------------#
#■サムネイル作成モジュール
#
#・使い方
#	use FCC::Class::Image::Thumbnail;
#	my $thumb = new FCC::Class::Image::Thumbnail();
#	my $meta = $thumb->make(
#		in_file      => "./source.gif",	# もとの画像ファイル（必須）
#		out_file     => "./destination.gif",	# サムネイル出力先（必須）
#		frame_width  => 200,	# サムネイルの枠の横幅
#		frame_height => 150,	# サムネイルの枠の縦幅
#		out_format   => 'jpeg',	# サムネイルの画像フォーマット (jpeg|gif|png)
#		quality      => 100,	# 品質（0-100）
#		module       => 'auto'	# 変換モジュール(im -> IMage::Magick, gd -> GD, auto -> 自動)
#	);
#	if( my $err = $thumb->error() ) {
#		die $err;
#	}
#
#	※moduleを指定しない、またはautoを指定した場合は、
#	  まずImage::Magickを試み、失敗したらGDを試みる
#
#	・newメソッド
#
#	・available_modulesメソッド
#		Image::MagickまたはGDが利用可能かをチェックする。
#		利用可能であれば、利用可能なモジュール（imおよびgd）を格納した
#		配列を返す。いずれも利用不可であれば空の配列を返す。
#
#	・makeメソッド
#		処理が成功すると、サムネイルのメタ情報を格納したhashrefを返す。
#		引数に問題があるとcroakする。
#		サムネイル生成に失敗するとundefを返す
#		{
#			in_file      => もとの画像ファイルパス,
#			out_file     => サムネイル出力先パス,
#			frame_width  => サムネイルの枠の横幅,
#			frame_height => サムネイルの枠の縦幅,
#			out_format   => サムネイルの画像フォーマット,
#			quality      => 品質(0-100),
#			module       => 変換モジュール(im or gd)
#			
#			in_format    => もとの画像フォーマットの説明文 (Image::Magickの場合のみ)
#			in_width     => もとの画像の横幅,
#			in_height    => もとの画像の縦幅,
#			out_width    => サムネイルの横幅,
#			out_height   => サムネイルの縦幅,
#			out_mtype    => サムネイルのMIMEタイプ,
#			out_size     => サムネイルのファイルサイズ
#		}
#
#	・errorメソッド
#		処理が失敗した場合に、エラーメッセージを返す
#---------------------------------------------------------------------#

$VERSION = 1.00;
use strict;
use warnings;
use Carp;

sub new {
	my($caller, %args) = @_;
	my $class = ref($caller) || $caller;
	my $self = {};
	#
	$self->{params} = {};
	$self->{err} = undef;
	bless $self, $class;
	return $self;
}

sub error {
	my($self) = @_;
	return $self->{err};
}

sub available_modules {
	my($self) = @_;
	my @ary;
	# Image::Magick
	eval {
		require Image::Magick;
	};
	if( ! $@ ) { push(@ary, "im"); }
	# GD
	eval {
		require GD;
		require GD::Image;
	};
	if( ! $@ ) { push(@ary, "gd"); }
	#
	return @ary;
}

sub make {
	my($self, %args) = @_;
	$self->{params} = $self->_make_params_check(%args);
	my $module = $self->{params}->{module};
	my $meta;
	eval {
		if($module eq "im") {
			$meta = $self->_make_by_im();
		} elsif($module eq "gd") {
			$meta = $self->_make_by_gd();
		} else {
			$meta = $self->_make_by_im();
			unless($meta) {
				$meta = $self->_make_by_gd();
			}
		}
	};
	if($@) {
		$self->{err} = $@;
		return undef;
	} else {
		if($meta) {
			return $meta;
		} else {
			return undef;
		}
	}
}


#--------------------------------------------------------------------

sub _make_params_check {
	my($self, %args) = @_;
	my $params = {};
	$params->{in_file} = $args{in_file};
	$params->{frame_width} = $args{frame_width};
	$params->{frame_height} = $args{frame_height};
	$params->{out_file} = $args{out_file};
	$params->{quality} = $args{quality};
	$params->{out_format} = $args{out_format};
	$params->{module} = $args{module};
	#パラメータのチェック
	if( ! defined $params->{in_file} ) {
		croak "the parameter of in_file is required.";
	} elsif( ! -e $params->{in_file} ) {
		croak "the file which is specified in the parameter of in_file is not found.";
	}
	#
	if( ! defined $params->{out_file} ) {
		croak "the parameter of out_file is required.";
	} else {
		if( open my $fh, ">", $params->{out_file} ) {
			unlink $params->{out_file};
		} else {
			croak "failed to make the file which is specified in the parameter of out_file. : $!";
		}
	}
	#
	if( ! defined $params->{frame_width} || $params->{frame_width} eq "" ) {
		$params->{frame_width} = 200;
	}
	if( $params->{frame_width} =~ /[^\d]/ ) {
		croak "the parameter of frame_width must be a number.";
	}
	#
	if( ! defined $params->{frame_height} || $params->{frame_height} eq "" ) {
		$params->{frame_height} = 150;
	}
	if( $params->{frame_height} =~ /[^\d]/ ) {
		croak "the parameter of frame_height must be a number.";
	}
	#
	if( ! defined $params->{quality} || $params->{quality} eq "" ) {
		$params->{quality} = 100;
	}
	if( $params->{quality} =~ /[^\d]/ ) {
		croak "the parameter of quality must be a number.";
	} elsif( $params->{quality} > 100 ) {
		croak "the parameter of quality must be up to 100.";
	}
	#
	if( ! defined $params->{out_format} || $params->{out_format} eq "" ) {
		if($params->{out_file} =~ /\.(png|gif)$/) {
			my $ext = $1;
			$params->{out_format} = $ext;
		} else {
			$params->{out_format} = "jpeg";
		}
	}
	if( $params->{out_format} !~ /^(png|jpeg|gif)$/ ) {
		croak "the parameter of out_format must be one of 'jpeg', 'png', 'gif'.";
	}
	#
	if( ! defined $params->{module} || $params->{module} eq "" ) {
		$params->{module} = "auto";
	}
	if( $params->{module} !~ /^(im|gd|auto)$/ ) {
		croak "the parameter of module must be one of 'im', 'gd', 'auto'.";
	}
	#
	return $params;
}

sub _make_by_im {
	my($self) = @_;
	eval { require Image::Magick; };
	if($@) {
		$self->{err} = $@;
		return undef;
	}
	#
	my $p = $self->{params};
	#サムネイル部分
	my $img = new Image::Magick->new;
	my $r_err = $img->Read($p->{in_file});
	if($r_err) { croak $r_err; }
	if($p->{quality}) {
		$img->Set(quality => $p->{quality});
	}
	my($in_width, $in_height, $in_format) = $img->Get('width', 'height', 'format');
	if( ! $in_width || ! $in_height || ! $in_format ) {
		$self->{err} = "unknown image format.";
		return undef;
	}
	my $in_aspect_ratio = $in_width / $in_height;
	my $frame_aspect_ratio = $p->{frame_width} / $p->{frame_height};
	my($out_width, $out_height);
	if($in_aspect_ratio >= $frame_aspect_ratio) {
		$out_width  = $p->{frame_width};
		$out_height = int($out_width / $in_aspect_ratio);
	} else {
		$out_height = $p->{frame_height};
		$out_width  = int($out_height * $in_aspect_ratio);
	}
	if($in_width < $p->{frame_width} && $in_height < $p->{frame_height}) {
		$out_width = $in_width;
		$out_height = $in_height;
	}
	$img->Scale(width=>$out_width, height=>$out_height);
	#ファイルに出力
	my $w_err = $img->Write("$p->{out_format}:$p->{out_file}");
	if($w_err) {
		$self->{err} =  $w_err;
		return undef;
	}
	#
	undef $img;
	chmod 0666, $p->{out_file};
	#
	$p->{in_format} = lc $in_format;
	$p->{in_width} = $in_width;
	$p->{in_height} = $in_height;
	$p->{out_width} = $out_width;
	$p->{out_height} = $out_height;
	$p->{out_size} = -s $p->{out_file};
	$p->{out_mtype} = "image/$p->{out_format}";
	$p->{module} = "im";
	#
	$self->{err} = undef;
	#
	return $p;
}

sub _make_by_gd {
	my($self) = @_;
	eval {
		require GD;
		require GD::Image;
	};
	if($@) {
		$self->{err} = $@;
		return undef;
	}
	#
	my $p = $self->{params};
	#オリジナル画像
	my $img = GD::Image->new($p->{in_file});
	unless($img) {
		$self->{err} = "failed to generate a GD instance.";
		return undef;
	}
	my($in_width,$in_height) = $img->getBounds();
	if( ! $in_width || ! $in_height ) {
		$self->{err} = "unknown image format.";
		return undef;
	}
	my $in_aspect_ratio = $in_width / $in_height;
	my $frame_aspect_ratio = $p->{frame_width} / $p->{frame_height};
	my($out_width, $out_height);
	if($in_aspect_ratio >= $frame_aspect_ratio) {
		$out_width  = $p->{frame_width};
		$out_height = int($out_width / $in_aspect_ratio);
	} else {
		$out_height = $p->{frame_height};
		$out_width  = int($out_height * $in_aspect_ratio);
	}
	if($in_width < $p->{frame_width} && $in_height < $p->{frame_height}) {
		$out_width = $in_width;
		$out_height = $in_height;
	}
	#サムネイル画像
	my $newimg = new GD::Image($out_width, $out_height, 1);
	$newimg->copyResized($img,0,0,0,0,$out_width,$out_height,$in_width,$in_height);
	my $data;
	if($p->{out_format} eq "gif") {
		$data = $newimg->gif();
	} elsif($p->{out_format} eq "png") {
		$data = $newimg->png();
	} else {
		$data = $newimg->jpeg($p->{quality});
	}
	unless (open(IMG, ">$p->{out_file}") ) {
		$self->{err} = "failed to open $p->{out_file} : $!";
		return undef;
	}
	binmode(IMG);
	print IMG $data;
	close(IMG);
	#
	$p->{in_width} = $in_width;
	$p->{in_height} = $in_height;
	$p->{out_width} = $out_width;
	$p->{out_height} = $out_height;
	$p->{out_size} = -s $p->{out_file};
	$p->{out_mtype} = "image/$p->{out_format}";
	$p->{module} = "gd";
	$self->{err} = undef;
	#
	$self->{err} = undef;
	#
	return $p;
}

1;
