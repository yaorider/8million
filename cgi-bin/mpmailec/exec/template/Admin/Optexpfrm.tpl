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
<h1><a href="%CGI_URL%?m=optcnfmnu">機能設定</a> &gt; 設定エクスポート</h1>
<div id="main">
<p>本システムの設定情報をバックアップ用にダウンロードします。「ダウンロード」ボタンを押してください。 </p>
<p>ダウンロードするデータは、画面テンプレート、機能設定、システム設定のデータです。管理メニューの管理者IDとパスワード、ログ出力設定、および蓄積されたログデータについては対象外となります。</p>
<p>ダウンロードされたデータファイルは、決してテキストエディタなどを使って編集しないでください。少しでも編集されたデータはインポートできませんのでご注意ください。</p>
<TMPL_IF NAME="errs"><div class="errs">%errs%</div></TMPL_IF>
<form method="post" action="%CGI_URL%">
	<input type="hidden" name="m" value="optexpset" />
	<input type="hidden" name="pkey" value="%pkey%" />
	<p><input type="submit" value="ダウンロード" name="setBtn" class="submit" /></p>
</form>
</div>
</body>
</html>
