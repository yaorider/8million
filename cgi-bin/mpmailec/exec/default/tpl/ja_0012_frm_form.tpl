<form action="%form_cgi_url%" method="post"<TMPL_IF NAME="with_atc"> enctype="multipart/form-data"</TMPL_IF>>
<div class="fieldset">
%hidden%
<dl>
<TMPL_LOOP NAME="item_loop">
<dt><span class="title<TMPL_IF NAME="required"> required</TMPL_IF> %err%">%caption%</span></dt>
<dd>
<TMPL_IF NAME="desc"><p>%desc%</p></TMPL_IF>
<TMPL_IF NAME="type_1"><input type="text" name="%name%" id="%name%" value="%value%" maxlength="%type_1_maxlength%" style="width:%type_1_width%" class="text %err%" /></TMPL_IF>
<TMPL_IF NAME="type_2"><input type="password" name="%name%" id="%name%" value="%value%" maxlength="%type_2_maxlength%" style="width:%type_2_width%" class="text %err%" /></TMPL_IF>
<TMPL_IF NAME="type_3"><TMPL_LOOP NAME="element_loop"><span class="radioelement"><input type="radio" name="%name%" id="%name%_%no%" value="%element%" class="radio %err%" %checked% /> <label for="%name%_%no%">%element%</label></span><TMPL_IF NAME="type_3_arrangement"><TMPL_UNLESS NAME="__last__"><br></TMPL_UNLESS></TMPL_IF></TMPL_LOOP></TMPL_IF>
<TMPL_IF NAME="type_4"><TMPL_LOOP NAME="element_loop"><span class="checkelement"><input type="checkbox" name="%name%" id="%name%_%no%" value="%element%" class="checkbox %err%" %checked% /> <label for="%name%_%no%">%element%</label></span><TMPL_IF NAME="type_4_arrangement"><TMPL_UNLESS NAME="__last__"><br></TMPL_UNLESS></TMPL_IF></TMPL_LOOP></TMPL_IF>
<TMPL_IF NAME="type_5"><select name="%name%" id="%name%" class="select %err%"<TMPL_IF NAME="type_5_multiple_1"> multiple="multiple" size="%element_num%"</TMPL_IF>><TMPL_LOOP NAME="element_loop"><option value="%value%" %selected%>%element%</option></TMPL_LOOP></select></TMPL_IF>
<TMPL_IF NAME="type_6"><textarea name="%name%" id="%name%" cols="%type_6_cols%" rows="%type_6_rows%" class="textarea %err%">%value%</textarea></TMPL_IF>
<TMPL_IF NAME="type_7"><input type="file" name="%name%" id="%name%" style="width:%type_7_width%" class="file %err%" />
%filename%</TMPL_IF>
</dd>
</TMPL_LOOP>
</dl>
</div>
<p><TMPL_IF NAME="confirm_enable"><input type="submit" value="確認画面へ" class="submit" /><TMPL_ELSE><input type="submit" value="送信" class="submit" /></TMPL_IF></p>
</form>