package Config;

# �����ɤ߹���
sub Read {
    my ($cfg_file) = @_;
    
    # ����ե����륪���ץ�
    open(IN,"< $cfg_file") or return undef;

    # �����Ǽ��Ϣ������ʥϥå�����ѿ����
    my %cfg = ();
    
    # �ɤ߹���
    while (<IN>){
        my $tmp = $_;
        
        # ���ԥ����ɤκ��
        chomp($tmp);
        
        if ($tmp !~ /^#/) {
            my $key;
            my $val;
            ($key, $val) = split(/<>/,$tmp);
            if ($key && ($val || $val eq '0')) {
                $cfg{$key} = $val;
            }
        }
    }

    # ����ե����륯����
    close(IN);
    
    return %cfg;
}

1;
