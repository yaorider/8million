<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="ja" lang="ja">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta http-equiv="Content-Language" content="ja" />
<meta http-equiv="Content-Style-Type" content="text/css" />
<meta http-equiv="Content-Script-Type" content="text/javascript" />
<title>%product_name% Ver %product_version%</title>
<link href="%static_url%/css/admin/common.css" type="text/css" rel="stylesheet" />
<link href="%static_url%/js/dialog/dialog.css" type="text/css" rel="stylesheet" />
<script type="text/javascript" src="%static_url%/js/dom.js"></script>
<script type="text/javascript" src="%static_url%/js/dialog/dialog.js"></script>
<script type="text/javascript" src="%static_url%/js/form.js"></script>
<script type="text/javascript" src="%static_url%/js/deco/table.js"></script>
<script type="text/javascript" src="%static_url%/js/admin/chkalllst.js"></script>
</head>
<body>
<h1><a href="%CGI_URL%?m=optcnfmnu">機能設定</a> &gt; 再入力設定</h1>
<div id="main">
<p>再入力設定とは、入力ミスを防ぐため、2回入力させ、その入力値が一致しているかをチェックする機能を定義するものです。おもにメールアドレスやパスワード入力欄に活用します。</p>
<form method="post" action="%CGI_URL%">
	<input type="hidden" name="m" value="chkaddset" />
	<input type="hidden" name="pkey" value="%pkey%" />
	<fieldset>
		<legend>新規登録</legend>
		<p>対象となるフォーム項目を選択して「登録」ボタンを押してください。選択可能なフォーム項目はテキスト入力フィールドおよびパスワード入力フィールドのみです。</p>
		<TMPL_IF NAME="errs"><div class="errs">%errs%</div></TMPL_IF>
		<select name="item_1" id="item_1">
			<option value="">&nbsp;</option>
			<TMPL_LOOP NAME="item_1_loop"><option value="%name%" %selected%>%caption%（%name%）</option></TMPL_LOOP>
		</select>
		<select name="item_2" id="item_2">
			<option value="">&nbsp;</option>
			<TMPL_LOOP NAME="item_2_loop"><option value="%name%" %selected%>%caption%（%name%）</option></TMPL_LOOP>
		</select>
		<input type="submit" value="登録" name="setBtn" class="submit" />
	</fieldset>
</form>
<TMPL_IF NAME="chk_loop">
<h2>登録一覧</h2>
<table id="listtbl" class="tbl2 tbldeco" summary="登録一覧">
	<thead>
		<tr>
			<td>項目1</td>
			<td>項目2</td>
			<td>削除</td>
		</tr>
	</thead>
	<tbody>
		<TMPL_LOOP NAME="chk_loop">
		<tr>
			<td>%caption_1%（%name_1%）</td>
			<td>%caption_2%（%name_2%）</td>
			<td><a href="%CGI_URL%?m=chkdelset&amp;no=%no%" class="del_link"><img src="%static_url%/imgs/ico_del_20.png" width="20" height="20" alt="削除" /></a></td>
		</tr>
		</TMPL_LOOP>
	</tbody>
</table>
</TMPL_IF>
</div>
</body>
</html>
