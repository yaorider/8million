#!/usr/bin/perl
##################################################
#
# MT4i Manager - MT4i����ץ����
my $version = "3.1a";
#
##################################################

use strict;
use CGI;
use CGI::Carp qw(fatalsToBrowser);

# Config.pl��Func.pl��require�ڤ�¸�߳�ǧ
eval {require 'lib/mt4i/Config.pl'; 1} || die &errorout('"./lib/mt4i/Config.pl"�����դ���ޤ���');
eval {require 'lib/mt4i/Func.pl'; 1} || die &errorout('"./lib/mt4i/Func.pl"�����դ���ޤ���');

# �ѿ����
my %cfg;
my $mt4inm = 'mt4i.cgi';

####################
# �����μ���
my $q = new CGI();
my $mode = $q->param("mode");                    # �����⡼��
my $mgr_password = $q->param("mgr_password");    # ������ѥ����
my $mgr_confirm = $q->param("mgr_confirm");      # �������ǧ�ѥѥ����

####################
# ����$mode��Ƚ��
if (!$mode)             { &default }
if ($mode eq 'passset') { &default }
if ($mode eq 'menu')    { &menu }
if ($mode eq 'edit')    { &edit }
if ($mode eq 'vup')     { &edit }
if ($mode eq 'save')    { &save }
if ($mode eq 'geturl')  { &geturl }
if ($mode eq 'dispurl') { &dispurl }

sub default {
    &header;

    if (!(%cfg = Config::Read("./mt4icfg.cgi")) || !$cfg{'Password'}) {
        if ($mode eq 'passset') {
            unless ($mgr_password) {
                print '<div class="alert">Error : �ѥ���ɤ����Ϥ��Ƥ���������</div>';
            } elsif ($mgr_password ne $mgr_confirm) {
                print '<div class="alert">Error : �ѥ���ɤȳ�ǧ�ѥѥ���ɤ��ۤʤ�ޤ���</div>';
            } else {
                %cfg = Config::Read("./mt4icfg.cgi");
                $cfg{'Password'} = MT4i::Func::enc_crypt($mgr_password);
                &write_file(%cfg);
                print '<div class="description">MT4i Manager �Υѥ���ɤ����ꤷ�ޤ�����</div>';
                &login;
            }
        }
        print "<form action=\"./mt4imgr.cgi\" method=\"post\">";
        print '<div class="description">';
        print '�ޤ��ǽ�ˡ�MT4i Manager �˥����󤹤�٤Υѥ���ɤ����ꤷ�Ƥ���������';
        print '<br />';
        print '�������ɻߤΰ١��ֳ�ǧ�ѡפˤ�Ʊ���ѥ���ɤ����Ϥ��Ƥ���������';
        print '</div>';
        print '<div class="input">';
        print '<table><tr>';
        print '<td>�ѥ���ɡ�</td><td><input type="password" name="mgr_password" value="'.$mgr_password.'" /></td>';
        print '</tr><tr>';
        print '<td>��ǧ�ѡ�</td><td><input type="password" name="mgr_confirm" value="'.$mgr_confirm.'" /></td>';
        print '</tr><tr>';
        print '<td colspan="2" ><input type="submit" name="submit" value="��¸" /></td>';
        print '</tr></table>';
        print '</div>';
        print '<input type="hidden" name="mode" value="passset" />';
        print '</form>';
    } else {
        &login;
    }

    &hooter;
}

sub login {

    print "<form action=\"./mt4imgr.cgi\" method=\"post\">";
    print "<h3>������</h3>";
    print '<div class="description">';
    print '�ѥ����';
    print '</div>';
    print '<div class="input">';
    print '<input type="password" name="password" />';
    print '<input type="submit" name="submit" value="������" />';
    print '</div>';
    print '<input type="hidden" name="mode" value="menu" />';
    print '</form>';

    &hooter;
    exit;
}

sub menu {
    %cfg = Config::Read("./mt4icfg.cgi");

    my $sendpass = $q->param("password");

    &header;

    if (!MT4i::Func::check_crypt($sendpass, $cfg{'Password'})) {
        print '�ѥ���ɤ��㤤�ޤ���<br />';
        print '<form action="./mt4imgr.cgi" method="post">';
        print '<input type="hidden" name="password" value="'.$sendpass.'" />';
        print '<input type="submit" name="submit" value="���" />';
        print '</form>';
    
        &hooter;
    
        exit;
    }

    print "<form action=\"./mt4imgr.cgi\" method=\"post\">";
    print '<div class="description">';
    print '��˥塼';
    print '</div>';
    print '<div class="input">';
    print '<input type="radio" name="mode" id="edit" value="edit" style="vertical-align:middle" checked /><label for="edit" style="vertical-align:middle" >������Խ����롣</label>';
    if ($cfg{AdminPassword} && $cfg{AdminPassword} ne 'password') {
        print '<br />';
        print '<input type="radio" name="mode" id="geturl" value="geturl" style="vertical-align:middle" /><label for="geturl" style="vertical-align:middle" >�������Ѥ�URL��������롣</label>';
    }
    print '</div>';
    print '<div class="input">';
    print '<input type="submit" name="submit" value="ENTER" />';
    print '</div>';
    print '<input type="hidden" name="password" value="'.$sendpass.'" />';
    print '</form>';

    &hooter;
}

sub geturl {
    %cfg = Config::Read("./mt4icfg.cgi");

    my $sendpass = $q->param("password");

    &header;

    if (!MT4i::Func::check_crypt($sendpass, $cfg{'Password'})) {
        print '�ѥ���ɤ��㤤�ޤ���<br />';
        print '<form action="./mt4imgr.cgi" method="post">';
        print '<input type="hidden" name="mode" value="menu" />';
        print '<input type="hidden" name="password" value="'.$sendpass.'" />';
        print '<input type="submit" name="submit" value="���" />';
        print '</form>';
    
        &hooter;
    
        exit;
    }

    print "<form action=\"./mt4imgr.cgi\" method=\"post\">";
    print '<div class="description">';
    print '��������URL�����ѥ����';
    print '</div>';
    print '<div class="input">';
    print '<input type="password" name="adminpassword" />';
    print '<input type="submit" name="submit" value="ENTER" />';
    print '</div>';
    print '<input type="hidden" name="mode" value="dispurl" />';
    print '<input type="hidden" name="password" value="'.$sendpass.'" />';
    print '</form>';
    print '<form action="./mt4imgr.cgi" method="post">';
    print '<input type="hidden" name="mode" value="menu" />';
    print '<input type="hidden" name="password" value="'.$sendpass.'" />';
    print '<input type="submit" name="submit" value="��˥塼�����" />';
    print '</form>';
    
    &hooter;
}

sub dispurl {
    my $adminpass = $q->param("adminpassword");
    my $sendpass = $q->param("password");

    # �����ɤ߹���
    %cfg = Config::Read("./mt4icfg.cgi");

    &header;

    if ($adminpass ne $cfg{AdminPassword}) {
        print '��������URL�����ѥ���ɤ��㤤�ޤ���<br />';
        print '<form action="./mt4imgr.cgi" method="post">';
        print '<input type="hidden" name="mode" value="geturl" />';
        print '<input type="hidden" name="password" value="'.$sendpass.'" />';
        print '<input type="submit" name="submit" value="���" />';
        print '</form>';
    
        &hooter;
    
        exit;
    } elsif (!MT4i::Func::check_crypt($sendpass, $cfg{'Password'})) {
        print '�ѥ���ɤ��㤤�ޤ���<br />';
        print '<form action="./mt4imgr.cgi" method="post">';
        print '<input type="hidden" name="mode" value="geturl" />';
        print '<input type="hidden" name="password" value="'.$sendpass.'" />';
        print '<input type="submit" name="submit" value="���" />';
        print '</form>';
    
        &hooter;
    
        exit;
    }

    my $key = MT4i::Func::enc_crypt($cfg{AdminPassword}.$cfg{Blog_ID});

    print '<p>��������URL��';
    print "<a href=\"$cfg{MyName}?".$cfg{Blog_ID}."&key=".$key."\">������</a>";
    print '�Ǥ���</p>';
    print '<form action="./mt4imgr.cgi" method="post">';
    print '<input type="hidden" name="mode" value="menu" />';
    print '<input type="hidden" name="password" value="'.$sendpass.'" />';
    print '<input type="submit" name="submit" value="��˥塼�����" />';
    print '</form>';
    
    &hooter;
}

