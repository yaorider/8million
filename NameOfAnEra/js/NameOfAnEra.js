/**
 *
 */
$(function() {
	$('#henkan').on('click',function(e) {
		var nengo1 = $('input[name=nengo1]').val();
		if (nengo1.length <= 0) {
			alert("西暦を入力してください。");
			return;
		}
		$.ajax({
			  type: 'POST',
			  url: './api/conversion.php',
			  dataType: 'json',
			  data: {
				  nengo:nengo1
				},
			  success: function(data){
				  $('input[name=nengo2]').val(data["wareki"]);
			  },
			  error: function(XMLHttpRequest, textStatus, errorThrown) {
				  alert("年号が取得できませんでした。");
				  $('input[name=nengo2]').val("");
				  this; // thisは他のコールバック関数同様にAJAX通信時のオプションを示します。
			  }
		});
	});
	$('#henkan2').on('click',function(e) {
		var eraname = $('[name=eraname]').val();
		var nengo3 = $('input[name=nengo3]').val();
		if (nengo3.length <= 0) {
			alert("和暦を入力してください。");
			return;
		}
		$.ajax({
			  type: 'POST',
			  url: './api/conversion2.php',
			  dataType: 'json',
			  data: {
				  eraname:eraname,
				  nengo:nengo3
				},
			  success: function(data){
				  $('input[name=nengo4]').val(data["seireki"]);
			  },
			  error: function(XMLHttpRequest, textStatus, errorThrown) {
				  alert("年号が取得できませんでした。");
				  $('input[name=nengo4]').val("");
				  this; // thisは他のコールバック関数同様にAJAX通信時のオプションを示します。
			  }
		});
	});
	$('#henkan3').on('click',function(e) {
		var eraname2 = $('[name=eraname2]').val();
		var nengo5 = $('input[name=nengo5]').val();
		if (nengo5.length <= 0) {
			alert("和暦を入力してください。");
			return;
		}
		$.ajax({
			  type: 'POST',
			  url: './api/conversion3.php',
			  dataType: 'json',
			  data: {
				  eraname:eraname2,
				  nengo:nengo5
				},
			  success: function(data){
					  var insertHtml;
					  var i=0;
					  $('#rireki tr').remove();
				  insertHtml = "<tr><td>西暦</td><td>和暦</td><td>年齢</td><td>数え年</td><td></td><td>厄年</td>";
				  $('#rireki').append( insertHtml );
				  insertHtml="";
				  for (var key in  data) {
					if ( key.match(/seireki/)) {
						insertHtml = "<tr><td>" + data[key] + "年</td>";
//								console.log(key + data[key]);
					} else if (key.match(/wareki/)) {
						insertHtml += "<td>" + data[key] + "年</td>";
//								console.log(key + data[key]);
						insertHtml += "<td>" + i + "歳</td>";
						insertHtml += "<td>" + (i+1) + "歳</td>";
						insertHtml += "<td>" + getRireki(i) + "</td>";
						insertHtml += "<td>" + yakudoshi(i) + "</td></tr>";
						$('#rireki').append( insertHtml );
						insertHtml="";
						i++;
					}
				  }
			  },
			  error: function(XMLHttpRequest, textStatus, errorThrown) {
				  alert("年号が取得できませんでした。");
				  $('input[name=nengo4]').val("");
				  this; // thisは他のコールバック関数同様にAJAX通信時のオプションを示します。
			  }
		});
	});
});
getRireki = function(i) {
	if (i==0) {
		return "誕生"
	} else if (i==3) {
		return "幼稚園入園"
	} else if (i==6) {
		return "卒園・小学校入学"
	} else if (i==12) {
		return "小学校卒業・中学校入学"
	} else if (i==15) {
		return "中学校卒業・高校入学"
	} else if (i==18) {
		return "高校卒業・大学入学"
	} else if (i==20) {
		return "成人"
	} else if (i==23) {
		return "大学卒業・新入社員"
	} else if (i==60) {
		return "還暦"
	} else if (i==70) {
		return "古希"
	} else if (i==77) {
		return "喜寿"
	} else if (i==88) {
		return "傘寿"
	} else if (i==88) {
		return "米寿"
	} else if (i==99) {
		return "白寿"
	} else if (i==100) {
		return "百寿"
	} else {
		return ""
	}
}
yakudoshi = function(i) {
	if (i==24) {
		return "前厄（男性）"
	} else if (i==25) {
		return "本厄（男性）"
	} else if (i==26) {
		return "後厄（男性）"
	} else if (i==41) {
		return "前厄（男性）"
	} else if (i==42) {
		return "本厄（男性）"
	} else if (i==43) {
		return "後厄（男性）"
	} else if (i==60) {
		return "前厄（男性・女性）"
	} else if (i==61) {
		return "本厄（男性・女性）"
	} else if (i==62) {
		return "後厄（男性・女性）"
	} else if (i==18) {
		return "前厄（女性）"
	} else if (i==19) {
		return "本厄（女性）"
	} else if (i==20) {
		return "後厄（女性）"
	} else if (i==32) {
		return "前厄（女性）"
	} else if (i==33) {
		return "本厄（女性）"
	} else if (i==34) {
		return "後厄（女性）"
	} else if (i==36) {
		return "前厄（女性）"
	} else if (i==37) {
		return "本厄（女性）"
	} else if (i==38) {
		return "後厄（女性）"
	} else {
		return ""
	}
}