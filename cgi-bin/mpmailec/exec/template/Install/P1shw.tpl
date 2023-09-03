<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="ja" lang="ja">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta http-equiv="Content-Language" content="ja" />
<meta http-equiv="Content-Style-Type" content="text/css" />
<meta http-equiv="Content-Script-Type" content="text/javascript" />
<title>%product_name% Ver %product_version%</title>
<link href="%static_url%/css/install/common.css" type="text/css" rel="stylesheet" />
<script type="text/javascript" src="%static_url%/js/dom.js"></script>
<script type="text/javascript" src="%static_url%/js/form.js"></script>
<script type="text/javascript" src="%static_url%/js/inputlimit.js"></script>
<style type="text/css">
input#static_url {
	width: 500px;
}
</style>
</head>
<body>
<!-- ヘッダー start -->
<div id="title">
	<div id="title_left">
		<TMPL_IF NAME="copyright_flag">
			<a href="%product_author_url%" target="_blank">%product_name% Ver %product_version%</a> - 初期セットアップ
		<TMPL_ELSE>
			%product_name% Ver %product_version% - 初期セットアップ
		</TMPL_IF>
	</div>
	<div id="title_right">
		<TMPL_IF NAME="copyright_flag">
			<a href="%product_author_url%" target="_blank">%copyright_caption%</a>
		</TMPL_IF>
	</div>
</div>
<!-- ヘッダー end -->
<div id="main">
	<!-- 左フレーム start -->
	<div id="leftbox">
		<p>%product_name% Ver %product_version% の初期セットアップを始めます。画面の指示に従ってセットアップを進めて下さい。</p>
		<h1>staticディレクトリURLの設定</h1>
		<p>この画面に色が付いていますか？ もし白黒の画面でしたら、staticディレクトリURLを設定しなければいけません。</p>
		<p>色が付いていない場合、ご利用のサーバが、cgi-binといった特定のディレクトリでないとCGIが動作しない環境となっている場合が想定されます。
			このようなディレクトリ内では、画像ファイル等のようなCGIファイル以外のファイルにアクセスすることができません。
			この場合、mpmailecフォルダ内にあるstaticディレクトリを、通常のHTMLファイルを設置する場所にアップロードししてください。
			そして、新たにアップロードされたstaticディレクトリのURLを、ここで定義してください。
			入力したら「設定」ボタンを押してください。</p>
		<TMPL_IF NAME="errs"><div class="errs">%errs%</div></TMPL_IF>
		<form method="post" action="%CGI_URL%">
			<fieldset>
				<legend>staticディレクトリのURL</legend>
				<input type="hidden" name="m" value="p1shw" />
				<p><input type="text" name="static_url" value="%static_url%" id="static_url" class="text inputlimit_ascii" /> <input type="submit" value="設定" name="B1" class="submit" /></p>
				<ul class="note">
					<li>URLの設定は、mpmailecフォルダ内からみた相対URLか、もしくは http:// から指定してください。また最後にスラッシュを入れないでください。</li>
				</ul>
			</fieldset>
		</form>
		<p>もしこの画面に色が付いていれば次の画面に進んでください。</p>
		<form method="post" action="%CGI_URL%">
			<input type="hidden" name="m" value="p2shw" />
			<input type="hidden" name="static_url" value="%static_url%" />
			<input type="submit" value="次へ" name="B1" class="submit" />
		</form>
	</div>
	<!-- 左フレーム end -->
	<!-- 右フレーム start -->
	<div id="rightbox">
		<div id="stepbox">
			<div class="step target">
				<div class="steptitle">Step 1</div>
				<div class="stepdesc">staticディレクトリのURLの設定</div>
			</div>
			<div class="step">
				<div class="steptitle">Step 2</div>
				<div class="stepdesc">CGI設置診断セットアップ</div>
			</div>
			<div class="step">
				<div class="steptitle">Step 3</div>
				<div class="stepdesc">メール送信設定</div>
			</div>
			<div class="step">
				<div class="steptitle">Step 4</div>
				<div class="stepdesc">管理者用ID・パスワード設定</div>
			</div>
			<div class="step">
				<div class="steptitle">セットアップ完了</div>
			</div>
		</div>
	</div>
	<!-- 右フレーム end -->
</div>
</body>
</html>