sub edit {
    %cfg = Config::Read("./mt4icfg.cgi");

    &header;

    # �ѥ����ǧ��
    my $sendpass = $q->param("password");
    if (!MT4i::Func::check_crypt($sendpass, $cfg{'Password'})) {
        print '�ѥ���ɤ��㤤�ޤ���<br />';
        print '<form action="./mt4imgr.cgi" method="post">';
        print '<input type="hidden" name="mode" value="menu" />';
        print '<input type="hidden" name="password" value="'.$sendpass.'" />';
        print '<input type="submit" name="submit" value="���" />';
        print '</form>';
    
        &hooter;
    
        exit;
    }

    if ($mode eq "vup") {
        if ($q->param("mt4inm")) {
            $mt4inm = $q->param("mt4inm");
        }
        if (!-e $mt4inm) {
            print "\"$mt4inm\"�����դ���ޤ���<br>";
            print "MT4i���ΤΥե�����̾�����Ϥ��Ƥ���������<br>";
            print "<form action=\"./mt4imgr.cgi\" method=\"post\">";
            print "<input type=\"text\" name=\"mt4inm\" style=\"width:200px\"><br />";
            print "<input type=\"submit\" name=\"submit\" value=\"����\">";
            print "<input type=\"hidden\" name=\"mode\" value=\"vup\">";
            print "<input type=\"hidden\" name=\"password\" value=\"$cfg{'Password'}\">";
            print "</form>";
        
            &hooter;
        
            exit;
        }
        # mt4i.cgi�����ץ�
        open(IN,"< $mt4inm") or die print "\"$mt4inm\"�����դ���ޤ���";
    
        my $rit_id_fl = 0;
        my $rat_id_fl = 0;
        while (<IN>){
            my $tmp = $_;
            chomp($tmp);
        
            # ��ա������ǤϸŤ��С�����󤫤��ͤ��ɤ߹���Ǥ���Τǡ�
            #       �����Υѥ�᡼���򤳤����ɲä���ɬ�פϤ���ޤ���
            if ($tmp =~ /^my/) {
                if ($tmp =~ /\(\$MT_DIR\)[^"']*["']([^"']*)["']/) {
                    $cfg{'MT_DIR'} = enc_tag($1);
                } elsif ($tmp =~ /\$blog_id[^"']*["']([^"']*)["']/) {
                    $cfg{'Blog_ID'} = enc_tag($1);
                } elsif ($tmp =~ /\$adm_nm[^"']*["']([^"']*)["']/) {
                    $cfg{'AdmNM'} = enc_tag($1);
                } elsif ($tmp =~ /\$adm_ml[^"']*["']([^"']*)["']/) {
                    $cfg{'AdmML'} = enc_tag($1);
                } elsif ($tmp =~ /\$logo_i[^"']*["']([^"']*)["']/) {
                    $cfg{'Logo_i'} = enc_tag($1);
                } elsif ($tmp =~ /\$logo_o[^"']*["']([^"']*)["']/) {
                    $cfg{'Logo_o'} = enc_tag($1);
                } elsif ($tmp =~ /\$disp_num[^"']*["']([^"']*)["']/) {
                    $cfg{'DispNum'} = enc_tag($1);
                } elsif ($tmp =~ /\$bg_color[^"']*["']([^"']*)["']/) {
                    $cfg{'BgColor'} = enc_tag($1);
                } elsif ($tmp =~ /\$txt_color[^"']*["']([^"']*)["']/) {
                    $cfg{'TxtColor'} = enc_tag($1);
                } elsif ($tmp =~ /\$lnk_color[^"']*["']([^"']*)["']/) {
                    $cfg{'LnkColor'} = enc_tag($1);
                } elsif ($tmp =~ /\$alnk_color[^"']*["']([^"']*)["']/) {
                    $cfg{'AlnkColor'} = enc_tag($1);
                } elsif ($tmp =~ /\$vlnk_color[^"']*["']([^"']*)["']/) {
                    $cfg{'VlnkColor'} = enc_tag($1);
                } elsif ($tmp =~ /\$z2h[^"']*["']([^"']*)["']/) {
                    $cfg{'Z2H'} = enc_tag($1);
                } elsif ($tmp =~ /\$bq2p[^"']*["']([^"']*)["']/) {
                    $cfg{'BQ2P'} = enc_tag($1);
                } elsif ($tmp =~ /\$bqcolor[^"']*["']([^"']*)["']/) {
                    $cfg{'BqColor'} = enc_tag($1);
                } elsif ($tmp =~ /\$sprtstr[^"']*["']([^"']*)["']/) {
                    $cfg{'SprtStr'} = enc_tag($1);
                } elsif ($tmp =~ /\$sprtlimit[^"']*["']([^"']*)["']/) {
                    $cfg{'SprtLimit'} = enc_tag($1);
                } elsif ($tmp =~ /\$myname[^"']*["']([^"']*)["']/) {
                    $cfg{'MyName'} = enc_tag($1);
                } elsif ($tmp =~ /\$accesskey[^"']*["']([^"']*)["']/) {
                    $cfg{'AccessKey'} = enc_tag($1);
                } elsif ($tmp =~ /\$image_autoreduce[^"']*["']([^"']*)["']/) {
                    $cfg{'ImageAutoReduce'} = enc_tag($1);
                } elsif ($tmp =~ /\$photo_width[^"']*["']([^"']*)["']/) {
                    $cfg{'PhotoWidth'} = enc_tag($1);
                } elsif ($tmp =~ /\$png_width[^"']*["']([^"']*)["']/) {
                    $cfg{'PngWidth'} = enc_tag($1);
                } elsif ($tmp =~ /\$cat_desc_replace[^"']*["']([^"']*)["']/) {
                    $cfg{'CatDescReplace'} = enc_tag($1);
                } elsif ($tmp =~ /\$cat_desc_sort[^"']*["']([^"']*)["']/) {
                    $cfg{'CatDescSort'} = enc_tag($1);
                } elsif ($tmp =~ /\$post_from_essential[^"']*["']([^"']*)["']/) {
                    $cfg{'PostFromEssential'} = enc_tag($1);
                } elsif ($tmp =~ /\$post_mail_essential[^"']*["']([^"']*)["']/) {
                    $cfg{'PostMailEssential'} = enc_tag($1);
                } elsif ($tmp =~ /\$post_text_essential[^"']*["']([^"']*)["']/) {
                    $cfg{'PostTextEssential'} = enc_tag($1);
                } elsif ($tmp =~ /\$recent_comment[^"']*["']([^"']*)["']/) {
                    $cfg{'RecentComment'} = enc_tag($1);
                } elsif ($tmp =~ /\$recent_trackback[^"']*["']([^"']*)["']/) {
                    $cfg{'RecentTB'} = enc_tag($1);
                } elsif ($tmp =~ /\$photo_host_original[^"']*["']([^"']*)["']/) {
                    $cfg{'Photo_Host_Original'} = enc_tag($1);
                } elsif ($tmp =~ /\$photo_host_replace[^"']*["']([^"']*)["']/) {
                    $cfg{'Photo_Host_Replace'} = enc_tag($1);
                } elsif ($tmp =~ /\$exitchtmltrans[^"']*["']([^"']*)["']/) {
                    $cfg{'ExitChtmlTrans'} = enc_tag($1);
                } elsif ($tmp =~ /\@rbld_indx_tmpl_id/) {
                    $rit_id_fl = 1;
                    $cfg{'RIT_ID'} = '';
                } elsif ($tmp =~ /\@rbld_arc_tmpl_id/) {
                    $rat_id_fl = 1;
                    $cfg{'RAT_ID'} = '';
                } elsif ($tmp =~ /\$approve_comment[^"']*["']([^"']*)["']/) {
                    $cfg{'ApproveComment'} = enc_tag($1);
                } elsif ($tmp =~ /\$admin_helper[^"']*["']([^"']*)["']/) {
                    my @arg = split(/,/, $1);
                    $cfg{'AdminHelper'} = 'yes';
                    $cfg{'AdminHelperID'} = $arg[0];
                    $cfg{'AdminHelperNM'} = $arg[1];
                    $cfg{'AdminHelperML'} = $arg[2];
                } elsif ($tmp =~ /\$author_name[^"']*["']([^"']*)["']/) {
                    $cfg{'AuthorName'} = enc_tag($1);
                } elsif ($tmp =~ /\$admin_password[^"']*["']([^"']*)["']/) {
                    $cfg{'AdminPassword'} = enc_tag($1);
                }
            } elsif ($rit_id_fl == 1) {
                if ($tmp !~ /\);/) {
                    $tmp =~ s/    //g;
                    $tmp =~ s/ //g;
                    $tmp =~ s/'//g;
                    $cfg{'RIT_ID'} = $cfg{'RIT_ID'} . $tmp;
                } else {
                    $rit_id_fl = 0;
                    $cfg{'RIT_ID'} =~ s/,$//g;
                }
            } elsif ($rat_id_fl == 1) {
                if ($tmp !~ /\);/) {
                    $tmp =~ s/    //g;
                    $tmp =~ s/ //g;
                    $tmp =~ s/'//g;
                    $cfg{'RAT_ID'} = $cfg{'RAT_ID'} . $tmp;
                } else {
                    $rat_id_fl = 0;
                    $cfg{'RAT_ID'} =~ s/,$//g;
                }
            }
            # ��ա������ǤϸŤ��С�����󤫤��ͤ��ɤ߹���Ǥ���Τǡ�
            #       �����Υѥ�᡼���򤳤����ɲä���ɬ�פϤ���ޤ���
        }
        print '<p>';
        if (!$cfg{'MT_DIR'}) {
            print '���꤬¸�ߤ��ޤ��󡣽���ͤ��������ޤ���<br />';
            print "���⤷���ϡ�<a href=\"./mt4imgr.cgi?mode=vup&amp;password=$sendpass\">v1.82��1������������ɤ߹���ˤϤ����顣</a>";
        } else {
            print '������ɤ߹��ߤޤ�����<br />';
        }
        print '</p>';
    } elsif (!exists $cfg{'MT_DIR'}) {
        print '<p>';
        print '���꤬¸�ߤ��ޤ��󡣽���ͤ��������ޤ���<br />';
        print "���⤷���ϡ�<a href=\"./mt4imgr.cgi?mode=vup&amp;password=$sendpass\">v1.82��1������������ɤ߹���ˤϤ����顣</a>";
        print '</p>';
    }

    # �ǥե����������
    if ( !exists $cfg{'MT_DIR'} ) { $cfg{'MT_DIR'} = './'; }
    if ( !exists $cfg{'Blog_ID'} ) { $cfg{'Blog_ID'} = ''; }
    if ( !exists $cfg{'AdmNM'} ) { $cfg{'AdmNM'} = ''; }
    if ( !exists $cfg{'AdmML'} ) { $cfg{'AdmML'} = ''; }
    if ( !exists $cfg{'Logo_i'} ) { $cfg{'Logo_i'} = ''; }
    if ( !exists $cfg{'Logo_o'} ) { $cfg{'Logo_o'} = ''; }
    if ( !exists $cfg{'DispNum'} ) { $cfg{'DispNum'} = 10; }
    if ( !exists $cfg{'DtLang'} ) { $cfg{'DtLang'} = 'ja'; }
    if ( !exists $cfg{'IndexDtFormat'} ) { $cfg{'IndexDtFormat'} = '%Y-%m-%d %H:%M:%S'; }
    if ( !exists $cfg{'IndividualDtFormat'} ) { $cfg{'IndividualDtFormat'} = '%Y-%m-%d %H:%M:%S'; }
    if ( !exists $cfg{'CommentDtFormat'} ) { $cfg{'CommentDtFormat'} = '%Y-%m-%d %H:%M:%S'; }
    if ( !exists $cfg{'TBPingDtFormat'} ) { $cfg{'TBPingDtFormat'} = '%Y-%m-%d %H:%M:%S'; }
    if ( !exists $cfg{'BgColor'} ) { $cfg{'BgColor'} = '#FFFFFF'; }
    if ( !exists $cfg{'TxtColor'} ) { $cfg{'TxtColor'} = '#000000'; }
    if ( !exists $cfg{'LnkColor'} ) { $cfg{'LnkColor'} = '#0000FF'; }
    if ( !exists $cfg{'AlnkColor'} ) { $cfg{'AlnkColor'} = '#FF0000'; }
    if ( !exists $cfg{'VlnkColor'} ) { $cfg{'VlnkColor'} = '#800080'; }
    if ( !exists $cfg{'Z2H'} ) { $cfg{'Z2H'} = 'yes'; }
    if ( !exists $cfg{'BQ2P'} ) { $cfg{'BQ2P'} = 'no'; }
    if ( !exists $cfg{'BqColor'} ) { $cfg{'BqColor'} = '#008000'; }
    if ( !exists $cfg{'SprtStr'} ) { $cfg{'SprtStr'} = '<br />,<br>,</p>'; }
    if ( !exists $cfg{'SprtLimit'} ) { $cfg{'SprtLimit'} = 4096; }
    if ( !exists $cfg{'MyName'} ) { $cfg{'MyName'} = 'mt4i.cgi'; }
    if ( !exists $cfg{'AccessKey'} ) { $cfg{'AccessKey'} = 'yes'; }
    if ( !exists $cfg{'ImageAutoReduce'} ) { $cfg{'ImageAutoReduce'} = 'imagemagick'; }
    if ( !exists $cfg{'PhotoWidth'} ) { $cfg{'PhotoWidth'} = 144; }
    if ( !exists $cfg{'PhotoWidthForce'} ) { $cfg{'PhotoWidthForce'} = 0; }
    if ( !exists $cfg{'PngWidth'} ) { $cfg{'PngWidth'} = 48; }
    if ( !exists $cfg{'CatDescReplace'} ) { $cfg{'CatDescReplace'} = 'no'; }
    if ( !exists $cfg{'CatDescSort'} ) { $cfg{'CatDescSort'} = 'none'; }
    if ( !exists $cfg{'PostFromEssential'} ) { $cfg{'PostFromEssential'} = 'yes'; }
    if ( !exists $cfg{'PostMailEssential'} ) { $cfg{'PostMailEssential'} = 'yes'; }
    if ( !exists $cfg{'PostTextEssential'} ) { $cfg{'PostTextEssential'} = 'yes'; }
    if ( !exists $cfg{'RecentComment'} ) { $cfg{'RecentComment'} = 15; }
    if ( !exists $cfg{'RecentTB'} ) { $cfg{'RecentTB'} = 10; }
    if ( !exists $cfg{'Photo_Host_Original'} ) { $cfg{'Photo_Host_Original'} = ''; }
    if ( !exists $cfg{'Photo_Host_Replace'} ) { $cfg{'Photo_Host_Replace'} = 'localhost'; }
    if ( !exists $cfg{'CommentNum'} ) { $cfg{'CommentNum'} = 5; }
    if ( !exists $cfg{'ChtmlTrans'} ) { $cfg{'ChtmlTrans'} = 1; }
    if ( !exists $cfg{'ExitChtmlTrans'} ) { $cfg{'ExitChtmlTrans'} = '�����б�'; }
    if ( !exists $cfg{'MobileGW'} ) { $cfg{'MobileGW'} = '1'; }
    if ( !exists $cfg{'ECTrans_Str_i'} ) { $cfg{'ECTrans_Str_i'} = '<font color="#FFCC33">&#63862;</font>'; }
    if ( !exists $cfg{'ECTrans_Str_j'} ) { $cfg{'ECTrans_Str_j'} = "\x1B\$Fu\x0F"; }
    if ( !exists $cfg{'ECTrans_Str_o'} ) { $cfg{'ECTrans_Str_o'} = '(�����б�)'; }
    if ( !exists $cfg{'Ainori_Str_i'} ) { $cfg{'Ainori_Str_i'} = '<font color="#FFCC33">&#63862;</font>'; }
    if ( !exists $cfg{'Ainori_Str_j'} ) { $cfg{'Ainori_Str_j'} = "\x1B\$Fu\x0F"; }
    if ( !exists $cfg{'Ainori_Str_o'} ) { $cfg{'Ainori_Str_o'} = '(MT4i)'; }
    if ( !exists $cfg{'RIT_ID'} ) { $cfg{'RIT_ID'} = 'ALL'; }
    if ( !exists $cfg{'RAT_ID'} ) { $cfg{'RAT_ID'} = 'ALL'; }
    if ( !exists $cfg{'ApproveComment'} ) { $cfg{'ApproveComment'} = 'yes'; }
    if ( !exists $cfg{'CommentFilterStr'} ) { $cfg{'CommentFilterStr'} = '<h1>,<a\s,^[\x00-\xff]+$'; }
    if ( !exists $cfg{'SerNo'} ) { $cfg{'SerNo'} = 0; }
    if ( !exists $cfg{'AdminHelper'} ) { $cfg{'AdminHelper'} = 'no'; }
    if ( !exists $cfg{'AdminHelperID'} ) { $cfg{'AdminHelperID'} = ''; }
    if ( !exists $cfg{'AdminHelperNM'} ) { $cfg{'AdminHelperNM'} = ''; }
    if ( !exists $cfg{'AdminHelperML'} ) { $cfg{'AdminHelperML'} = ''; }
    if ( !exists $cfg{'AuthorName'} ) { $cfg{'AuthorName'} = ''; }
    if ( !exists $cfg{'AdminPassword'} ) { $cfg{'AdminPassword'} = 'password'; }
    if ( !exists $cfg{'NonDispCat'} ) { $cfg{'NonDispCat'} = ''; }
    if ( !exists $cfg{'LenCutCat'} ) { $cfg{'LenCutCat'} = 0; }
    if ( !exists $cfg{'ArrowComments'} ) { $cfg{'ArrowComments'} = 1; }
    if ( !exists $cfg{'CacheTime'} ) { $cfg{'CacheTime'} = 0; }
    if ( !exists $cfg{'PurgeCacheLimit'} ) { $cfg{'PurgeCacheLimit'} = 24; }
    if ( !exists $cfg{'PurgeCacheMailFrom'} ) { $cfg{'PurgeCacheMailFrom'} = ''; }
    if ( !exists $cfg{'PurgeCacheMailTo'} ) { $cfg{'PurgeCacheMailTo'} = ''; }
    if ( !exists $cfg{'CachePageCountIndex'} ) { $cfg{'CachePageCountIndex'} = 0; }
    if ( !exists $cfg{'PathOfUseLib'} ) { $cfg{'PathOfUseLib'} = ''; }

    #----------------------------------------------------------------------------------------------------
    print '<table><tr><td>';
    print '<ul>';
    print '    <li><span style="font-weight:bold;color:#FF0000;">ɬ���������</span>';
    print '    <ul>';
    print '        <li><a href="#MT_DIR"> MT�ۡ���ǥ��쥯�ȥ�</a></li>';
    print '        <li><a href="#Blog_ID">Movable Type ��ǻ��Ѥ��Ƥ���Blog��ͭ��ID</a></li>';
    print '    </ul>';
    print '    </li>';
    print '</ul>';
    print '<ul>';
    print '    <li>ɽ����Ϣ�������';
    print '    <ul>';
    print '        <li><a href="#AdmNML">������̾��ɽ���ȥ᡼�륢�ɥ쥹</a></li>';
    print '        <li><a href="#Logo">�����ȥ�����������ꤹ��</a></li>';
    print '        <li><a href="#DispNum">�ȥåסʵ��������ˤ�ɽ�������뵭����</a></li>';
    print '        <li><a href="#DT">���������ɽ������</a></li>';
    print '        <li><a href="#Colors">��������</a></li>';
    print '    </ul>';
    print '    </li>';
    print '</ul>';
    print '<ul>';
    print '    <li>�����ȴ�Ϣ�������';
    print '    <ul>';
    print '        <li><a href="#CommentNum">1�ڡ�����ɽ�����륳���ȿ�</a></li>';
    print '        <li><a href="#PostEssential">��������ƻ�����ɬ�ܹ��ܤλ���</a></li>';
    print '        <li><a href="#RecentComment">�Ƕ�Υ����Ȱ���ɽ�������ȿ�</a></li>';
    print '        <li><a href="#RIAT_ID">��������ƻ���Rebuild�оݥƥ�ץ졼�Ȥ���ꤹ��</a></li>';
    print '        <li><a href="#ArrowComments">��������Ƶ�ǽ��ON/OFF</a></li>';
    print '        <li><a href="#ApproveComment">�����ȷǺܤξ�����MT3.0�ʾ��ͭ����</a></li>';
    print '        <li><a href="#CommentFilterStr">������ SPAM Ƚ������ɽ��</a></li>';
    print '        <li><a href="#SerNo">��������ƻ��˸�ͭ���̾�����׵᤹��</a></li>';
    print '    </ul>';
    print '    </li>';
    print '</ul>';
    print '<ul>';
    print '    <li>���ƥ����Ϣ�������';
    print '    <ul>';
    print '        <li><a href="#CatDescReplace">���ƥ���̾��Description�ִ�</a></li>';
    print '        <li><a href="#CatDescSort">���ƥ���̾�Υ�����</a></li>';
    print '        <li><a href="#NonDispCat">����Υ��ƥ������ɽ���ˤ���</a></li>';
    print '        <li><a href="#LenCutCat">���ƥ���̾�����ʸ�����ǥ��åȤ���</a></li>';
    print '    </ul>';
    print '    </li>';
    print '</ul>';
    print '<ul>';
    print '    <li>Cache ��Ϣ�������';
    print '    <ul>';
    print '        <li><a href="#CacheTime">����å�����ݻ�����</a></li>';
    print '        <li><a href="#PurgeCacheScript">purge_old_cache.pl ������ץȤ˴ؤ�������</a></li>';
    print '        <li><a href="#CachePageCountIndex">����ǥå����ڡ����򥭥�å��夹��ڡ�����</a></li>';
    print '    </ul>';
    print '    </li>';
    print '</ul>';
    print '</td><td>';
    print '<ul>';
    print '    <li>������Ϣ�������';
    print '    <ul>';
    print '        <li><a href="#ImageAutoReduce">�����μ�ư�̾�</a></li>';
    print '        <li><a href="#PhotoWidth">�ǥե���Ȳ����β���</a></li>';
    print '        <li><a href="#PngWidth">vodafone�����굡��(6����)��PNG�����β���</a></li>';
    print '        <li><a href="#PhotoWidthForce">��������ꤷ�����˶���Ū�˽̾�����</a></li>';
    print '    </ul>';
    print '    </li>';
    print '</ul>';
    print '<ul>';
    print '    <li>����¾Ǥ���������';
    print '    <ul>';
    print '        <li><a href="#Z2H">���Ѣ�Ⱦ���Ѵ�</a></li>';
    print '        <li><a href="#BQ2P">&lt;blockquote&gt;��&lt;p&gt;�Ѵ�</a></li>';
    print '        <li><a href="#SprtStr">����ʬ����ζ��ڤ�ʸ����</a></li>';
    print '        <li><a href="#SprtLimit">������ʸ��ʬ��򤹤����¥Х��ȿ�</a></li>';
    print '        <li><a href="#MyName">MT4i���ΤΥե�����̾</a></li>';
    print '        <li><a href="#AccessKey">�������äγ�ʸ���ڤӥ�����������</a></li>';
    print '        <li><a href="#RecentTB">�Ƕ�Υȥ�å��Хå�ɽ����</a></li>';
    print '        <li><a href="#Photo_Host">���𥵡��Фγ�/�����ۥ���̾</a></li>';
    print '        <li><a href="#ChtmlTrans">��Х����Ѵ������ȥ��������������</a></li>';
    print '        <li><a href="#Ainori">�����Τ굡ǽ��Mobile Link Discovery��</a></li>';
    print '    </ul>';
    print '    </li>';
    print '</ul>';
    print '<ul>';
    print '    <li>�����ԥ⡼���������';
    print '    <ul>';
    print '        <li><a href="#AdminHelper">��������ƻ��δ����Ծ����������</a></li>';
    print '        <li><a href="#AuthorName">Entry��ƼԤΥ�����̾</a></li>';
    print '        <li><a href="#AdminPassword">������URL�����ѥ����</a></li>';
    print '    </ul>';
    print '    </li>';
    print '</ul>';
    print '<ul>';
    print '    <li>�����������';
    print '    <ul>';
    print '        <li><a href="#PathOfUseLib">�ɲå饤�֥��Υѥ�</a></li>';
    print '    </ul>';
    print '    </li>';
    print '</ul>';
    print '<ul>';
    print '    <li>MT4i Manager �������';
    print '    <ul>';
    print '        <li><a href="#ManagementPass">MT4i Manager �ѥ���ɤ��ѹ�</a></li>';
    print '    </ul>';
    print '    </li>';
    print '</ul>';
    print '</td></tr></table>';
    #----------------------------------------------------------------------------------------------------

    print '<form action="./mt4imgr.cgi" method="post">';
    print '<input type="hidden" name="mode" value="menu" />';
    print '<input type="hidden" name="password" value="'.$sendpass.'" />';
    print '<input type="submit" name="submit" value="��˥塼�����" />';
    print '</form>';
    print "<form action=\"./mt4imgr.cgi\" method=\"post\">";
    print '<input type="submit" name="submit" value="��¸" /><br />';

    #----------------------------------------------------------------------------------------------------
    print '<h3>ɬ���������</h3>';
    print '<h4 id="MT_DIR">MT_DIR - MT�ۡ���ǥ��쥯�ȥ�</h4>';
    print '<div class="description">';
    print 'Movable Type �򥤥󥹥ȡ��뤷���ǥ��쥯�ȥ��mt.cgi�Τ�����ˤ����Хѥ����뤤�����Хѥ��ǻ��ꡣ<br />��"http://��" �ǻϤޤ�URL�ǤϤʤ��פΤ���ա�<br />�Ǹ�ˤ�ɬ��"/"�ʥ���å���ˤ��դ��Ƥ���������<br />���㡧/home/user/www/mt/<br />�ޤ�MT3.0�ʾ�Ǥϡ�MT�ۡ���ǥ��쥯�ȥ�ʳ��Υǥ��쥯�ȥ��MT4i�򥤥󥹥ȡ��뤷�����Хѥ��ˤ�MT�ۡ���ǥ��쥯�ȥ����ꤷ����硢������ǽ�������ư��ʤ����Ȥ��ǧ���Ƥ��ޤ���Plugin�ˤ��ɲä����ƥ����ȥե����ޥåȤ��ɥ�åץ�����ꥹ�Ȥ˸����ʤ��ʤɡˡ�<br />MT3.0�ʾ����Ѥ��Ƥ�����ϡ����Хѥ��ǻ��ꤷ�Ƥ���������<br />';
    print '</div>';
    print '<div class="input">';
    print '<input type="text" name="MT_DIR" value="' . $cfg{MT_DIR} . '" /><br />';
    print '</div><div class="backlink"><a href="#top">�ڡ�����TOP�����</a></div>';

    print '<h4 id="Blog_ID">Blog_ID - Movable Type ��ǻ��Ѥ��Ƥ���Blog��ͭ��ID</h4>';
    print '<div class="description">';
    print 'Movable Type ���ָ塢�ǥե���ȤǺ��������Blog��ID�� "1"��<br />���θ塢Blog���ɲä������Ϣ�֤���Ϳ����롣<br />�����ǻ��ꤷ�ʤ��Ƥ⡢������������ݤ�URL�� "?id=" �Ȥ����Ϥ��Ƥ�äƤ��ɤ���<br />MT4i�ؤ�URL�� "http://your-domain/mt4i.cgi"��Blog��ID�� "1" �ʤ�С�<br />"http://your-domain/mt4i.cgi?id=1" �Ȥʤ롣<br />�ɤ�ʬ����ʤ����Ϥ����ǻ��ꤻ�������֡�������������Ȳ����ɽ������ΤǤ�����򻲾ȤΤ��ȡ�<br />';
    print '</div>';
    print '<div class="input">';
    print '<input type="text" name="Blog_ID" value="' . $cfg{Blog_ID} . '" /><br />';
    print '</div><div class="backlink"><a href="#top">�ڡ�����TOP�����</a></div>';

    #----------------------------------------------------------------------------------------------------
    print '<h3>Ǥ���������</h3>';
    print '<h4 id="AdmNML">������̾��ɽ���ȥ᡼�륢�ɥ쥹</h4>';
    print '<div class="description">';
    print '�Ʋ��̲��˴�����̾��ɽ��������ˤϴ�����̾�����Ϥ��롣<br />';
    print '�������Ϥ���Ƥ��ʤ������ɽ����';
    print '</div>';
    print '<div class="input">';
    print '������̾�� <input type="text" name="AdmNM" value="' . $cfg{AdmNM} . '" /><br />';
    print '</div>';
    print '<div class="description">';
    print '�嵭������̾�ˡ�"mailto:��" �Υϥ��ѡ���󥯤�Ž����ˤϴ����ԥ᡼�륢�ɥ쥹�����Ϥ��롣<br />ɬ��Ū�˾嵭������̾�����꤬ɬ�ܡ�<br />�᡼�륢�ɥ쥹��ɽ������"@" �� "." �Τ߿���ʸ�����Ȥ��Ѵ���SPAM�᡼���к��ˡ�<br />';
    print '</div>';
    print '<div class="input">';
    print '�����ԥ᡼�륢�ɥ쥹�� <input type="text" name="AdmML" value="' . $cfg{AdmML} . '" style="width:200px;" /><br />';
    print '</div><div class="backlink"><a href="#top">�ڡ�����TOP�����</a></div>';

    print '<h4 id="Logo">Logo - �����ȥ�������λ���</h4>';
    print '<div class="description">';
    print '�ȥåפ�ɽ�����륿���ȥ�����ɽ����������硢ɽ��������������URL�����ϡ����Хѥ��Ǥ�ġ�̤���Ϥʤ�ƥ����Ȥ�ɽ����i-mode�Ѥ�GIF��i-mode�ʳ��Ѥ�PNG��������ꤹ�뤳�ȡ�<br />';
    print '</div>';
    print '<div class="input">';
    print 'i-mode�ѡ� ';
    print '<input type="text" name="Logo_i" value="' . $cfg{Logo_i} . '" class="long" /><br />';
    print 'i-mode�ʳ��ѡ� ';
    print '<input type="text" name="Logo_o" value="' . $cfg{Logo_o} . '" class="long" /><br />';
    print '</div><div class="backlink"><a href="#top">�ڡ�����TOP�����</a></div>';

    print '<h4 id="DispNum">DispNum - �ȥåסʵ��������ˤ�ɽ�������뵭����</h4>';
    print '<div class="input">';
    print '<input type="text" name="DispNum" value="' . $cfg{DispNum} . '" /><br />';
    print '</div><div class="backlink"><a href="#top">�ڡ�����TOP�����</a></div>';

    print '<h4 id="DT">���������ɽ������</h4>';
    print '<div class="description">';
    print 'Movable Type �Υƥ�ץ졼�ȥ����ǻȤ������դ˴ؤ����ǥ��ե������ˤƷ���������Ǥ��ޤ���<br />�ޤ��������̤����եե����ޥåȤ����Ǥ��ޤ���<br /><a href="http://movabletype.jp/documentation/appendices/date-formats.html">���դ˴ؤ���ƥ�ץ졼�ȥ����Υ�ǥ��ե�������ե����</a>';
    print '</div>';
    print '<div class="input">';
    print '<table border="0">';
    print '<tr><td>';
    print '�����̤����եե����ޥåȡ�';
    print '</td><td>';
    print '<input type="text" name="DtLang" value="' . $cfg{DtLang} . '" class="middle" /><br />';
    print '</td></tr>';
    print '<tr><td>';
    print '�ȥåסʵ��������ȥ�����˥ڡ�����';
    print '</td><td>';
    print '<input type="text" name="IndexDtFormat" value="' . $cfg{IndexDtFormat} . '" class="middle" /><br />';
    print '</td></tr>';
    print '<tr><td>';
    print '���̵����ڡ�����';
    print '</td><td>';
    print '<input type="text" name="IndividualDtFormat" value="' . $cfg{IndividualDtFormat} . '" class="middle" /><br />';
    print '</td></tr>';
    print '<tr><td>';
    print '�����Ȱ����ڡ�����';
    print '</td><td>';
    print '<input type="text" name="CommentDtFormat" value="' . $cfg{CommentDtFormat} . '" class="middle" /><br />';
    print '</td></tr>';
    print '<tr><td>';
    print '�ȥ�å��Хå������ڡ�����';
    print '</td><td>';
    print '<input type="text" name="TBPingDtFormat" value="' . $cfg{TBPingDtFormat} . '" class="middle" /><br />';
    print '</td></tr>';
    print '</table>';
    print '</div><div class="backlink"><a href="#top">�ڡ�����TOP�����</a></div>';

    print '<h4 id="Colors">��������</h4>';
    print '<div class="input">';
    print '<table border="0">';
    print '<tr><td>';
    print '�طʿ�(bgcolor)��';
    print '</td><td>';
    print '<input type="text" name="BgColor" value="' . $cfg{BgColor} . '" /><br />';
    print '</td></tr><tr><td>';
    print '�ƥ����Ȥο�(text)��';
    print '</td><td>';
    print '<input type="text" name="TxtColor" value="' . $cfg{TxtColor} . '" /><br />';
    print '</td></tr><tr><td>';
    print '��󥯿�(link)��';
    print '</td><td>';
    print '<input type="text" name="LnkColor" value="' . $cfg{LnkColor} . '" /><br />';
    print '</td></tr><tr><td>';
    print '�����ƥ��֤ʥ�󥯿�(alink)��';
    print '</td><td>';
    print '<input type="text" name="AlnkColor" value="' . $cfg{AlnkColor} . '" /><br />';
    print '</td></tr><tr><td>';
    print '��ˬ��Υ�󥯿�(vlink)��';
    print '</td><td>';
    print '<input type="text" name="VlnkColor" value="' . $cfg{VlnkColor} . '" /><br />';
    print '</td></tr><tr><td>';
    print 'Entry��ʸ&lt;blockquote&gt;���ο��� ';
    print '</td><td>';
    print '<input type="text" name="BqColor" value="' . $cfg{BqColor} . '" />';
    print ' Movable Type ������ǡ�convert_breaks �� ON �ˤʤäƤ��뤳�Ȥ�����';
    print '</td></tr>';
    print '</table>';
    print '</div><div class="backlink"><a href="#top">�ڡ�����TOP�����</a></div>';

    print '<h4 id="Z2H">Z2H - ���Ѣ�Ⱦ���Ѵ�</h4>';
    print '<div class="input">';
    print '<select name="Z2H">';
    if ($cfg{Z2H} eq 'yes') {
        print '<option value="yes" selected>����</option>';
        print '<option value="no">���ʤ�</option>';
    } else {
        print '<option value="yes">����</option>';
        print '<option value="no" selected>���ʤ�</option>';
    }
    print '</select>';
    print '</div><div class="backlink"><a href="#top">�ڡ�����TOP�����</a></div>';

    print '<h4 id="BQ2P">BQ2P - &lt;blockquote&gt;��&lt;p&gt;�Ѵ�</h4>';
    print '<div class="description">';
    print 'Movable Type ������ǡ�convert_breaks �� ON �ˤʤäƤ��뤳�Ȥ�����';
    print '</div>';
    print '<div class="input">';
    print '<select name="BQ2P">';
    if ($cfg{BQ2P} eq 'yes') {
        print '<option value="yes" selected>����</option>';
        print '<option value="no">���ʤ�</option>';
    } else {
        print '<option value="yes">����</option>';
        print '<option value="no" selected>���ʤ�</option>';
    }
    print '</select>';
    print '</div><div class="backlink"><a href="#top">�ڡ�����TOP�����</a></div>';

    print '<h4 id="SprtStr">SprtStr - ����ʬ����ζ��ڤ�ʸ����</h4>';
    print '<div class="description">';
    print '����ޤǶ��ڤä�ʣ���ѥ�������ꤹ�뤳�Ȥ��Ǥ��ޤ���<br />';
    print '1���ܤ˻��ꤷ��ʸ���󤬥ޥå����ʤ��ä���2���ܡ��Ƚ��֤˥ޥå��󥰤��ޤ���<br />';
    print '�㡧&lt;br /&gt;,&lt;br&gt;,&lt;/p&gt;';
    print '</div>';
    print '<div class="input">';
    print '<input type="text" name="SprtStr" value="' . $cfg{SprtStr} . '" /><br />';
    print '</div><div class="backlink"><a href="#top">�ڡ�����TOP�����</a></div>';

    print '<h4 id="SprtLimit">SprtLimit - ������ʸ��ʬ��򤹤����¥Х��ȿ��ʥإå���եå����θ���뤳�ȡ�</h4>';
    print '<div class="input">';
    print '<input type="text" name="SprtLimit" value="' . $cfg{SprtLimit} . '" /><br />';
    print '</div><div class="backlink"><a href="#top">�ڡ�����TOP�����</a></div>';

    print '<h4 id="MyName">MyName - MT4i���ΤΥե�����̾��index.cgi�ʤɤ��ѹ����������ѡ�</h4>';
    print '<div class="input">';
    print '<input type="text" name="MyName" value="' . $cfg{MyName} . '" /><br />';
    print '</div><div class="backlink"><a href="#top">�ڡ�����TOP�����</a></div>';

    print '<h4 id="AccessKey">AccessKey - �������äγ�ʸ���ڤӥ�����������</h4>';
    print '<div class="description">';
    print '�����ͭ���ˤ���ȡ��������ä��饢���������줿�ݡ���ưŪ�˵���������ɽ������뵭������6��ʲ���Ĵ������ޤ���<br />';
    print '</div>';
    print '<div class="input">';
    print '<select name="AccessKey">';
    if ($cfg{AccessKey} eq 'yes') {
        print '<option value="yes" selected>ͭ��</option>';
        print '<option value="no">̵��</option>';
    } else {
        print '<option value="yes">ͭ��</option>';
        print '<option value="no" selected>̵��</option>';
    }
    print '</select>';
    print '</div><div class="backlink"><a href="#top">�ڡ�����TOP�����</a></div>';

    print '<h4 id="ImageAutoReduce">ImageAutoReduce - �����μ�ư�̾�</h4>';
    print '<div class="input">';
    print '<select name="ImageAutoReduce">';
    if ($cfg{ImageAutoReduce} eq 'imagemagick') {
        print '<option value="imagemagick" selected>������Image::Magick��</option>';
        print '<option value="picto">���������ӥ���Picto��</option>';
        print '<option value="no">���ʤ�</option>';
    } elsif ($cfg{ImageAutoReduce} eq 'picto') {
        print '<option value="imagemagick">������Image::Magick��</option>';
        print '<option value="picto" selected>���������ӥ���Picto��</option>';
        print '<option value="no">���ʤ�</option>';
    } else {
        print '<option value="imagemagick">������Image::Magick��</option>';
        print '<option value="picto">���������ӥ���Picto��</option>';
        print '<option value="no" selected>���ʤ�</option>';
    }
    print '</select>';
    print '</div><div class="backlink"><a href="#top">�ڡ�����TOP�����</a></div>';

    print '<h4 id="PhotoWidth">�ǥե���Ȳ����β���</h4>';
    print '<div class="input">';
    print '<input type="text" name="PhotoWidth" value="' . $cfg{PhotoWidth} . '" /><br />';
    print '</div><div class="backlink"><a href="#top">�ڡ�����TOP�����</a></div>';

    print '<h4 id="PngWidth">vodafone�����굡��(6����)��PNG�����β���</h4>';
    print '<div class="input">';
    print '<input type="text" name="PngWidth" value="' . $cfg{PngWidth} . '" /><br />';
    print '</div><div class="backlink"><a href="#top">�ڡ�����TOP�����</a></div>';

    print '<h4 id="PhotoWidthForce">��������ꤷ�����˶���Ū�˽̾�����</h4>';
    print '<div class="description">';
    print 'ü���Υ���å��奵�����˴ط��ʤ��������β�����嵭�������ض���Ū�˽̾����뤫�ɤ���������Ǥ��ޤ�(�Ĥι⤵�ⲣ�������㤷�ƽ̾�����ޤ��ˡ�<br />';
    print '�ֶ����̾����ʤ��סʥǥե���ȡˤ����򤹤�ȡ�ü���Υ���å��奵�����򸡽Ф���ɽ���Ǥ�����祵������ɽ�����ޤ���<br />';
    print '</div>';
    print '<select name="PhotoWidthForce">';
    print '<option value="1"'.($cfg{PhotoWidthForce} == 1 ? ' selected' : '').'>�����̾�����</option>';
    print '<option value="0"'.($cfg{PhotoWidthForce} == 0 ? ' selected' : '').'>�����̾����ʤ�</option>';
    print '</select>';
    print '</div><div class="backlink"><a href="#top">�ڡ�����TOP�����</a></div>';

    print '<h4 id="CatDescReplace">CatDescReplace - ���ƥ���̾��Description�ִ�</h4>';
    print '<div class="description">';
    print '���ƥ���̾�����ܸ첽��MTCategoryDescription�ǹԤäƤ��뤫��';
    print '</div>';
    print '<div class="input">';
    print '<select name="CatDescReplace">';
    if ($cfg{CatDescReplace} eq 'yes') {
        print '<option value="yes" selected>�ԤäƤ���</option>';
        print '<option value="no">�ԤäƤ��ʤ�</option>';
    } else {
        print '<option value="yes">�ԤäƤ���</option>';
        print '<option value="no" selected>�ԤäƤ��ʤ�</option>';
    }
    print '</select>';
    print '</div><div class="backlink"><a href="#top">�ڡ�����TOP�����</a></div>';

    print '<h4 id="CatDescSort">CatDescSort - ���ƥ���̾�Υ�����</h4>';
    print '<div class="input">';
    print '<select name="CatDescSort">';
    if ($cfg{CatDescSort} eq 'none') {
        print '<option value="none" selected>���ʤ�</option>';
        print '<option value="asc">����</option>';
        print '<option value="desc">�߽�</option>';
    } elsif ($cfg{CatDescSort} eq 'asc') {
        print '<option value="none">���ʤ�</option>';
        print '<option value="asc" selected>����</option>';
        print '<option value="desc">�߽�</option>';
    } else {
        print '<option value="none">���ʤ�</option>';
        print '<option value="asc">����</option>';
        print '<option value="desc" selected>�߽�</option>';
    }
    print '</select>';
    print '</div><div class="backlink"><a href="#top">�ڡ�����TOP�����</a></div>';

    print '<h4 id="PostEssential">��������ƻ�����ɬ�ܹ��ܤλ���</h4>';
    print '<div class="input">';
    print '<table border="0">';
    print '<tr><td>';
    print '��Ƽ�̾��';
    print '</td><td>';
    print '<select name="PostFromEssential">';
    if ($cfg{PostFromEssential} eq 'yes') {
        print '<option value="yes" selected>ɬ��</option>';
        print '<option value="no">��ά��</option>';
    } else {
        print '<option value="yes">ɬ��</option>';
        print '<option value="no" selected>��ά��</option>';
    }
    print '</select>';
    print '</td></tr><tr><td>';
    print '�᡼�륢�ɥ쥹��';
    print '</td><td>';
    print '<select name="PostMailEssential">';
    if ($cfg{PostMailEssential} eq 'yes') {
        print '<option value="yes" selected>ɬ��</option>';
        print '<option value="no">��ά��</option>';
    } else {
        print '<option value="yes">ɬ��</option>';
        print '<option value="no" selected>��ά��</option>';
    }
    print '</select>';
    print '</td></tr><tr><td>';
    print '��������ʸ��';
    print '</td><td>';
    print '<select name="PostTextEssential">';
    if ($cfg{PostTextEssential} eq 'yes') {
        print '<option value="yes" selected>ɬ��</option>';
        print '<option value="no">��ά��</option>';
    } else {
        print '<option value="yes">ɬ��</option>';
        print '<option value="no" selected>��ά��</option>';
    }
    print '</select>';
    print '</td></tr>';
    print '</table>';
    print '</div><div class="backlink"><a href="#top">�ڡ�����TOP�����</a></div>';

    print '<h4 id="RecentComment">RecentComment - �Ƕ�Υ����Ȱ���ɽ�������ȿ�</h4>';
    print '<div class="input">';
    print '<input type="text" name="RecentComment" value="' . $cfg{RecentComment} . '" /><br />';
    print '</div><div class="backlink"><a href="#top">�ڡ�����TOP�����</a></div>';

    print '<h4 id="RecentTB">RecentTB - �Ƕ�Υȥ�å��Хå�ɽ����</h4>';
    print '<div class="input">';
    print '<input type="text" name="RecentTB" value="' . $cfg{RecentTB} . '" /><br />';
    print '</div><div class="backlink"><a href="#top">�ڡ�����TOP�����</a></div>';

    print '<h4 id="Photo_Host">Photo_Host_Original/Replace - ���𥵡��Фγ����������ۥ���̾</h4>';
    print '<div class="description">';
    print '���𥵡��б������ǲ����̾���ư���ʤ���硢�ޤ��������Τ굡ǽ��Mobile Link Discovery�ˤ�ư���ʤ���硢\'�����ۥ���̾\'�˳����鸫����ۥ���̾��\'�����ۥ���̾\'������Ū�ʥۥ���̾�����ϡ�<br />';
    print '(������)\'www.hazama.nu\'�ξ�硢<br />';
    print '<ul><li>http://www.hazama.nu/archive/test.jpg</li></ul>��<ul><li>http://localhost/archive/test.jpg</li></ul>���ִ�����뤳�Ȥǡ����ۥ��Ȥβ����ǡ������ɤ߹��᤿���Х������URL�������Ǥ���褦�ˤʤ��礢�ꡣ<br />';
    print '\'Photo_Host_Original\'̤���Ϥǵ�ǽ���ա�<br />';
    print '</div>';
    print '<div class="input">';
    print '�����ۥ���̾: ';
    print '<input type="text" name="Photo_Host_Original" value="' . $cfg{Photo_Host_Original} . '" /><br />';
    print '�����ۥ���̾: ';
    print '<input type="text" name="Photo_Host_Replace" value="' . $cfg{Photo_Host_Replace} . '" /><br />';
    print '</div><div class="backlink"><a href="#top">�ڡ�����TOP�����</a></div>';

    print '<h4 id="CommentNum">1�ڡ�����ɽ�����륳���ȿ�</h4>';
    print '<div class="description">';
    print '�����ȥڡ����ˤơ�1�ڡ�����ɽ�����륳���ȿ�����ꤷ�ޤ���<br />';
    print '�����ǻ��ꤵ�줿����Ķ������Ƥ����ä���硢���ڡ�������ޤ���<br />';
    print '�����ȿ���1�����Ȥ��礭���ʤɤ򸫤Ĥġ�Ŭ��Ĵ�����Ƥ���������<br />';
    print '</div>';
    print '<div class="input">';
    print '<input type="text" name="CommentNum" value="' . $cfg{CommentNum} . '" /><br />';
    print '</div><div class="backlink"><a href="#top">�ڡ�����TOP�����</a></div>';

    print '<h4 id="ChtmlTrans">��Х����Ѵ������ȥ��������������</h4>';
    print '<div class="description">';
    print '������ʸ�˴ޤޤ���󥯤򡢷��Ӹ�����ɽ�����Ѵ����Ƥ���륲���ȥ������ʥץ����ˤ˴ؤ������ꡣ';
    print '</div>';
    print '<div class="description">';
    print '<input type="checkbox" id="chtmltrans" name="ChtmlTrans" ';
    print $cfg{ChtmlTrans} ? 'checked ' : '';
    print '"/>';
    print '��<label for="chtmltrans">��Х����Ѵ������ȥ���������Ѥ���</label>';
    print '</div>';
    print '<div class="description">';
    print 'A������TITLE°�������ʲ��˻��ꤷ��ʸ�����ޤ��硢��Х����Ѵ������ȥ��������ͳ���ʤ���<br />';
    print '</div>';
    print '<div class="input">';
    print '<input type="text" name="ExitChtmlTrans" value="' . enc_amp_quot($cfg{ExitChtmlTrans}) . '" /><br />';
    print '</div>';
    print '<div class="description">';
    print '�����б���󥯡ʥ�Х����Ѵ������ȥ��������ͳ���ʤ���󥯡ˤ�����ɽ������ʸ��(�դ������ʤ����϶�ʸ����ˤ����';
    print '</div>';
    print '<div class="input">';
    print 'i-mode ����� EZWeb��<input type="text" name="ECTrans_Str_i" value="' . enc_amp_quot($cfg{ECTrans_Str_i}) . '" style="width:300px;" /><br />';
    print 'J-SKY��<input type="text" name="ECTrans_Str_j" value="' . enc_amp_quot($cfg{ECTrans_Str_j}) . '" style="width:300px;" /><br />';
    print '����¾��<input type="text" name="ECTrans_Str_o" value="' . enc_amp_quot($cfg{ECTrans_Str_o}) . '" style="width:300px;" /><br />';
    print '</div>';
    print '<div class="description">';
    print '��Х����Ѵ������ȥ���������';
    print '</div>';
    print '<div class="input">';
    print '<select name="MobileGW">';
    if ($cfg{MobileGW} eq '1') {
        print '<option value="1" selected>�̶Х֥饦��</option>';
        print '<option value="2">Google.co.jp</option>';
    } elsif ($cfg{MobileGW} eq '2') {
        print '<option value="1">�̶Х֥饦��</option>';
        print '<option value="2" selected>Google.co.jp</option>';
    }
    print '</select>';
    print '</div><div class="backlink"><a href="#top">�ڡ�����TOP�����</a></div>';

    print '<h4 id="Ainori">�����Τ굡ǽ��Mobile Link Discovery��</h4>';
    print '<div class="description">';
    print '�����Τ굡ǽ�ǥ�Х����б��Ȥʤä���󥯤�����ɽ������ʸ��(�դ������ʤ����϶�ʸ����ˤ����';
    print '</div>';
    print '<div class="input">';
    print 'i-mode ����� EZWeb��<input type="text" name="Ainori_Str_i" value="' . enc_amp_quot($cfg{Ainori_Str_i}) . '" style="width:300px;" /><br />';
    print 'J-SKY��<input type="text" name="Ainori_Str_j" value="' . enc_amp_quot($cfg{Ainori_Str_j}) . '" style="width:300px;" /><br />';
    print '����¾��<input type="text" name="Ainori_Str_o" value="' . enc_amp_quot($cfg{Ainori_Str_o}) . '" style="width:300px;" /><br />';
    print '</div>';
    print '</div><div class="backlink"><a href="#top">�ڡ�����TOP�����</a></div>';

    print '<h4 id="RIAT_ID">��������ƻ���Rebuild�оݥƥ�ץ졼�Ȥ���ꤹ��</h4>';
    print '<div class="description">';
    print '��������ƻ���Rebuild���оݤȤ���Index�ƥ�ץ졼�Ȥ�Templete ID����ꤹ�롣<br />';
    print 'Index�ƥ�ץ졼�Ȥ��٤Ƥ��оݤȤ���ʤ�"ALL"�Ȼ��ꤹ�롣<br />';
    print '��ID�ϥ���ޡ�,�ˤǶ��ڤ�������ڡ���������ʤ����ȡ�<br />';
    print '�㡧10,13,20<br />';
    print '</div>';
    print '<div class="input">';
    print 'Index�ƥ�ץ졼�ȡ�<input type="text" name="RIT_ID" value="' . $cfg{RIT_ID} . '" style="width:300px;" /><br />';
    print '</div>';
    print '<div class="description">';
    print '��������ƻ���Rebuild���оݤȤ���Archive�ƥ�ץ졼�Ȥ���ꤹ�롣<br />';
    print 'Archive�ƥ�ץ졼�Ȥ��٤Ƥ��оݤȤ���ʤ�"ALL"�Ȼ��ꤹ�롣';
    print '��ID�ϥ���ޡ�,�ˤǶ��ڤ�������ڡ���������ʤ����ȡ�<br />';
    print '�㡧Individual,Daily,Weekly,Monthly,Category<br />';
    print '</div>';
    print '<div class="input">';
    print 'Archive�ƥ�ץ졼�ȡ�<input type="text" name="RAT_ID" value="' . $cfg{RAT_ID} . '" style="width:300px;" /><br />';
    print '</div><div class="backlink"><a href="#top">�ڡ�����TOP�����</a></div>';

    print '<h4 id="ApproveComment">ApproveComment - �����ȷǺܤξ�����MT3.0�ʾ��ͭ����</h4>';
    print '<div class="input">';
    print '<select name="ApproveComment">';
    if ($cfg{ApproveComment} eq 'yes') {
        print '<option value="yes" selected>¨��������</option>';
        print '<option value="no">��ö��α����</option>';
    } else {
        print '<option value="yes">¨��������</option>';
        print '<option value="no" selected>��ö��α����</option>';
    }
    print '</select>';
    print '</div><div class="backlink"><a href="#top">�ڡ�����TOP�����</a></div>';

    print '<h4 id="CommentFilterStr">CommentFilterStr - ������ SPAM Ƚ������ɽ��</h4>';
    print '<div class="description">';
    print '��������ʸ�����ꤷ������ɽ���˥ޥå������硢������ SPAM �Ȥ����Ƥ���<br />';
    print 'ʣ�����ꤹ�����Ⱦ�ѥ���ޤǶ��ڤ롣<br />';
    print '</div>';
    print '<div class="input">';
    print '<input type="text" name="CommentFilterStr" value="' . $cfg{CommentFilterStr} . '" style="width:300px;" /><br />';
    print '</div>';
    print '<div class="backlink"><a href="#top">�ڡ�����TOP�����</a></div>';

    print '<h4 id="SerNo">��������ƻ��˸�ͭ���̾�����׵᤹��</h4>';
    print '<div class="description">';
    print 'Docomo �Τߡ�<br />';
    print '��������Ƥκݤˡ���ͭ���̾�����������׵᤹�롣<br />';
    print '�������ݤ������ˤϡ������Ȥ���Ƥ�����ʤ���<br />';
    print '</div>';
    print '<div class="input">';
    print '<select name="SerNo">';
    if ($cfg{SerNo} == 1) {
        print '<option value="1" selected>�׵᤹��</option>';
        print '<option value="0">�׵ᤷ�ʤ�</option>';
    } else {
        print '<option value="1">�׵᤹��</option>';
        print '<option value="0" selected>�׵ᤷ�ʤ�</option>';
    }
    print '</select>';
    print '<div class="backlink"><a href="#top">�ڡ�����TOP�����</a></div>';

    print '<h4 id="NonDispCat">NonDispCat - ����Υ��ƥ������ɽ���ˤ���</h4>';
    print '<div class="description">';
    print '��ɽ���ˤ��륫�ƥ����ID����ꤹ�롣<br />';
    print '̤���ϤǤ��٤Ƥ�ɽ����<br />';
    print '���ƥ���ID�ϡ�MT�������̤Ρ֥��ƥ��꡼�פˤơ��ƥ��ƥ���̾�Υ�󥯤�ݥ���Ȥ��ƥ��ơ������С���ɽ��������http://your-domain.com/mt/mt.cgi?__mode=view&_type=category&blog_id=x&id=xx�פȤ��ä�URL�κǸ�Ρ�id=xx�פΡ�xx�פ���ʬ��<br />';
    print '��ID�ϥ���ޡ�,�ˤǶ��ڤ�������ڡ���������ʤ����ȡ�<br />';
    print '�㡧10,13,20<br />';
    print '�ƥ��ƥ������ɽ�������ꤹ��ȡ������°����ҥ��ƥ����ɽ������ʤ��ʤ�Τ���դ��뤳�ȡ�<br />';
    print '</div>';
    print '<div class="input">';
    print '<input type="text" name="NonDispCat" value="' . $cfg{NonDispCat} . '" style="width:300px;" /><br />';
    print '</div>';
    print '<div class="backlink"><a href="#top">�ڡ�����TOP�����</a></div>';

    print '<h4 id="LenCutCat">LenCutCat - ���ƥ���̾�����Х��ȿ��ǥ��åȤ���</h4>';
    print '<div class="description">';
    print '���ƥ��ꥻ�쥯����Υ��ƥ���̾�򡢻���Х��ȿ��ǥ��åȤ��롣<br />';
    print '���ƥ���̾��Ĺ�᤮�ơ�����ü���ΥХ��ȿ����¤ʤɤ˰��óݤ�����˻��ѡ�<br />';
    print '��0�ʥ���ˡ׻����̵���ʥǥե���ȡˡ�<br />';
    print '</div>';
    print '<div class="input">';
    print '<input type="text" name="LenCutCat" value="' . $cfg{LenCutCat} . '" style="width:300px;" /><br />';
    print '</div>';
    print '<div class="backlink"><a href="#top">�ڡ�����TOP�����</a></div>';

    print '<h4 id="ArrowComments">ArrowComments - ��������Ƶ�ǽ��ON/OFF</h4>';
    print '<div class="description">';
    print '��������Ƥβġ��ԲĤϡ��ǥե���ȤǤ�MT�ʤ��뤤�ϸġ��Υ���ȥ�ˤ�����˽�������';
    print '����Ū��OFF�ˤ�������MT4i��ǤΥ�������Ƥ�ػߤ������˾��˻��ѡ�';
    print '</div>';
    print '<div class="input">';
    print '<select name="ArrowComments">';
    if ($cfg{ArrowComments} eq '1') {
        print '<option value="1" selected>MT������˽����ʥǥե���ȡ�</option>';
        print '<option value="0">����Ū��OFF�ˤ���</option>';
    } else {
        print '<option value="1">MT������˽����ʥǥե���ȡ�</option>';
        print '<option value="0" selected>����Ū��OFF�ˤ���</option>';
    }
    print '</select>';
    print '</div>';
    print '<div class="backlink"><a href="#top">�ڡ�����TOP�����</a></div>';

    print '<h4 id="CacheTime">CacheTime - ����å�����ݻ�����</h4>';
    print '<div class="description">';
    print '����å������Ѥ����硢����å�����ݻ�������֤�ʬñ�̤ǻ��ꡣ<br />';
    print '��0�ʥ���ˡ׻����̵���ʥǥե���ȡˡ�<br />';
    print '</div>';
    print '<div class="input">';
    print '<input type="text" name="CacheTime" value="' . $cfg{CacheTime} . '" /><br />';
    print '</div>';
    print '<div class="backlink"><a href="#top">�ڡ�����TOP�����</a></div>';

    print '<h4 id="PurgeCacheScript">PurgeCacheScript - purge_old_cache.pl ������ץȤ˴ؤ�������</h4>';
    print '<div class="description">';
    print '������ץ� purge_old_cache.pl ����Ѥ��ƥ���å����ä�������Ρ�����å�����ݻ�������֤��ñ�̤ǻ��ꡣ<br />';
    print '�ե�����ι������֤������ǻ��ꤷ�����֤���ΤΥե����뤬 unlink �Ǻ������ޤ���<br />';
    print '�ޤ���������ץ�ư����������������Υ᡼�����������������Υ᡼�륢�ɥ쥹�����Ϥ��Ƥ���������<br />';
    print '</div>';
    print '<div class="input">';
    print '<table><tr><th>';
    print '�ݻ����֡�';
    print '</th><td>';
    print '<input type="text" name="PurgeCacheLimit" value="' . $cfg{PurgeCacheLimit} . '" /><br />';
    print '</td></tr><tr><th>';
    print '�᡼����������';
    print '</th><td>';
    print '<input type="text" name="PurgeCacheMailFrom" value="' . $cfg{PurgeCacheMailFrom} . '" style="width:200px;" /><br />';
    print '</td></tr><tr><th>';
    print '�᡼�������衧';
    print '</th><td>';
    print '<input type="text" name="PurgeCacheMailTo" value="' . $cfg{PurgeCacheMailTo} . '" style="width:200px;" /><br />';
    print '</td></tr><table>';
    print '</div>';
    print '<div class="backlink"><a href="#top">�ڡ�����TOP�����</a></div>';

    print '<h4 id="CachePageCountIndex">����ǥå����ڡ����򥭥�å��夹��ڡ�����</h4>';
    print '<div class="description">';
    print '����ǥå����ʵ��������˥ڡ����Υ���å���ϥ���ȥ꡼���/�Խ��������說�ꥢ����ɬ�פ����롣<br />';
    print '����ȥ꡼����Ƥʤɤ˻��֤���������ϡ��������ͤ�Ĵ�����롣<br />';
    print '���Τ���ꡢ�ڡ����������¤���ȥܥåȤΥ����뤬����٤������ǽ�������롣<br />';
    print '���ڡ����ܤޤǤ򥭥�å��夹�뤫���ڡ����������ϡ�<br />';
    print '��0�ʥ���ˡ׻�������ڡ����򥭥�å��夹��ʥǥե���ȡˡ�<br />';
    print '</div>';
    print '<div class="input">';
    print '<input type="text" name="CachePageCountIndex" value="' . $cfg{CachePageCountIndex} . '" /><br />';
    print '</div>';
    print '<div class="backlink"><a href="#top">�ڡ�����TOP�����</a></div>';

    #----------------------------------------------------------------------------------------------------
    print '<h3>�����ԥ⡼���������</h3>';
    print '<h4 id="AdminHelper">AdminHelper - ��������ƻ��δ����Ծ������Ϥ�����</h4>';
    print '<div class="description">';
    print '̾���������ID������������ǡ�̾�����᡼�륢�ɥ쥹����ưŪ�˵�������롣<br />';
    print '�����ԥ⡼�ɤǤΤ�ͭ����<br />';
    print '</div>';
    print '<div class="input">';
    print '<table border="0">';
    print '<tr><td>';
    print 'AdminHelper����Ѥ���';
    print '</td><td>';
    print '<select name="AdminHelper">';
    if ($cfg{AdminHelper} eq 'yes') {
        print '<option value="yes" selected>�Ϥ�</option>';
        print '<option value="no">������</option>';
    } else {
        print '<option value="yes">�Ϥ�</option>';
        print '<option value="no" selected>������</option>';
    }
    print '</select>';
    print '</td></tr><tr><td>';
    print 'ID��';
    print '</td><td>';
    print '<input type="text" name="AdminHelperID" value="' . $cfg{AdminHelperID} . '" /><br />';
    print '</td></tr><tr><td>';
    print '̾����';
    print '</td><td>';
    print '<input type="text" name="AdminHelperNM" value="' . $cfg{AdminHelperNM} . '" /><br />';
    print '</td></tr><tr><td>';
    print '�᡼�륢�ɥ쥹��';
    print '</td><td>';
    print '<input type="text" name="AdminHelperML" value="' . $cfg{AdminHelperML} . '" style="width:200px;" /><br />';
    print '</td></tr>';
    print '</table>';
    print '</div><div class="backlink"><a href="#top">�ڡ�����TOP�����</a></div>';

    print '<h4 id="AuthorName">AuthorName - Entry��ƼԤΥ�����̾</h4>';
    print '<div class="description">';
    print 'MovableType����Ͽ�ѤߤΡ���Ƽԡʥ桼���ˤΥ�����̾�ʥ桼��̾�ˤ���ꤹ�롣<br />';
    print '3.0�ʹߡ��ᥤ�󡦥�˥塼 &gt; �����ƥࡦ��˥塼 &gt; ��Ƽ� &gt; ��Ƽ�̾ &gt; ������̾<br />';
    print '2.661�������ᥤ���˥塼 &gt; �ץ�ե�������Խ����� &gt; �桼��̾<br />';
    print '</div>';
    print '<div class="input">';
    print '<input type="text" name="AuthorName" value="' . $cfg{AuthorName} . '" /><br />';
    print '</div><div class="backlink"><a href="#top">�ڡ�����TOP�����</a></div>';

    print '<h4 id="AdminPassword">AdminPassword - �ִ����Ը���URL�����פΰ٤Υѥ����</h4>';
    print '<div class="description">';
    print '�ѿ�����ɬ���ǥե���ȤΥѥ���ɤ����ѹ����뤳�ȡ�<br />';
    print '</div>';
    print '<div class="input">';
    print '<input type="text" name="AdminPassword" value="' . $cfg{AdminPassword} . '" /><br />';
    print '</div><div class="backlink"><a href="#top">�ڡ�����TOP�����</a></div>';
 
    #----------------------------------------------------------------------------------------------------
    print '<h3>�����������</h3>';
    print '<h4 id="PathOfUseLib">�ɲå饤�֥��ؤΥѥ�</h4>';
    print '<div class="description">';
    print '\'use lib\' ���ƻ��Ѥ���饤�֥��ѥ�����ꤷ�ޤ���<br />';
    print 'ʣ���������Ⱦ�ѥ���ޤǶ��ڤäƤ���������';
    print '</div>';
    print '<div class="input">';
    print '<table border="0">';
    print '<tr><th>';
    print '�ѥ���';
    print '</th><td>';
    print '<input type="text" name="PathOfUseLib" value="'.$cfg{PathOfUseLib}.'" style="width:300px;" /><br />';
    print '</td></tr>';
    print '</table>';
    print '</div><div class="backlink"><a href="#top">�ڡ�����TOP�����</a></div>';

    #----------------------------------------------------------------------------------------------------
    print '<h3>MT4i Manager ���������</h3>';
    print '<h4 id="ManagementPass">MT4i Manager �ѥ���ɤ��ѹ�</h4>';
    print '<div class="description">';
    print '���Υ�����ץȤ˥����󤹤�٤Υѥ���ɤ����ꤷ�ޤ���<br />';
    print '</div>';
    print '<div class="input">';
    print '<table border="0">';
    print '<tr><th>';
    print '���ߤΥѥ���ɡ�';
    print '</th><td>';
    print '<input type="password" name="PresentPass" /><br />';
    print '</td></tr><tr><th>';
    print '�������ѥ���ɡ�';
    print '</th><td>';
    print '<input type="password" name="NewPass" /><br />';
    print '</td></tr><tr><th>';
    print '�������ѥ���ɳ�ǧ��';
    print '</th><td>';
    print '<input type="password" name="ConfirmPass" /><br />';
    print '</td></tr>';
    print '</table>';
    print '</div><div class="backlink"><a href="#top">�ڡ�����TOP�����</a></div>';

    #----------------------------------------------------------------------------------------------------
    print '<input type="submit" name="submit" value="��¸">';
    print '<input type="hidden" name="mode" value="save">';
    print '<input type="hidden" name="password" value="'.$sendpass.'">';
    print '</form>';
    print '<form action="./mt4imgr.cgi" method="post">';
    print '<input type="hidden" name="mode" value="menu" />';
    print '<input type="hidden" name="password" value="'.$sendpass.'" />';
    print '<input type="submit" name="submit" value="��˥塼�����" />';
    print '</form>';

    &hooter;
}

