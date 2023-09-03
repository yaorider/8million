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
#mai_word_wrap { width: 5em; }
#mai_from_default { width: 400px; }
#mai_cc { width: 400px; }
#mai_bcc { width: 400px; }
</style>
<script type="text/javascript" src="%static_url%/js/dom.js"></script>
<script type="text/javascript" src="%static_url%/js/form.js"></script>
<script type="text/javascript" src="%static_url%/js/inputlimit.js"></script>
</head>
<body>
<h1><a href="%CGI_URL%?m=optcnfmnu">機能設定</a> &gt; 投稿メール設定</h1>
<div id="main">
<p>フォームから投稿されたメールを受け取るメールアドレスなど、本システムが送信するメールに関する設定します。設定入力後、画面下の「設定」ボタンを押してください。 </p>
<TMPL_IF NAME="errs"><div class="errs">%errs%</div></TMPL_IF>
<form method="post" action="%CGI_URL%">
	<input type="hidden" name="m" value="optmaiset" />
	<input type="hidden" name="pkey" value="%pkey%" />
	<fieldset>
		<legend>投稿メール基本設定</legend>
		<dl>
			<dt><label for="mai_to" class="required %mai_to_err%">受信アドレス</label></dt>
			<dd>
				<input type="text" id="mai_to" name="mai_to" value="%mai_to%" class="text inputlimit_ascii %mai_to_err%" />
				<ul class="note">
					<li>投稿メールを受け取るメールアドレスを指定してください。</li>
					<li>複数のメールアドレスを指定したい場合は、各メールアドレスを半角カンマで区切って入力してください。</li>
				</ul>
			</dd>
		</dl>
		<dl>
			<dt><label for="mai_cc" class="%mai_cc_err% %mai_bcc_err%">Cc/Bcc</label></dt>
			<dd>
				<table class="noborder" summary="">
					<tr>
						<td>Cc</td>
						<td>：</td>
						<td><input type="text" id="mai_cc" name="mai_cc" value="%mai_cc%" class="text inputlimit_ascii %mai_cc_err%" /></td>
					</tr>
					<tr>
						<td>Bcc</td>
						<td>：</td>
						<td><input type="text" id="mai_bcc" name="mai_bcc" value="%mai_bcc%" class="text inputlimit_ascii %mai_bcc_err%" /></td>
					</tr>
				</table>
				<ul class="note">
					<li>投稿メールをCcやBccでも送信したい場合は、そのメールアドレスを入力してください。</li>
					<li>複数のメールアドレスを指定したい場合は、各メールアドレスを半角カンマで区切って入力してください。</li>
				</ul>
			</dd>
		</dl>
		<dl>
			<dt><label for="mai_from" class="required %mai_from_err% %mai_from_default_err%">差出人メールアドレス</label></dt>
			<dd>
				入力項目：<select name="mai_from" id="mai_from" class="select %mai_from_err%">
					<option value="">固定のメールアドレスを設定する</option>
					<TMPL_LOOP NAME="mai_from_item_loop"><option value="%name%" %selected%>%caption%（%name%）</option></TMPL_LOOP>
				</select>
				<ul class="note">
					<li>メールアドレス入力項目を選択してください。ここで選択された入力項目に入力された値が、投稿メールの差出人メールアドレスとなります。</li>
					<li>もしフォームにメールアドレス入力欄がない場合や、投稿メールの差出人メールアドレスを投稿者のメールアドレスとしたくない場合は、&quot;固定のメールアドレスを設定する&quot; を選択してください。</li>
				</ul>
				デフォルトのメールアドレス：<input type="text" id="mai_from_default" name="mai_from_default" value="%mai_from_default%" class="text %mai_from_default_err%" />
				<ul class="note">
					<li>メールアドレス入力項目が無い、またはメールアドレス入力欄に何も入力がなかった場合に適用する投稿メールの差出人メールアドレスを定義してください。</li>
				</ul>
			</dd>
		</dl>
		<dl>
			<dt><label for="mai_sender" class="%mai_sender_err%">差出人名</label></dt>
			<dd>
				<input type="text" id="mai_sender" name="mai_sender" value="%mai_sender%" class="text %mai_sender_err%" />
				<ul class="note">
					<li>フォームに入力された値を埋め込むことが可能です。たとえば、この差出人名に <code>&quot;&#x25;namae&#x25; 様&quot;</code> が設定されたとしましょう。識別キーが <code>&quot;namae&quot;</code> のフォーム項目に <code>&quot;山田太郎&quot;</code> が入力されたとすると、投稿メールの差出人名は <code>&quot;山田太郎 様&quot;</code> に変換されます。</li>
					<li>埋め込むことができる入力値は、フォームコントロールがテキスト入力フィールド、パスワード入力フィールド、ラジオボタン、セレクトメニュー（複数選択でない場合のみ）、非表示フィールドの項目のみです。それ以外の入力項目の識別キーを指定しても変換されませんのでご注意ください。</li>
				</ul>
			</dd>
		</dl>
		<dl class="last">
			<dt><label for="mai_subject" class="required %mai_subject_err%">サブジェクト（題名）</label></dt>
			<dd>
				<input type="text" id="mai_subject" name="mai_subject" value="%mai_subject%" class="text %mai_subject_err%" />
				<ul class="note">
					<li>フォームに入力された値を埋め込むことが可能です。たとえば、このサブジェクトに <code>&quot;注文通知 - &#x25;item&#x25;&quot;</code> が設定されたとしましょう。識別キーが &quot;item&quot; のフォーム項目に &quot;item&quot; に &quot;商品A&quot; が入力されたとすると、投稿メールのサブジェクトは <code>&quot;注文通知 - 商品A&quot;</code> に変換されます。</li>
					<li>埋め込むことができる入力値は、フォームコントロールがテキスト入力フィールド、パスワード入力フィールド、ラジオボタン、セレクトメニュー（複数選択でない場合のみ）、非表示フィールドの項目のみです。それ以外の入力項目の識別キーを指定しても変換されませんのでご注意ください。</li>
				</ul>
			</dd>
		</dl>
	</fieldset>
	<fieldset>
		<legend>投稿メール詳細設定</legend>
		<dl>
			<dt><label for="mai_word_wrap" class="%mai_word_wrap_err%">英文ワードラップ・禁則処理折返文字数</label></dt>
			<dd>
				<input type="text" id="mai_word_wrap" name="mai_word_wrap" value="%mai_word_wrap%" class="text inputlimit_num %mai_word_wrap_err%" /> 文字で折り返し
				<ul class="note">
					<li>投稿メールの英文ワードラップ・禁則処理を行います。指定文字数は50以上にしてください。50未満の場合には設定が無効となります。</li>
					<li>半角文字（英数字や半角カナ）、ラテン系欧州語でない文字（全角カナ、全角ひらがな、漢字など）は1文字を2文字としてカウントします。70文字程度で折り返すように設定することをお勧めします。</li>
					<li>ワードラップ機能は日本語またはラテン系欧州語を想定しております。それ以外の言語をご利用の場合は、正しくワードラップできない場合がありますので、ご注意ください。</li>
				</ul>
			</dd>
		</dl>
		<dl class="last">
			<dt><label for="mai_addon_headers" class="%mai_addon_headers_err%">追加メールヘッダー</label></dt>
			<dd>
				<textarea id="mai_addon_headers" name="mai_addon_headers" rows="3" cols="80" class="inputlimit_ascii %mai_addon_headers_err%">%mai_addon_headers%</textarea>
				<ul class="note">
					<li>投稿メールのメールヘッダーを任意に追加することが可能です。</li>
					<li>必ず、<code>xxxx: xxxxxx</code> という形式で記述してください。また、全角文字や特殊記号が入ると、正しくメールが送信されなくなったり、受け取ったメールソフトで予期せぬ動作をする可能性がありますのでご注意ください。ある程度メールヘッダーに詳しい方のみ設定してください。</li>
					<li>複数指定する場合には、改行を入れて記述してください。</li>
				</ul>
			</dd>
		</dl>
	</fieldset>
	<div><input type="submit" value="設定" name="setBtn" class="submit" /></div>
</form>
</div>
</body>
</html>
