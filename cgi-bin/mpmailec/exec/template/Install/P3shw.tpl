<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="ja" lang="ja">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta http-equiv="Content-Language" content="ja" />
<meta http-equiv="Content-Style-Type" content="text/css" />
<meta http-equiv="Content-Script-Type" content="text/javascript" />
<title>%product_name% Ver %product_version%</title>
<link href="%static_url%/css/install/common.css" type="text/css" rel="stylesheet" />
<script type="text/javascript" src="%static_url%/js/dom.js"></script>
<script type="text/javascript" src="%static_url%/js/form.js"></script>
<script type="text/javascript" src="%static_url%/js/inputlimit.js"></script>
</head>
<body>
<!-- ヘッダー start -->
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
<!-- ヘッダー end -->
<div id="main">
	<!-- 左フレーム start -->
	<div id="leftbox">
		<h1>メール送信設定</h1>
		<p>sendmail設定および投稿メール受信アドレス設定を行います。入力後、「設定」ボタンを押してください。</p>
		<TMPL_IF NAME="errs"><div class="errs">%errs%</div></TMPL_IF>
		<form method="post" action="%CGI_URL%">
			<input type="hidden" name="m" value="p3shw" />
			<input type="hidden" name="smt" value="1" />
			<fieldset>
				<legend>メール送信システム設定</legend>
				<dl class="last">
					<dt><label for="sendmail_path" class="%sendmail_path_err%">sendmailのパス</label></dt>
					<dd>
						<input type="text" id="sendmail_path" name="sendmail_path" value="%sendmail_path%" class="text inputlimit_ascii %sendmail_path_err%" />
						<ul class="note">
							<li>ご利用の環境のsendmailのパスを指定してください。例：/usr/sbin/sendmail</li>
						</ul>
					</dd>
				</dl>
			</fieldset>
			<fieldset>
				<legend>メールアドレス設定</legend>
				<dl class="last">
					<dt><label for="mai_to" class="required %mai_to_err%">受信アドレス</label></dt>
					<dd>
						<input type="text" id="mai_to" name="mai_to" value="%mai_to%" class="text inputlimit_ascii %mai_to_err%" />
						<ul class="note">
							<li>投稿メールを受け取るメールアドレスを指定してください。</li>
							<li>複数のメールアドレスを指定したい場合は、各メールアドレスを半角カンマで区切って入力してください。</li>
						</ul>
					</dd>
				</dl>
			</fieldset>
			<div><input type="submit" value="設定" name="setBtn" class="submit" /></div>
		</form>
	</div>
	<!-- 左フレーム end -->
	<!-- 右フレーム start -->
	<div id="rightbox">
		<div id="stepbox">
			<div class="step">
				<div class="steptitle">Step 1</div>
				<div class="stepdesc">staticディレクトリのURLの設定</div>
			</div>
			<div class="step">
				<div class="steptitle">Step 2</div>
				<div class="stepdesc">CGI設置診断セットアップ</div>
			</div>
			<div class="step target">
				<div class="steptitle">Step 3</div>
				<div class="stepdesc">メール送信設定</div>
			</div>
			<div class="step">
				<div class="steptitle">Step 4</div>
				<div class="stepdesc">管理者用ID・パスワード設定</div>
			</div>
			<div class="step">
				<div class="steptitle">セットアップ完了</div>
			</div>
		</div>
	</div>
	<!-- 右フレーム end -->
</div>
</body>
</html>
