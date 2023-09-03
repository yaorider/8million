<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="ja" lang="ja">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta http-equiv="Content-Language" content="ja" />
<meta http-equiv="Content-Style-Type" content="text/css" />
<meta http-equiv="Content-Script-Type" content="text/javascript" />
<title>%product_name% Ver %product_version%</title>
<link href="%static_url%/css/admin/common.css" type="text/css" rel="stylesheet" />
<style type="text/css">
#pass_lock_limit { width:3em; }
#session_expire { width:3em; }
</style>
<script type="text/javascript" src="%static_url%/js/dom.js"></script>
<script type="text/javascript" src="%static_url%/js/form.js"></script>
<script type="text/javascript" src="%static_url%/js/inputlimit.js"></script>
</head>
<body>
<h1>システム設定</h1>
<div id="main">
<p>本システムの設定を行います。設定入力後、画面下の「設定」ボタンを押してください。 </p>
<TMPL_IF NAME="errs"><div class="errs">%errs%</div></TMPL_IF>
<form method="post" action="%CGI_URL%">
	<input type="hidden" name="m" value="syscnfset" />
	<input type="hidden" name="pkey" value="%pkey%" />
	<fieldset>
		<legend>管理メニューのアクセス制限</legend>
		<dl>
			<dt><label for="hosts_allow" class="%hosts_allow_err%">許可するIPアドレス</label></dt>
			<dd>
				<textarea id="hosts_allow" name="hosts_allow" rows="2" cols="80" class="inputlimit_ascii %hosts_allow_err%">%hosts_allow%</textarea>
				<ul class="note">
					<li>管理メニューへのアクセスを許可するIPアドレス帯域を指定してください。</li>
					<li>%REMOTE_ADDR%/32 といった具合にビットマスクをつけて指定してください。いくつでも指定可能です。</li>
					<li>現在、あなたのアクセス元IPアドレス（%REMOTE_ADDR%）を含めた帯域を指定してください。もしあなたのアクセス元IPアドレスを含まない帯域を指定すると管理メニューへアクセスできなくなりますのでご注意ください。</li>
					<li>指定がなければ、IPアドレス制限は無効となります。</li>
				</ul>
			</dd>
		</dl>
		<dl>
			<dt><label for="pass_lock_limit" class="%pass_lock_limit_err%">パスワードロック</label></dt>
			<dd>
				<input type="text" id="pass_lock_limit" name="pass_lock_limit" value="%pass_lock_limit%" maxlength="2" class="text inputlimit_num %pass_lock_limit_err%" /> 回
				<ul class="note">
					<li>登録されたログオンIDを使って指定回数だけ連続してログオンに失敗すると、そのログオンIDで今後ログインできないようロックします。</li>
					<li>パスワードロック機能を使わない場合は何も設定しないでください。</li>
					<li>パスワードロック機能を利用する場合は、1～99の値をセットしてください。</li>
				</ul>
			</dd>
		</dl>
		<dl>
			<dt><label for="session_expire" class="required %session_expire_err%">ログオンセッション有効期間</label></dt>
			<dd>
				<input type="text" id="session_expire" name="session_expire" value="%session_expire%" maxlength="3" class="text inputlimit_num %session_expire_err%" /> 時間
				<ul class="note">
					<li>管理メニューへの最後のアクセスから、ここで指定した時間を経過するとログオフした状態となります。</li>
					<li>1～999時間の間で指定してください。小数を指定することはできません。</li>
				</ul>
			</dd>
		</dl>
		<dl class="last">
			<dt><label class="%auto_logon_err%">自動ログオン</label></dt>
			<dd>
				<input type="checkbox" id="auto_logon_1" name="auto_logon" value="1" class="checkbox %auto_logon_err%" %auto_logon_checked% /> <label for="auto_logon_1">有効にする</label>
				<ul class="note">
					<li>自動ログオンを有効にすると、ログオンセッション有効期間の間は、ログオン認証をせずに管理画面を利用することができるようになります。</li>
				</ul>
			</dd>
		</dl>
	</fieldset>
	<fieldset>
		<legend>システム設定情報</legend>
		<dl>
			<dt><label for="static_url" class="required %static_url_err%">staticディレクトリのURL</label></dt>
			<dd>
				<input type="text" id="static_url" name="static_url" value="%static_url%" class="text inputlimit_ascii %static_url_err%" />
				<ul class="note">
					<li>最後にスラッシュを入れないで下さい。</li>
					<li>すでに画面が正しく表示されている場合は、決して変更しないでください。</li>
				</ul>
			</dd>
		</dl>
		<dl>
			<dt><label for="sendmail_path" class="%sendmail_path_err%">sendmailのパス</label></dt>
			<dd>
				<ul class="note">
					<li>ご利用の環境のsendmailのパスを指定してください。例：/usr/sbin/sendmail</li>
					<li>sendmailが利用できない場合は、何も指定しないでください。</li>
				</ul>
				<input type="text" id="sendmail_path" name="sendmail_path" value="%sendmail_path%" class="text inputlimit_ascii %sendmail_path_err%" />
			</dd>
		</dl>
		<dl>
			<dt><label for="smtp_host" class="%smtp_host_err%">SMTPサーバ</label></dt>
			<dd>
				<input type="text" id="smtp_host" name="smtp_host" value="%smtp_host%" class="text inputlimit_ascii %smtp_host_err%" style="width:300px" />：ポート番号 <input type="text" id="smtp_port" name="smtp_port" value="%smtp_port%" class="text inputlimit_num %smtp_port_err%" style="width:50px" />
				<ul class="note">
					<li>sendmailが利用できない場合は、SMTPサーバを指定することも可能です。SMTPサーバのIPアドレスまたはホスト名を指定してください。</li>
					<li>SMTPサーバを利用してメールを送信する場合は、sendmailのパスの設定に何も入力しないでください。</li>
					<li>もし指定のSMTPサーバがSMTP認証を必要とする場合は、SMTP認証用のユーザー名とパスワードを指定してください。</li>
					<li>SMTP認証が不要な場合は、何も指定しないでください。</li>
				</ul>
				ユーザー名：<input type="text" id="smtp_auth_user" name="smtp_auth_user" value="%smtp_auth_user%" class="text inputlimit_ascii %smtp_auth_user_err%" style="width:200px" />　
				パスワード：<input type="password" id="smtp_auth_pass" name="smtp_auth_pass" value="%smtp_auth_pass%" class="text inputlimit_ascii %smtp_auth_pass_err%" style="width:200px" />
			</dd>
		</dl>
		<dl>
			<dt><label for="notice_to" class="%notice_to_err%">通知メール送信先アドレス</label></dt>
			<dd>
				<input type="text" id="notice_to" name="notice_to" value="%notice_to%" class="text inputlimit_ascii %notice_to_err%" />
				<ul class="note">
					<li>パスワードロックなどの通知をメールで受け取りたい場合は、メールアドレスを指定してください。</li>
				</ul>
			</dd>
		</dl>
		<dl>
			<dt><label for="notice_from" class="%notice_from_err%">通知メール差出人アドレス</label></dt>
			<dd>
				<input type="text" id="notice_from" name="notice_from" value="%notice_from%" class="text inputlimit_ascii %notice_from_err%" />
				<ul class="note">
					<li>通知メールの差出人となるメールアドレスを指定してください。</li>
					<li>指定がなければ送信先アドレスをセットします。</li>
				</ul>
			</dd>
		</dl>
		<dl class="last">
			<dt><label for="tz" class="%tz_err%">タイムゾーン</label></dt>
			<dd>
				<select name="tz" id="tz">
					<option value="">指定しない</option>
					<TMPL_LOOP NAME="tz_loop"><option value="%tz%" %selected%>%tz%</option></TMPL_LOOP>
				</select>
				<ul class="note">
					<li>日時がご利用の地域とずれているようであれば、タイムゾーンを指定してください。日本国内での利用であれば Asia/Tokyo または +0900 を選択してください。</li>
					<li>ご利用のサーバによってはタイムゾーンを選択することができない場合があります。その場合は、サーバOS側で適切なタイムゾーンを設定してください。</li>
				</ul>
			</dd>
		</dl>

	</fieldset>
	<div><input type="submit" value="設定" name="setBtn" class="submit" /></div>
</form>
</div>
</body>
</html>
