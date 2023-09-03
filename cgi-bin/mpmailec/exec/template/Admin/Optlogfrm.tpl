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
#log_save_days { width:5em; }
</style>
<script type="text/javascript" src="%static_url%/js/dom.js"></script>
<script type="text/javascript" src="%static_url%/js/form.js"></script>
<script type="text/javascript" src="%static_url%/js/inputlimit.js"></script>
<script type="text/javascript" src="%static_url%/js/admin/optlogfrm.js"></script>
</head>
<body>
<h1><a href="%CGI_URL%?m=optcnfmnu">機能設定</a> &gt; ログ出力設定</h1>
<div id="main">
<p>受け付けたデータをログファイルに記録する機能を設定します。設定入力後、画面下の「設定」ボタンを押してください。 </p>
<TMPL_IF NAME="errs"><div class="errs">%errs%</div></TMPL_IF>
<form method="post" action="%CGI_URL%">
	<input type="hidden" name="m" value="optlogset" />
	<input type="hidden" name="pkey" value="%pkey%" />
	<fieldset>
		<dl class="last">
			<dt><label class="%log_enable_err%">ログ出力</label></dt>
			<dd>
				<input type="checkbox" id="log_enable_1" name="log_enable" value="1" class="checkbox %log_enable_err%" %log_enable_1_checked% /> <label for="log_enable_1">ログを出力する</label>
				<ul class="note">
					<li>フォームから送信された内容をログに保存するかどうかを設定します。ログを出力したい場合は、チェックボックスにチェックを入れ、以下の設定を行ってください。</li>
					<li>ログを出力する設定にすると、「ログ管理」メニューが表示され、ログファイルを削除したり、ダウンロードすることができるようになります。</li>
				</ul>
			</dd>
		</dl>
	</fieldset>
	<fieldset id="log_box">
		<legend>ログ出力設定</legend>
		<dl>
			<dt><label for="log_dir" class="required %log_dir_err%">ログファイル格納ディレクトリ</label></dt>
			<dd>
				<input type="text" id="log_dir" name="log_dir" value="%log_dir%" class="text inputlimit_ascii %log_dir_err%" />
				<ul class="note">
					<li>ログを格納するディレクトリのパスを指定してください。最後にスラッシュを入れないでください。通常はデフォルト値で構いません。</li>
					<li>デフォルト値を変更する場合は、事前に該当のディレクトリを作成し、書込権限を与えてください。</li>
				</ul>
			</dd>
		</dl>
		<dl>
			<dt><label class="%log_atc_save_err%">添付ファイルの保存</label></dt>
			<dd>
				<input type="checkbox" id="log_atc_save_1" name="log_atc_save" value="1" class="checkbox" %log_atc_save_1_checked% /> <label for="log_atc_save_1">添付ファイルを保存する</label>
				<ul class="note">
					<li>ファイルが添付された場合に、そのファイルをサーバに保存したい場合はチェックを入れてください。</li>
				</ul>
			</dd>
		</dl>
		<dl class="last">
			<dt><label class="required %log_save_days_err%">保存日数</label></dt>
			<dd>
				<input type="text" id="log_save_days" name="log_save_days" value="%log_save_days%" class="text inputlimit_num %log_save_days_err%" /> 日前の分まで保存する
				<ul class="note">
					<li>保存日数を過ぎた古いログは、フォームの投稿が完了したタイミングと、管理メニューのログ管理にアクセスしたタイミングで、自動的に削除されます。</li>
					<li>0を指定すると、当日分のみが保存されることになります。</li>
				</ul>
			</dd>
		</dl>
	</fieldset>
	<div><input type="submit" value="設定" name="setBtn" class="submit" /></div>
</form>
</div>
</body>
</html>
