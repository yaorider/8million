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
<script type="text/javascript" src="%static_url%/js/admin/tpledtfrm.js"></script>
</head>
<body>
<h1><a href="%CGI_URL%?m=tpllstmnu">画面テンプレート</a> - %title1%<TMPL_IF NAME="title2"> - %title2%</TMPL_IF><TMPL_IF NAME="title3"> - %title3%</TMPL_IF></h1>
<div id="main">
<form method="post" action="%CGI_URL%">
	<input type="hidden" name="m" value="tpledtset" />
	<input type="hidden" name="tid" value="%tid%" />
	<input type="hidden" name="pkey" value="%pkey%" />
	<fieldset>
		<legend>デフォルトテンプレートのロード</legend>
		<dl class="last">
			<dd>
				<p>テンプレートが設定されていない場合は、事前にデフォルトのテンプレートをロードして編集してください。</p>
				<input type="radio" name="tpltype" id="tpltype_1" value="1" /> <label for="tpltype_1">簡単モード</label>　
				<input type="radio" name="tpltype" id="tpltype_2" value="2" /> <label for="tpltype_2">エキスパートモード</label>　
				<input type="button" name="loadBtn" id="loadBtn" value="ロード" />
				<ul class="note">
					<li>簡単モードでロードしたテンプレートは、細かいデザインカスタマイズができない反面、フォーム項目などあらゆる設定変更が自動的に反映され出力されます。主にヘッダー部やフッター部のみを編集するのみであれば、このモードが便利です。</li>
					<li>エキスパートモードでロードするテンプレートは、フォーム項目などあらゆる設定を反映した静的なHTMLです。すべての内容を個別にデザインをカスタマイズできる反面、一度セットしてしまうと、フォーム項目などの設定変更が反映されませんので、これらの設定を変更する都度、このテンプレートもそれにあわせて変更しなければいけません。</li>
				</ul>
			</dd>
		</dl>
	</fieldset>
	<fieldset>
		<legend>%title1%<TMPL_IF NAME="title2"> - %title2%</TMPL_IF><TMPL_IF NAME="title3"> - %title3%</TMPL_IF></legend>
		<table class="noborder" summary="ドキュメント情報">
			<tr>
				<td>言語</td>
				<td>：</td>
				<td>%lang%</td>
			</tr>
			<tr>
				<td>ドキュメントタイプ</td>
				<td>：</td>
				<td>%doctype%</td>
			</tr>
			<tr>
				<td>コンテントタイプ</td>
				<td>：</td>
				<td>%ctype%</td>
			</tr>
		</table>
		<TMPL_IF NAME="errs"><div class="errs">%errs%</div></TMPL_IF>
		<textarea name="tpl" id="tpl" cols="80" rows="30">%tpl%</textarea>
	</fieldset>
	<div><input type="button" value="プレビュー" name="previewBtn" id="previewBtn" class="submit" />　<input type="submit" value="設定" name="setBtn" class="submit" /></div>
</form>
</div>
</body>
</html>
