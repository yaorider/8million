<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="ja" lang="ja">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta http-equiv="Content-Language" content="ja" />
<meta http-equiv="Content-Style-Type" content="text/css" />
<meta http-equiv="Content-Script-Type" content="text/javascript" />
<title>%product_name% Ver %product_version%</title>
<link href="%static_url%/css/admin/common.css" type="text/css" rel="stylesheet" />
<link href="%static_url%/css/admin/authlogonform.css" type="text/css" rel="stylesheet" />
<script type="text/javascript" src="%static_url%/js/dom.js"></script>
<script type="text/javascript" src="%static_url%/js/form.js"></script>
<script type="text/javascript" src="%static_url%/js/inputlimit.js"></script>
<script type="text/javascript" src="%static_url%/js/input_length_limit.js"></script>
</head>
<body>
<div id="title">
	<div id="title_left">
		<TMPL_IF NAME="copyright_flag">
			<a href="%product_author_url%" target="_blank">%product_name% Ver %product_version%</a> - 管理者パスワード設定
		<TMPL_ELSE>
			%product_name% Ver %product_version% - 管理者パスワード設定
		</TMPL_IF>
	</div>
	<div id="title_right">
		<TMPL_IF NAME="copyright_flag">
			<a href="%product_author_url%" target="_blank">%copyright_caption%</a>
		</TMPL_IF>
	</div>
</div>
<div id="main">
<p id="description">管理者ID/パスワードを登録します。入力したら「登録」ボタンを押してください。正常にセットされるとログオン画面が表示されます。登録したID/パスワードを使ってログオンしてください。</p>
<form id="passform" method="post" action="%CGI_URL%" name="passform">
	<input type="hidden" name="m" value="authinit" />
	<fieldset>
		<legend>管理者ID/パスワード情報</legend>
		<TMPL_IF NAME="errs"><div class="errs">%errs%</div></TMPL_IF>
		<dl>
			<dt><label for="id" class="%id_err%">管理者ID</label></dt>
			<dd>
				<input type="text" id="id" name="id" value="%id%" size="20" class="text inputlimit_ascii length_limit %id_err%" />
				<ul class="note">
					<li><span id="id_min_char_num">3</span>文字以上<span id="id_max_char_num">255</span>文字以内で入力してください。（現在の入力文字数：<span id="id_char_num">0</span>文字）</li>
					<li>半角スペースを指定することはできません。</li>
				</ul>
			</dd>
		</dl>
		<dl>
			<dt><label for="pass1" class="%pass1_err%">パスワード</label></dt>
			<dd>
				<input type="password" id="pass1" name="pass1" value="%pass1%" size="20" class="password length_limit %pass1_err%" />
				<ul class="note">
					<li><span id="pass1_min_char_num">3</span>文字以上<span id="pass1_max_char_num">255</span>文字以内で入力してください。（現在の入力文字数：<span id="pass1_char_num">0</span>文字）</li>
					<li>半角スペースを指定することはできません。</li>
				</ul>
			</dd>
		</dl>
		<dl class="last">
			<dt><label for="pass2" class="%pass2_err%">パスワード再入力</label></dt>
			<dd>
				<input type="password" id="pass2" name="pass2" value="%pass2%" size="20" class="password %pass2_err%" />
				<ul class="note">
					<li>確認のためにもう一度パスワードを入力してください。</li>
				</ul>
			</dd>
		</dl>
		<p><input type="submit" value="登録" name="setBtn" class="submit" /></p>
	</fieldset>
</form>
</div>
</body>
</html>
