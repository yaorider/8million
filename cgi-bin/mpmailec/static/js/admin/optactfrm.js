(function () {

dom.event.addEventListener(window, "load", init);

function init() {
	dom.event.addEventListener(document.getElementById("thx_redirect_enable_0"), "click", thx_redirect_enable_change);
	dom.event.addEventListener(document.getElementById("thx_redirect_enable_1"), "click", thx_redirect_enable_change);
	dom.event.addEventListener(document.getElementById("lang"), "change", lang_change);
	dom.event.addEventListener(document.getElementById("html_mobi_selectable_1"), "click", html_mobi_selectable_change);
	dom.event.addEventListener(document.getElementById("html_mobi_carrier_selectable_0"), "click", html_mobi_carrier_selectable_change);
	dom.event.addEventListener(document.getElementById("html_mobi_carrier_selectable_1"), "click", html_mobi_carrier_selectable_change);
	thx_redirect_enable_change();
	lang_change();
}

function lang_change() {
	var lang = document.getElementById("lang").value;
	/* */
	var available_list = {};
	if(lang == "ja") {
		available_list["0"] = 1;
		available_list["1"] = 1;
		available_list["2"] = 1;
		available_list["3"] = 1;
	} else {
		available_list["0"] = 1;
	}
	var rdos = document.getElementsByName("html_00_encoding");
	for( var i=0; i<rdos.length; i++ ) {
		var rdo = rdos.item(i);
		var lbl = document.getElementById("html_00_encoding_label_"+rdo.value);
		if( available_list[rdo.value] == 1 ) {
			rdo.disabled = false;
			lbl.style.color = "black";
		} else {
			rdo.checked = false;
			rdo.disabled = true;
			lbl.style.color = "#888888";
		}
	}
	/* */
	if(lang == "ja") {
		document.getElementById("html_mobi_selectable_box").style.display = "block";
		document.getElementById("html_mobi_carrier_selectable_box").style.display = "block";
		document.getElementById("html_mobi_doctype_box").style.display = "block";
		html_mobi_selectable_change();
	} else {
		document.getElementById("html_mobi_selectable_box").style.display = "none";
		document.getElementById("html_mobi_carrier_selectable_box").style.display = "none";
		document.getElementById("html_mobi_doctype_box").style.display = "none";
	}
}

function html_mobi_selectable_change() {
	if( document.getElementById("html_mobi_selectable_1").checked == true ) {
		document.getElementById("html_mobi_carrier_selectable_box").style.display = "block";
		document.getElementById("html_mobi_doctype_box").style.display = "block";
		html_mobi_carrier_selectable_change();
	} else {
		document.getElementById("html_mobi_carrier_selectable_box").style.display = "none";
		document.getElementById("html_mobi_doctype_box").style.display = "none";
	}
}

function html_mobi_carrier_selectable_change() {
	if( document.getElementById("html_mobi_carrier_selectable_1").checked == true ) {
		document.getElementById("html_mobi00_doctype_box").style.display = "none";
		document.getElementById("html_mobi01_doctype_box").style.display = "block";
	} else {
		document.getElementById("html_mobi00_doctype_box").style.display = "block";
		document.getElementById("html_mobi01_doctype_box").style.display = "none";
	}
}

function thx_redirect_enable_change() {
	var thx_box = document.getElementById("thx_box");
	if(document.getElementById("thx_redirect_enable_1").checked == true) {
		thx_box.style.display = 'block';
	} else {
		thx_box.style.display = 'none';
	}
}

})();
