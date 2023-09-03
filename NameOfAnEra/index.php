<!DOCTYPE html>
<?php
if(isset($_POST["nengo1"])){
	$nengo = $_POST["nengo1"];
} else {
	$nengo = "";
}
?>
<html lang="ja">
	<head>
		<!-- Google tag (gtag.js) -->
		<script async src="https://www.googletagmanager.com/gtag/js?id=G-Q04RGENL5Y"></script>
		<script>
		  window.dataLayer = window.dataLayer || [];
		  function gtag(){dataLayer.push(arguments);}
		  gtag('js', new Date());

		  gtag('config', 'G-Q04RGENL5Y');
		</script>
		<title>年号変換</title>
		<script src="./js/jquery-3.1.0.min.js"></script>
		<script src="./js/NameOfAnEra.js"></script>
		<link href="./css/style.css" rel="stylesheet" type="text/css">
		<meta name="keywords" content="年号変換,誕生年,年齢">
		<meta name="description" content="年号変換と誕生年齢経緯の検索">
		<meta name="author" content="8million LLC.">
		<meta name="generator" content="text">
		<meta http-equiv="content-type" content="text/html; charset=UTF-8">
	</head>
	<body>
		<h1>年号変換</h1>
		<hr>
		西暦：<input type="text" id="nengo1" name="nengo1" value="<?php echo $nengo ?>" style="ime-mode:disabled" maxlength="4" size="4"/>年
		<input type="button" id="henkan" name="henkan" value="和暦変換" />
		和暦：<input type="text" id="nengo2" name="nengo2" value="<?php echo $nengo ?>" readonly="readonly" size="8"/>年<br />

		和暦：<select id="eraname" name="eraname"  TABINDEX="1">
				<option value="大正" >大正</option>
				<option value="昭和">昭和</option>
				<option value="平成">平成</option>
				<option value="令和" selected="selected">令和</option>
				</select>
			<input type="text" id="nengo3" name="nengo3" value="<?php echo $nengo ?>" style="ime-mode:disabled" maxlength="2" size="2"/>年
		<input type="button" id="henkan2" name="henkan2" value="西暦変換" />
		西暦：<input type="text" id="nengo4" name="nengo4" value="<?php echo $nengo ?>" readonly="readonly" size="4"/>年
		<hr>
		<h1>誕生年経緯</h1>
		誕生年：<select id="eraname2" name="eraname2" TABINDEX="2">
				<option value="大正">大正</option>
				<option value="昭和" selected="selected">昭和</option>
				<option value="平成">平成</option>
				<option value="令和">令和</option>
				</select>
			<input type="text" id="nengo5" name="nengo5" value="<?php echo $nengo ?>" style="ime-mode:disabled" maxlength="2" size="2"/>年
		<input type="button" id="henkan3" name="henkan3" value="誕生年経緯" />
		<table id="rireki">
		</table>
	</body>
</html>
