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
			<td>%rpy_subject%</td>
		</tr>
		<tr>
			<td>From</td>
			<td>：</td>
			<td><TMPL_IF NAME="rpy_sender">%rpy_sender% &lt;%rpy_from%&gt;<TMPL_ELSE>%rpy_from%</TMPL_IF></td>
		</tr>
		<tr>
			<td>To</td>
			<td>：</td>
			<td>%rpy_item%</td>
		</tr>
		<TMPL_IF NAME="rpy_cc">
		<tr>
			<td>Cc</td>
			<td>：</td>
			<td>%rpy_cc%</td>
		</tr>
		</TMPL_IF>
		<TMPL_IF NAME="rpy_bcc">
		<tr>
			<td>Bcc</td>
			<td>：</td>
			<td>%rpy_bcc%</td>
		</tr>
		</TMPL_IF>
		<tr>
			<td>X-Priority</td>
			<td>：</td>
			<td>
				%rpy_priority%
				<TMPL_IF NAME="rpy_priority_1">（高）</TMPL_IF>
				<TMPL_IF NAME="rpy_priority_2">（やや高）</TMPL_IF>
				<TMPL_IF NAME="rpy_priority_3">（通常）</TMPL_IF>
				<TMPL_IF NAME="rpy_priority_4">（やや低）</TMPL_IF>
				<TMPL_IF NAME="rpy_priority_5">（低）</TMPL_IF>
			</td>
		</tr>
		<TMPL_IF NAME="rpy_notification">
		<tr>
			<td>Disposition-Notification-To</td>
			<td>：</td>
			<td>%rpy_from%</td>
		</tr>
		</TMPL_IF>
	</table>
</div>
<div id="mailbody">%body%</div>
</body>
</html>
