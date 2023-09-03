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
<script type="text/javascript" src="%static_url%/js/inputlimit.js"></script>
<script type="text/javascript" src="%static_url%/js/admin/optactfrm.js"></script>
</head>
<body>
<h1><a href="%CGI_URL%?m=optcnfmnu">機能設定</a> &gt; 基本動作設定</h1>
<div id="main">
<p>画面の文字コードの設定や、確認画面表示の設定など、フォームに関する基本動作を設定します。設定入力後、画面下の「設定」ボタンを押してください。 </p>
<TMPL_IF NAME="errs"><div class="errs">%errs%</div></TMPL_IF>
<form method="post" action="%CGI_URL%">
	<input type="hidden" name="m" value="optactset" />
	<input type="hidden" name="pkey" value="%pkey%" />
	<fieldset>
		<legend>言語と文字エンコーディング</legend>
		<dl>
			<dt><label for="lang" class="required %lang_err%">言語</label></dt>
			<dd>
				<select name="lang" id="lang">
					<option value="de" %lang_de_selected%>ドイツ語（de）</option>
					<option value="en" %lang_en_selected%>英語（en）</option>
					<option value="es" %lang_es_selected%>スペイン語（es）</option>
					<option value="fr" %lang_fr_selected%>フランス語（fr）</option>
					<option value="ja" %lang_ja_selected%>日本語（ja）</option>
					<option value="ko" %lang_ko_selected%>韓国語（ko）</option>
					<option value="pt" %lang_pt_selected%>ポルトガル語（pt）</option>
					<option value="ru" %lang_ru_selected%>ロシア語（ru）</option>
					<option value="zh" %lang_zh_selected%>中国語（zh）</option>
				</select>
				<ul class="note">
					<li>フォームで受け付ける言語を選択してください。</li>
					<li>上記にない言語を扱う場合は、日本語以外のいずれかひとつを選択してください。</li>
				</ul>
			</dd>
		</dl>
		<dl>
			<dt><label class="required %html_00_encoding_err%">サイトの文字エンコーディング</label></dt>
			<dd>
				<input type="radio" id="html_00_encoding_0" name="html_00_encoding" value="0" class="radio" %html_00_encoding_0_checked% /> <label for="html_00_encoding_0" id="html_00_encoding_label_0">UTF-8（全言語）</label><br />
				<input type="radio" id="html_00_encoding_1" name="html_00_encoding" value="1" class="radio" %html_00_encoding_1_checked% /> <label for="html_00_encoding_1" id="html_00_encoding_label_1">Shift_JIS（日本語）</label>　
				<input type="radio" id="html_00_encoding_2" name="html_00_encoding" value="2" class="radio" %html_00_encoding_2_checked% /> <label for="html_00_encoding_2" id="html_00_encoding_label_2">EUC-JP（日本語）</label>　
				<input type="radio" id="html_00_encoding_3" name="html_00_encoding" value="3" class="radio" %html_00_encoding_3_checked% /> <label for="html_00_encoding_3" id="html_00_encoding_label_3">ISO-2022-JP（日本語）</label><br />
				<ul class="note">
					<li>フォームから完了画面までのウェブページの文字エンコーディングを指定します。選択された言語によって、指定できるエンコーディングは異なります。</li>
				</ul>
			</dd>
		</dl>
		<dl>
			<dt><label for="html_00_doctype" class="required %html_00_doctype_err%">サイトのドキュメントタイプ（DTD）</label></dt>
			<dd>
				<select name="html_00_doctype" id="html_00_doctype">
					<option value="0011" %html_00_doctype_0011_selected%>HTML 4.01 Transitional</option>
					<option value="0012" %html_00_doctype_0012_selected%>HTML 4.01 Strict</option>
					<option value="0013" %html_00_doctype_0013_selected%>XHTML 1.0 Transitional</option>
					<option value="0014" %html_00_doctype_0014_selected%>XHTML 1.0 Strict</option>
					<option value="0015" %html_00_doctype_0015_selected%>XHTML 1.1</option>
					<option value="1001" %html_00_doctype_1001_selected%>XHTML Mobile Profile 1.0</option>
					<option value="1111" %html_00_doctype_1111_selected%>i-XHTML 1.1</option>
					<option value="1210" %html_00_doctype_1210_selected%>OPENWAVE XHTML 1.0</option>
					<option value="1310" %html_00_doctype_1310_selected%>J-PHONE XHTML Basic 1.0</option>
				</select>
				<ul class="note">
					<li>フォームから完了画面までのウェブページのドキュメントタイプ（DTD）を選択してください。</li>
				</ul>
			</dd>
		</dl>
		<dl id="html_mobi_auto_ctype_box">
			<dt><label class="%html_auto_ctype_err%">Content-Typeの自動認識</label></dt>
			<dd>
				<input type="checkbox" id="html_auto_ctype_1" name="html_auto_ctype" value="1" class="checkbox" %html_auto_ctype_1_checked% /> <label for="html_auto_ctype_1" id="html_auto_ctype_label_1">Content-Typeの自動認識を有効にする</label><br />
				<ul class="note">
					<li>本システムでは、画面出力の際に、ドキュメントタイプ（DTD）に応じた Content-Type が適用されます。XHTML 1.1 または i-XHTML であれば application/xhtml+xml が、それ以外では text/html が適用されます。</li>
					<li>しかし、Internet Explorer 7 以前では application/xhtml+xml では正しく表示されません。また、携帯向けの場合、text/html で画面が出力された場合は DoCoMo 端末で正しく表示されず、application/xhtml+xml で画面が出力されると DoCoMo以外の携帯端末で正しく表示されません。</li>
					<li>自動認識を有効にすると、これらユーザーエージェントからアクセスがあった場合、それにあわせて適切な Content-Type を適用します。</li>
				</ul>
			</dd>
		</dl>
		<dl class="last" id="html_mobi_selectable_box">
			<dt><label class="%html_mobi_selectable_err%">携帯端末の画面自動振り分け</label></dt>
			<dd>
				<input type="checkbox" id="html_mobi_selectable_1" name="html_mobi_selectable" value="1" class="checkbox" %html_mobi_selectable_1_checked% /> <label for="html_mobi_selectable_1" id="html_mobi_selectable_label_1">携帯端末用に画面自動振り分けをする</label><br />
				<ul class="note">
					<li>携帯端末（DoCoMo, au, Softbank）からアクセスがあった場合、携帯端末用の画面に自動的に振り分けたい場合は、チェックを入れてください。</li>
				</ul>
			</dd>
		</dl>
		<dl class="last" id="html_mobi_carrier_selectable_box">
			<dt><label class="%html_mobi_carrier_selectable_err%">携帯キャリアごとの画面自動振り分け</label></dt>
			<dd>
				<input type="radio" id="html_mobi_carrier_selectable_0" name="html_mobi_carrier_selectable" value="0" class="radio" %html_mobi_carrier_selectable_0_checked% /> <label for="html_mobi_carrier_selectable_0" id="html_mobi_carrier_selectable_label_0">携帯端末共通の画面を表示する</label>　
				<input type="radio" id="html_mobi_carrier_selectable_1" name="html_mobi_carrier_selectable" value="1" class="radio" %html_mobi_carrier_selectable_1_checked% /> <label for="html_mobi_carrier_selectable_1" id="html_mobi_carrier_selectable_label_1">キャリア別に画面自動振り分けをする</label>
				<ul class="note">
					<li>携帯端末（DoCoMo, au, Softbank）からアクセスがあった場合、携帯キャリア別に画面に自動的に振り分けたい場合は、「キャリア別に画面自動振り分けをする」にチェックを入れてください。</li>
				</ul>
			</dd>
		</dl>
		<dl class="last" id="html_mobi_doctype_box">
			<dt><label>携帯端末用ドキュメントタイプ（DTD）と文字エンコーディング</label></dt>
			<dd>
				<table id="html_mobi00_doctype_box" summary="携帯端末共通のドキュメント情報">
					<tr>
						<td>携帯端末共通</td>
						<td>
							<select name="html_10_doctype" id="html_10_doctype">
								<option value="1001" %html_10_doctype_1001_selected%>XHTML Mobile Profile 1.0</option>
								<option value="1111" %html_10_doctype_1111_selected%>i-XHTML 1.1</option>
								<option value="1210" %html_10_doctype_1210_selected%>OPENWAVE XHTML Basic 1.0</option>
								<option value="1310" %html_10_doctype_1310_selected%>J-PHONE XHTML Basic 1.0</option>
							</select>
						</td>
						<td>
							<select name="html_10_encoding" id="html_10_encoding">
								<option value="0" %html_10_encoding_0_selected%>UTF-8</option>
								<option value="1" %html_10_encoding_1_selected%>Shift_JIS</option>
								<option value="2" %html_10_encoding_2_selected%>EUC-JP</option>
							</select>
						</td>
					</tr>
				</table>
				<table id="html_mobi01_doctype_box" summary="キャリア別のドキュメント情報">
					<tr>
						<td>DoCoMo端末用</td>
						<td>
							<select name="html_11_doctype" id="html_11_doctype">
								<option value="1001" %html_11_doctype_1001_selected%>XHTML Mobile Profile 1.0</option>
								<option value="1111" %html_11_doctype_1111_selected%>i-XHTML 1.1</option>
							</select>
						</td>
						<td>
							<select name="html_11_encoding" id="html_11_encoding">
								<option value="0" %html_11_encoding_0_selected%>UTF-8</option>
								<option value="1" %html_11_encoding_1_selected%>Shift_JIS</option>
								<option value="2" %html_11_encoding_2_selected%>EUC-JP</option>
							</select>
						</td>
					</tr>
					<tr>
						<td>au端末用</td>
						<td>
							<select name="html_12_doctype" id="html_12_doctype">
								<option value="1001" %html_12_doctype_1001_selected%>XHTML Mobile Profile 1.0</option>
								<option value="1210" %html_12_doctype_1210_selected%>OPENWAVE XHTML Basic 1.0</option>
							</select>
						</td>
						<td>
							<select name="html_12_encoding" id="html_12_encoding">
								<option value="0" %html_12_encoding_0_selected%>UTF-8</option>
								<option value="1" %html_12_encoding_1_selected%>Shift_JIS</option>
								<option value="2" %html_12_encoding_2_selected%>EUC-JP</option>
							</select>
						</td>
					</tr>
					<tr>
						<td>Softbank端末用</td>
						<td>
							<select name="html_13_doctype" id="html_13_doctype">
								<option value="1001" %html_13_doctype_1001_selected%>XHTML Mobile Profile 1.0</option>
								<option value="1310" %html_13_doctype_1310_selected%>J-PHONE XHTML Basic 1.0</option>
							</select>
						</td>
						<td>
							<select name="html_13_encoding" id="html_13_encoding">
								<option value="0" %html_13_encoding_0_selected%>UTF-8</option>
								<option value="1" %html_13_encoding_1_selected%>Shift_JIS</option>
								<option value="2" %html_13_encoding_2_selected%>EUC-JP</option>
							</select>
						</td>
					</tr>
				</table>
			</dd>
		</dl>
	</fieldset>
	<fieldset>
		<legend>画面遷移</legend>
		<dl>
			<dt><label class="%confirm_enable_err%">確認画面の表示</label></dt>
			<dd>
				<input type="checkbox" id="confirm_enable_1" name="confirm_enable" value="1" class="checkbox %confirm_enable_err%" %confirm_enable_1_checked% /> <label for="confirm_enable_1">確認画面を表示する</label>
				<ul class="note">
					<li>フォームに入力したあと、確認画面を表示するかどうかの設定です。確認画面を表示させたい場合は、チェックボックスにチェックを入れてください。チェックを外すと、フォームに入力した後、すぐに完了画面が表示されます。</li>
				</ul>
			</dd>
		</dl>
		<dl class="last">
			<dt><label class="required %thx_redirect_enable_err%">完了画面表示方法</label></dt>
			<dd>
				<input type="radio" id="thx_redirect_enable_0" name="thx_redirect_enable" value="0" class="radio" %thx_redirect_enable_0_checked% /> <label for="thx_redirect_enable_0">テンプレートを使ってCGIが出力</label>　
				<input type="radio" id="thx_redirect_enable_1" name="thx_redirect_enable" value="1" class="radio" %thx_redirect_enable_1_checked% /> <label for="thx_redirect_enable_1">指定URLへリダイレクト</label>
				<ul class="note">
					<li>完了画面を表示するためには、2 つの方法を選択することが出来ます。ご都合の良い方を選択して下さい。</li>
					<li>指定URLへリダイレクト：事前に用意された指定のURLへリダイレクトをします。ただ単に指定ページへ飛ばすだけですので、入力された値を表示することは出来ません。この方式を選択した場合には、事前に完了画面をサーバに用意しておいてください。</li>
					<li>テンプレートを使ってCGIが出力：完了画面テンプレートのHTMLに従い、CGIが完了画面を表示します。この方式では、入力値を置換して表示することも可能です。完了画面テンプレートの編集は、管理メニューの"完了画面編集"をご覧ください。</li>
				</ul>
			</dd>
		</dl>
		<dl id="thx_box" class="last">
			<dt><label for="thx_redirect_url" class="required %thx_redirect_url_err%">完了画面のリダイレクト先URL</label></dt>
			<dd>
				<input type="text" id="thx_redirect_url" name="thx_redirect_url" value="%thx_redirect_url%" class="text inputlimit_url %thx_redirect_url_err%" />
				<ul class="note">
					<li>「完了画面表示方法」で &quot;指定URLへリダイレクト&quot; を選択した場合にのみ設定してください。</li>
					<li>フォームから送信した後、表示されるページのURLを指定してください。必ず、http:// もしくは https:// から指定してください。</li>
				</ul>
			</dd>
		</dl>
	</fieldset>
	<div><input type="submit" value="設定" name="setBtn" class="submit" /></div>
</form>
</div>
</body>
</html>
