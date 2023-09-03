package MT4i::Func;

########################################
# Sub Lenb_EUC - Ⱦ�ѥ��ʡ�3�Х��ȴޤ�EUCʸ������length
# ���������Х��ȿ��������ʸ����
# \x8E[\xA1-\xDF] = EUCȾ�ѥ�������ɽ��
# \x8F[\xA1-\xFE][\xA1-\xFE] = EUC3�Х���ʸ������ɽ��
# ���͡�Perl��⢪http://www.din.or.jp/~ohzaki/perl.htm
########################################

sub lenb_euc {
    my $llen;
    $llen = length($_[0]);                                      # ���̤�length
    $llen -= $_[0]=~s/(\x8E[\xA1-\xDF])/$1/g;                   # Ⱦ�ѥ��ʿ���ޥ��ʥ�
    $llen -= ($_[0]=~s/(\x8F[\xA1-\xFE][\xA1-\xFE])/$1/g)*2;    # 3�Х���ʸ����*2��ޥ��ʥ�
    return $llen;
}

########################################
# Sub Midb_EUC - Ⱦ�ѥ��ʡ�3�Х��ȴޤ�EUCʸ������substr
# ���������ڤ�Ф�����ʸ����
# ����������ڤ�Ф����ϰ��֡�0����
# �軰�������ڤ�Ф��Х��ȿ�
# \x8E[\xA1-\xDF] = EUCȾ�ѥ�������ɽ��
# \x8F[\xA1-\xFE][\xA1-\xFE] = EUC3�Х���ʸ������ɽ��
# ���͡�Perl��⢪http://www.din.or.jp/~ohzaki/perl.htm
########################################

sub midb_euc {
    my $llen1;
    my $llen2;
    my $lstr;
    my $lstart;

    # �褺���������ϰ��֤���ʤ���
    if ($_[1] == 0) {
        $lstart = 0;
    } else {
        $llen1 = $_[1];
        $lstr = substr($_[0], 0, $llen1);
        $llen2 = MT4i::Func::lenb_euc($lstr);
        my $llen3 = $llen1;
        while ($_[1] > $llen2) {
            $llen3 = $llen1;
            $llen3 += $lstr=~s/(\x8E[\xA1-\xDF])/$1/g;                   # Ⱦ�ѥ��ʿ���ץ饹
            $llen3 += ($lstr=~s/(\x8F[\xA1-\xFE][\xA1-\xFE])/$1/g)*2;    # 3�Х���ʸ����*2��ץ饹
            $lstr = substr($_[0], 0, $llen3);
            $llen2 = MT4i::Func::lenb_euc($lstr);
        }
        $llen1 = $llen3;

        # �Ǹ��ʸ�������ڤ�Ƥ��뤫Ƚ�ꤹ��
        if ($lstr =~ /\x8F$/ || $lstr =~ tr/\x8E\xA1-\xFE// % 2) {
            chop $lstr;
            $llen1--;
            if($lstr =~ /\x8F$/){
                $llen1--;
            }
        }
        $lstart = $llen1;
    }

    # ʸ������ڤ�Ф�
    $llen1 = $_[2];
    $lstr = substr($_[0], $lstart, $llen1);
    $llen2 = MT4i::Func::lenb_euc($lstr);
    my $llen3;
    while ($_[2] > $llen2) {
        $llen3 = $llen1;
        $llen3 += $lstr=~s/(\x8E[\xA1-\xDF])/$1/g;                   # Ⱦ�ѥ��ʿ���ץ饹
        $llen3 += ($lstr=~s/(\x8F[\xA1-\xFE][\xA1-\xFE])/$1/g)*2;    # 3�Х���ʸ����*2��ץ饹
        $lstr = substr($_[0], $lstart, $llen3);
        $llen2 = MT4i::Func::lenb_euc($lstr);
    }
    $llen1 = $llen3;

    # �Ǹ��ʸ�������ڤ�Ƥ��뤫Ƚ�ꤹ��
    if ($lstr =~ /\x8F$/ || $lstr =~ tr/\x8E\xA1-\xFE// % 2) {
        chop $lstr;
        if($lstr =~ /\x8F$/){
            chop $lstr;
        }
    }
    return $lstr;
}

