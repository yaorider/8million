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
#seq_fmt_tpl { width:20em; }
</style>
<script type="text/javascript" src="%static_url%/js/dom.js"></script>
<script type="text/javascript" src="%static_url%/js/form.js"></script>
<script type="text/javascript" src="%static_url%/js/inputlimit.js"></script>
<script type="text/javascript" src="%static_url%/js/admin/seqcnffrm.js"></script>
</head>
<body>
<h1><a href="%CGI_URL%?m=optcnfmnu">機能設定</a> &gt; 受付シリアル番号設定</h1>
<div id="main">
<p>フォームからの投稿ごとに受付シリアル番号を付与することができます。受付シリアル番号のフォーマット定義やシリアル番号のリセットを行うことができます。設定入力後、画面下の「設定」ボタンを押してください。 </p>
<TMPL_IF NAME="errs"><div class="errs">%errs%</div></TMPL_IF>
<form method="post" action="%CGI_URL%">
	<input type="hidden" name="m" value="seqcnfset" />
	<input type="hidden" name="pkey" value="%pkey%" />
	<fieldset>
		<legend>受付シリアル番号</legend>
		<dl>
			<dt><label class="required %seq_fmt_err%">受付シリアル番号のフォーマット</label></dt>
			<dd>
				<input type="radio" id="seq_fmt_1" name="seq_fmt" value="1" class="radio %seq_fmt_1_err%" %seq_fmt_1_checked% /> <label for="seq_fmt_1">連番 : 12345 (<code>&#x25;SEQ&#x25;</code>)</label><br />
				<input type="radio" id="seq_fmt_2" name="seq_fmt" value="2" class="radio %seq_fmt_2_err%" %seq_fmt_2_checked% /> <label for="seq_fmt_2">日ごとの連番 : 2009-08-29-12345 (<code>&#x25;Y&#x25;</code>-<code>&#x25;m&#x25;</code>-<code>&#x25;d&#x25;</code>-<code>&#x25;SEQD&#x25;</code>)</label><br />
				<input type="radio" id="seq_fmt_3" name="seq_fmt" value="3" class="radio %seq_fmt_3_err%" %seq_fmt_3_checked% /> <label for="seq_fmt_3">月ごとの連番 : 2009-08-12345 (<code>&#x25;Y&#x25;</code>-<code>&#x25;m&#x25;</code>-<code>&#x25;SEQM&#x25;</code>)</label><br />
				<input type="radio" id="seq_fmt_4" name="seq_fmt" value="4" class="radio %seq_fmt_4_err%" %seq_fmt_4_checked% /> <label for="seq_fmt_4">年ごとの連番 : 2009-12345 (<code>&#x25;Y&#x25;</code>-<code>&#x25;SEQY&#x25;</code>)</label><br />
				<input type="radio" id="seq_fmt_0" name="seq_fmt" value="0" class="radio %seq_fmt_0_err%" %seq_fmt_0_checked% /> <label for="seq_fmt_0">カスタム</label>
				：雛形 <input type="text" id="seq_fmt_tpl" name="seq_fmt_tpl" value="%seq_fmt_tpl%" class="text %seq_fmt_tpl_err%" />
				<ul class="note">
					<li>カスタムを選択すると、お好みのフォーマットを指定することができます。雛形の欄にフォーマットを指定してください。<code>&#x25;SEQ&#x25;</code> は連番、<code>&#x25;Y&#x25;</code> は西暦（4桁）、<code>&#x25;m&#x25;</code> は月（2桁）、<code>&#x25;d&#x25;</code> は日（2桁）を表します。</li>
					<li>連番に関しては、先頭に0を埋めて桁数（最大9桁）を統一することが可能です。たとえば 00123 のように5桁で固定とする場合は <code>&#x25;SEQ5&#x25;</code> と指定します。</li>
					<li>通常、連番は1から順に増え続けますが、日や月や年で自動的に1にリセットすることが可能です。日ごとに連番を発行する場合は <code>&#x25;SEQD&#x25;</code>、月ごとであれば <code>&#x25;SEQM&#x25;</code>、年ごとであれば <code>&#x25;SEQY&#x25;</code> と指定します。</li>
					<li>日や月や年で自動的に1にリセットする場合でも、先頭に0を埋めて桁数（最大9桁）を統一することが可能です。<code>&#x25;SEQD5&#x25;</code> と指定と指定すれば、日ごとに5桁固定で連番が生成されます。</li>
					<li>連番は9桁を超えるとリセットされます。</li>
				</ul>
			</dd>
		</dl>
		<dl class="last">
			<dt><label class="%seq_reset_err%">連番のリセット</label></dt>
			<dd>
				最終受付シリアル番号：%SERIAL%<br />
				<input type="checkbox" id="seq_reset_1" name="seq_reset" value="1" class="checkbox %seq_reset_1_err%" %seq_reset_1_checked% /> <label for="seq_reset_1">連番をリセットする</label><br />
				<ul class="note">
					<li>連番をリセットしたい場合はチェックボックスにチェックを入れてください。</li>
				</ul>
			</dd>
		</dl>
	</fieldset>
	<div><input type="submit" value="設定" name="setBtn" class="submit" /></div>
</form>
</div>
</body>
</html>
