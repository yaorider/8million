<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="ja" lang="ja">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta http-equiv="Content-Language" content="ja" />
<meta http-equiv="Content-Style-Type" content="text/css" />
<meta http-equiv="Content-Script-Type" content="text/javascript" />
<title>%product_name% Ver %product_version%</title>
<link href="%static_url%/css/admin/common.css" type="text/css" rel="stylesheet" />
<style type="text/css">
#atc_max_size { width:3em; }
#atc_max_total_size { width:3em; }
#atc_thumb_w { width: 5em; }
#atc_thumb_h { width: 5em; }
</style>
<script type="text/javascript" src="%static_url%/js/dom.js"></script>
<script type="text/javascript" src="%static_url%/js/form.js"></script>
<script type="text/javascript" src="%static_url%/js/inputlimit.js"></script>
<script type="text/javascript" src="%static_url%/js/admin/optdtlfrm.js"></script>
</head>
<body>
<h1><a href="%CGI_URL%?m=optcnfmnu">機能設定</a> &gt; 詳細設定</h1>
<div id="main">
<p>設定入力後、画面下の「設定」ボタンを押してください。 </p>
<TMPL_IF NAME="errs"><div class="errs">%errs%</div></TMPL_IF>
<form method="post" action="%CGI_URL%">
	<input type="hidden" name="m" value="optdtlset" />
	<input type="hidden" name="pkey" value="%pkey%" />
	<fieldset>
		<legend>添付ファイルの扱い</legend>
		<dl>
			<dt><label for="atc_max_total_size" class="required %atc_max_total_size_err%">添付ファイルの合計サイズ制限</label></dt>
			<dd>
				<input type="text" id="atc_max_total_size" name="atc_max_total_size" value="%atc_max_total_size%" class="text inputlimit_num %atc_max_total_size_err%" /> MB
				<ul class="note">
					<li>添付ファイルを複数投稿された場合、それらの合計サイズ上限を指定してください。</li>
				</ul>
			</dd>
		</dl>
		<dl class="last">
			<dt><label class="%atc_thumb_show_err%">サムネイル表示</label></dt>
			<dd>
				<TMPL_IF NAME="atc_thumb_available">
					<input type="checkbox" id="atc_thumb_show_1" name="atc_thumb_show" value="1" class="checkbox" %atc_thumb_show_1_checked% />
				<TMPL_ELSE>
					<input type="checkbox" id="atc_thumb_show_1" name="atc_thumb_show" value="1" class="checkbox" disabled="disabled" />
				</TMPL_IF>
				<label for="atc_thumb_show_1">確認画面でサムネイル表示する</label>
				<ul class="note">
					<li>画像ファイルが添付された場合、確認画面でサムネイル（縮小画像）を表示させたい場合はチェックを入れてください。</li>
					<TMPL_UNLESS NAME="atc_thumb_available"><li class="warning">ご利用のサーバに Image::Magick または GD がインストールされていないため、本機能はご利用頂けません。</li></TMPL_UNLESS>
				</ul>
			</dd>
		</dl>
		<div id="atc_thumb_box">
		<dl class="last">
			<dt><label for="atc_thumb_w" class="%atc_thumb_w_err% %atc_thumb_h_err%">サムネイルのサイズ</label></dt>
			<dd>
				横幅 <input type="text" id="atc_thumb_w" name="atc_thumb_w" value="%atc_thumb_w%" class="text inputlimit_num %atc_thumb_w_err%" /> × 縦幅 <input type="text" id="atc_thumb_h" name="atc_thumb_h" value="%atc_thumb_h%" class="text inputlimit_num %atc_thumb_h_err%" /> ピクセル
				<ul class="note">
					<li>確認画面で表示するサムネイルのサイズを指定してください。指定の横幅と縦幅に収まるよう画像が縮小表示されます。</li>
					<li>ここでサイズを指定しなければ、確認画面で画像は縮小されず、そのままのサイズで表示されます。</li>
					<li>横幅、縦幅のいずれか一方のみを指定した場合は、指定した方向の幅にあわせて縮小されます。</li>
					<li>投稿された画像ファイルのサイズが指定サイズより小さい場合は、オリジナルのサイズのまま確認画面に表示されます。</li>
				</ul>
			</dd>
		</dl>
		<dl class="last">
			<dt><label for="atc_thumb_module" class="%atc_thumb_module_err%">画像変換モジュール</label></dt>
			<dd>
				<select name="atc_thumb_module" id="atc_thumb_module" class="select %atc_thumb_module_err%">
					<option value="auto" %atc_thumb_module_auto_selected%>自動</option>
					<TMPL_IF NAME="atc_thumb_module_im"><option value="im" %atc_thumb_module_im_selected%>Image::Magick</option></TMPL_IF>
					<TMPL_IF NAME="atc_thumb_module_gd"><option value="gd" %atc_thumb_module_gd_selected%>GD</option></TMPL_IF>
				</select>
				<ul class="note">
					<li>サムネイルを生成するためにロードする画像変換モジュールを選択してください。通常は「自動」を選択してください。</li>
				</ul>
			</dd>
		</dl>
		<dl class="last">
			<dt><label for="atc_thumb_format" class="%atc_thumb_format_err%">サムネイルの画像フォーマット</label></dt>
			<dd>
				<select name="atc_thumb_format" id="atc_thumb_format" class="select %atc_thumb_format_err%">
					<option value="gif" %atc_thumb_format_gif_selected%>gif</option>
					<option value="png" %atc_thumb_format_png_selected%>png</option>
					<option value="jpeg" %atc_thumb_format_jpeg_selected%>jpeg</option>
				</select>
				<ul class="note">
					<li>確認画面で表示するサムネイルの画像フォーマットを選択してください。</li>
				</ul>
			</dd>
		</dl>
		</div>
	</fieldset>
	<div><input type="submit" value="設定" name="setBtn" class="submit" /></div>
</form>
</div>
</body>
</html>
