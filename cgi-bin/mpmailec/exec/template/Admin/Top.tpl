<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="ja" lang="ja">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta http-equiv="Content-Language" content="ja" />
<meta http-equiv="Content-Style-Type" content="text/css" />
<meta http-equiv="Content-Script-Type" content="text/javascript" />
<title>%product_name% Ver %product_version%</title>
<link href="%static_url%/css/admin/common.css" type="text/css" rel="stylesheet" />
</head>
<body>
<h1>%product_name% - システム管理者メニュー </h1>
<div id="main">
<h2>前回ログオン情報</h2>
<table class="tbl1" summary="前回ログオン情報">
	<tr>
		<th>日時</th>
		<td><TMPL_IF NAME="last_logon_tm">%last_logon_tm_0%-%last_logon_tm_1%-%last_logon_tm_2% %last_logon_tm_3%:%last_logon_tm_4%:%last_logon_tm_5% %last_logon_tm_8%<TMPL_IF NAME="last_logon_tm_9"> %last_logon_tm_9%</TMPL_IF><TMPL_IF NAME="last_logon_tm_7">（夏時間）</TMPL_IF><TMPL_ELSE>-</TMPL_IF></td>
	</tr>
	<tr>
		<th>IPアドレス</th>
		<td><TMPL_IF NAME="last_logon_ip">%last_logon_ip%<TMPL_ELSE>-</TMPL_IF></td>
	</tr>
	<tr>
		<th>User-Agent</th>
		<td><TMPL_IF NAME="last_logon_ip">%last_logon_ua%<TMPL_ELSE>-</TMPL_IF></td>
	</tr>
</table>
<TMPL_IF NAME="copyright_flag">
<h2>%copyright_caption% からのお知らせ</h2>
<iframe src="%product_info_url%" class="infoframe" frameborder="0"></iframe>
</TMPL_IF>
</div>
</body>
</html>
