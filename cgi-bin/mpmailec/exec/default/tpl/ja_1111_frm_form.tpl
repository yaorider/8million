<form action="%form_cgi_url%" method="post"<TMPL_IF NAME="with_atc"> enctype="multipart/form-data"</TMPL_IF>>
<div style="background-color:#35556b"><img src="%static_url%/imgs/spacer.gif" width="1" height="2" alt="" /></div>
%hidden%
<TMPL_LOOP NAME="item_loop">
<div style="background-color:#35556b"><img src="%static_url%/imgs/spacer.gif" width="1" height="1" alt="" /></div>
<div style="color:#35556b;background-color:#eeeeee;font-weight:bold;">
%caption%
<TMPL_IF NAME="required">(必須)</TMPL_IF>
</div>
<div style="background-color:#35556b"><img src="%static_url%/imgs/spacer.gif" width="1" height="1" alt="" /></div>
<div>
<div><img src="%static_url%/imgs/spacer.gif" width="1" height="5" alt="" /></div>
<TMPL_IF NAME="desc"><div>%desc%</div></TMPL_IF>
<TMPL_IF NAME="type_1"><input type="text" name="%name%" value="%value%" maxlength="%type_1_maxlength%" style="width:%type_1_width%" /></TMPL_IF>
<TMPL_IF NAME="type_2"><input type="password" name="%name%" value="%value%" maxlength="%type_2_maxlength%" style="width:%type_2_width%" /></TMPL_IF>
<TMPL_IF NAME="type_3"><TMPL_LOOP NAME="element_loop"><span style="margin-right:1em;"><input type="radio" name="%name%" value="%element%" %checked% /> %element%</span><TMPL_IF NAME="type_3_arrangement"><TMPL_UNLESS NAME="__last__"><br /></TMPL_UNLESS></TMPL_IF></TMPL_LOOP></TMPL_IF>
<TMPL_IF NAME="type_4"><TMPL_LOOP NAME="element_loop"><span style="margin-right:1em;"><input type="checkbox" name="%name%" value="%element%" %checked% /> %element%</span><TMPL_IF NAME="type_4_arrangement"><TMPL_UNLESS NAME="__last__"><br /></TMPL_UNLESS></TMPL_IF></TMPL_LOOP></TMPL_IF>
<TMPL_IF NAME="type_5"><select name="%name%" id="%name%"<TMPL_IF NAME="type_5_multiple_1"> multiple="multiple" size="%element_num%"</TMPL_IF>><TMPL_LOOP NAME="element_loop"><option value="%value%" %selected%>%element%</option></TMPL_LOOP></select></TMPL_IF>
<TMPL_IF NAME="type_6"><textarea name="%name%" id="%name%" cols="%type_6_cols%" rows="%type_6_rows%">%value%</textarea></TMPL_IF>
<TMPL_IF NAME="type_7"><input type="file" name="%name%" id="%name%" style="width:%type_7_width%" />
%filename%</TMPL_IF>
<div><img src="%static_url%/imgs/spacer.gif" width="1" height="5" alt="" /></div>
</div>
</TMPL_LOOP>
<div style="background-color:#35556b"><img src="%static_url%/imgs/spacer.gif" width="1" height="2" alt="" /></div>
<div style="text-align:center;"><TMPL_IF NAME="confirm_enable"><input type="submit" value="確認画面へ" /><TMPL_ELSE><input type="submit" value="送信" /></TMPL_IF></div>
</form>