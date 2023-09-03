/**
 *
 */
$(function() {
	$('#henkan').on('click',function(e) {
		var height = $('input[name=height]').val();
		var weight = $('input[name=weight]').val();
		var sex = $('input[name=sex]').val();
		var age = $('input[name=age]').val();
		if (height.length <= 0) {
			alert("身長を入力してください。");
			return;
		} else if (weight.length <= 0) {
			alert("体重を入力してください。");
			return;
		} else if (sex <= 0) {
			alert("性別を選択してください。");
			return;
		} else if (age.length <= 0) {
			alert("年齢を入力してください。");
			return;
		}

		$.ajax({
			  type: 'POST',
			  url: './api/bmi.php',
			  dataType: 'json',
			  data: {
				  height:height,
				  weight:weight,
				  sex:sex,
				  age:age
				},
			  success: function(data){
				  $('input[name=BMI]').val(data["bmi"]);
				  $('input[name=bestWeight]').val(data["bestWeight"]);
				  $('input[name=diffWeight]').val(data["diffWeight"]);
				  $('input[name=basalmetabolism]').val(data["basalmetabolism"]);
			  },
			  error: function(XMLHttpRequest, textStatus, errorThrown) {
				  alert("処理が出来ませんでした。");
				  $('input[name=BMI]').val("");
				  $('input[name=metabolism]').val("");
				  $('input[name="diffWeight"]').val("");
				  $('input[name="basalmetabolism"]').val("");
				  this; // thisは他のコールバック関数同様にAJAX通信時のオプションを示します。
			  }
		});
	});
});