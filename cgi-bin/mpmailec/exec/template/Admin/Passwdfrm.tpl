<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="ja" lang="ja">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta http-equiv="Content-Language" content="ja" />
<meta http-equiv="Content-Style-Type" content="text/css" />
<meta http-equiv="Content-Script-Type" content="text/javascript" />
<title>%product_name% Ver %product_version%</title>
<link href="%static_url%/css/admin/common.css" type="text/css" rel="stylesheet" />
<script type="text/javascript" src="%static_url%/js/dom.js"></script>
<script type="text/javascript" src="%static_url%/js/form.js"></script>
<script type="text/javascript" src="%static_url%/js/inputlimit.js"></script>
<script type="text/javascript" src="%static_url%/js/input_length_limit.js"></script>
</head>
<body>
<h1>パスワード変更</h1>
<div id="main">
<p id="description">管理メニューにログオンするための管理者IDとパスワードを変更します。入力したら「設定」ボタンを押してください。変更処理が完了すると、自動的にログオフして、ログオン画面が表示されます。変更したID/パスワードを使ってログオンしてください。</p>
<form id="passform" method="post" action="%CGI_URL%" name="passform">
	<input type="hidden" name="m" value="passwdset" />
	<input type="hidden" name="pkey" value="%pkey%" />
	<fieldset>
		<legend>管理者ID/パスワード情報</legend>
		<TMPL_IF NAME="errs"><div class="errs">%errs%</div></TMPL_IF>
		<dl>
			<dt><label for="id">管理者ID</label></dt>
			<dd>
				<input type="text" name="id" id="id" value="%id%" size="20" class="text inputlimit_ascii length_limit" />
				<ul class="note">
					<li>半角英数字および半角記号で、<span id="id_min_char_num">3</span>文字以上<span id="id_max_char_num">255</span>文字以内で入力してください。（現在の入力文字数：<span id="id_char_num">0</span>文字）</li>
					<li>半角スペースを指定することはできません。</li>
				</ul>
			</dd>
		</dl>
		<dl>
			<dt><label for="pass1">パスワード</label></dt>
			<dd>
				<input type="password" name="pass1" id="pass1" value="%pass1%" size="20" class="password length_limit" />
				<ul class="note">
					<li>半角英数字および半角記号で、<span id="pass1_min_char_num">3</span>文字以上<span id="pass1_max_char_num">255</span>文字以内で入力してください。（現在の入力文字数：<span id="pass1_char_num">0</span>文字）</li>
					<li>半角スペースを指定することはできません。</li>
				</ul>
			</dd>
		</dl>
		<dl class="last">
			<dt><label for="pass2">パスワード再入力</label></dt>
			<dd>
				<input type="password" name="pass2" id="pass2" value="%pass2%" size="20" class="password length_limit" />
				<ul class="note">
					<li>確認のためにもう一度パスワードを入力してください。</li>
				</ul>
			</dd>
		</dl>
		<p><input type="submit" value="設定" name="setBtn" class="submit" /></p>
	</fieldset>
</form>
</div>
</body>
</html>
