<form action="%form_cgi_url%" method="post">
<div class="fieldset">
%hidden%
<dl>
<TMPL_LOOP NAME="item_loop">
<dt>%caption%</dt>
<dd>
<TMPL_IF NAME="type_1">%value%</TMPL_IF>
<TMPL_IF NAME="type_2">%value_secret%</TMPL_IF>
<TMPL_IF NAME="type_3">%value%</TMPL_IF>
<TMPL_IF NAME="type_4">%element_loop%</TMPL_IF>
<TMPL_IF NAME="type_5">%element_loop%</TMPL_IF>
<TMPL_IF NAME="type_6">%value_with_br%</TMPL_IF>
<TMPL_IF NAME="type_7">%filename%</TMPL_IF>
&nbsp;
</dd>
</TMPL_LOOP>
</dl>
</div>
<p class="center"><input type="submit" value="送信" class="submit" /></p>
<p class="center">[<a href="%back_url%">戻る</a>]</p>
</form>