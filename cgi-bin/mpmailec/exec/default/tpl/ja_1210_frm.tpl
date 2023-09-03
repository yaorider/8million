%xml_declaration%
<!DOCTYPE html PUBLIC "-//OPENWAVE//DTD XHTML 1.0//EN" "http://www.openwave.com/DTD/xhtml-basic.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="%ctype%" />
<meta http-equiv="Content-Language" content="%lang%" />
<title>入力画面</title>
<link href="%static_url%/css/mobi-au.css" rel="stylesheet" />
</head>
<body>
<h1>入力画面</h1>
<!-- エラー部 start -->
<TMPL_IF NAME="errs">
<div class="errs">
<p>エラー</p>
<ul><TMPL_LOOP NAME="err_loop"><li>%err%</li></TMPL_LOOP></ul>
</div>
</TMPL_IF>
<!-- エラー部 end -->
<!-- 入力部 start -->
%form%
<!-- 入力部 end -->
</body>
</html>