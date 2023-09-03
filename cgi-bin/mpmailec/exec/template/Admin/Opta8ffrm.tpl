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
#a8f_pid { width:15em; }
#a8f_item_price { width:9em; }
#a8f_item_num { width:4em; }
</style>
<script type="text/javascript" src="%static_url%/js/dom.js"></script>
<script type="text/javascript" src="%static_url%/js/form.js"></script>
<script type="text/javascript" src="%static_url%/js/inputlimit.js"></script>
<script type="text/javascript" src="%static_url%/js/admin/opta8ffrm.js"></script>
</head>
<body>
<h1><a href="%CGI_URL%?m=optcnfmnu">機能設定</a> &gt; A8FLY設定</h1>
<div id="main">
<p>完了画面にA8FLY用のタグを出力することができます。A8FLYに必要なパラメータはブラウザで設定することができ、誰でも簡単にA8FLYをご利用頂くことができます。</p>
<p>A8FLYをご利用になるためには、事前に、株式会社ファンコミュニケーションズが提供するアフェリエイトサービス「<a href="http://www.a8.net/" target="_blank">A8.net</a>」の広告主会員として申込みが必要です。</p>
<p>設定入力後、画面下の「設定」ボタンを押してください。 </p>
<TMPL_IF NAME="errs"><div class="errs">%errs%</div></TMPL_IF>
<form method="post" action="%CGI_URL%">
	<input type="hidden" name="m" value="opta8fset" />
	<input type="hidden" name="pkey" value="%pkey%" />
	<fieldset>
		<dl class="last">
			<dt><label class="%a8f_enable_err%">A8FLYの利用</label></dt>
			<dd>
				<input type="checkbox" id="a8f_enable_1" name="a8f_enable" value="1" class="checkbox %a8f_enable_err%" %a8f_enable_1_checked% /> <label for="a8f_enable_1">A8FLYを利用する</label>
				<ul class="note">
					<li>A8FLYをご利用になる場合は、まず「A8FLYを利用する」にチェックを入れてください。チェックを入れると、A8FLYに必要な設定欄が入力可能な状態になります。</li>
				</ul>
			</dd>
		</dl>
	</fieldset>
	<fieldset id="a8f_box">
		<legend>A8FLY設定</legend>
		<dl>
			<dt><label class="required %a8f_type_err%">利用パターン</label></dt>
			<dd>
				<input type="radio" id="a8f_type_1" name="a8f_type" value="1" class="radio %a8f_type_1_err%" %a8f_type_1_checked% /> <label for="a8f_type_1">売上型（物販タイプ - 単価・個数は固定）</label><br />
				<input type="radio" id="a8f_type_2" name="a8f_type" value="2" class="radio %a8f_type_2_err%" %a8f_type_2_checked% /> <label for="a8f_type_2">申込型（リードタイプ）</label><br />
				<ul class="note">
					<li>「売上型」もしくは「申込型」のいずれかを選択してください。「売上型＋申込型」や「申込型×複数」といったパターンには対応しておりませんので、ご了承ください。</li>
					<li>また、「売上型」の場合は、商品単価や商品個数は固定となります。MP Form Mail CGI での受付内容に応じて動的に変化させることはできません。</li>
				</ul>
			</dd>
		</dl>
		<dl>
			<dt><label for="a8f_url" class="required %a8f_url_err%">リクエストURL</label></dt>
			<dd>
				<input type="text" id="a8f_url" name="a8f_url" value="%a8f_url%" class="text inputlimit_url %a8f_url_err%" />
				<ul class="note">
					<li>通常はデフォルトで入力されている値のままで問題ありません。デフォルトでは、https://px.a8.net/cgi-bin/a8fly/sales とセットされます。A8.netより、このデフォルト値以外のURLを指定するよう指示された場合にのみ、変更してください。</li>
				</ul>
			</dd>
		</dl>
		<dl>
			<dt><label for="a8f_pid" class="required %a8f_pid_err%">プログラムID</label></dt>
			<dd>
				<input type="text" id="a8f_pid" name="a8f_pid" value="%a8f_pid%" class="text inputlimit_alphanum %a8f_pid_err%" maxlength="15" />
				<ul class="note">
					<li>プログラムIDは、A8.netのサービス利用申込後に、A8.netから発行される、アフェリエイトプログラム毎に割り当てられる固有のIDです。小文字のsで始まる15文字の英数となります。</li>
				</ul>
			</dd>
		</dl>
		<dl>
			<dt><label for="a8f_item_price" class="required %a8f_item_price_err%">商品単価/報酬額</label></dt>
			<dd>
				<input type="text" id="a8f_item_price" name="a8f_item_price" value="%a8f_item_price%" class="text inputlimit_num %a8f_item_price_err%" maxlength="9" /> 円
				<ul class="note">
					<li>商品単価/報酬額には、本システムで受け付ける注文の商品単価を表す金額を入力してください。0を指定することはできません。</li>
				</ul>
			</dd>
		</dl>
		<dl id="a8f_item_num_box">
			<dt><label for="a8f_item_num" class="required %a8f_item_num_err%">商品個数</label></dt>
			<dd>
				<input type="text" id="a8f_item_num" name="a8f_item_num" value="%a8f_item_num%" class="text inputlimit_num %a8f_item_num_err%" maxlength="4" /> 個
				<ul class="note">
					<li>商品個数には、本システムで受け付ける注文個数を表す数字を入力してください。0を指定することはできません。申込型の場合は、商品個数を指定することはできません。申込型の場合は、1 固定となります。</li>
				</ul>
			</dd>
		</dl>
		<dl class="last">
			<dt><label for="a8f_item_code" class="required %a8f_item_code_err%">商品コード</label></dt>
			<dd>
				<input type="text" id="a8f_item_code" name="a8f_item_code" value="%a8f_item_code%" class="text inputlimit_alphanum %a8f_item_code_err%" maxlength="50" />
				<ul class="note">
					<li>商品コードには、本システムで受け付ける注文商品を区別できる文字列を入力してください。商品コードで指定できる文字は、半角英数字および半角ハイフンのみです。また 0 のみを指定することはできません。</li>
				</ul>
			</dd>
		</dl>
	</fieldset>
	<div><input type="submit" value="設定" name="setBtn" class="submit" /></div>
</form>
</div>
</body>
</html>