sub save {
    %cfg = Config::Read("./mt4icfg.cgi");

    # �ѥ����ǧ��
    my $sendpass = $q->param("password");
    if (!MT4i::Func::check_crypt($sendpass, $cfg{'Password'})) {
        &header;

        print '�ѥ���ɤ��㤤�ޤ���<br />';
        print '<form action="./mt4imgr.cgi" method="post">';
        print '<input type="hidden" name="mode" value="edit" />';
        print '<input type="hidden" name="password" value="'.$sendpass.'" />';
        print '<input type="submit" name="submit" value="���" />';
        print '</form>';
    
        &hooter;
    
        exit;
    }

    # �ѥ�����ѹ��γ�ǧ
    my $presentpass = $q->param("PresentPass");
    my $newpass = $q->param("NewPass");
    my $confirmpass = $q->param("ConfirmPass");
    if ($presentpass) {
        if (!MT4i::Func::check_crypt($presentpass, $cfg{'Password'}) || $newpass ne $confirmpass) {
            &header;

            print '���ߤΥѥ���ɤ�����ǧ�ѤΥѥ���ɤ��ְ�äƤ��ޤ���<br />';
            print '<form action="./mt4imgr.cgi" method="post">';
            print '<input type="button" name="button" value="���" onclick=\'javascript:history.back()\'/>';
            print '</form>';
    
            &hooter;
    
            exit;
        } else {
            $cfg{'Password'} = MT4i::Func::enc_crypt($newpass);
            $sendpass = $newpass;
        }
    }
    
    ####################
    # �����μ���
    $cfg{'MT_DIR'} = del_rn($q->param('MT_DIR'));
    $cfg{'Blog_ID'} = del_rn($q->param('Blog_ID'));
    $cfg{'AdmNM'} = del_rn($q->param('AdmNM'));
    $cfg{'AdmML'} = del_rn($q->param('AdmML'));
    $cfg{'Logo_i'} = del_rn($q->param('Logo_i'));
    $cfg{'Logo_o'} = del_rn($q->param('Logo_o'));
    $cfg{'DispNum'} = del_rn($q->param('DispNum'));
    $cfg{'DtLang'} = del_rn($q->param('DtLang'));
    $cfg{'IndexDtFormat'} = del_rn($q->param('IndexDtFormat'));
    $cfg{'IndividualDtFormat'} = del_rn($q->param('IndividualDtFormat'));
    $cfg{'CommentDtFormat'} = del_rn($q->param('CommentDtFormat'));
    $cfg{'TBPingDtFormat'} = del_rn($q->param('TBPingDtFormat'));
    $cfg{'BgColor'} = del_rn($q->param('BgColor'));
    $cfg{'TxtColor'} = del_rn($q->param('TxtColor'));
    $cfg{'LnkColor'} = del_rn($q->param('LnkColor'));
    $cfg{'AlnkColor'} = del_rn($q->param('AlnkColor'));
    $cfg{'VlnkColor'} = del_rn($q->param('VlnkColor'));
    $cfg{'Z2H'} = del_rn($q->param('Z2H'));
    $cfg{'BQ2P'} = del_rn($q->param('BQ2P'));
    $cfg{'BqColor'} = del_rn($q->param('BqColor'));
    $cfg{'SprtStr'} = del_rn($q->param('SprtStr'));
    $cfg{'SprtLimit'} = del_rn($q->param('SprtLimit'));
    $cfg{'MyName'} = del_rn($q->param('MyName'));
    $cfg{'AccessKey'} = del_rn($q->param('AccessKey'));
    $cfg{'ImageAutoReduce'} = del_rn($q->param('ImageAutoReduce'));
    $cfg{'PhotoWidth'} = del_rn($q->param('PhotoWidth'));
    $cfg{'PhotoWidthForce'} = del_rn($q->param('PhotoWidthForce'));
    $cfg{'PngWidth'} = del_rn($q->param('PngWidth'));
    $cfg{'CatSelect'} = del_rn($q->param('CatSelect'));
    $cfg{'CatDescReplace'} = del_rn($q->param('CatDescReplace'));
    $cfg{'CatDescSort'} = del_rn($q->param('CatDescSort'));
    $cfg{'PostFromEssential'} = del_rn($q->param('PostFromEssential'));
    $cfg{'PostMailEssential'} = del_rn($q->param('PostMailEssential'));
    $cfg{'PostTextEssential'} = del_rn($q->param('PostTextEssential'));
    $cfg{'RecentComment'} = del_rn($q->param('RecentComment'));
    $cfg{'RecentTB'} = del_rn($q->param('RecentTB'));
    $cfg{'Photo_Host_Original'} = del_rn($q->param('Photo_Host_Original'));
    $cfg{'Photo_Host_Replace'} = del_rn($q->param('Photo_Host_Replace'));
    $cfg{'CommentNum'} = del_rn($q->param('CommentNum'));
    $cfg{'ChtmlTrans'} = del_rn($q->param('ChtmlTrans')) || 0;
    $cfg{'ExitChtmlTrans'} = del_rn($q->param('ExitChtmlTrans'));
    $cfg{'MobileGW'} = del_rn($q->param('MobileGW'));
    $cfg{'ECTrans_Str_i'} = del_rn($q->param('ECTrans_Str_i'));
    $cfg{'ECTrans_Str_j'} = del_rn($q->param('ECTrans_Str_j'));
    $cfg{'ECTrans_Str_o'} = del_rn($q->param('ECTrans_Str_o'));
    $cfg{'Ainori_Str_i'} = del_rn($q->param('Ainori_Str_i'));
    $cfg{'Ainori_Str_j'} = del_rn($q->param('Ainori_Str_j'));
    $cfg{'Ainori_Str_o'} = del_rn($q->param('Ainori_Str_o'));
    $cfg{'RIT_ID'} = del_rn($q->param('RIT_ID'));
    $cfg{'RAT_ID'} = del_rn($q->param('RAT_ID'));
    $cfg{'ApproveComment'} = del_rn($q->param('ApproveComment'));
    $cfg{'CommentFilterStr'} = del_rn($q->param('CommentFilterStr'));
    $cfg{'SerNo'} = del_rn($q->param('SerNo'));
    $cfg{'AdminHelper'} = del_rn($q->param('AdminHelper'));
    $cfg{'AdminHelperID'} = del_rn($q->param('AdminHelperID'));
    $cfg{'AdminHelperNM'} = del_rn($q->param('AdminHelperNM'));
    $cfg{'AdminHelperML'} = del_rn($q->param('AdminHelperML'));
    $cfg{'AuthorName'} = del_rn($q->param('AuthorName'));
    $cfg{'AdminPassword'} = del_rn($q->param('AdminPassword'));
    $cfg{'NonDispCat'} = del_rn($q->param('NonDispCat'));
    $cfg{'LenCutCat'} = del_rn($q->param('LenCutCat'));
    $cfg{'ArrowComments'} = del_rn($q->param('ArrowComments'));
    $cfg{'CacheTime'} = del_rn($q->param('CacheTime'));
    $cfg{'PurgeCacheLimit'} = del_rn($q->param('PurgeCacheLimit'));
    $cfg{'PurgeCacheMailFrom'} = del_rn($q->param('PurgeCacheMailFrom'));
    $cfg{'PurgeCacheMailTo'} = del_rn($q->param('PurgeCacheMailTo'));
    $cfg{'CachePageCountIndex'} = del_rn($q->param('CachePageCountIndex'));
    $cfg{'PathOfUseLib'} = del_rn($q->param('PathOfUseLib'));

    ####################
    # �񤭹���
    &write_file(%cfg);

    # ����
    &header;

    print '�������¸���ޤ�����';
    print "<form action=\"./mt4imgr.cgi\" method=\"post\">";
    print '<input type="submit" name="submit" value="���" />';
    print '<input type="hidden" name="password" value="'.$sendpass.'" />';
    print '<input type="hidden" name="mode" value="edit" />';
    print '</form>';

    &hooter;
}

