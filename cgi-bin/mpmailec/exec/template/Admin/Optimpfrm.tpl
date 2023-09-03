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
</head>
<body>
<h1><a href="%CGI_URL%?m=optcnfmnu">機能設定</a> &gt; 設定インポート</h1>
<div id="main">
<p>エクスポートした設定情報を本システムにロードします。エクスポートファイルを選択の上、「インポート」ボタンを押してください。</p>
<p>エクスポートファイルは、決してテキストエディタなどを使って編集しないでください。少しでも編集されたデータはインポートできませんのでご注意ください。</p>
<TMPL_IF NAME="errs"><div class="errs">%errs%</div></TMPL_IF>
<form method="post" action="%CGI_URL%" enctype="multipart/form-data">
	<input type="hidden" name="m" value="optimpset" />
	<input type="hidden" name="pkey" value="%pkey%" />
	<fieldset>
		<legend>設定インポート</legend>
		<dl class="last">
			<dt><label class="required %export_file_err%">エクスポートファイル</label></dt>
			<dd><input type="file" name="export_file" id="export_file" class="text" /></dd>
		</dl>
	</fieldset>
	<div><input type="submit" value="インポート" name="setBtn" class="submit" /></div>
</form>
</div>
</body>
</html>
