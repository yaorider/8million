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
<script type="text/javascript" src="%static_url%/js/expandrow.js"></script>
<script type="text/javascript" src="%static_url%/js/admin/logadmmnu.js"></script>
<!-- dialog js start -->
<link href="%static_url%/js/dialog/dialog.css" type="text/css" rel="stylesheet" />
<script type="text/javascript" src="%static_url%/js/dialog/dialog.js"></script>
<!-- dialog js end -->
<style type="text/css">
tr.expand-row {
	background-color: #efefef;
}
table.detail-table {
	margin: 0em 2em 0em 2em;
	border-collapse: collapse;
}
table.detail-table tr td {
	font-size: 90%;
	padding: 0.3em;
	vertical-align: top;
	border: 0;
	border-bottom: 1px solid #aaaaaa;
}
table.detail-table tr th {
	font-size: 90%;
	padding: 0.3em;
	vertical-align: top;
	border: 0;
	border-bottom: 1px solid #aaaaaa;
	font-weight: normal;
	white-space: nowrap;
}
table.detail-table tr {
	background-color: #f3f3f3;
}
table.detail-table tr.info {
	background-color: #dddddd;
}
div.page_navi {
	text-align: center;
}
div.page_navi span.current {
	font-weight: bold;
}
#log_download_rc_replace {
	width: 5em;
}
label.item-orig {
	color: #777777;
}
label.item-user {
	color: #000000;
}
talbe.date-range-tbl td {
	vertical-align: middle;
}
</style>
</head>
<body>
<h1>ログ管理</h1>
<div id="main">
<h2>絞り込み</h2>
<form action="" method="post">
	<input type="hidden" name="m" value="logadmmnu" />
	<table class="noborder date-range-tbl" summary="絞り込み検索">
		<tr>
			<td>日付の範囲</td>
			<td>：</td>
			<td>
				<select name="sdatey" id="sdatey"><TMPL_LOOP NAME="sdatey_loop"><option value="%sdatey%" %selected%>%sdatey%</option></TMPL_LOOP></select> 年 
				<select name="sdatem" id="sdatem"><TMPL_LOOP NAME="sdatem_loop"><option value="%sdatem%" %selected%>%sdatem%</option></TMPL_LOOP></select> 月 
				<select name="sdated" id="sdated"><TMPL_LOOP NAME="sdated_loop"><option value="%sdated%" %selected%>%sdated%</option></TMPL_LOOP></select> 日 
				～
				<select name="edatey" id="edatey"><TMPL_LOOP NAME="edatey_loop"><option value="%edatey%" %selected%>%edatey%</option></TMPL_LOOP></select> 年 
				<select name="edatem" id="edatem"><TMPL_LOOP NAME="edatem_loop"><option value="%edatem%" %selected%>%edatem%</option></TMPL_LOOP></select> 月 
				<select name="edated" id="edated"><TMPL_LOOP NAME="edated_loop"><option value="%edated%" %selected%>%edated%</option></TMPL_LOOP></select> 日 
			</td>
			<td>
				<input type="submit" id="searchbtn" name="searchbtn" value="検索" class="submit" />
			</td>
		</tr>
	</table>
</form>
<h2>ログ一覧</h2>
<div class="page_navi">
	<p>%total%件中、%hit%件がヒットしました。%start%～%end%件目の%fetch%件を表示しています。</p>
	<TMPL_IF NAME="hit">
	<div class="navi">
		<span class="prev"><TMPL_IF NAME="prev_url"><a href="%prev_url%" class="prev">&lt; 前の%prev_num%件へ</a><TMPL_ELSE>&nbsp;</TMPL_IF></span>
		| <span class="page"><TMPL_LOOP NAME="page_loop"><TMPL_IF NAME="current"><span class="current">%page%</span><TMPL_ELSE><a href="%url%">%page%</a></TMPL_IF><TMPL_UNLESS NAME="__last__"> | </TMPL_UNLESS></TMPL_LOOP></span> |
		<span class="next"><TMPL_IF NAME="next_url"><a href="%next_url%" class="next">次の%next_num%件へ &gt;</a><TMPL_ELSE>&nbsp;</TMPL_IF></span>
	</div>
	</TMPL_IF>
