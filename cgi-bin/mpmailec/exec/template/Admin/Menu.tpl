<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="ja" lang="ja">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta http-equiv="Content-Language" content="ja" />
<meta http-equiv="Content-Style-Type" content="text/css" />
<meta http-equiv="Content-Script-Type" content="text/javascript" />
<title>%product_name% Ver %product_version%</title>
<link href="%static_url%/css/admin/menu.css" type="text/css" rel="stylesheet" />
</head>
<body>
<div id="title">
	<div id="title_left">
		<TMPL_IF NAME="copyright_flag">
			<a href="%product_author_url%" target="_blank">%product_name% Ver %product_version%</a>
		<TMPL_ELSE>
			%product_name% Ver %product_version%
		</TMPL_IF>
	</div>
	<div id="title_right">
		<TMPL_IF NAME="copyright_flag">
			<a href="%product_author_url%" target="_blank">%copyright_caption%</a>
		</TMPL_IF>
	</div>
</div>
<div id="menu">
	<ul>
		<li><a href="%CGI_URL%" target="_top">Top</a></li>
		<li><a href="form.cgi" target="_blank">入力フォーム</a></li>
		<TMPL_IF NAME="log_enable"><li><a href="%CGI_URL%?m=logadmmnu" target="main">ログ管理</a></li></TMPL_IF>
		<li><a href="%CGI_URL%?m=tpllstmnu" target="main">画面テンプレート</a></li>
		<li><a href="%CGI_URL%?m=optcnfmnu" target="main">機能設定</a></li>
		<li><a href="%CGI_URL%?m=syscnffrm" target="main">システム設定</a></li>
		<li><a href="%CGI_URL%?m=passwdfrm" target="main">パスワード変更</a></li>
	</ul>
	<ul>
		<li><a href="%CGI_URL%?m=logoff" target="_top">ログオフ</a></li>
	</ul>
</div>
</body>
</html>