############################################################
# �ե�����ؤν񤭹���
############################################################
sub write_file {
    my (%cfg) = @_;
    my $cfg_file = "./mt4icfg.cgi";
    if (!-e $cfg_file) {
        open(OUT,"> $cfg_file") or die "Can't open     : $!";    # ̵����о�񤭥⡼�ɤǿ�������
    } else {
        open(OUT,"+< $cfg_file") or die "Can't open    : $!";    # ͭ����ɤ߽񤭥⡼�ɤǳ���
    }
    flock(OUT, 2) or die "Can't flock                  : $!";    # ��å���ǧ����å�
    seek(OUT, 0, 0) or die "Can't seek                 : $!";    # �ե�����ݥ��󥿤���Ƭ�˥��å�
    while ( my ( $key , $value ) = each %cfg ) {
        print OUT "$key<>$value\n" or die "Can't print : $!";    # �񤭹���
    }
    truncate(OUT, tell(OUT)) or die "Can't truncate    : $!";    # �ե����륵������񤭹�����������ˤ���
    close(OUT);                                                  # close����м�ư�ǥ�å����
}

############################################################
# ���Ԥ���
############################################################
sub del_rn {
    my ($val) = @_;
    $val =~ s/\r//g;
    $val =~ s/\n//g;
    return $val;
}

