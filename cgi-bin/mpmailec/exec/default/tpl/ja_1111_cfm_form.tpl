<form action="%form_cgi_url%" method="post">
%hidden%
<div style="background-color:#35556b"><img src="%static_url%/imgs/spacer.gif" width="1" height="2" alt="" /></div>
<TMPL_LOOP NAME="item_loop">
<div style="background-color:#35556b"><img src="%static_url%/imgs/spacer.gif" width="1" height="1" alt="" /></div>
<div style="color:#35556b;background-color:#eeeeee;font-weight:bold;border-top:1px solid #35556b;border-bottom:1px solid #35556b;">
%caption%
<TMPL_IF NAME="required">(必須)</TMPL_IF>
</div>
<div style="background-color:#35556b"><img src="%static_url%/imgs/spacer.gif" width="1" height="1" alt="" /></div>
<div>
<div><img src="%static_url%/imgs/spacer.gif" width="1" height="5" alt="" /></div>
<TMPL_IF NAME="type_1">%value%</TMPL_IF>
<TMPL_IF NAME="type_2">%value_secret%</TMPL_IF>
<TMPL_IF NAME="type_3">%value%</TMPL_IF>
<TMPL_IF NAME="type_4">%element_loop%</TMPL_IF>
<TMPL_IF NAME="type_5">%element_loop%</TMPL_IF>
<TMPL_IF NAME="type_6">%value_with_br%</TMPL_IF>
<TMPL_IF NAME="type_7">%filename%</TMPL_IF>
<div><img src="%static_url%/imgs/spacer.gif" width="1" height="5" alt="" /></div>
</div>
</TMPL_LOOP>
<div style="background-color:#35556b"><img src="%static_url%/imgs/spacer.gif" width="1" height="2" alt="" /></div>
<div style="text-align:center;"><input type="submit" value="送信" /></div>
<div style="text-align:center;">[<a href="%back_url%">戻る</a>]</div>
</form>