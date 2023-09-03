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
h2 { clear: both; }
h3 { font-size: small; }
ul { margin-left: 2em; }
div.mnubox {
	margin-bottom: 2em;
	float: left;
	width: 140px;
}
li.disable { color: #888888; }
</style>
</head>
<body>
<h1>画面テンプレート</h1>
<div id="main">
<h2>HTML画面</h2>
<div class="mnubox story">
	<h3>PC用</h3>
	<ul>
		<li><a href="%CGI_URL%?m=tpledtfrm&amp;tid=frm00">入力画面</a></li>
		<TMPL_IF NAME="confirm_enable">
			<li><a href="%CGI_URL%?m=tpledtfrm&amp;tid=cfm00">確認画面</a></li>
		<TMPL_ELSE>
			<li class="disable">確認画面</li>
		</TMPL_IF>
		<TMPL_IF NAME="thx_redirect_enable">
			<li class="disable">完了画面</li>
		<TMPL_ELSE>
			<li><a href="%CGI_URL%?m=tpledtfrm&amp;tid=cpt00">完了画面</a></li>
		</TMPL_IF>
		<li><a href="%CGI_URL%?m=tpledtfrm&amp;tid=err00">エラー画面</a></li>
	</ul>
</div>
<TMPL_IF NAME="html_mobi_selectable">
	<TMPL_IF NAME="html_mobi_carrier_selectable">
		<div class="mnubox">
			<h3>DoCoMo用</h3>
			<ul>
				<li><a href="%CGI_URL%?m=tpledtfrm&amp;tid=frm11">入力画面</a></li>
				<TMPL_IF NAME="confirm_enable">
					<li><a href="%CGI_URL%?m=tpledtfrm&amp;tid=cfm11">確認画面</a></li>
				<TMPL_ELSE>
					<li class="disable">確認画面</li>
				</TMPL_IF>
				<TMPL_IF NAME="thx_redirect_enable">
					<li class="disable">完了画面</li>
				<TMPL_ELSE>
					<li><a href="%CGI_URL%?m=tpledtfrm&amp;tid=cpt11">完了画面</a></li>
				</TMPL_IF>
				<li><a href="%CGI_URL%?m=tpledtfrm&amp;tid=err11">エラー画面</a></li>
			</ul>
		</div>
		<div class="mnubox">
			<h3>au用</h3>
			<ul>
				<li><a href="%CGI_URL%?m=tpledtfrm&amp;tid=frm12">入力画面</a></li>
				<TMPL_IF NAME="confirm_enable">
					<li><a href="%CGI_URL%?m=tpledtfrm&amp;tid=cfm12">確認画面</a></li>
				<TMPL_ELSE>
					<li class="disable">確認画面</li>
				</TMPL_IF>
				<TMPL_IF NAME="thx_redirect_enable">
					<li class="disable">完了画面</li>
				<TMPL_ELSE>
					<li><a href="%CGI_URL%?m=tpledtfrm&amp;tid=cpt12">完了画面</a></li>
				</TMPL_IF>
				<li><a href="%CGI_URL%?m=tpledtfrm&amp;tid=err12">エラー画面</a></li>
			</ul>
		</div>
		<div class="mnubox">
			<h3>Softbank用</h3>
			<ul>
				<li><a href="%CGI_URL%?m=tpledtfrm&amp;tid=frm13">入力画面</a></li>
				<TMPL_IF NAME="confirm_enable">
					<li><a href="%CGI_URL%?m=tpledtfrm&amp;tid=cfm13">確認画面</a></li>
				<TMPL_ELSE>
					<li class="disable">確認画面</li>
				</TMPL_IF>
				<TMPL_IF NAME="thx_redirect_enable">
					<li class="disable">完了画面</li>
				<TMPL_ELSE>
					<li><a href="%CGI_URL%?m=tpledtfrm&amp;tid=cpt13">完了画面</a></li>
				</TMPL_IF>
				<li><a href="%CGI_URL%?m=tpledtfrm&amp;tid=err13">エラー画面</a></li>
			</ul>
		</div>
	<TMPL_ELSE>
		<div class="mnubox">
			<h3>携帯用</h3>
			<ul>
				<li><a href="%CGI_URL%?m=tpledtfrm&amp;tid=frm10">入力画面</a></li>
				<TMPL_IF NAME="confirm_enable">
					<li><a href="%CGI_URL%?m=tpledtfrm&amp;tid=cfm10">確認画面</a></li>
				<TMPL_ELSE>
					<li class="disable">確認画面</li>
				</TMPL_IF>
				<TMPL_IF NAME="thx_redirect_enable">
					<li class="disable">完了画面</li>
				<TMPL_ELSE>
					<li><a href="%CGI_URL%?m=tpledtfrm&amp;tid=cpt10">完了画面</a></li>
				</TMPL_IF>
				<li><a href="%CGI_URL%?m=tpledtfrm&amp;tid=err10">エラー画面</a></li>
			</ul>
		</div>
	</TMPL_IF>
</TMPL_IF>

<h2>メール本文</h2>
<div class="mnubox story">
	<ul>
		<li><a href="%CGI_URL%?m=tplmaifrm">通知メール</a></li>
		<TMPL_IF NAME="rpy_enable">
			<li><a href="%CGI_URL%?m=tplrpyfrm">自動返信メール</a></li>
		<TMPL_ELSE>
			<li class="disable">自動返信メール</li>
		</TMPL_IF>
	</ul>
</div>
</div>
</body>
</html>
