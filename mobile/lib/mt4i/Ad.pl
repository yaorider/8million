package MT4i::Ad;

use Encode;

########################################
# Sub Ad_Exchange - ���������ɽ��
########################################
sub ad_exchange {
    my ($ua) = @_; 
    my @ad_str;

    if ($ua eq 'i-mode' || $ua eq 'ezweb' || $ua eq 'j-sky') {
        #----- �������ä���Υ������� -----
    
        # ����ʸ�������
        push(@ad_str,
            '',
        );
        
        # Vodafone�Τ�ͭ���ʹ���ʸ������ɲ�
        if ($ua eq 'j-sky') {
            push(@ad_str,
                '',
            );
        }
        
        # EZweb(au)�Τ�ͭ���ʹ���ʸ������ɲ�
        if ($ua eq 'ezweb') {
            push(@ad_str,
                '',
            );
        }
        
        # i-mode�Τ�ͭ���ʹ���ʸ������ɲ�
        if ($ua eq 'i-mode') {
            push(@ad_str,
                '',
            );
        }
            
    } else {
        # ��������"�ʳ�"����Υ�������
        push(@ad_str,
            '',
        );
    }

    # ����κǽ�ź�� + 1��ź����0����Ϥޤ�Τǡ˼���
    my $no = $#ad_str + 1;

    # ���ȯ��
    srand;
    $no = int(rand($no));

    # ʸ����� Shift_JIS ���Ѵ�
    $ad_str[$no] = Encode::encode("shiftjis", Encode::decode("euc-jp", $ad_str[$no]));

    # ����ʸ������֤�
    return $ad_str[$no];
}

1;
