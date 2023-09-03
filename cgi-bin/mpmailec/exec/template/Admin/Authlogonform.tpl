<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="ja" lang="ja">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta http-equiv="Content-Language" content="ja" />
<meta http-equiv="Content-Style-Type" content="text/css" />
<meta http-equiv="Content-Script-Type" content="text/javascript" />
<meta name="robots" content="noindex" />
<title>%product_name% Ver %product_version%</title>
<link href="%static_url%/css/admin/common.css" type="text/css" rel="stylesheet" />
<link href="%static_url%/css/admin/authlogonform.css" type="text/css" rel="stylesheet" />
<script type="text/javascript" src="%static_url%/js/dom.js"></script>
<script type="text/javascript" src="%static_url%/js/form.js"></script>
<script type="text/javascript" src="%static_url%/js/inputlimit.js"></script>
</head>
<body>
<div id="title">
	<div id="title_left">
		<TMPL_IF NAME="copyright_flag">
			<a href="%product_author_url%" target="_blank">%product_name% Ver %product_version%</a> - 管理者ログオン
		<TMPL_ELSE>
			%product_name% Ver %product_version% - 管理者ログオン
		</TMPL_IF>
	</div>
	<div id="title_right">
		<TMPL_IF NAME="copyright_flag">
			<a href="%product_author_url%" target="_blank">%copyright_caption%</a>
		</TMPL_IF>
	</div>
</div>
<div id="main">
<p>管理者ID と パスワードを入力して「ログオン」ボタンを押して下さい。</p>
<form action="%CGI_URL%" method="post" target="_top">
	<input type="hidden" name="m" value="authlogon" />
	<fieldset>
		<legend>ログオン</legend>
		<TMPL_IF NAME="errs"><div class="errs">%errs%</div></TMPL_IF>
		<dl>
			<dt><label for="id">管理者ID</label></dt>
			<dd><input type="text" id="id" name="id" value="%id%" size="20" class="text inputlimit_ascii" /></dd>
		</dl>
		<dl class="last">
			<dt><label for="pass">パスワード</label></dt>
			<dd><input type="password" id="pass" name="pass" value="" size="20" class="password" /></dd>
		</dl>
		<TMPL_IF NAME="auto_logon"><p><input type="checkbox" id="auto_logon_enable" name="auto_logon_enable" value="1" class="checkbox" /> <label for="auto_logon_enable">次回から自動でログオンする。</label></p></TMPL_IF>
		<p><input type="submit" name="setBtn" value="ログオン" class="submit" /></p>
	</fieldset>
</form>
</div>
</body>
</html>