########################################
# crypt()�ˤ��Ź沽���ȹ�
# ���͡�http://www.rfs.co.jp/sitebuilder/perl/05/01.html#crypt
########################################

# �Ź沽������ʸ����($val)�������ꡢ�Ź沽����ʸ������֤��ؿ�
sub enc_crypt {
    my ($val) = @_;

    my( $sec, $min, $hour, $day, $mon, $year, $weekday )
        = localtime( time );
    my( @token ) = ( '0'..'9', 'A'..'Z', 'a'..'z' );
    my $salt = $token[(time | $$) % scalar(@token)];
    $salt .= $token[($sec + $min*60 + $hour*60*60) % scalar(@token)];
    my $passwd2 =  crypt( $val, $salt );

    $passwd2 =~ s/\//\@2F/g;
    $passwd2 =~ s/\$/\@24/g;
    $passwd2 =~ s/\./\@2E/g;

    return $passwd2;
}

########################################
# �ѥ����($passwd1)�ȰŹ沽�����ѥ����($passwd2)�������ꡢ
# ���פ��뤫��Ƚ�ꤹ��ؿ�
########################################
sub check_crypt{
    my ($passwd1, $passwd2) = @_;

    # ���Υѥ���ɤϵ����ʤ�
    return 0 if (!$passwd1 || !$passwd2);

    $passwd2 =~ s/\@2F/\//g;
    $passwd2 =~ s/\@24/\$/g;
    $passwd2 =~ s/\@2E/\./g;

    # �Ź�Υ����å�
    return ( crypt($passwd1, $passwd2) eq $passwd2 ) ? 1 : 0 ;
}

############################################################
# calc_cache_size:���ӤΥ���å���(1���̤˽��ϤǤ��������)�����
# ���� ���ӤΥ���å��奵����
# ���͡�http://deneb.jp/Perl/mobile/
# Special Thanks��drry
############################################################
sub calc_cache_size {

     my ( $user_agent ) = @_;
     my $cache_size = 50*1024;
    if ( $user_agent =~ m|DoCoMo.*\W.*c(\d+).*(c\d+)?|i ) {
         $cache_size = $1*1024;
     } elsif ( $user_agent =~ m|DoCoMo|i ) {
         $cache_size = 5*1024;
    } elsif ( $user_agent =~ m!(?:SoftBank|Vodafone)/\d\.\d|MOT-\w980! ) {
         $cache_size = 300*1024;
    } elsif ( $user_agent =~ m!J-PHONE(?:/([45]\.\d))?! ) {
        $cache_size = ($1 ? ($1 >= 5.0 ? 200: ($1 >= 4.3 ? 30: 12)): 6)*1024;
     } elsif ( $ENV{HTTP_X_UP_DEVCAP_MAX_PDU} ) {
         $cache_size = $ENV{HTTP_X_UP_DEVCAP_MAX_PDU};
     } elsif ( $user_agent =~ m|KDDI\-| ) {
        $cache_size = 9*1024;
    } elsif ( $user_agent =~ m|UP\.Browser| ) {
        $cache_size = 7.5*1024;
    }
    return $cache_size;
}

