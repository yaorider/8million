package MT4i::Emoticon;

sub get_code {
    my ($name, $ua, $enc) = @_;

    my %emoticon = _hash_n2c();
    my $agent = _get_agent($ua);

    my $code = $emoticon{$agent}->{$name};
    return Encode::encode($enc, chr(hex($code || '3013')), Encode::JP::Mobile::FB_CHARACTER);
}

sub get_name {
    my ($char, $ua, $enc) = @_;

    my %emoticon = _hash_c2n();
    my $agent = _get_agent($ua);

    my $hex = sprintf '%X', ord($char);
    my $name = $emoticon{$agent}->{$hex};
    return $name;
}

sub _get_agent {
    my $ua = shift;

    my $agent = $ua eq 'i-mode'
                    ? 'docomo'
                    : $ua eq 'ezweb'
                        ? 'kddi'
                        : 'softbank';

    return $agent;
}

sub range {
    my $ua = shift;

    return '\x{E63E}-\x{E6A5}\x{E6AC}-\x{E6AE}\x{E6B1}-\x{E6BA}\x{E6CE}-\x{E757}'
        if $ua eq 'i-mode';
    return '\x{E468}-\x{E5DF}\x{EA80}-\x{EB88}'
        if $ua eq 'ezweb';
    return '\x{E001}-\x{E05A}\x{E101}-\x{E15A}\x{E201}-\x{E25A}\x{E301}-\x{E34D}\x{E401}-\x{E44C}\x{E501}-\x{E539}'
        if $ua eq 'j-sky';
    return '';
}

