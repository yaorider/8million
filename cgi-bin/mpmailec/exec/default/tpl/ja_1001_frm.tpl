%xml_declaration%
<!DOCTYPE html PUBLIC "-//WAPFORUM//DTD XHTML Mobile 1.0//EN" "http://www.wapforum.org/DTD/xhtml-mobile10.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="%lang%">
<head>
<meta http-equiv="Content-Type" content="%ctype%" />
<meta http-equiv="Content-Language" content="%lang%" />
<title>入力画面</title>
<link href="%static_url%/css/mobi-mp.css" rel="stylesheet" />
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