<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="ja" lang="ja">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta http-equiv="Content-Language" content="ja" />
<meta http-equiv="Content-Style-Type" content="text/css" />
<meta http-equiv="Content-Script-Type" content="text/javascript" />
<title>%product_name% Ver %product_version%</title>
<link href="./static/css/admin/tplmaipvw.css" type="text/css" rel="stylesheet" />
</head>
<body>
<div id="headers">
	<table summary="メールヘッダー">
		<tr>
			<td>Subject</td>
			<td>：</td>
			<td>%mai_subject%</td>
		</tr>
		<tr>
			<td>From</td>
			<td>：</td>
			<td><TMPL_IF NAME="mai_sender">%mai_sender% &lt;%mai_from%&gt;<TMPL_ELSE>%mai_from%</TMPL_IF></td>
		</tr>
		<tr>
			<td>To</td>
			<td>：</td>
			<td>%mai_to%</td>
		</tr>
		<TMPL_IF NAME="mai_cc">
		<tr>
			<td>Cc</td>
			<td>：</td>
			<td>%mai_cc%</td>
		</tr>
		</TMPL_IF>
		<TMPL_IF NAME="mai_bcc">
		<tr>
			<td>Bcc</td>
			<td>：</td>
			<td>%mai_bcc%</td>
		</tr>
		</TMPL_IF>
		<TMPL_IF NAME="mai_addon_headers">
		<TMPL_LOOP NAME="mai_addon_headers_loop">
		<tr>
			<td>%key%</td>
			<td>：</td>
			<td>%value%</td>
		</tr>
		</TMPL_LOOP>
		</TMPL_IF>
	</table>
</div>
<div id="mailbody">%body%</div>
</body>
</html>
