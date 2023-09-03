<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="ja" lang="ja">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta http-equiv="Content-Language" content="ja" />
<meta http-equiv="Content-Style-Type" content="text/css" />
<meta http-equiv="Content-Script-Type" content="text/javascript" />
<meta http-equiv="refresh" content="60;URL=%CGI_DIR_URL%/admin.cgi" />
<title>%product_name% Ver %product_version%</title>
<link href="%static_url%/css/install/common.css" type="text/css" rel="stylesheet" />
<script type="text/javascript">
window.onload = function() {
	var url = get_admin_url();
	document.getElementById("admin_url").innerHTML = url;
	if(document.uniqueID && window.external) {
		document.getElementById("favorite-box").style.display = "block";
	}
};
function addbookmark() {
	var title = '%product_name% 管理メニュー ログオン画面';
	var url = get_admin_url();
	window.external.addFavorite(url, title);
}
function get_admin_url() {
	var url = document.location.href;
	if(url) {
		url = url.replace("/install.cgi", "/admin.cgi");
	}
	return url;
}
</script>
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
		<h1>セットアップ完了</h1>
		<p>CGIのセットアップが無事完了しました。<a href="%CGI_DIR_URL%/admin.cgi">ログオン画面</a>にアクセスして、先ほど登録した管理者用IDとパスワードを入力してログオンしてください。ログオン画面のアドレスは以下の通りです。</p>
		<div id="admin_url" class="code">%CGI_DIR_URL%/admin.cgi</div>
		<div id="favorite-box" style="display:none;">
			<form action="#" method="get">
				<p><input type="button" value="お気に入りに登録" onclick="addbookmark();" /></p>
			</form>
		</div>
	</div>
	<!-- 左フレーム end -->
	<!-- 右フレーム start -->
	<div id="rightbox">
		<div id="stepbox">
			<div class="step">
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
			<div class="step target">
				<div class="steptitle">セットアップ完了</div>
			</div>
		</div>
	</div>
	<!-- 右フレーム end -->
</div>
</body>
</html>