sub _hash_n2c {
    my %emoticon = (
        'docomo' => {
            'sun' => 'E63E',
            'cloud' => 'E63F',
            'rain' => 'E640',
            'snow' => 'E641',
            'thunder' => 'E642',
            'typhoon' => 'E643',
            'mist' => 'E644',
            'sprinkle' => 'E645',
            'aries' => 'E646',
            'taurus' => 'E647',
            'gemini' => 'E648',
            'cancer' => 'E649',
            'leo' => 'E64A',
            'virgo' => 'E64B',
            'libra' => 'E64C',
            'scorpius' => 'E64D',
            'sagittarius' => 'E64E',
            'capricornus' => 'E64F',
            'aquarius' => 'E650',
            'pisces' => 'E651',
            'sports' => 'E652',
            'baseball' => 'E653',
            'golf' => 'E654',
            'tennis' => 'E655',
            'soccer' => 'E656',
            'ski' => 'E657',
            'basketball' => 'E658',
            'motorsports' => 'E659',
            'pocketbell' => 'E65A',
            'train' => 'E65B',
            'subway' => 'E65C',
            'bullettrain' => 'E65D',
            'car' => 'E65E',
            'rvcar' => 'E65F',
            'bus' => 'E660',
            'ship' => 'E661',
            'airplane' => 'E662',
            'house' => 'E663',
            'building' => 'E664',
            'postoffice' => 'E665',
            'hospital' => 'E666',
            'bank' => 'E667',
            'atm' => 'E668',
            'hotel' => 'E669',
            '24hours' => 'E66A',
            'gasstation' => 'E66B',
            'parking' => 'E66C',
            'signaler' => 'E66D',
            'toilet' => 'E66E',
            'restaurant' => 'E66F',
            'cafe' => 'E670',
            'bar' => 'E671',
            'beer' => 'E672',
            'fastfood' => 'E673',
            'boutique' => 'E674',
            'hairsalon' => 'E675',
            'karaoke' => 'E676',
            'movie' => 'E677',
            'upwardright' => 'E678',
            'carouselpony' => 'E679',
            'music' => 'E67A',
            'art' => 'E67B',
            'drama' => 'E67C',
            'event' => 'E67D',
            'ticket' => 'E67E',
            'smoking' => 'E67F',
            'nosmoking' => 'E680',
            'camera' => 'E681',
            'bag' => 'E682',
            'book' => 'E683',
            'ribbon' => 'E684',
            'present' => 'E685',
            'birthday' => 'E686',
            'telephone' => 'E687',
            'mobilephone' => 'E688',
            'memo' => 'E689',
            'tv' => 'E68A',
            'game' => 'E68B',
            'cd' => 'E68C',
            'heart' => 'E68D',
            'spade' => 'E68E',
            'diamond' => 'E68F',
            'club' => 'E690',
            'eye' => 'E691',
            'ear' => 'E692',
            'rock' => 'E693',
            'scissors' => 'E694',
            'paper' => 'E695',
            'downwardright' => 'E696',
            'upwardleft' => 'E697',
            'foot' => 'E698',
            'shoe' => 'E699',
            'eyeglass' => 'E69A',
            'wheelchair' => 'E69B',
            'newmoon' => 'E69C',
            'moon1' => 'E69D',
            'moon2' => 'E69E',
            'moon3' => 'E69F',
            'fullmoon' => 'E6A0',
            'dog' => 'E6A1',
            'cat' => 'E6A2',
            'yacht' => 'E6A3',
            'xmas' => 'E6A4',
            'downwardleft' => 'E6A5',
            'slate' => 'E6AC',
            'pouch' => 'E6AD',
            'pen' => 'E6AE',
            'shadow' => 'E6B1',
            'chair' => 'E6B2',
            'night' => 'E6B3',
            'soon' => 'E6B7',
            'on' => 'E6B8',
            'end' => 'E6B9',
            'clock' => 'E6BA',
            'phoneto' => 'E6CE',
            'mailto' => 'E6CF',
            'faxto' => 'E6D0',
            'info01' => 'E6D1',
            'info02' => 'E6D2',
            'mail' => 'E6D3',
            'by-d' => 'E6D4',
            'd-point' => 'E6D5',
            'yen' => 'E6D6',
            'free' => 'E6D7',
            'id' => 'E6D8',
            'key' => 'E6D9',
            'enter' => 'E6DA',
            'clear' => 'E6DB',
            'search' => 'E6DC',
            'new' => 'E6DD',
            'flag' => 'E6DE',
            'freedial' => 'E6DF',
            'sharp' => 'E6E0',
            'mobaq' => 'E6E1',
            'one' => 'E6E2',
            'two' => 'E6E3',
            'three' => 'E6E4',
            'four' => 'E6E5',
            'five' => 'E6E6',
            'six' => 'E6E7',
            'seven' => 'E6E8',
            'eight' => 'E6E9',
            'nine' => 'E6EA',
            'zero' => 'E6EB',
            'heart01' => 'E6EC',
            'heart02' => 'E6ED',
            'heart03' => 'E6EE',
            'heart04' => 'E6EF',
            'happy01' => 'E6F0',
            'angry' => 'E6F1',
            'despair' => 'E6F2',
            'sad' => 'E6F3',
            'wobbly' => 'E6F4',
            'up' => 'E6F5',
            'note' => 'E6F6',
            'spa' => 'E6F7',
            'cute' => 'E6F8',
            'kissmark' => 'E6F9',
            'shine' => 'E6FA',
            'flair' => 'E6FB',
            'annoy' => 'E6FC',
            'punch' => 'E6FD',
            'bomb' => 'E6FE',
            'notes' => 'E6FF',
            'down' => 'E700',
            'sleepy' => 'E701',
            'sign01' => 'E702',
            'sign02' => 'E703',
            'sign03' => 'E704',
            'impact' => 'E705',
            'sweat01' => 'E706',
            'sweat02' => 'E707',
            'dash' => 'E708',
            'sign04' => 'E709',
            'sign05' => 'E70A',
            'ok' => 'E70B',
            'appli01' => 'E70C',
            'appli02' => 'E70D',
            't-shirt' => 'E70E',
            'moneybag' => 'E70F',
            'rouge' => 'E710',
            'denim' => 'E711',
            'snowboard' => 'E712',
            'bell' => 'E713',
            'door' => 'E714',
            'dollar' => 'E715',
            'pc' => 'E716',
            'loveletter' => 'E717',
            'wrench' => 'E718',
            'pencil' => 'E719',
            'crown' => 'E71A',
            'ring' => 'E71B',
            'sandclock' => 'E71C',
            'bicycle' => 'E71D',
            'japanesetea' => 'E71E',
            'watch' => 'E71F',
            'think' => 'E720',
            'confident' => 'E721',
            'coldsweats01' => 'E722',
            'coldsweats02' => 'E723',
            'pout' => 'E724',
            'gawk' => 'E725',
            'lovely' => 'E726',
            'good' => 'E727',
            'bleah' => 'E728',
            'wink' => 'E729',
            'happy02' => 'E72A',
            'beering' => 'E72B',
            'catface' => 'E72C',
            'crying' => 'E72D',
            'weep' => 'E72E',
            'ng' => 'E72F',
            'clip' => 'E730',
            'copyright' => 'E731',
            'tm' => 'E732',
            'run' => 'E733',
            'secret' => 'E734',
            'recycle' => 'E735',
            'r-mark' => 'E736',
            'danger' => 'E737',
            'ban' => 'E738',
            'empty' => 'E739',
            'pass' => 'E73A',
            'full' => 'E73B',
            'leftright' => 'E73C',
            'updown' => 'E73D',
            'school' => 'E73E',
            'wave' => 'E73F',
            'fuji' => 'E740',
            'clover' => 'E741',
            'cherry' => 'E742',
            'tulip' => 'E743',
            'banana' => 'E744',
            'apple' => 'E745',
            'bud' => 'E746',
            'maple' => 'E747',
            'cherryblossom' => 'E748',
            'riceball' => 'E749',
            'cake' => 'E74A',
            'bottle' => 'E74B',
            'noodle' => 'E74C',
            'bread' => 'E74D',
            'snail' => 'E74E',
            'chick' => 'E74F',
            'penguin' => 'E750',
            'fish' => 'E751',
            'delicious' => 'E752',
            'smile' => 'E753',
            'horse' => 'E754',
            'pig' => 'E755',
            'wine' => 'E756',
            'shock' => 'E757',
        },
        'kddi' => {
            'typhoon' => 'E469',
            'signaler' => 'E46A',
            'run' => 'E46B',
            'happy01' => 'E471',
            'angry' => 'E472',
            'crying' => 'E473',
            'sleepy' => 'E475',
            'flair' => 'E476',
            'heart03' => 'E477',
            'heart04' => 'E478',
            'bomb' => 'E47A',
            'sandclock' => 'E47C',
            'smoking' => 'E47D',
            'nosmoking' => 'E47E',
            'wheelchair' => 'E47F',
            'danger' => 'E481',
            'sign01' => 'E482',
            'snow' => 'E485',
            'moon3' => 'E486',
            'thunder' => 'E487',
            'sun' => 'E488',
            'rain' => 'E48C',
            'cloud' => 'E48D',
            'aries' => 'E48F',
            'taurus' => 'E490',
            'gemini' => 'E491',
            'cancer' => 'E492',
            'leo' => 'E493',
            'virgo' => 'E494',
            'libra' => 'E495',
            'scorpius' => 'E496',
            'sagittarius' => 'E497',
            'capricornus' => 'E498',
            'aquarius' => 'E499',
            'pisces' => 'E49A',
            'bag' => 'E49C',
            'ticket' => 'E49E',
            'book' => 'E49F',
            'clip' => 'E4A0',
            'pencil' => 'E4A1',
            'atm' => 'E4A3',
            '24hours' => 'E4A4',
            'toilet' => 'E4A5',
            'parking' => 'E4A6',
            'bank' => 'E4AA',
            'house' => 'E4AB',
            'restaurant' => 'E4AC',
            'building' => 'E4AD',
            'bicycle' => 'E4AE',
            'bus' => 'E4AF',
            'bullettrain' => 'E4B0',
            'car' => 'E4B1',
            'airplane' => 'E4B3',
            'yacht' => 'E4B4',
            'train' => 'E4B5',
            'soccer' => 'E4B6',
            'tennis' => 'E4B7',
            'snowboard' => 'E4B8',
            'motorsports' => 'E4B9',
            'baseball' => 'E4BA',
            'spa' => 'E4BC',
            'slate' => 'E4BE',
            'wine' => 'E4C1',
            'bar' => 'E4C2',
            'beer' => 'E4C3',
            'game' => 'E4C6',
            'dollar' => 'E4C7',
            'xmas' => 'E4C9',
            'cherryblossom' => 'E4CA',
            'maple' => 'E4CE',
            'present' => 'E4CF',
            'cake' => 'E4D0',
            'cherry' => 'E4D2',
            'riceball' => 'E4D5',
            'fastfood' => 'E4D6',
            'horse' => 'E4D8',
            'cat' => 'E4DB',
            'penguin' => 'E4DC',
            'pig' => 'E4DE',
            'chick' => 'E4E0',
            'dog' => 'E4E1',
            'tulip' => 'E4E4',
            'annoy' => 'E4E5',
            'sweat02' => 'E4E6',
            'bleah' => 'E4E7',
            'kissmark' => 'E4EB',
            'secret' => 'E4F1',
            'punch' => 'E4F3',
            'dash' => 'E4F4',
            'good' => 'E4F9',
            'eyeglass' => 'E4FE',
            'tv' => 'E502',
            'karaoke' => 'E503',
            'moneybag' => 'E504',
            'notes' => 'E505',
            'music' => 'E508',
            'rouge' => 'E509',
            'cd' => 'E50C',
            'bell' => 'E512',
            'clover' => 'E513',
            'ring' => 'E514',
            'camera' => 'E515',
            'hairsalon' => 'E516',
            'movie' => 'E517',
            'search' => 'E518',
            'key' => 'E519',
            'boutique' => 'E51A',
            'faxto' => 'E520',
            'mail' => 'E521',
            'one' => 'E522',
            'two' => 'E523',
            'three' => 'E524',
            'four' => 'E525',
            'five' => 'E526',
            'six' => 'E527',
            'seven' => 'E528',
            'eight' => 'E529',
            'nine' => 'E52A',
            'mobaq' => 'E52C',
            'upwardleft' => 'E54C',
            'downwardright' => 'E54D',
            'tm' => 'E54E',
            'upwardright' => 'E555',
            'downwardleft' => 'E556',
            'copyright' => 'E558',
            'r-mark' => 'E559',
            'enter' => 'E55D',
            'gasstation' => 'E571',
            'free' => 'E578',
            'watch' => 'E57A',
            'yen' => 'E57D',
            'wrench' => 'E587',
            'mobilephone' => 'E588',
            'clock' => 'E594',
            'heart01' => 'E595',
            'telephone' => 'E596',
            'cafe' => 'E597',
            'mist' => 'E598',
            'golf' => 'E599',
            'basketball' => 'E59A',
            'pocketbell' => 'E59B',
            'art' => 'E59C',
            'event' => 'E59E',
            'ribbon' => 'E59F',
            'birthday' => 'E5A0',
            'spade' => 'E5A1',
            'diamond' => 'E5A2',
            'club' => 'E5A3',
            'eye' => 'E5A4',
            'ear' => 'E5A5',
            'scissors' => 'E5A6',
            'paper' => 'E5A7',
            'newmoon' => 'E5A8',
            'moon1' => 'E5A9',
            'moon2' => 'E5AA',
            'clear' => 'E5AB',
            'zero' => 'E5AC',
            'ok' => 'E5AD',
            'wobbly' => 'E5AE',
            'impact' => 'E5B0',
            'sweat01' => 'E5B1',
            'noodle' => 'E5B4',
            'new' => 'E5B5',
            't-shirt' => 'E5B6',
            'pc' => 'E5B8',
            'subway' => 'E5BC',
            'fuji' => 'E5BD',
            'note' => 'E5BE',
            'wink' => 'E5C3',
            'lovely' => 'E5C4',
            'shock' => 'E5C5',
            'coldsweats02' => 'E5C6',
            'crown' => 'E5C9',
            'postoffice' => 'E5DE',
            'hospital' => 'E5DF',
            'school' => 'EA80',
            'hotel' => 'EA81',
            'ship' => 'EA82',
            'id' => 'EA88',
            'full' => 'EA89',
            'empty' => 'EA8A',
            'memo' => 'EA92',
            'bottle' => 'EA97',
            'heart' => 'EAA5',
            'shine' => 'EAAB',
            'ski' => 'EAAC',
            'japanesetea' => 'EAAE',
            'bread' => 'EAAF',
            'apple' => 'EAB9',
            'catface' => 'EABF',
            'despair' => 'EAC0',
            'beering' => 'EAC2',
            'sad' => 'EAC3',
            'confident' => 'EAC5',
            'gawk' => 'EAC9',
            'delicious' => 'EACD',
            'sprinkle' => 'EAE8',
            'night' => 'EAF1',
            'drama' => 'EAF5',
            'pen' => 'EB03',
            'phoneto' => 'EB08',
            'foot' => 'EB2A',
            'shoe' => 'EB2B',
            'flag' => 'EB2C',
            'up' => 'EB2D',
            'down' => 'EB2E',
            'sign02' => 'EB2F',
            'sign03' => 'EB30',
            'sign05' => 'EB31',
            'banana' => 'EB35',
            'pout' => 'EB5D',
            'mailto' => 'EB62',
            'weep' => 'EB69',
            'heart02' => 'EB75',
            'denim' => 'EB77',
            'loveletter' => 'EB78',
            'recycle' => 'EB79',
            'leftright' => 'EB7A',
            'updown' => 'EB7B',
            'wave' => 'EB7C',
            'bud' => 'EB7D',
            'snail' => 'EB7E',
            'smile' => 'EB80',
            'rock' => 'EB83',
            'sharp' => 'EB84',
        },
        'softbank' => {
            'kissmark' => 'E003',
            't-shirt' => 'E006',
            'shoe' => 'E007',
            'camera' => 'E008',
            'telephone' => 'E009',
            'mobilephone' => 'E00A',
            'faxto' => 'E00B',
            'pc' => 'E00C',
            'punch' => 'E00D',
            'good' => 'E00E',
            'rock' => 'E010',
            'scissors' => 'E011',
            'paper' => 'E012',
            'ski' => 'E013',
            'golf' => 'E014',
            'tennis' => 'E015',
            'baseball' => 'E016',
            'soccer' => 'E018',
            'fish' => 'E019',
            'horse' => 'E01A',
            'car' => 'E01B',
            'yacht' => 'E01C',
            'airplane' => 'E01D',
            'train' => 'E01E',
            'sign01' => 'E021',
            'heart01' => 'E022',
            'heart03' => 'E023',
            'clock' => 'E02D',
            'cherryblossom' => 'E030',
            'xmas' => 'E033',
            'ring' => 'E034',
            'house' => 'E036',
            'building' => 'E038',
            'gasstation' => 'E03A',
            'fuji' => 'E03B',
            'karaoke' => 'E03C',
            'movie' => 'E03D',
            'note' => 'E03E',
            'key' => 'E03F',
            'restaurant' => 'E043',
            'wine' => 'E044',
            'cafe' => 'E045',
            'cake' => 'E046',
            'beer' => 'E047',
            'snow' => 'E048',
            'cloud' => 'E049',
            'sun' => 'E04A',
            'rain' => 'E04B',
            'moon3' => 'E04C',
            'cat' => 'E04F',
            'dog' => 'E052',
            'penguin' => 'E055',
            'delicious' => 'E056',
            'happy01' => 'E057',
            'despair' => 'E058',
            'angry' => 'E059',
            'loveletter' => 'E103',
            'phoneto' => 'E104',
            'bleah' => 'E105',
            'lovely' => 'E106',
            'shock' => 'E107',
            'coldsweats02' => 'E108',
            'pig' => 'E10B',
            'crown' => 'E10E',
            'flair' => 'E10F',
            'clover' => 'E110',
            'present' => 'E112',
            'search' => 'E114',
            'run' => 'E115',
            'maple' => 'E118',
            'chair' => 'E11F',
            'fastfood' => 'E120',
            'spa' => 'E123',
            'ticket' => 'E125',
            'cd' => 'E126',
            'tv' => 'E12A',
            'dollar' => 'E12F',
            'motorsports' => 'E132',
            'bicycle' => 'E136',
            'sleepy' => 'E13C',
            'thunder' => 'E13D',
            'boutique' => 'E13E',
            'book' => 'E148',
            'bank' => 'E14D',
            'signaler' => 'E14E',
            'parking' => 'E14F',
            'toilet' => 'E151',
            'postoffice' => 'E153',
            'atm' => 'E154',
            'hospital' => 'E155',
            '24hours' => 'E156',
            'school' => 'E157',
            'hotel' => 'E158',
            'bus' => 'E159',
            'ship' => 'E202',
            'nosmoking' => 'E208',
            'wheelchair' => 'E20A',
            'heart' => 'E20C',
            'diamond' => 'E20D',
            'spade' => 'E20E',
            'club' => 'E20F',
            'sharp' => 'E210',
            'freedial' => 'E211',
            'new' => 'E212',
            'one' => 'E21C',
            'two' => 'E21D',
            'three' => 'E21E',
            'four' => 'E21F',
            'five' => 'E220',
            'six' => 'E221',
            'seven' => 'E222',
            'eight' => 'E223',
            'nine' => 'E224',
            'zero' => 'E225',
            'id' => 'E229',
            'full' => 'E22A',
            'empty' => 'E22B',
            'up' => 'E236',
            'upwardleft' => 'E237',
            'downwardright' => 'E238',
            'downwardleft' => 'E239',
            'aries' => 'E23F',
            'taurus' => 'E240',
            'gemini' => 'E241',
            'cancer' => 'E242',
            'leo' => 'E243',
            'virgo' => 'E244',
            'libra' => 'E245',
            'scorpius' => 'E246',
            'sagittarius' => 'E247',
            'capricornus' => 'E248',
            'aquarius' => 'E249',
            'pisces' => 'E24A',
            'ok' => 'E24D',
            'copyright' => 'E24E',
            'r-mark' => 'E24F',
            'danger' => 'E252',
            'memo' => 'E301',
            'tulip' => 'E304',
            'music' => 'E30A',
            'bottle' => 'E30B',
            'smoking' => 'E30E',
            'bomb' => 'E311',
            'hairsalon' => 'E313',
            'ribbon' => 'E314',
            'secret' => 'E315',
            'rouge' => 'E31C',
            'bag' => 'E323',
            'slate' => 'E324',
            'bell' => 'E325',
            'notes' => 'E326',
            'heart04' => 'E327',
            'shine' => 'E32E',
            'dash' => 'E330',
            'sweat02' => 'E331',
            'annoy' => 'E334',
            'japanesetea' => 'E338',
            'bread' => 'E339',
            'noodle' => 'E340',
            'riceball' => 'E342',
            'apple' => 'E345',
            'birthday' => 'E34B',
            'catface' => 'E402',
            'think' => 'E403',
            'smile' => 'E404',
            'wink' => 'E405',
            'wobbly' => 'E406',
            'sad' => 'E407',
            'confident' => 'E40A',
            'gawk' => 'E40E',
            'crying' => 'E411',
            'weep' => 'E413',
            'coldsweats01' => 'E415',
            'pout' => 'E416',
            'eye' => 'E419',
            'ear' => 'E41B',
            'basketball' => 'E42A',
            'rvcar' => 'E42E',
            'subway' => 'E434',
            'bullettrain' => 'E435',
            'sprinkle' => 'E43C',
            'wave' => 'E43E',
            'typhoon' => 'E443',
            'night' => 'E44B',
            'art' => 'E502',
            'drama' => 'E503',
            'chick' => 'E523',
            'foot' => 'E536',
            'tm' => 'E537',
        },
    );

    return %emoticon;
}

sub _hash_c2n {
    my %emoticon = _hash_n2c();

    my %docomo = reverse %{$emoticon{docomo}};
    my %kddi = reverse %{$emoticon{kddi}};
    my %softbank = reverse %{$emoticon{softbank}};
    my %reverse = ( 'docomo'   => \%docomo,
                    'kddi'     => \%kddi,
                    'softbank' => \%softbank );
    return %reverse;
}

1;
