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
#acl_post_deny_sec { width:8em; }
</style>
<script type="text/javascript" src="%static_url%/js/dom.js"></script>
<script type="text/javascript" src="%static_url%/js/form.js"></script>
<script type="text/javascript" src="%static_url%/js/inputlimit.js"></script>
</head>
<body>
<h1><a href="%CGI_URL%?m=optcnfmnu">機能設定</a> &gt; アクセス制限設定</h1>
<div id="main">
<p>特定のIPアドレスからの受付禁止や、連続投稿禁止の設定を行います。設定入力後、画面下の「設定」ボタンを押してください。 </p>
<TMPL_IF NAME="errs"><div class="errs">%errs%</div></TMPL_IF>
<form method="post" action="%CGI_URL%">
	<input type="hidden" name="m" value="optaclset" />
	<input type="hidden" name="pkey" value="%pkey%" />
	<fieldset>
		<legend>アクセス制限設定</legend>
		<dl>
			<dt><label for="acl_deny_hosts" class="%acl_deny_hosts_err%">利用禁止ホスト</label></dt>
			<dd>
				<textarea id="acl_deny_hosts" name="acl_deny_hosts" rows="3" cols="80" class="inputlimit_ascii %acl_deny_hosts_err%">%acl_deny_hosts%</textarea>
				<ul class="note">
					<li>アクセスを禁止するホスト名またはIPアドレスを指定してください。指定のホストから投稿があった場合はエラーメッセージを表示します。</li>
					<li>ホスト名を指定した場合は後方一致で評価されます。たとえば、.example.com と指定すれば、ドメイン example.com からのアクセスをすべて拒否します。</li>
					<li>IPアドレスを指定した場合は前方一致で評価されます。たとえば、192.168.1. と指定すれば、192.168.1.0 ～ 192.168.1.255 からのアクセスをすべて拒否します。</li>
					<li>IPアドレスの場合は、192.168.1.0/24 のように、ビットマスクによって帯域を指定することが可能です。</li>
					<li>複数指定する場合には、改行を入れて記述してください。</li>
				</ul>
			</dd>
		</dl>
		<dl class="last">
			<dt><label for="acl_post_deny_sec" class="%acl_post_deny_sec_err%">連続投稿禁止設定</label></dt>
			<dd>
				<input type="text" id="acl_post_deny_sec" name="acl_post_deny_sec" value="%acl_post_deny_sec%" maxlength="10" class="text inputlimit_num %acl_post_deny_sec_err%" /> 秒間、次の投稿を禁止する
				<ul class="note">
					<li>一度投稿した利用者は、指定秒数を経過するまで次の投稿をすることができません。連続投稿禁止設定に何も設定しなかった場合、もしくは 0 を設定した場合には、連続投稿禁止機能が無効になります。</li>
					<li>基本的には、ここの設定は、数秒～10秒程度の範囲内で指定することをお勧めします。悪意を持って連続投稿を行おうとしても、10秒程度の制限があるだけでも十分に役立ちます。逆に、間違えて投稿してしまった人が、再度投稿しようとした場合を考慮したほうがよいでしょう。</li>
					<li>この機能は、投稿者のIPアドレスと投稿時間を記録していくことで実現しています。もしご利用のサーバがプロクシー機能が有効になっており、CGIへのアクセス元がすべてサーバのIPアドレスとなってしまう環境ではご利用いただけませんので注意してください。本システムでは、投稿者のIPアドレスを取得する際に環境変数の REMOTE_ADDR を使っています。詳細はご利用のサーバ事業者にお問合せください。</li>
				</ul>
			</dd>
		</dl>
	</fieldset>
	<div><input type="submit" value="設定" name="setBtn" class="submit" /></div>
</form>
</div>
</body>
</html>