</div>
<TMPL_IF NAME="hit">
<form method="post" action="%CGI_URL%" id="delform">
	<input type="hidden" name="m" value="logdelset" />
	<input type="hidden" name="pkey" value="%pkey%" />
	<table class="tbl2 tbldeco" summary="ログ一覧">
		<thead>
			<tr>
				<td>&nbsp;</td>
				<td>受付シリアル番号</td>
				<td>受付日時</td>
				<td>削除</td>
			</tr>
		</thead>
		<tbody>
			<TMPL_LOOP NAME="LOG_LOOP">
			<tr id="expand-row-%RECEPTION_DATE_YYYYMMDD%_%SEQ%" class="expand-row">
				<td><input type="checkbox" name="target" value="%RECEPTION_DATE_YYYYMMDD%_%SEQ%" /></td>
				<td><span id="serial_%SEQ%">%SERIAL%</span></td>
				<td>%RECEPTION_DATE_Y%-%RECEPTION_DATE_m%-%RECEPTION_DATE_d% %RECEPTION_DATE_H%:%RECEPTION_DATE_i%:%RECEPTION_DATE_s% %RECEPTION_DATE_O%<TMPL_IF NAME="RECEPTION_DATE_e"> %RECEPTION_DATE_e%</TMPL_IF><TMPL_IF NAME="RECEPTION_DATE_I">（夏時間）</TMPL_IF></td>
				<td><a href="%CGI_URL%?m=logdelset&amp;target=%RECEPTION_DATE_YYYYMMDD%_%SEQ%" class="del_link"><img src="%static_url%/imgs/ico_del_20.png" width="20" height="20" alt="削除" /></a></td>
			</tr>
			<tr id="detail-row-%RECEPTION_DATE_YYYYMMDD%_%SEQ%" class="detail-box" style="display:none">
				<td colspan="4">
					<table class="detail-table" summary="ログ詳細">
						<tr class="info">
							<th>受付シリアル番号</th>
							<td>：</td>
							<td>%SERIAL%</td>
						</tr>
						<tr class="info">
							<th>受付日時</th>
							<td>：</td>
							<td>%RECEPTION_DATE_Y%-%RECEPTION_DATE_m%-%RECEPTION_DATE_d% %RECEPTION_DATE_H%:%RECEPTION_DATE_i%:%RECEPTION_DATE_s% %RECEPTION_DATE_O%<TMPL_IF NAME="RECEPTION_DATE_e"> %RECEPTION_DATE_e%</TMPL_IF><TMPL_IF NAME="RECEPTION_DATE_I">（夏時間）</TMPL_IF></td>
						</tr>
						<TMPL_LOOP NAME="item_loop">
						<tr>
							<th>%caption%</th>
							<td>：</td>
							<td>
								<TMPL_IF NAME="type_7">
									<TMPL_IF NAME="filename">%filename% (%size_with_comma% byte)<TMPL_IF NAME="file_saved"> [<a href="%CGI_URL%?m=logatcdwn&amp;target=%RECEPTION_DATE_YYYYMMDD%_%SEQ%&amp;name=%name%">ダウンロード</a>]</TMPL_IF></TMPL_IF>
								<TMPL_ELSE>
									<TMPL_LOOP NAME="element_loop"><div>%element%</div></TMPL_LOOP>
								</TMPL_IF>
							</td>
						</tr>
						</TMPL_LOOP>
						<tr class="info">
							<th>User-Agent</th>
							<td>：</td>
							<td>%HTTP_USER_AGENT%</td>
						</tr>
						<tr class="info">
							<th>REMOTE_HOST</th>
							<td>：</td>
							<td>%REMOTE_HOST%</td>
						</tr>
						<tr class="info">
							<th>REMOTE_ADDR</th>
							<td>：</td>
							<td>%REMOTE_ADDR%</td>
						</tr>
					</table>
				</td>
			</tr>
			</TMPL_LOOP>
		</tbody>
	</table>
	<div class="page_navi">
		<TMPL_IF NAME="hit">
		<div class="navi">
			<span class="prev"><TMPL_IF NAME="prev_url"><a href="%prev_url%" class="prev">&lt; 前の%prev_num%件へ</a><TMPL_ELSE>&nbsp;</TMPL_IF></span>
			| <span class="page"><TMPL_LOOP NAME="page_loop"><TMPL_IF NAME="current"><span class="current">%page%</span><TMPL_ELSE><a href="%url%">%page%</a></TMPL_IF><TMPL_UNLESS NAME="__last__"> | </TMPL_UNLESS></TMPL_LOOP></span> |
			<span class="next"><TMPL_IF NAME="next_url"><a href="%next_url%" class="next">次の%next_num%件へ &gt;</a><TMPL_ELSE>&nbsp;</TMPL_IF></span>
		</div>
	</TMPL_IF>
	</div>
	<p><input type="submit" name="delBtn" value="チェックした項目をまとめて削除する" class="submit" /></p>
