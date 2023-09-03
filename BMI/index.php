<!DOCTYPE html>
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
		<title>基礎代謝計算</title>
		<script src="./js/jquery-3.1.0.min.js"></script>
		<script src="./js/BMI.js"></script>
		<link href="./css/style.css" rel="stylesheet" type="text/css">
		<meta name="keywords" content="基礎代謝計算,BMI">
		<meta name="description" content="基礎代謝とBMIの計算">
		<meta name="author" content="8million LLC.">
		<meta name="generator" content="text">
		<meta http-equiv="content-type" content="text/html; charset=UTF-8">
	</head>
	<body>
		<h1>基礎代謝</h1>
		<hr>
		身長：<input type="text" id="height" name="height" value="" style="ime-mode:disabled" maxlength="5" size="5"/>cm
		体重：<input type="text" id="weight" name="weight" value="" style="ime-mode:disabled" maxlength="5" size="8"/>kg<br />
		<input type="radio" id="sex" name="sex" value="1">男性
		<input type="radio" id="sex" name="sex" value="2">女性<br />
		年齢：<input type="text" id="age" name="age" value="" style="ime-mode:disabled" maxlength="3" size="3"/>歳
		<input type="button" id="henkan" name="henkan" value="計算" /><br />
		<hr>
		BMI：<input type="text" id="BMI" name="BMI" value="" readonly="readonly" size="8"/><br />
		適正体重：<input type="text" id="bestWeight" name="bestWeight" value="" readonly="readonly" size="8"/><br />
		体重-適正体重：<input type="text" id="diffWeight" name="diffWeight" value="" readonly="readonly" size="8"/><br />
		基礎代謝量：<input type="text" id="basalmetabolism" name="basalmetabolism" value="" readonly="readonly" size="8"/>kcal<br />
	</body>
</html>
