%xml_declaration%
<!DOCTYPE html PUBLIC "-//i-mode group (ja)//DTD XHTML i-XHTML(Locale/Ver.=ja/1.1) 1.0//EN" "i-xhtml_4ja_10.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="%ctype%" />
<title>入力画面</title>
</head>
<body>
<div style="background-color:#35556b;color:#ffffff;font-size:medium;">
<h1>入力画面</h1>
</div>
<div style="font-size:small;">
<div ><img src="%static_url%/imgs/spacer.gif" width="1" height="5" alt="" /></div>
<!-- エラー部 start -->
<TMPL_IF NAME="errs">
<div style="background-color:#aa0000"><img src="%static_url%/imgs/spacer.gif" width="1" height="1" alt="" /></div>
<div style="color:#ff0000;background-color:#ffeeee;">
<div style="font-weight:bold;">エラー</div>
<ul><TMPL_LOOP NAME="err_loop"><li>%err%</li></TMPL_LOOP></ul>
</div>
<div style="background-color:#aa0000"><img src="%static_url%/imgs/spacer.gif" width="1" height="1" alt="" /></div>
<div ><img src="%static_url%/imgs/spacer.gif" width="1" height="5" alt="" /></div>
</TMPL_IF>
<!-- エラー部 end -->
<!-- 入力部 start -->
%form%
<!-- 入力部 end -->
</div>
</body>
</html>