############################################################
# '<'��'>'����λ��Ȥ��Ѵ�����
############################################################
sub enc_tag {
    my ($val) = @_;
    $val =~ s/</&lt;/g;
    $val =~ s/>/&gt;/g;
    return $val;
}

############################################################
# "&"�ڤӥ��֥륯�����ơ���������λ��Ȥ��Ѵ�����
############################################################
sub enc_amp_quot {
    my ($val) = @_;
    $val =~ s/&/&amp;/g;
    $val =~ s/"/&quot;/g;
    return $val;
}

############################################################
# Error�ν���
############################################################
sub errorout {
    my ($val) = @_;
    print "Content-type: text/plain; charset=EUC-JP\n\nError!\n$val";
}

############################################################
# �إå��ν���
############################################################
sub header {
    print "Content-type: text/html; charset=EUC-JP\n\n";
    print '<?xml version="1.0" encoding="EUC-JP"?>';
    print '<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">';
    print '<html xmlns="http://www.w3.org/1999/xhtml" lang="ja" xml:lang="ja">';
    print '<head>';
    print '<meta http-equiv="Content-Type" content="text/html; charset=EUC-JP" />';
    print '<title>MT4i Manager</title>';
    print '<style type="text/css">';
    print 'body { background-color:#ffffcc; }';
    print 'h2 { background-color:#ccffcc;border:solid 2px;text-align:center; }';
    print 'h3 { background-color:#ccffcc; border:solid 1px; margin-left:5px; padding:5px; }';
    print 'h4 { text-decoration:underline; }';
    print 'div.alert { color:#FF0000; font-weight:bold; margin:10px; }';
    print 'div.description { margin:10px; }';
    print 'div.input { margin-left:20px;margin-right:20px;margin-bottom:10px; }';
    print 'div.backlink { margin-left:30px;margin-right:10px;margin-bottom:20px; }';
    print 'div.version { text-align:center;font-size:x-small;font-weight:bold;background-color:#ccffcc;padding:5px;border-top:solid 2px;border-bottom:solid 2px; }';
    print 'input { vertical-align:middle;height:22px;margin-bottom:10px; }';
    print 'input.middle { width:200px; }';
    print 'input.long { width:400px; }';
    print 'select { height:22px;margin-bottom:10px; }';
    print '</style>';
    print '</head>';
    print '<body>';
    print '<h2 id=\'top\'>MT4i Manager</h2>';
}

############################################################
# �եå��ν���
############################################################
sub hooter {
    print "<div class=\"version\">version $version</div>";
    print "</body>";
    print "</html>";
}
