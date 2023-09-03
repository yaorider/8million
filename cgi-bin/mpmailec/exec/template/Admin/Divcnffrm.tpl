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
<script type="text/javascript" src="%static_url%/js/admin/divcnffrm.js"></script>
</head>
<body>
<h1><a href="%CGI_URL%?m=optcnfmnu">機能設定</a> &gt; メール送信先振り分け設定</h1>
<div id="main">
<p>フォーム項目で選択された内容に応じて、メール送信先を振り分けることができます。</p>
<p>振り分けもととして選択可能なフォーム項目はラジオボタン、チェックボックス、セレクトメニューのみです。チェックボックスとセレクトメニューで複数の要素が選択された場合は、すべての宛先にメールが送信されます。</p>
<form method="post" action="%CGI_URL%">
	<input type="hidden" name="m" value="divcnffrm" />
	<input type="hidden" name="pkey" value="%pkey%" />
	<fieldset>
		<legend>振り分けもとのフォーム項目</legend>
		<TMPL_IF NAME="settedname">
			<p>設定されている内容を削除、もしくは振り分けもとのフォーム項目を変更したい場合は、「設定解除」ボタンを押してください。</p>
		<TMPL_ELSE>
			<p>対象となるフォーム項目を選択して「決定」ボタンを押してください。</p>
		</TMPL_IF>
		<select name="name" id="name"<TMPL_IF NAME="settedname"> disabled="disabled"</TMPL_IF>>
			<option value="">-</option>
			<TMPL_LOOP NAME="item_loop"><option value="%name%" %selected%>%caption%（%name%）</option></TMPL_LOOP>
		</select>
		<TMPL_IF NAME="settedname">
			<input type="button" value="設定解除" name="delBtn" id="delBtn" class="submit" />
		<TMPL_ELSE>
			<input type="submit" value="決定" name="setBtn" class="submit" />
		</TMPL_IF>
	</fieldset>
</form>
<TMPL_IF NAME="div_loop">
<h2>振り分け先</h2>
<p>選択要素ごとに、送信先メールアドレスを入力して「設定」ボタンを押してください。もし指定がなければ、「メール設定」の「投稿メール受信アドレス」宛てにメールが送信されます。</p>
<form method="post" action="%CGI_URL%">
	<input type="hidden" name="m" value="divcnfset" />
	<input type="hidden" name="pkey" value="%pkey%" />
	<input type="hidden" name="name" value="%name%" />
	<fieldset>
		<legend>「%caption%（%name%）」による振り分け先</legend>
		<TMPL_IF NAME="errs"><div class="errs">%errs%</div></TMPL_IF>
		<table class="tbl2" style="margin-top:1em;" summary="「%caption%（%name%）」による振り分け先">
			<thead>
				<tr>
					<td style="width:30%;">選択項目</td>
					<td style="width:68%;">送信先メールアドレス</td>
				</tr>
			</thead>
			<tbody>
				<tr>
					<td>デフォルトの宛先</td>
					<td>
						<table class="noborder" summary="デフォルトの宛先">
							<tr>
								<td style="width:6%;">To</td>
								<td style="width:2%;">:</td>
								<td style="width:90%;">%mai_to%</td>
							</tr>
							<tr>
								<td>Cc</td>
								<td>:</td>
								<td>%mai_cc%</td>
							</tr>
							<tr>
								<td>Bcc</td>
								<td>:</td>
								<td>%mai_bcc%</td>
							</tr>
						</table>
					</td>
				</tr>
				<TMPL_LOOP NAME="div_loop">
				<tr>
					<td>%element%</td>
					<td>
						<table class="noborder" summary="「%element%」が選択された場合の宛先">
							<tr>
								<td style="width:6%;">To</td>
								<td style="width:2%;">:</td>
								<td style="width:90%;"><input type="text" id="mai_to_%no%" name="mai_to_%no%" value="%mai_to%" class="text inputlimit_ascii %mai_to_err%" /></td>
							</tr>
							<tr>
								<td>Cc</td>
								<td>:</td>
								<td><input type="text" id="mai_cc_%no%" name="mai_cc_%no%" value="%mai_cc%" class="text inputlimit_ascii %mai_cc_err%" /></td>
							</tr>
							<tr>
								<td>Bcc</td>
								<td>:</td>
								<td><input type="text" id="mai_bcc_%no%" name="mai_bcc_%no%" value="%mai_bcc%" class="text inputlimit_ascii %mai_bcc_err%" /></td>
							</tr>
						</table>
					</td>
				</tr>
				</TMPL_LOOP>
			</tbody>
		</table>
		<div><input type="submit" value="設定" name="setBtn" class="submit" /></div>
	</fieldset>
</form>
</TMPL_IF>
</div>
</body>
</html>
