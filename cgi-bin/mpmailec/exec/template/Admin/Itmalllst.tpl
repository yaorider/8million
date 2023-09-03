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
<style type="text/css">
input.dummytbox { width: 170px; }
input.dummyfbox { width: 170px; }
textarea.dummy { width: 170px; height: 30px; }
select.dummy { width: 170px; }
</style>
<script type="text/javascript" src="%static_url%/js/dom.js"></script>
<script type="text/javascript" src="%static_url%/js/dialog/dialog.js"></script>
<script type="text/javascript" src="%static_url%/js/admin/itmalllst.js"></script>
<script type="text/javascript" src="%static_url%/js/deco/table.js"></script>

</head>
<body>
<h1><a href="%CGI_URL%?m=optcnfmnu">機能設定</a> &gt; フォーム項目設定</h1>
<div id="main">
<h2>フォーム項目一覧</h2>
<div><a href="%CGI_URL%?m=itmaddfrm"><img src="%static_url%/imgs/ico_add_20.png" alt="項目を新規に登録する" width="20" height="20" /></a> <a href="%CGI_URL%?m=itmaddfrm">項目を新規に登録する</a></div>
<form method="post" action="%CGI_URL%" id="delform">
	<input type="hidden" name="m" value="itmdelset" />
	<input type="hidden" name="pkey" value="%pkey%" />
	<table class="tbl2 tbldeco" summary="フォーム項目一覧">
		<thead>
			<tr>
				<td>&nbsp;</td>
				<td>識別キー</td>
				<td>項目名</td>
				<td>コントロール種別</td>
				<td>表示順</td>
				<td>編集</td>
				<td>削除</td>
			</tr>
		</thead>
		<tbody>
			<TMPL_LOOP NAME="ITEM_LOOP">
			<tr>
				<td><TMPL_IF NAME="deletable"><input type="checkbox" name="name" value="%name%" /><TMPL_ELSE>&nbsp;</TMPL_IF></td>
				<td>%name%</td>
				<td>%caption%</td>
				<td>
					<TMPL_IF NAME="type_1"><input type="text" name="dummy_%offset%" value="" class="text dummytbox" disabled="disabled" /></TMPL_IF>
					<TMPL_IF NAME="type_2"><input type="password" name="dummy_%offset%" value="dummy" class="text dummytbox" disabled="disabled" /></TMPL_IF>
					<TMPL_IF NAME="type_3"><input type="radio" name="dummy_%offset%" value="dummy" class="radio dummy" disabled="disabled" checked="checked" /> %element%</TMPL_IF>
					<TMPL_IF NAME="type_4"><input type="checkbox" name="dummy_%offset%" value="dummy" class="checkbox dummy" disabled="disabled" checked="checked" /> %element%</TMPL_IF>
					<TMPL_IF NAME="type_5"><select name="dummy_%offset%" class="dummy select" disabled="disabled"><option value="%element%">%element%</option></select></TMPL_IF>
					<TMPL_IF NAME="type_6"><textarea name="dummy_%offset%" class="dummy textarea" cols="3" rows="3" disabled="disabled"></textarea></TMPL_IF>
					<TMPL_IF NAME="type_7"><input type="file" name="dummy_%offset%" class="file dummyfbox" disabled="disabled" /></TMPL_IF>
					<TMPL_IF NAME="type_8">非表示フィールド</TMPL_IF>
				</td>
				<td>
					<TMPL_IF NAME="offset_up"><a href="%CGI_URL%?m=itmoftchg&amp;name=%name_urlenc%&amp;offset=%offset_up%" class="fancy_button_link"><img src="%static_url%/imgs/ico_up_20.png" width="20" height="20" alt="上へ" /></a><TMPL_ELSE><img src="%static_url%/imgs/ico_up_disabled_20.png" width="20" height="20" alt="移動できません" /></TMPL_IF>
					<TMPL_IF NAME="offset_dn"><a href="%CGI_URL%?m=itmoftchg&amp;name=%name_urlenc%&amp;offset=%offset_dn%" class="fancy_button_link"><img src="%static_url%/imgs/ico_dn_20.png" width="20" height="20" alt="下へ" /></a><TMPL_ELSE><img src="%static_url%/imgs/ico_dn_disabled_20.png" width="20" height="20" alt="移動できません" /></TMPL_IF>
				</td>
				<td><a href="%CGI_URL%?m=itmmodfrm&amp;name=%name_urlenc%" class="mod_link"><img src="%static_url%/imgs/ico_edt_20.png" width="20" height="20" alt="編集" /></a></td>
				<td><TMPL_IF NAME="deletable"><a href="%CGI_URL%?m=itmdelset&amp;name=%name_urlenc%" class="del_link"><img src="%static_url%/imgs/ico_del_20.png" width="20" height="20" alt="削除" /></a><TMPL_ELSE>&nbsp;</TMPL_IF></td>
			</tr>
			</TMPL_LOOP>
		</tbody>
	</table>
	<p><input type="submit" name="delBtn" value="チェックした項目をまとめて削除する" /></p>
</form>
</div>
</body>
</html>
