(function () {

dom.event.addEventListener(window, "load", init);

function init() {
	if( document.getElementById("type_1_is_email_1") ) {
		dom.event.addEventListener(document.getElementById("type_1_is_email_1"), "change", type_1_is_email_change);
		dom.event.addEventListener(document.getElementById("type_1_is_email_1"), "click", type_1_is_email_change);
		type_1_is_email_change();
	}
	if( document.getElementById("type_5_multiple_1") ) {
		dom.event.addEventListener(document.getElementById("type_5_multiple_1"), "change", type_5_multiple_change);
		dom.event.addEventListener(document.getElementById("type_5_multiple_1"), "click", type_5_multiple_change);
		type_5_multiple_change();
	}
}

function type_1_is_email_change() {
	if(document.getElementById("type_1_is_email_1").checked == true) {
		document.getElementById("type_1_deny_emails_box").style.display = 'block';
	} else {
		document.getElementById("type_1_deny_emails_box").style.display = 'none';
	}
}

function type_5_multiple_change() {
	var type_5_maxlength_box = document.getElementById("type_5_maxlength_box");
	if(document.getElementById("type_5_multiple_1").checked == true) {
		type_5_maxlength_box.style.display = 'block';
	} else {
		type_5_maxlength_box.style.display = 'none';
	}
}

})();
