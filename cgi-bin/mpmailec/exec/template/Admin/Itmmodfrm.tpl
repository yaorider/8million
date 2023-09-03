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
#name { width:15em; }
#type_1_name { width: 10em; }
#type_1_width { width: 5em; }
#type_1_maxlength { width: 5em; }
#type_1_minlength { width: 5em; }
#type_2_width { width: 5em; }
#type_2_maxlength { width: 5em; }
#type_2_minlength { width: 5em; }
#type_4_maxlength { width: 5em; }
#type_4_minlength { width: 5em; }
#type_5_maxlength { width: 5em; }
#type_5_minlength { width: 5em; }
#type_6_cols { width: 5em; }
#type_6_rows { width: 5em; }
#type_6_maxlength { width: 5em; }
#type_6_minlength { width: 5em; }
#type_7_maxsize { width: 3em; }
#type_8_maxlength { width: 5em; }
#type_8_minlength { width: 5em; }
input.dummytbox { width: 170px; }
input.dummyfbox { width: 170px; }
textarea.dummy { width: 170px; height: 30px; }
select.dummy { width: 170px; }
</style>
<script type="text/javascript" src="%static_url%/js/dom.js"></script>
<script type="text/javascript" src="%static_url%/js/form.js"></script>
<script type="text/javascript" src="%static_url%/js/inputlimit.js"></script>
<script type="text/javascript" src="%static_url%/js/admin/itmmodfrm.js"></script>
</head>
<body>
<h1><a href="%CGI_URL%?m=optcnfmnu">機能設定</a> &gt; <a href="%CGI_URL%?m=itmalllst">フォーム項目設定</a> &gt; 登録情報編集</h1>
<div id="main">
<TMPL_IF NAME="errs"><div class="errs">%errs%</div></TMPL_IF>
<form method="post" action="%CGI_URL%">
	<input type="hidden" name="m" value="itmmodset" />
	<input type="hidden" name="pkey" value="%pkey%" />
	<fieldset>
		<legend>フォーム項目情報</legend>
		<dl>
			<dt>識別キー</dt>
			<dd>%name%</dd>
		</dl>
		<dl>
			<dt>コントロール種別</dt>
			<dd>
				<TMPL_IF NAME="type_1"><input type="text" name="dummy_%offset%" value="" class="text dummytbox" disabled="disabled" /></TMPL_IF>
				<TMPL_IF NAME="type_2"><input type="password" name="dummy_%offset%" value="dummy" class="text dummytbox" disabled="disabled" /></TMPL_IF>
				<TMPL_IF NAME="type_3"><input type="radio" name="dummy_%offset%" value="dummy" class="radio dummy" disabled="disabled" checked="checked" /> %element%</TMPL_IF>
				<TMPL_IF NAME="type_4"><input type="checkbox" name="dummy_%offset%" value="dummy" class="checkbox dummy" disabled="disabled" checked="checked" /> %element%</TMPL_IF>
				<TMPL_IF NAME="type_5"><select name="dummy_%offset%" class="select dummy" disabled="disabled"><option value="%element%">%element%</option></select></TMPL_IF>
				<TMPL_IF NAME="type_6"><textarea name="dummy_%offset%" class="textarea dummy" cols="3" rows="3" disabled="disabled"></textarea></TMPL_IF>
				<TMPL_IF NAME="type_7"><input type="file" name="dummy_%offset%" class="file dummyfbox" disabled="disabled" /></TMPL_IF>
				<TMPL_IF NAME="type_8">非表示フィールド</TMPL_IF>
			</dd>
		</dl>
		<dl>
			<dt><label for="caption" class="required %caption_err%">項目名</label></dt>
			<dd>
				<input type="text" id="caption" name="caption" value="%caption%" class="text %caption_err%" />
				<ul class="note">
					<li>項目を表す表示名称を入力してください。</li>
				</ul>
			</dd>
		</dl>
		<dl>
			<dt><label class="%desc_err%">説明文</label></dt>
			<dd>
				<textarea name="desc" cols="80" rows="3" id="desc" class="textarea %desc_err%">%desc%</textarea>
				<ul class="note">
					<li>この項目の説明文を入力してください。</li>
				</ul>
			</dd>
		</dl>
		<dl class="last">
			<dt><label class="%required_err%">必須指定</label></dt>
			<dd>
				<input type="checkbox" id="required_1" name="required" value="1" %required_1_checked% class="checkbox" /> <label for="required_1">必須とする</label>
				<ul class="note">
					<li>この項目を入力必須としたい場合には、チェックを入れてください。</li>
				</ul>
			</dd>
		</dl>
	</fieldset>
	<!-- テキスト入力フィールド start -->
	<TMPL_IF NAME="type_1">
	<div id="type_1_box">
	<fieldset>
		<legend>テキスト入力フィールド詳細情報</legend>
		<dl>
			<dt><label for="type_1_width" class="%type_1_width_err%">横幅のサイズ</label></dt>
			<dd>
				<input type="text" id="type_1_width" name="type_1_width" value="%type_1_width%" maxlength="10" class="text inputlimit_ascii %type_1_width_err%" />
				<ul class="note">
					<li>テキスト入力フィールドの横幅のサイズをスタイルシートのwidh属性の値として指定してください。（例：100px, 15em, 90% など）</li>
				</ul>
			</dd>
		</dl>
		<dl>
			<dt><label class="required %type_1_maxlength_err% %type_1_minlength%">入力文字数制限</label></dt>
			<dd>
				最小 <input type="text" id="type_1_minlength" name="type_1_minlength" value="%type_1_minlength%" maxlength="10" class="text inputlimit_num %type_1_minlength_err%" /> 文字 ～
				最大 <input type="text" id="type_1_maxlength" name="type_1_maxlength" value="%type_1_maxlength%" maxlength="10" class="text inputlimit_num %type_1_maxlength_err%" /> 文字
				<ul class="note">
					<li>もしテキスト入力フィールドに入力文字数制限を設けたい場合は、その文字数を指定してください。</li>
					<li>最小文字数は必須ではありませんが、最大文字数は必須です。</li>
				</ul>
			</dd>
		</dl>
		<dl>
			<dt><label for="type_1_value" class="%type_1_value_err%">デフォルト値</label></dt>
			<dd>
				<input type="text" id="type_1_value" name="type_1_value" value="%type_1_value%" class="text %type_1_value_err%" />
				<ul class="note">
					<li>テキストフィールドに値をプリセットしたい場合は、上記入力欄に入力してください。</li>
				</ul>
			</dd>
		</dl>
		<dl>
			<dt><label class="%type_1_convert_1_err% %type_1_convert_2_err% %type_1_convert_3_err% %type_1_convert_5_err% %type_1_convert_5_err%">入力値変換</label></dt>
			<dd>
				<div>
					変換ルール1：
					<select name="type_1_convert_1" id="type_1_convert_1" class="select %type_1_convert_1_err%">
						<option value="">変換しない</option>
						<TMPL_LOOP NAME="type_1_convert_loop_1"><option value="%code%" %selected%>%label%</option></TMPL_LOOP>
					</select>
				</div>
				<div>
					変換ルール2：
					<select name="type_1_convert_2" id="type_1_convert_2" class="select %type_1_convert_2_err%">
						<option value="">変換しない</option>
						<TMPL_LOOP NAME="type_1_convert_loop_2"><option value="%code%" %selected%>%label%</option></TMPL_LOOP>
					</select>
				</div>
				<div>
					変換ルール3：
					<select name="type_1_convert_3" id="type_1_convert_3" class="select %type_1_convert_3_err%">
						<option value="">変換しない</option>
						<TMPL_LOOP NAME="type_1_convert_loop_3"><option value="%code%" %selected%>%label%</option></TMPL_LOOP>
					</select>
				</div>
				<div>
					変換ルール4：
					<select name="type_1_convert_4" id="type_1_convert_4" class="select %type_1_convert_4_err%">
						<option value="">変換しない</option>
						<TMPL_LOOP NAME="type_1_convert_loop_4"><option value="%code%" %selected%>%label%</option></TMPL_LOOP>
					</select>
				</div>
				<div>
					変換ルール5：
					<select name="type_1_convert_5" id="type_1_convert_5" class="select %type_1_convert_5_err%">
						<option value="">変換しない</option>
						<TMPL_LOOP NAME="type_1_convert_loop_5"><option value="%code%" %selected%>%label%</option></TMPL_LOOP>
					</select>
				</div>
			</dd>
		</dl>
		<dl>
			<dt><label class="%type_1_restrict_1_err% %type_1_restrict_2_err% %type_1_restrict_3_err%">入力値制限</label></dt>
			<dd>
				<div>
					制限ルール1：
					<select name="type_1_restrict_1" id="type_1_restrict_1" class="select %type_1_restrict_1_err%">
						<option value="">制限なし</option>
						<TMPL_LOOP NAME="type_1_restrict_loop_1"><option value="%code%" %selected% %disabled%>%label%</option></TMPL_LOOP>
					</select>
				</div>
				<div>
					制限ルール2：
					<select name="type_1_restrict_2" id="type_1_restrict_2" class="select %type_1_restrict_2_err%">
						<option value="">制限なし</option>
						<TMPL_LOOP NAME="type_1_restrict_loop_2"><option value="%code%" %selected% %disabled%>%label%</option></TMPL_LOOP>
					</select>
				</div>
				<div>
					制限ルール3：
					<select name="type_1_restrict_3" id="type_1_restrict_3" class="select %type_1_restrict_3_err%">
						<option value="">制限なし</option>
						<TMPL_LOOP NAME="type_1_restrict_loop_3"><option value="%code%" %selected% %disabled%>%label%</option></TMPL_LOOP>
					</select>
				</div>
				<ul class="note">
					<TMPL_UNLESS NAME="net_dns_available"><li>サーバにPerlモジュール Net::DNS がインストールされていないため「メールアドレス - 文字列チェック + DNSによるドメインチェック」はご利用になれません。</li></TMPL_UNLESS>
					<TMPL_UNLESS NAME="lwp_available"><li>サーバにPerlモジュール LWP::UserAgent がインストールされていないため「URL - 文字列チェック + HTTP通信による実在チェック」はご利用になれません。</li></TMPL_UNLESS>
				</ul>
			</dd>
		</dl>
		<dl class="last">
			<dt><label class="%type_1_is_email_err%">メールアドレス入力欄</label></dt>
			<dd>
				<input type="checkbox" id="type_1_is_email_1" name="type_1_is_email" value="1" class="checkbox %type_1_is_email_err%" %type_1_is_email_1_checked% /> <label for="type_1_is_email_1">この項目をメールアドレス入力欄として利用</label>
				<ul class="note">
					<li>この項目をメールアドレス入力欄として利用する場合はチェックを入れてください。</li>
				</ul>
			</dd>
		</dl>
		<dl class="last" id="type_1_deny_emails_box">
			<dt><label class="%type_1_deny_emails_err%">禁止メールアドレス</label></dt>
			<dd>
				<textarea id="type_1_deny_emails" name="type_1_deny_emails" rows="3" cols="80" class="textarea inputlimit_ascii %type_1_deny_emails_err%">%type_1_deny_emails%</textarea>
				<ul class="note">
					<li>禁止するメールアドレスを指定してください。指定の条件に一致するメールアドレスが入力された場合はエラーメッセージを表示します。</li>
					<li>指定したアドレスは後方一致で評価されます。たとえば、@example.com と指定すれば、ドメイン example.com のメールアドレスをすべて拒否します。</li>
					<li>複数指定する場合には、改行を入れて記述してください。</li>
				</ul>
			</dd>
		</dl>
	</fieldset>
	</div>
	</TMPL_IF>
	<!-- テキスト入力フィールド end -->
	<!-- パスワード入力フィールド start -->
	<TMPL_IF NAME="type_2">
	<div id="type_2_box">
	<fieldset>
		<legend>パスワード入力フィールド詳細情報</legend>
		<dl>
			<dt><label for="type_2_width" class="%type_2_width_err%">横幅のサイズ</label></dt>
			<dd>
				<input type="text" id="type_2_width" name="type_2_width" value="%type_2_width%" maxlength="10" class="text inputlimit_ascii %type_2_width_err%" />
				<ul class="note">
					<li>パスワード入力フィールドの横幅のサイズをスタイルシートのwidh属性の値として指定してください。（例：100px, 15em, 90% など）</li>
				</ul>
			</dd>
		</dl>
		<dl class="last">
			<dt><label class="required %type_2_maxlength_err% %type_2_minlength_err%">入力文字数制限</label></dt>
			<dd>
				最小 <input type="text" id="type_2_minlength" name="type_2_minlength" value="%type_2_minlength%" maxlength="10" class="text inputlimit_num %type_2_minlength_err%" /> 文字 ～
				最大 <input type="text" id="type_2_maxlength" name="type_2_maxlength" value="%type_2_maxlength%" maxlength="10" class="text inputlimit_num %type_2_maxlength_err%" /> 文字
				<ul class="note">
					<li>もしパスワード入力フィールドに入力文字数制限を設けたい場合は、その文字数を指定してください。</li>
					<li>最小文字数は必須ではありませんが、最大文字数は必須です。</li>
				</ul>
			</dd>
		</dl>
	</fieldset>
	</div>
	</TMPL_IF>
	<!-- パスワード入力フィールド end -->
	<!-- ラジオボタン start -->
	<TMPL_IF NAME="type_3">
	<div id="type_3_box">
	<fieldset>
		<legend>ラジオボタン詳細情報</legend>
		<dl>
			<dt><label class="required %type_3_elements_err%">選択項目</label></dt>
			<dd>
				<textarea name="type_3_elements" cols="80" rows="5" id="type_3_elements" class="textarea %type_3_elements_err%">%type_3_elements%</textarea>
				<ul class="note">
					<li>ラジオボタンの選択項目を入力してください。一つの項目を1行で記述し、改行を入れて項目を追加してください。</li>
					<li>先頭に * を入れると、事前にチェックされた状態となります。</li>
				</ul>
			</dd>
		</dl>
		<dl class="last">
			<dt><label class="required %type_3_arrangement_err%">表示方法</label></dt>
			<dd>
				<input type="radio" id="type_3_arrangement_0" name="type_3_arrangement" value="0" %type_3_arrangement_0_checked% class="radio" /> <label for="type_3_arrangement_0">横に並べて表示する</label>　
				<input type="radio" id="type_3_arrangement_1" name="type_3_arrangement" value="1" %type_3_arrangement_1_checked% class="radio" /> <label for="type_3_arrangement_1">縦にに並べて表示する</label>
				<ul class="note">
					<li>ラジオボタンの項目を横に並べて表示するか、縦に並べて表示するのかを選択してください。</li>
				</ul>
			</dd>
		</dl>
	</fieldset>
	</div>
	</TMPL_IF>
	<!-- ラジオボタン end -->
	<!-- チェックボックス start -->
	<TMPL_IF NAME="type_4">
	<div id="type_4_box">
	<fieldset>
		<legend>チェックボックス詳細情報</legend>
		<dl>
			<dt><label class="required %type_4_elements_err%">選択項目</label></dt>
			<dd>
				<textarea name="type_4_elements" cols="80" rows="5" id="type_4_elements" class="textarea %type_4_elements_err%">%type_4_elements%</textarea>
				<ul class="note">
					<li>チェックボックスの選択項目を入力してください。一つの項目を1行で記述し、改行を入れて項目を追加してください。</li>
					<li>先頭に * を入れると、事前にチェックされた状態となります。</li>
				</ul>
			</dd>
		</dl>
		<dl>
			<dt><label class="required %type_4_arrangement_err%">表示方法</label></dt>
			<dd>
				<input type="radio" id="type_4_arrangement_0" name="type_4_arrangement" value="0" %type_4_arrangement_0_checked% class="radio" /> <label for="type_4_arrangement_0">横に並べて表示する</label>　
				<input type="radio" id="type_4_arrangement_1" name="type_4_arrangement" value="1" %type_4_arrangement_1_checked% class="radio" /> <label for="type_4_arrangement_1">縦にに並べて表示する</label>
				<ul class="note">
					<li>チェックボックスの項目を横に並べて表示するか、縦に並べて表示するのかを選択してください。</li>
				</ul>
			</dd>
		</dl>
		<dl class="last">
			<dt><label class="%type_4_maxlength_err% %type_4_minlength_err%">選択数制限</label></dt>
			<dd>
				最小 <input type="text" id="type_4_minlength" name="type_4_minlength" value="%type_4_minlength%" maxlength="10" class="text inputlimit_num %type_4_minlength_err%" /> 個 ～
				最大 <input type="text" id="type_4_maxlength" name="type_4_maxlength" value="%type_4_maxlength%" maxlength="10" class="text inputlimit_num %type_4_maxlength_err%" /> 個
				<ul class="note">
					<li>チェックを入れる数に制限を設けたい場合は、その数を指定してください。</li>
				</ul>
			</dd>
		</dl>
	</fieldset>
	</div>
	</TMPL_IF>
	<!-- チェックボックス end -->
	<!-- セレクトメニュー start -->
	<TMPL_IF NAME="type_5">
	<div id="type_5_box">
	<fieldset>
		<legend>セレクトメニュー詳細情報</legend>
		<dl>
			<dt><label class="required %type_5_elements_err%">選択項目</label></dt>
			<dd>
				<textarea name="type_5_elements" cols="80" rows="5" id="type_5_elements" class="textarea %type_5_elements_err%">%type_5_elements%</textarea>
				<ul class="note">
					<li>セレクトメニューの選択項目を入力してください。一つの項目を1行で記述し、改行を入れて項目を追加してください。</li>
					<li>先頭に <code>^</code> (半角ハット）を入れると、未選択用の項目になります。（option要素のvalue属性に空の値がセットされます。)</li>
					<li>先頭に <code>*</code> (半角アスタリスク）を入れると、事前に選択された状態となります。（option要素にselectec属性がセットされます。)</li>
				</ul>
			</dd>
		</dl>
		<dl class="last">
			<dt><label class="%type_5_multiple_err%">複数行選択</label></dt>
			<dd>
				<input type="checkbox" id="type_5_multiple_1" name="type_5_multiple" value="1" %type_5_multiple_1_checked% class="checkbox" /> <label for="type_5_multiple_1">複数行選択を可能とする</label>
				<ul class="note">
					<li>チェックを入れた場合は、select要素にmultiple属性がセットされ、size属性には登録された選択項目数がセットされます。</li>
				</ul>
			</dd>
		</dl>
		<dl class="last" id="type_5_maxlength_box">
			<dt><label class="%type_5_maxlength_err% %type_5_minlength_err%">選択数制限</label></dt>
			<dd>
				最小 <input type="text" id="type_5_minlength" name="type_5_minlength" value="%type_5_minlength%" maxlength="10" class="text inputlimit_num %type_5_minlength_err%" /> 個 ～
				最大 <input type="text" id="type_5_maxlength" name="type_5_maxlength" value="%type_5_maxlength%" maxlength="10" class="text inputlimit_num %type_5_maxlength_err%" /> 個
				<ul class="note">
					<li>選択数に制限を設けたい場合は、その数を指定してください。</li>
				</ul>
			</dd>
		</dl>
	</fieldset>
	</div>
	</TMPL_IF>
	<!-- チェックボックス end -->
	<!-- テキストエリア start -->
	<TMPL_IF NAME="type_6">
	<div id="type_6_box">
	<fieldset>
		<legend>テキストエリア詳細情報</legend>
		<dl>
			<dt><label class="required %type_6_cols_err% %type_6_rows_err%">サイズ</label></dt>
			<dd>
				横 <input type="text" id="type_6_cols" name="type_6_cols" value="%type_6_cols%" maxlength="10" class="text inputlimit_num %type_6_cols_err%" /> 文字 ×
				縦 <input type="text" id="type_6_rows" name="type_6_rows" value="%type_6_rows%" maxlength="10" class="text inputlimit_num %type_6_rows_err%" /> 行
				<ul class="note">
					<li>テキストエリアの横と縦のサイズを指定してください。</li>
				</ul>
			</dd>
		</dl>
		<dl>
			<dt><label class="required %type_6_maxlength_err% %type_6_minlength%">入力文字数制限</label></dt>
			<dd>
				最小 <input type="text" id="type_6_minlength" name="type_6_minlength" value="%type_6_minlength%" maxlength="10" class="text inputlimit_num %type_6_minlength_err%" /> 文字 ～
				最大 <input type="text" id="type_6_maxlength" name="type_6_maxlength" value="%type_6_maxlength%" maxlength="10" class="text inputlimit_num %type_6_maxlength_err%" /> 文字
				<ul class="note">
					<li>もしテキストエリアに入力文字数制限を設けたい場合は、その文字数を指定してください。</li>
					<li>最小文字数は必須ではありませんが、最大文字数は必須です。</li>
					<li>テキストエリアの場合は、改行も文字数に含めて評価されます。</li>
				</ul>
			</dd>
		</dl>
		<dl>
			<dt><label class="%type_6_convert_1_err% %type_6_convert_2_err% %type_6_convert_3_err% %type_6_convert_4_err% %type_6_convert_5_err%">入力値変換</label></dt>
			<dd>
				<div>
					変換ルール1：
					<select name="type_6_convert_1" id="type_6_convert_1" class="select %type_6_convert_1_err%">
						<option value="">変換しない</option>
						<TMPL_LOOP NAME="type_6_convert_loop_1"><option value="%code%" %selected%>%label%</option></TMPL_LOOP>
					</select>
				</div>
				<div>
					変換ルール2：
					<select name="type_6_convert_2" id="type_6_convert_2" class="select %type_6_convert_2_err%">
						<option value="">変換しない</option>
						<TMPL_LOOP NAME="type_6_convert_loop_2"><option value="%code%" %selected%>%label%</option></TMPL_LOOP>
					</select>
				</div>
				<div>
					変換ルール3：
					<select name="type_6_convert_3" id="type_6_convert_3" class="select %type_6_convert_3_err%">
						<option value="">変換しない</option>
						<TMPL_LOOP NAME="type_6_convert_loop_3"><option value="%code%" %selected%>%label%</option></TMPL_LOOP>
					</select>
				</div>
				<div>
					変換ルール4：
					<select name="type_6_convert_4" id="type_6_convert_4" class="select %type_6_convert_4_err%">
						<option value="">変換しない</option>
						<TMPL_LOOP NAME="type_6_convert_loop_4"><option value="%code%" %selected%>%label%</option></TMPL_LOOP>
					</select>
				</div>
				<div>
					変換ルール5：
					<select name="type_6_convert_5" id="type_6_convert_5" class="select %type_6_convert_5_err%">
						<option value="">変換しない</option>
						<TMPL_LOOP NAME="type_6_convert_loop_5"><option value="%code%" %selected%>%label%</option></TMPL_LOOP>
					</select>
				</div>
			</dd>
		</dl>
		<dl class="last">
			<dt><label for="type_6_value" class="%type_6_value_err%">デフォルト値</label></dt>
			<dd>
				<textarea name="type_6_value" id="type_6_value" cols="80" rows="3" class="textarea %type_6_value_err%">%type_6_value%</textarea>
				<ul class="note">
					<li>テキストエリアに値をプリセットしたい場合は、上記入力欄に入力してください。</li>
				</ul>
			</dd>
		</dl>
	</fieldset>
	</div>
	</TMPL_IF>
	<!-- テキストエリア end -->
	<!-- ファイル添付 start -->
	<TMPL_IF NAME="type_7">
	<div id="type_7_box">
	<fieldset>
		<legend>ファイル添付詳細情報</legend>
		<dl>
			<dt><label for="type_7_maxsize" class="required %type_7_maxsize_err%">添付ファイルのサイズ制限</label></dt>
			<dd>
				<input type="text" id="type_7_maxsize" name="type_7_maxsize" value="%type_7_maxsize%" class="text inputlimit_num %type_7_maxsize_err%" /> MB
				<ul class="note">
					<li>添付ファイルのサイズ上限を指定してください。</li>
				</ul>
			</dd>
		</dl>
		<dl class="last">
			<dt><label for="type_7_allow_exts" class="%type_7_allow_exts_err%">添付ファイルの拡張子限定</label></dt>
			<dd>
				<textarea id="type_7_allow_exts" name="type_7_allow_exts" rows="3" cols="80" class="inputlimit_ascii textarea %type_7_allow_exts_err%">%type_7_allow_exts%</textarea>
				<ul class="note">
					<li>添付ファイルの拡張子を限定することができます。何も指定しなければすべてのファイルを送ることができますが、ここで一つでも指定すると、その拡張子のファイルしか送れないようになります。</li>
					<li>.gif のようにドットから指定してください。</li>
					<li>複数指定する場合には、改行を入れて記述してください。</li>
				</ul>
			</dd>
		</dl>
	</fieldset>
	</div>
	</TMPL_IF>
	<!-- ファイル添付 end -->
	<!-- 非表示フィールド start -->
	<TMPL_IF NAME="type_8">
	<div id="type_8_box">
	<fieldset>
		<legend>非表示フィールド詳細情報</legend>
		<dl>
			<dt><label class="%type_8_handover_err%">パラメータ引き継ぎ</label></dt>
			<dd>
				<input type="checkbox" id="type_8_handover_1" name="type_8_handover" value="1" %type_8_handover_1_checked% class="checkbox" /> <label for="type_8_handover_1">この項目をパラメータ引き継ぎに利用する</label>
				<ul class="note">
					<li>外部サイトからパラメータを引き継ぎたい場合はチェックを入れてください。</li>
				</ul>
			</dd>
		</dl>
		<dl>
			<dt><label class="required %type_8_maxlength_err% %type_8_minlength%">入力文字数制限</label></dt>
			<dd>
				最小 <input type="text" id="type_8_minlength" name="type_8_minlength" value="%type_8_minlength%" maxlength="10" class="text inputlimit_num %type_8_minlength_err%" /> 文字 ～
				最大 <input type="text" id="type_8_maxlength" name="type_8_maxlength" value="%type_8_maxlength%" maxlength="10" class="text inputlimit_num %type_8_maxlength_err%" /> 文字
				<ul class="note">
					<li>最小文字数は必須ではありませんが、最大文字数は必須です。</li>
					<li>最大文字数は255文字が上限です。</li>
				</ul>
			</dd>
		</dl>
		<dl class="last">
			<dt><label for="type_8_value" class="%type_8_value_err%">固定値</label></dt>
			<dd>
				<input type="text" id="type_8_value" name="type_8_value" value="%type_8_value%" class="text %type_8_value_err%" />
				<ul class="note">
					<li>固定値を埋め込みたい場合は、上記入力欄にその値を255文字以内で入力してください。</li>
					<li>この項目をパラメータ引き継ぎに使う場合、この固定値は引き継ぎパラメータ値が空だった場合のデフォルト値として利用されます。</li>
				</ul>
			</dd>
		</dl>
	</fieldset>
	</div>
	</TMPL_IF>
	<!-- 非表示フィールド end -->

	<div><input type="submit" value="設定" name="setBtn" class="submit" /></div>
</form>
</div>
</body>
</html>
