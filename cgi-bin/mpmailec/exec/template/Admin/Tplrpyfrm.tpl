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
<script type="text/javascript" src="%static_url%/js/admin/tplrpyfrm.js"></script>
<style type="text/css">
#atc_file_list_tbl {
	border-collapse: collapse;
	border-top: 1px solid #222222;
	border-bottom: 1px solid #222222;
}
#atc_file_list_tbl td {
	font-size: 90%;
	padding: 0.1em 0.5em 0.1em 0.5em;
}
#atc_file_list_tbl td.center {
	text-align: center;
}
#atc_file_list_tbl td.right {
	text-align: right;
}
#atc_file_list_tbl thead td {
	border-bottom: 1px solid #222222;
}
</style>
</head>
<body>
<h1><a href="%CGI_URL%?m=tpllstmnu">画面テンプレート</a> - 自動返信メール</h1>
<div id="main">
<form method="post" action="%CGI_URL%" enctype="multipart/form-data">
	<input type="hidden" name="m" value="tplrpyset" />
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
		<legend>自動返信メール</legend>
		<TMPL_IF NAME="errs"><div class="errs">%errs%</div></TMPL_IF>
		<textarea name="tpl" id="tpl" cols="80" rows="30">%tpl%</textarea>
	</fieldset>
	<fieldset>
		<legend>添付ファイル</legend>
		<dl class="last %atc_file_err%">
			<dt>新規ファイル</dt>
			<dd>
				<input type="file" name="atc_file" id="atc_file" class="text %atc_file_err%" />
				<ul class="note">
					<li>自動返信メールにファイルを添付したい場合は、添付するファイルを選択してください。</li>
					<li>ファイル名は30文字以内としてください。</li>
					<li>合計で%rpy_atc_max_total_size%MB以下としてください。</li>
				</ul>
			</dd>
		</dl>
		<TMPL_IF NAME="atc_file_num">
		<dl class="last">
			<dt>添付ファイル一覧</dt>
			<dd>
				<table summary="" id="atc_file_list_tbl">
					<thead>
						<tr>
							<td class="center">削除</td>
							<td class="center">ファイル名</td>
							<td class="center">サイズ</td>
							<td class="center">最終更新日時</td>
							<td class="center">MIMEタイプ</td>
						</tr>
					</thead>
					<tbody>
						<TMPL_LOOP NAME="atc_file_loop">
						<tr>
							<td class="center"><input type="checkbox" name="atc_file_del" value="%name_hex%" /></td>
							<td>%name%</td>
							<td class="right">%size_with_comma% byte</td>
							<td>%mtime_Y%-%mtime_m%-%mtime_d% %mtime_H%:%mtime_i%:%mtime_s%</td>
							<td>%mtype%</td>
						</tr>
						</TMPL_LOOP>
					</tbody>
				</table>
				<ul class="note">
					<li>削除したいファイルにチェックを入れてください。</li>
				</ul>
			</dd>
		</dl>
		</TMPL_IF>
	</fieldset>
	<div><input type="button" value="プレビュー" name="previewBtn" id="previewBtn" class="submit" />　<input type="submit" value="設定" name="setBtn" class="submit" /></div>
</form>
</div>
</body>
</html>
