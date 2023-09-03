(function () {

dom.event.addEventListener(window, "load", init);

function init() {
	var seq_fmt_lst = document.getElementsByName("seq_fmt");
	for( var i=0; i<seq_fmt_lst.length; i++ ) {
		var seq_fmt_rdo = seq_fmt_lst.item(i);
		dom.event.addEventListener(seq_fmt_rdo, "click", seq_fmt_change);
	}
	seq_fmt_change();
}

function seq_fmt_change() {
	var seq_fmt_lst = document.getElementsByName("seq_fmt");
	var fmt;
	for( var i=0; i<seq_fmt_lst.length; i++ ) {
		var seq_fmt_rdo = seq_fmt_lst.item(i);
		if(seq_fmt_rdo.checked == true) {
			fmt = seq_fmt_rdo.value;
			break;
		}
	}
	/* */
	var tpl_elm = document.getElementById("seq_fmt_tpl");
	if(fmt == "1") {
		tpl_elm.value = "%SEQ%";
	} else if(fmt == "2") {
		tpl_elm.value = "%Y%-%m%-%d%-%SEQD%";
	} else if(fmt == "3") {
		tpl_elm.value = "%Y%-%m%-%SEQM%";
	} else if(fmt == "4") {
		tpl_elm.value = "%Y%-%SEQY%";
	}
	/* */
	if(fmt == "0") {
		tpl_elm.readOnly = false;
		tpl_elm.style.color = "black";
	} else {
		tpl_elm.readOnly = true;
		tpl_elm.style.color = "#888888";
	}
}

})();
