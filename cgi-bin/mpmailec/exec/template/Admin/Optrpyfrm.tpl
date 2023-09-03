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
#rpy_cc { width: 400px; }
#rpy_bcc { width: 400px; }
#rpy_word_wrap { width: 5em; }
</style>
<script type="text/javascript" src="%static_url%/js/dom.js"></script>
<script type="text/javascript" src="%static_url%/js/form.js"></script>
<script type="text/javascript" src="%static_url%/js/inputlimit.js"></script>
<script type="text/javascript" src="%static_url%/js/admin/optrpyfrm.js"></script>
</head>
<body>
<h1><a href="%CGI_URL%?m=optcnfmnu">機能設定</a> &gt; 自動返信メール設定</h1>
<div id="main">
<p>フォームから送信されたら、自動的に返信する機能を定義します。設定入力後、画面下の「設定」ボタンを押してください。 </p>
<TMPL_IF NAME="errs"><div class="errs">%errs%</div></TMPL_IF>
<form method="post" action="%CGI_URL%">
	<input type="hidden" name="m" value="optrpyset" />
	<input type="hidden" name="pkey" value="%pkey%" />
	<fieldset>
		<dl class="last">
			<dt><label class="%rpy_enable_err%">自動返信メール送信</label></dt>
			<dd>
				<input type="checkbox" id="rpy_enable_1" name="rpy_enable" value="1" class="checkbox %rpy_enable_err%" %rpy_enable_1_checked% /> <label for="rpy_enable_1">自動返信メールを送信する</label>
				<ul class="note">
					<li>自動返信メールとは、フォームからメールを送信した後、送信者のメールアドレスに対して自動的にメールを返信する機能です。この機能を有効にするには &quot;自動返信メールを送信する&quot; にチェックを入れ、下に表示される設定を行ってください。</li>
				</ul>
			</dd>
		</dl>
	</fieldset>
	<div id="rpy_box">
	<fieldset>
		<legend>自動返信メール基本設定</legend>
		<dl>
			<dt><label for="rpy_item" class="required %rpy_item_err%">メールアドレス入力欄のフォーム項目</label></dt>
			<dd>
				<select name="rpy_item" id="rpy_item" class="select %rpy_item_err%">
					<option value="">-</option>
					<TMPL_LOOP NAME="item_loop"><option value="%name%" %selected%>%caption%（%name%）</option></TMPL_LOOP>
				</select>
				<ul class="note">
					<li>メールアドレス入力欄に相当するフォーム項目を選択してください。</li>
					<li>選択した項目に入力されたメールアドレス宛に自動返信メールが送信されます。</li>
				</ul>
			</dd>
		</dl>
		<dl>
			<dt><label for="rpy_from" class="required %rpy_from_err%">差出人メールアドレス</label></dt>
			<dd>
				<input type="text" id="rpy_from" name="rpy_from" value="%rpy_from%" class="text inputlimit_ascii %rpy_from_err%" />
				<ul class="note">
					<li>ここで設定するメールアドレスは、自動返信メールを受け取った人から見ると、差出人のメールアドレスになります。自動返信メールを受け取った人がメールソフトで返信すると、あて先がこのメールアドレスになりますので、お間違えのないように指定して下さい。決して存在しないメールアドレスを指定することがないようにご注意ください。</li>
				</ul>
			</dd>
		</dl>
		<dl>
			<dt><label for="rpy_sender" class="%rpy_sender_err%">差出人名</label></dt>
			<dd>
				<input type="text" id="rpy_sender" name="rpy_sender" value="%rpy_sender%" class="text %rpy_sender_err%" />
				<ul class="note">
					<li>ここで設定する差出人名は、自動返信メールを受け取った人から見ると、差出人の名前になります。個人でご利用の場合には、あなたのお名前やハンドル名を入れてください。法人でご利用の場合には、会社名などを入れてください。ここの設定は必須ではありませんが、メールを受け取った方から見ると、指定されていたほうが親切です。</li>
				</ul>
			</dd>
		</dl>
		<dl>
			<dt><label for="rpy_subject" class="required %rpy_subject_err%">サブジェクト（件名）</label></dt>
			<dd>
				<input type="text" id="rpy_subject" name="rpy_subject" value="%rpy_subject%" class="text %rpy_subject_err%" />
				<ul class="note">
					<li>自動返信メールのサブジェクト（題名）を指定してください。</li>
					<li>フォームに入力された値を埋め込むことが可能です。たとえば、このサブジェクトに <code>&quot;&#x25;item&#x25;のご注文ありがとうございました。&quot;</code> が設定されたとしましょう。識別キーが &quot;item&quot; のフォーム項目に &quot;商品A&quot; が入力されたとすると、実際のサブジェクトは、<code>&quot;商品Aのご注文ありがとうございました。&quot;</code> に変換されます。</li>
					<li>埋め込むことができる入力値は、フォームコントロールがテキスト入力フィールド、パスワード入力フィールド、ラジオボタン、セレクトメニュー（複数選択でない場合のみ）、非表示フィールドの項目のみです。それ以外の入力項目の識別キーを指定しても変換されませんのでご注意ください。</li>
				</ul>
			</dd>
		</dl>
		<dl>
			<dt><label for="rpy_cc" class="%rpy_cc_err% %rpy_bcc_err%">Cc/Bcc</label></dt>
			<dd>
				<table class="noborder" summary="">
					<tr>
						<td>Cc</td>
						<td>：</td>
						<td><input type="text" id="rpy_cc" name="rpy_cc" value="%rpy_cc%" class="text inputlimit_ascii %rpy_cc_err%" /></td>
					</tr>
					<tr>
						<td>Bcc</td>
						<td>：</td>
						<td><input type="text" id="rpy_bcc" name="rpy_bcc" value="%rpy_bcc%" class="text inputlimit_ascii %rpy_bcc_err%" /></td>
					</tr>
				</table>
				<ul class="note">
					<li>自動返信メールをCcやBccでも送信したい場合は、そのメールアドレスを入力してください。</li>
					<li>複数のメールアドレスを指定したい場合は、各メールアドレスを半角カンマで区切って入力してください。</li>
				</ul>
			</dd>
		</dl>
		<dl class="last">
			<dt><label for="rpy_error_to" class="%rpy_error_to_err%">エラーメール受信アドレス</label></dt>
			<dd>
				<input type="text" id="rpy_error_to" name="rpy_error_to" value="%rpy_error_to%" class="text inputlimit_ascii %rpy_error_to_err%" />
				<ul class="note">
					<li>自動返信メールを送信したにもかかわらず、入力されたメールアドレスが間違っていた場合、エラーメールが返ってきます。</li>
					<li>通常は、投稿メール設定の「投稿メール受信アドレス」にセットされたメールアドレス宛にエラーメールが送信されます。しかし、その受信アドレスを個別に指定したい場合は、ここで指定してください。</li>
				</ul>
			</dd>
		</dl>
	</fieldset>
	<fieldset>
		<legend>自動返信メール詳細設定</legend>
		<dl>
			<dt><label for="rpy_word_wrap" class="%rpy_word_wrap_err%">英文ワードラップ・禁則処理折返文字数</label></dt>
			<dd>
				<input type="text" id="rpy_word_wrap" name="rpy_word_wrap" value="%rpy_word_wrap%" class="text inputlimit_num %rpy_word_wrap_err%" /> 文字で折り返し
				<ul class="note">
					<li>投稿メールの英文ワードラップ・禁則処理を行います。指定文字数は50以上にしてください。50未満の場合には設定が無効となります。</li>
					<li>半角文字（英数字や半角カナ）、ラテン系欧州語でない文字（全角カナ、全角ひらがな、漢字など）は1文字を2文字としてカウントします。70文字程度で折り返すように設定することをお勧めします。</li>
					<li>ワードラップ機能は日本語またはラテン系欧州語を想定しております。それ以外の言語をご利用の場合は、正しくワードラップできない場合がありますので、ご注意ください。</li>
				</ul>
			</dd>
		</dl>
		<dl>
			<dt><label class="required %rpy_priority_err%">メール重要度</label></dt>
			<dd>
				<input type="radio" id="rpy_priority_1" name="rpy_priority" value="1" class="radio" %rpy_priority_1_checked% /> <label for="rpy_priority_1">高</label>　
				<input type="radio" id="rpy_priority_2" name="rpy_priority" value="2" class="radio" %rpy_priority_2_checked% /> <label for="rpy_priority_2">やや高</label>　
				<input type="radio" id="rpy_priority_3" name="rpy_priority" value="3" class="radio" %rpy_priority_3_checked% /> <label for="rpy_priority_3">通常</label>　
				<input type="radio" id="rpy_priority_4" name="rpy_priority" value="4" class="radio" %rpy_priority_4_checked% /> <label for="rpy_priority_4">やや低</label>　
				<input type="radio" id="rpy_priority_5" name="rpy_priority" value="5" class="radio" %rpy_priority_5_checked% /> <label for="rpy_priority_5">低</label>
				<ul class="note">
					<li>自動返信メールの重要度を選択してください。</li>
				</ul>
			</dd>
		</dl>
		<dl>
			<dt><label class="%rpy_notification_err%">開封確認メッセージの要求</label></dt>
			<dd>
				<input type="checkbox" id="rpy_notification_1" name="rpy_notification" value="1" class="checkbox" %rpy_notification_1_checked% /> <label for="rpy_notification_1">開封確認メッセージを要求する</label>　
				<ul class="note">
					<li>自動返信メールの開封確認メッセージを要求する場合は、チェックを入れてください。</li>
				</ul>
			</dd>
		</dl>
		<dl class="last">
			<dt><label class="%rpy_atc_reply_err%">添付ファイルの扱い</label></dt>
			<dd>
				<input type="checkbox" id="rpy_atc_reply_1" name="rpy_atc_reply" value="1" class="checkbox" %rpy_atc_reply_1_checked% /> <label for="rpy_atc_reply_1">添付されたファイルを返送する</label>　
				<ul class="note">
					<li>添付されたファイルを自動返信メールに添付したい場合にチェックを入れてください。</li>
				</ul>
			</dd>
		</dl>
	</fieldset>
	</div>
	<div><input type="submit" value="設定" name="setBtn" class="submit" /></div>
</form>
</div>
</body>
</html>
