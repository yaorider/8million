<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="ja" lang="ja">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta http-equiv="Content-Language" content="ja" />
<meta http-equiv="Content-Style-Type" content="text/css" />
<meta http-equiv="Content-Script-Type" content="text/javascript" />
<title>%product_name% Ver %product_version%</title>
<link href="%static_url%/css/install/common.css" type="text/css" rel="stylesheet" />
</head>
<body>
<div id="title">
	<div id="title_left">
		<TMPL_IF NAME="copyright_flag">
			<a href="%product_author_url%" target="_blank">%product_name% Ver %product_version%</a> - 初期セットアップ
		<TMPL_ELSE>
			%product_name% Ver %product_version% - 初期セットアップ
		</TMPL_IF>
	</div>
	<div id="title_right">
		<TMPL_IF NAME="copyright_flag">
			<a href="%product_author_url%" target="_blank">%copyright_caption%</a>
		</TMPL_IF>
	</div>
</div>
<div id="main">
	<div class="errs">%error%</div>
	<hr />
	<button name="backBtn" onclick="javascript:history.back()">&lt;&lt; 戻る</button>
</div>
</body>
</html>