</form>
<h2>ログダウンロード</h2>
<p>%sdatey%-%sdatem%-%sdated%～%edatey%-%edatem%-%edated%の%hit%件のログをダウンロードします。ダウンロードオプションを選択の上、「ダウンロードボタン」を押してください。</p>
<form method="post" action="%CGI_URL%">
	<input type="hidden" name="m" value="logdwnsmt" />
	<input type="hidden" name="sdatey" value="%sdatey%" />
	<input type="hidden" name="sdatem" value="%sdatem%" />
	<input type="hidden" name="sdated" value="%sdated%" />
	<input type="hidden" name="edatey" value="%edatey%" />
	<input type="hidden" name="edatem" value="%edatem%" />
	<input type="hidden" name="edated" value="%edated%" />
	<fieldset id="log_box">
		<legend>ダウンロードオプション</legend>
		<dl>
			<dt>カラムの区切り文字</dt>
			<dd>
				<select name="log_download_delimiter" id="log_download_delimiter" class="select">
					<option value="1" %log_download_delimiter_1_selected%>カンマ区切り (CSV)</option>
					<option value="2" %log_download_delimiter_2_selected%>スペース区切り (SSV)</option>
					<option value="3" %log_download_delimiter_3_selected%>タブ区切り (TSV)</option>
				</select>
			</dd>
		</dl>
		<dl>
			<dt>文字コード</dt>
			<dd>
				<select name="log_download_charcode" id="log_download_charcode" class="select">
					<option value="1" %log_download_charcode_1_selected%>UTF-8</option>
					<option value="2" %log_download_charcode_2_selected%>Shift_JIS</option>
					<option value="3" %log_download_charcode_3_selected%>EUC-JP</option>
				</select>
				<ul class="note">
					<li>日本語・英語以外の文字が含まれる場合はUTF-8を選択してください。Shift_JISおよびEUC-JPでは文字化けしてしまいますので注意してください。</li>
				</ul>
			</dd>
		</dl>
		<dl>
			<dt>改行コード</dt>
			<dd>
				<select name="log_download_rc" id="log_download_rc" class="select">
					<option value="1" %log_download_rc_1_selected%>LF（UNIX系OSおよびMac OS X）</option>
					<option value="2" %log_download_rc_2_selected%>CR（Mac OS 9以前）</option>
					<option value="3" %log_download_rc_3_selected%>CRLF（Windows）</option>
				</select>
			</dd>
		</dl>
		<dl>
			<dt>対象カラム</dt>
			<dd>
				<input type="checkbox" id="log_download_item_SERIAL" name="log_download_item" value="SERIAL" %log_download_item_SERIAL_checked% /> <label for="log_download_item_SERIAL" class="item-orig">受付シリアル番号</label><br />
				<input type="checkbox" id="log_download_item_RECEPTION_DATE" name="log_download_item" value="RECEPTION_DATE" %log_download_item_RECEPTION_DATE_checked% /> <label for="log_download_item_RECEPTION_DATE" class="item-orig">受付日時</label><br />
				<TMPL_LOOP NAME="log_download_item_loop">
					<input type="checkbox" id="log_download_item_%name%" name="log_download_item" value="%name%" %checked% /> <label for="log_download_item_%name%" class="item-user">%caption%</label><br />
				</TMPL_LOOP>
				<input type="checkbox" id="log_download_item_HTTP_USER_AGENT" name="log_download_item" value="HTTP_USER_AGENT" %log_download_item_HTTP_USER_AGENT_checked% /> <label for="log_download_item_HTTP_USER_AGENT" class="item-orig">HTTP_USER_AGENT</label><br />
				<input type="checkbox" id="log_download_item_REMOTE_HOST" name="log_download_item" value="REMOTE_HOST" %log_download_item_REMOTE_HOST_checked% /> <label for="log_download_item_REMOTE_HOST" class="item-orig">REMOTE_HOST</label><br />
				<input type="checkbox" id="log_download_item_REMOTE_ADDR" name="log_download_item" value="REMOTE_ADDR" %log_download_item_REMOTE_ADDR_checked% /> <label for="log_download_item_REMOTE_ADDR" class="item-orig">REMOTE_ADDR</label>
				<ul class="note">
					<li>ダウンロードしたいカラムにチェックを入れてください。</li>
				</ul>
			</dd>
		</dl>
		<dl class="last">
			<dt>改行の扱い</dt>
			<dd>
				<input type="text" id="log_download_rc_replace" name="log_download_rc_replace" value="%log_download_rc_replace%" class="text inputlimit_ascii" />
				<ul class="note">
					<li>1レコード1行でログを生成するため、各カラム内の改行は取り除かれます。もし各カラム内に含まれる改行を別の文字列に変換したい場合は、ここで変換後の文字を半角英数字で指定してください。</li>
				</ul>
			</dd>
		</dl>
		<div><input type="submit" value="ダウンロード" name="downloadBtn" class="submit" /></div>
	</fieldset>
</form>

</TMPL_IF>
</div>
</body>
</html>
