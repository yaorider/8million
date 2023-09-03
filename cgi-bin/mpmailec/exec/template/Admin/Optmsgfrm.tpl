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
textarea {height: 3.2em;}
</style>
<script type="text/javascript" src="%static_url%/js/dom.js"></script>
<script type="text/javascript" src="%static_url%/js/form.js"></script>
<script type="text/javascript" src="%static_url%/js/inputlimit.js"></script>
</head>
<body>
<h1><a href="%CGI_URL%?m=optcnfmnu">機能設定</a> &gt; メッセージ設定</h1>
<div id="main">
<p>本システムで出力する各種メッセージを定義します。HTMLタグおよび改行は無視されますので、ご注意ください。設定入力後、画面下の「設定」ボタンを押してください。 </p>
<TMPL_IF NAME="errs"><div class="errs">%errs%</div></TMPL_IF>
<form method="post" action="%CGI_URL%">
	<input type="hidden" name="m" value="optmsgset" />
	<input type="hidden" name="pkey" value="%pkey%" />
	<fieldset>
		<legend>不正アクセスエラーメッセージ</legend>
		<dl>
			<dt><label for="item_1_deny_emails" class="%item_1_deny_emails_err%">利用禁止メールアドレスエラーメッセージ</label></dt>
			<dd>
				<textarea id="item_1_deny_emails" name="item_1_deny_emails" rows="2" cols="80" class="%item_1_deny_emails_err%">%item_1_deny_emails%</textarea>
				<ul class="note">
					<li>メールアドレス入力欄に入力された値が禁止アドレスの条件に一致した場合に表示するメッセージを記述してください。</li>
				</ul>
			</dd>
		</dl>
		<dl>
			<dt><label for="acl_deny_hosts" class="%acl_deny_hosts_err%">利用禁止ホストエラーメッセージ</label></dt>
			<dd>
				<textarea id="acl_deny_hosts" name="acl_deny_hosts" rows="2" cols="80" class="%acl_deny_hosts_err%">%acl_deny_hosts%</textarea>
				<ul class="note">
					<li>利用禁止ホストから投稿があった場合に表示するメッセージを記述してください。</li>
				</ul>
			</dd>
		</dl>
		<dl class="last">
			<dt><label for="acl_post_deny" class="%acl_post_deny_err%">連続投稿エラーメッセージ</label></dt>
			<dd>
				<textarea id="acl_post_deny" name="acl_post_deny" rows="2" cols="80" class="%acl_post_deny_err%">%acl_post_deny%</textarea>
			</dd>
		</dl>
	</fieldset>
	<fieldset>
		<legend>入力不備エラーメッセージ</legend>
		<dl>
			<dt><label for="item_required" class="%item_required_err%">必須項目に入力・選択されなかった場合のエラーメッセージ</label></dt>
			<dd>
				<textarea id="item_required" name="item_required" rows="2" cols="80" class="%item_required_err%">%item_required%</textarea>
			</dd>
		</dl>
		<dl>
			<dt><label for="item_1_minlength" class="%item_1_minlength_err%">テキストフィールド - 入力文字数が最小文字数より少なかった場合のエラーメッセージ</label></dt>
			<dd>
				<textarea id="item_1_minlength" name="item_1_minlength" rows="2" cols="80" class="%item_1_minlength_err%">%item_1_minlength%</textarea>
			</dd>
		</dl>
		<dl>
			<dt><label for="item_1_maxlength" class="%item_1_maxlength_err%">テキストフィールド - 入力文字数が最大文字数より多かった場合のエラーメッセージ</label></dt>
			<dd>
				<textarea id="item_1_maxlength" name="item_1_maxlength" rows="2" cols="80" class="%item_1_maxlength_err%">%item_1_maxlength%</textarea>
			</dd>
		</dl>
		<dl>
			<dt><label for="item_2_minlength" class="%item_2_minlength_err%">パスワードフィールド - 入力文字数が最小文字数より少なかった場合のエラーメッセージ</label></dt>
			<dd>
				<textarea id="item_2_minlength" name="item_2_minlength" rows="2" cols="80" class="%item_2_minlength_err%">%item_2_minlength%</textarea>
			</dd>
		</dl>
		<dl>
			<dt><label for="item_2_maxlength" class="%item_2_maxlength_err%">パスワードフィールド - 入力文字数が最大文字数より多かった場合のエラーメッセージ</label></dt>
			<dd>
				<textarea id="item_2_maxlength" name="item_2_maxlength" rows="2" cols="80" class="%item_2_maxlength_err%">%item_2_maxlength%</textarea>
			</dd>
		</dl>
		<dl>
			<dt><label for="item_4_minlength" class="%item_4_minlength_err%">チェックボックス - 選択数が最小数より少なかった場合のエラーメッセージ</label></dt>
			<dd>
				<textarea id="item_4_minlength" name="item_4_minlength" rows="2" cols="80" class="%item_4_minlength_err%">%item_4_minlength%</textarea>
			</dd>
		</dl>
		<dl>
			<dt><label for="item_4_maxlength" class="%item_4_maxlength_err%">チェックボックス - 選択数が最大数より多かった場合のエラーメッセージ</label></dt>
			<dd>
				<textarea id="item_4_maxlength" name="item_4_maxlength" rows="2" cols="80" class="%item_4_maxlength_err%">%item_4_maxlength%</textarea>
			</dd>
		</dl>
		<dl>
			<dt><label for="item_5_minlength" class="%item_5_minlength_err%">セレクトメニュー - 選択数が最小数より少なかった場合のエラーメッセージ</label></dt>
			<dd>
				<textarea id="item_5_minlength" name="item_5_minlength" rows="2" cols="80" class="%item_5_minlength_err%">%item_5_minlength%</textarea>
			</dd>
		</dl>
		<dl>
			<dt><label for="item_5_maxlength" class="%item_5_maxlength_err%">セレクトメニュー - 選択数が最大数より多かった場合のエラーメッセージ</label></dt>
			<dd>
				<textarea id="item_5_maxlength" name="item_5_maxlength" rows="2" cols="80" class="%item_5_maxlength_err%">%item_5_maxlength%</textarea>
			</dd>
		</dl>
		<dl>
			<dt><label for="item_6_minlength" class="%item_6_minlength_err%">テキストエリア - 入力文字数が最小文字数より少なかった場合のエラーメッセージ</label></dt>
			<dd>
				<textarea id="item_6_minlength" name="item_6_minlength" rows="2" cols="80" class="%item_6_minlength_err%">%item_6_minlength%</textarea>
			</dd>
		</dl>
		<dl>
			<dt><label for="item_6_maxlength" class="%item_6_maxlength_err%">テキストエリア - 入力文字数が最大文字数より多かった場合のエラーメッセージ</label></dt>
			<dd>
				<textarea id="item_6_maxlength" name="item_6_maxlength" rows="2" cols="80" class="%item_6_maxlength_err%">%item_6_maxlength%</textarea>
			</dd>
		</dl>
		<dl>
			<dt><label for="item_7_allow_exts" class="%item_7_allow_exts_err%">ファイル添付 - 許可されていない拡張子だった場合のエラーメッセージ</label></dt>
			<dd>
				<textarea id="item_7_allow_exts" name="item_7_allow_exts" rows="2" cols="80" class="%item_7_allow_exts_err%">%item_7_allow_exts%</textarea>
			</dd>
		</dl>
		<dl>
			<dt><label for="item_7_maxsize" class="%item_7_maxsize_err%">ファイル添付 - 添付ファイルのサイズ制限をオーバーした場合のエラーメッセージ</label></dt>
			<dd>
				<textarea id="item_7_maxsize" name="item_7_maxsize" rows="2" cols="80" class="%item_7_maxsize_err%">%item_7_maxsize%</textarea>
			</dd>
		</dl>
		<dl class="last">
			<dt><label for="atc_max_total_size" class="%atc_max_total_size_err%">ファイル添付 - 添付ファイルの合計サイズ制限をオーバーした場合のエラーメッセージ</label></dt>
			<dd>
				<textarea id="atc_max_total_size" name="atc_max_total_size" rows="2" cols="80" class="%atc_max_total_size_err%">%atc_max_total_size%</textarea>
			</dd>
		</dl>
	</fieldset>
	<fieldset>
		<legend>入力値制限エラーメッセージ</legend>
		<dl>
			<dt><label for="restrict_en01" class="%restrict_en01_err%">半角数字のみ (0-9)</label></dt>
			<dd>
				<textarea id="restrict_en01" name="restrict_en01" rows="2" cols="80" class="%restrict_en01_err%">%restrict_en01%</textarea>
			</dd>
		</dl>
		<dl>
			<dt><label for="restrict_en02" class="%restrict_en02_err%">半角英字のみ (a-zA-Z)</label></dt>
			<dd>
				<textarea id="restrict_en02" name="restrict_en02" rows="2" cols="80" class="%restrict_en02_err%">%restrict_en02%</textarea>
			</dd>
		</dl>
		<dl>
			<dt><label for="restrict_en03" class="%restrict_en03_err%">半角英数字のみ (0-9a-zA-Z)</label></dt>
			<dd>
				<textarea id="restrict_en03" name="restrict_en03" rows="2" cols="80" class="%restrict_en03_err%">%restrict_en03%</textarea>
			</dd>
		</dl>
		<dl>
			<dt><label for="restrict_en11" class="%restrict_en11_err%">メールアドレス - 文字列チェックのみ</label></dt>
			<dd>
				<textarea id="restrict_en11" name="restrict_en11" rows="2" cols="80" class="%restrict_en11_err%">%restrict_en11%</textarea>
			</dd>
		</dl>
		<dl>
			<dt><label for="restrict_en12" class="%restrict_en12_err%">メールアドレス - 文字列チェック + DNSによるドメインチェック</label></dt>
			<dd>
				<textarea id="restrict_en12" name="restrict_en12" rows="2" cols="80" class="%restrict_en12_err%">%restrict_en12%</textarea>
			</dd>
		</dl>
		<dl>
			<dt><label for="restrict_en21" class="%restrict_en21_err%">URL - 文字列チェックのみ</label></dt>
			<dd>
				<textarea id="restrict_en21" name="restrict_en21" rows="2" cols="80" class="%restrict_en21_err%">%restrict_en21%</textarea>
			</dd>
		</dl>
		<dl>
			<dt><label for="restrict_en22" class="%restrict_en22_err%">URL - 文字列チェック + HTTP通信による実在チェック</label></dt>
			<dd>
				<textarea id="restrict_en22" name="restrict_en22" rows="2" cols="80" class="%restrict_en22_err%">%restrict_en22%</textarea>
			</dd>
		</dl>
		<dl>
			<dt><label for="restrict_en31" class="%restrict_en31_err%">電話番号（日本国内向け）- 半角/固定電話/ハイフンなし (例:0312345678)</label></dt>
			<dd>
				<textarea id="restrict_en31" name="restrict_en31" rows="2" cols="80" class="%restrict_en31_err%">%restrict_en31%</textarea>
			</dd>
		</dl>
		<dl>
			<dt><label for="restrict_en32" class="%restrict_en32_err%">電話番号（日本国内向け）- 半角/固定電話/ハイフンあり (例:03-1234-5678)</label></dt>
			<dd>
				<textarea id="restrict_en32" name="restrict_en32" rows="2" cols="80" class="%restrict_en32_err%">%restrict_en32%</textarea>
			</dd>
		</dl>
		<dl>
			<dt><label for="restrict_en33" class="%restrict_en33_err%">電話番号（日本国内向け）- 半角/携帯・PHS/ハイフンなし (例:09012345678)</label></dt>
			<dd>
				<textarea id="restrict_en33" name="restrict_en33" rows="2" cols="80" class="%restrict_en33_err%">%restrict_en33%</textarea>
			</dd>
		</dl>
		<dl>
			<dt><label for="restrict_en34" class="%restrict_en34_err%">電話番号（日本国内向け）- 半角/携帯・PHS/ハイフンあり (例:090-1234-5678)</label></dt>
			<dd>
				<textarea id="restrict_en34" name="restrict_en34" rows="2" cols="80" class="%restrict_en34_err%">%restrict_en34%</textarea>
			</dd>
		</dl>
		<dl>
			<dt><label for="restrict_en35" class="%restrict_en35_err%">電話番号（日本国内向け）- 半角/電話全般/ハイフンなし</label></dt>
			<dd>
				<textarea id="restrict_en35" name="restrict_en35" rows="2" cols="80" class="%restrict_en35_err%">%restrict_en35%</textarea>
			</dd>
		</dl>
		<dl>
			<dt><label for="restrict_en36" class="%restrict_en36_err%">電話番号（日本国内向け）- 半角/電話全般/ハイフンあり</label></dt>
			<dd>
				<textarea id="restrict_en36" name="restrict_en36" rows="2" cols="80" class="%restrict_en36_err%">%restrict_en36%</textarea>
			</dd>
		</dl>

		<dl>
			<dt><label for="restrict_en41" class="%restrict_en41_err%">郵便番号（日本国内向け） - 半角/ハイフンなし (例：1234567)</label></dt>
			<dd>
				<textarea id="restrict_en41" name="restrict_en41" rows="2" cols="80" class="%restrict_en41_err%">%restrict_en41%</textarea>
			</dd>
		</dl>
		<dl>
			<dt><label for="restrict_en42" class="%restrict_en42_err%">郵便番号（日本国内向け） - 半角/ハイフンあり (例：123-4567)</label></dt>
			<dd>
				<textarea id="restrict_en42" name="restrict_en42" rows="2" cols="80" class="%restrict_en42_err%">%restrict_en42%</textarea>
			</dd>
		</dl>
		<TMPL_IF NAME="lang_ja">
		<dl>
			<dt><label for="restrict_ja01" class="%restrict_ja01_err%">全角数字のみ (０-９)</label></dt>
			<dd>
				<textarea id="restrict_ja01" name="restrict_ja01" rows="2" cols="80" class="%restrict_ja01_err%">%restrict_ja01%</textarea>
			</dd>
		</dl>
		<dl>
			<dt><label for="restrict_ja02" class="%restrict_ja02_err%">全角アルファベットのみ (ａ-ｚＡ-Ｚ)</label></dt>
			<dd>
				<textarea id="restrict_ja02" name="restrict_ja02" rows="2" cols="80" class="%restrict_ja02_err%">%restrict_ja02%</textarea>
			</dd>
		</dl>
		<dl>
			<dt><label for="restrict_ja03" class="%restrict_ja03_err%">全角英数のみ (０-９ａ-ｚＡ-Ｚ)</label></dt>
			<dd>
				<textarea id="restrict_ja03" name="restrict_ja03" rows="2" cols="80" class="%restrict_ja03_err%">%restrict_ja03%</textarea>
			</dd>
		</dl>
		<dl>
			<dt><label for="restrict_ja04" class="%restrict_ja04_err%">全角ひらがなのみ</label></dt>
			<dd>
				<textarea id="restrict_ja04" name="restrict_ja04" rows="2" cols="80" class="%restrict_ja04_err%">%restrict_ja04%</textarea>
			</dd>
		</dl>
		<dl class="last">
			<dt><label for="restrict_ja05" class="%restrict_ja05_err%">全角カタカナのみ</label></dt>
			<dd>
				<textarea id="restrict_ja05" name="restrict_ja05" rows="2" cols="80" class="%restrict_ja05_err%">%restrict_ja05%</textarea>
			</dd>
		</dl>
		</TMPL_IF>
	</fieldset>
	<fieldset>
		<legend>再入力エラーメッセージ</legend>
		<dl class="last">
			<dt><label for="chk_mismatched" class="%chk_mismatched_err%">再入力エラーメッセージ</label></dt>
			<dd class="last">
				<textarea id="chk_mismatched" name="chk_mismatched" rows="2" cols="80" class="%chk_mismatched_err%">%chk_mismatched%</textarea>
				<ul class="note">
					<li>再入力設定で指定された2つの項目の入力値が一致しない場合のメッセージを記述してください。</li>
				</ul>
			</dd>
		</dl>
	</fieldset>
	<div><input type="submit" value="設定" name="setBtn" class="submit" /></div>
</form>
</div>
</body>
</html>