#################################################################
# Sub Get_mt4ilink - MT4i�ؤΥ�󥯤����
#
# ������HTML���������MT4i�Ǳ�������Τ�Ŭ����������
# �������롣����Ū�ˤ� [rel|rev]="alternate" ��link�����Τ�����
# title="MT4i" ���뤤�� media="handheld" ��°�����ĥ����ǻ�
# �ꤵ��Ƥ��� href ���֤���ξ�����ä����� title="MT4i" ����
# ��ͥ�褹�롣���Ĥ���ʤ���ж�ʸ������֤���
#
#################################################################
sub get_mt4ilink {
    my $url = $_[0];

    # �ۥ���̾���ִ�
    $url =~ s/http:\/\///;
    my $host = substr($url, 0, index($url, "/"));
    my $path = substr($url, index($url, "/"));
    if ($host eq $cfg{Photo_Host_Original}){
        $host = $cfg{Photo_Host_Replace};
    }
    $url = 'http://'.$host.$path;

    require LWP::Simple;
    # ����襳��ƥ�ļ���
    my $content = LWP::Simple::get($url);
    if (!$content) {
        # ��������
        return "";
    }

    # �إå����μ��Ф�
    my $pattern = "<[\s\t]*?head[\s\t]*?>(.*?)<[\s\t]*?/[\s\t]*?head[\s\t]*?>";
    my @head = ($content =~ m/$pattern/is);
    if (!$head[0]) {
        return "";
    }

    # link�����μ��Ф�
    $pattern = "<[\s\t]*?link[\s\t]*?(.*?)[\s\t/]*?>";
    my @links = ($head[0] =~ m/$pattern/isg);

    my $mt4ilink = ""; # titile="MT4i"
    my $hhlink     = ""; # media="handheld"

    found : foreach my $link ( @links ) {
        my $title = "";
        my $rel = "";
        my $media = "";
        my $href = "";
        if ($link =~ /title[\s\t]*?=[\s\t]*?([^\s\t]*)/i) {
            $title = $1;
            $title =~ s/["']//g;
        }
        if ($link =~ /rel[\s\t]*?=[\s\t]*?([^\s\t]*)/i) {
            $rel = $1;
        } elsif ($link =~ /rev[\s\t]*?=[\s\t]*?([^\s\t]*)/i) {
            $rel = $1;
        }
        if ($rel) {
            $rel =~ s/["']//g;
        }
        if ($link =~ /media[\s\t]*?=[\s\t]*?([^\s\t]*)/i) {
            $media = $1;
            $media =~ s/["']//g;
        }
        if ($link =~ /href[\s\t]*?=[\s\t]*?([^\s\t]*)/i) {
            $href = $1;
            $href =~ s/["']//g;
        }
        if ((lc $rel) eq 'alternate') {
            if ((lc $title) eq 'mt4i') {
                $mt4ilink = $href;
                last found;
            } elsif ((lc $media) eq 'handheld') {
                if (!$hhlink) {
                    $hhlink = $href;
                }
            }
        }
    }

    if ($mt4ilink) {
        return $mt4ilink;
    }
    return $hhlink;
}

##################################################
# Sub Get_SubObjList - ���֥��ƥ��ꥪ�֥������ȥꥹ�Ȥμ���
##################################################
sub get_subcatobjlist {
    my $category = shift;
    
    #�����������ƥ��ꥪ�֥������Ȥ���ҥ��ƥ�������
    my @sub_categories = $category->children_categories;
    if (@sub_categories) {
        # ���֥��ƥ���μ���
        foreach my $sub_category (@sub_categories) {
            my @ssub_categories = &get_subcatobjlist($sub_category);
            foreach my $ssub_category (@ssub_categories) {
                push @sub_categories, $ssub_category;
            }
        }
    }
    return @sub_categories;
}

####################
# Career distinction by User Agent
# ���͡�http://specters.net/cgipon/labo/c_dist.html
####################
sub get_ua {
    my ($ejpmobile) = @_;
    my $ua;
    my @user_agent = split(/\//,$::ENV{'HTTP_USER_AGENT'});
    my $png_flag;
    if ($user_agent[0] eq 'ASTEL') {
        # dot i
        $ua = 'other';
    } elsif ($user_agent[0] eq 'UP.Browser') {
        # EZweb old model
        $ua = 'ezweb';
    } elsif ($user_agent[0] =~ /^KDDI/) {
        # EZweb WAP2.0
        $ua = 'ezweb';
    } elsif ($user_agent[0] eq 'PDXGW') {
        # H"
        $ua = 'other';
    } elsif ($user_agent[0] eq 'DoCoMo') {
        # i-mode
        $ua = 'i-mode';
    } elsif ($user_agent[0] eq 'Vodafone' ||
             $user_agent[0] eq 'SoftBank') {
        # Vodafone or SoftBank
        $ua = 'j-sky';
    } elsif ($user_agent[0] eq 'J-PHONE') {
        # J-PHONE
        $ua = 'j-sky';
    
        # The model that can display only PNG is checked beforehand.
        if (($user_agent[2] =~ /^J-DN02/) ||
            ($user_agent[2] =~ /^J-P02/) ||
            ($user_agent[2] =~ /^J-P03/) ||
            ($user_agent[2] =~ /^J-T04/) ||
            ($user_agent[2] =~ /^J-SA02/) ||
            ($user_agent[2] =~ /^J-SH02/) ||
            ($user_agent[2] =~ /^J-SH03/)){
                $png_flag = 1;
        }
    } elsif ($user_agent[1] =~ 'DDIPOCKET' ||
             $user_agent[1] =~ 'WILLCOM') {
        # AirH"PHONE��Willcom
        $ua = 'i-mode';
    } elsif ($user_agent[0] eq 'L-mode') {
        # L-mode
        $ua = 'other';
    } elsif ($user_agent[0] =~ 'emobile') {
        # emobile
        $ua = 'i-mode';
    } else {
        # Other
        $ua = 'other';
    }

    my $enc_sjis;
    my $enc_utf8;
    if ($ejpmobile) {
        if ($ua eq 'i-mode' || $ua eq 'other') {
            $enc_sjis = 'x-sjis-docomo';
            $enc_utf8 = 'x-utf8-docomo';
        } elsif ($ua eq 'ezweb') {
            $enc_sjis = 'x-sjis-kddi';
            $enc_utf8 = 'x-utf8-kddi';
        } else {
            $enc_sjis = 'x-sjis-softbank';
            $enc_utf8 = 'x-utf8-softbank';
        }
    } else {
        $enc_sjis = 'shiftjis';
        $enc_utf8 = 'utf8';
    }

    return ($ua, $png_flag, $enc_sjis, $enc_utf8);
}

##################################################
# Sub Get_NonDispCats - ��ɽ�����ƥ���ꥹ�Ȥμ���
##################################################
sub get_nondispcats {
    my @nondispcats = split(",", $::cfg{NonDispCat});
    my @nonsubdispcats;
    foreach my $nondispcatid (@nondispcats) {
        # ID���饫�ƥ��ꥪ�֥������Ȥ����
        require MT::Category;
        my $category = MT::Category->load($nondispcatid);
        if (defined $category) {
            my @sub_categories = MT4i::Func::get_subcatobjlist($category);
            foreach my $sub_category (@sub_categories) {
                push @nonsubdispcats, $sub_category->id;
            }
        }
    }
    push @nondispcats, @nonsubdispcats;

    return @nondispcats;
}

##################################################
# Sub URL_Encode
# via http://sonic64.com/2003-08-31.html
##################################################
sub url_encode {
    my $url = shift;
    $url =~ s/([^\w ])/'%'.unpack('H2', $1)/eg;
    $url =~ tr/ /+/;
    return $url;
}

##################################################
# Sub Decode_Utf8
# If version is 5.0 upper, use decode_utf8
##################################################
sub decode_utf8 {
    my $str = shift;
    my $rtn = $::cfg{Version} >= 5.0
            ? Encode::decode_utf8($str)
            : Encode::decode("utf8", $str);
    return $rtn;
}

1;
