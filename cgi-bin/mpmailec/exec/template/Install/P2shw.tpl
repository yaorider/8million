<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="ja" lang="ja">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta http-equiv="Content-Language" content="ja" />
<meta http-equiv="Content-Style-Type" content="text/css" />
<meta http-equiv="Content-Script-Type" content="text/javascript" />
<title>%product_name% Ver %product_version%</title>
<link href="%static_url%/css/install/common.css" type="text/css" rel="stylesheet" />
<script type="text/javascript" src="%static_url%/js/form.js"></script>
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
		<h1>CGI設置診断セットアップ</h1>
		<TMPL_IF NAME="errs"><div class="errs">%errs%</div></TMPL_IF>
		<p>これよりCGIが正しくセットアップされているかを診断します。「診断」ボタンを押してください。</p>
		<p>もしCGIがファイル所有者(owner)権限で実行されるサーバ環境であれば、自動的にファイルパーミッションの変更やPerlパスの修正を行います。
			そうでないサーバ環境の場合は、自動的にセットアップは行われません。エラーの指示に従ってCGIのセットアップを手動で行い、繰り返し診断を行ってください。</p>
		<form method="post" action="%CGI_URL%">
			<input type="hidden" name="m" value="p2shw" />
			<input type="hidden" name="stat" value="1" />
			<input type="hidden" name="static_url" value="%static_url%" />
			<input type="submit" value="　診　断　" name="B1" class="submit" />
		</form>
		<!-- 診断結果 start -->
		<TMPL_IF NAME="stat_ok">
			<p>診断結果は良好です。「次へ」ボタンを押してセットアップを進めてください。</p>
			<form action="%CGI_URL%" method="post">
				<input type="hidden" name="m" value="p3shw" />
				<input type="submit" name="b1" value="　次　へ　" class="submit" />
			</form>
		</TMPL_IF>
		<TMPL_IF NAME="stat_ng">
			<div class="errs">%stat_errs%</div>
		</TMPL_IF>
		<!-- 診断結果 end -->
	</div>
	<!-- 左フレーム end -->
	<!-- 右フレーム start -->
	<div id="rightbox">
		<div id="stepbox">
			<div class="step">
				<div class="steptitle">Step 1</div>
				<div class="stepdesc">staticディレクトリのURLの設定</div>
			</div>
			<div class="step target">
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
