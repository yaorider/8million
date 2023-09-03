<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01//EN" "http://www.w3.org/TR/html4/strict.dtd">
<html lang="%lang%">
<head>
<meta http-equiv="Content-Type" content="%ctype%">
<meta http-equiv="Content-Language" content="%lang%">
<meta http-equiv="Content-Style-Type" content="text/css">
<meta http-equiv="Content-Script-Type" content="text/javascript">
<title>入力画面</title>
<link href="%static_url%/css/default.css" type="text/css" rel="stylesheet">
<script type="text/javascript" src="%static_url%/js/form.js"></script>
</head>
<body>
<div id="mp-head"><h1>入力画面</h1></div>
<div id="mp-main">
<!-- エラー部 start -->
<TMPL_IF NAME="errs"><div class="errs"><ul><TMPL_LOOP NAME="err_loop"><li>%err%</li></TMPL_LOOP></ul></div></TMPL_IF>
<!-- エラー部 end -->
<!-- 入力部 start -->
%form%
<!-- 入力部 end -->
</div>
</body>
</html>