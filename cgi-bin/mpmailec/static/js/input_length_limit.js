(function () {

dom.event.addEventListener(window, "load", init);
var names = [];

function init() {
	var inputs = dom.core.getElementsByClassName(document, "length_limit");
	for( var i=0; i<inputs.length; i++ ) {
		var elm = inputs.item(i);
		if( ! elm ) { continue; }
		if( ! /^(INPUT|TEXTAERA)$/.test(elm.nodeName) ) { continue; }
		if( elm.nodeName == "INPUT" && ! /^(text|password)$/.test(elm.type) ) { continue; }
		if( elm.readOnly == true ) { continue; }
		if( elm.disabled == true ) { continue; }
		if( ! document.getElementById(elm.name + "_char_num") ) { continue; }
		if( ! document.getElementById(elm.name + "_max_char_num") && ! document.getElementById(elm.name + "_min_char_num") ) { continue; }
		dom.event.addEventListener(elm, "keyup", count_char_num);
		dom.event.addEventListener(elm, "focus", count_char_num);
		dom.event.addEventListener(elm, "blur", count_char_num);
		names.push(elm.name);
	}
	count_char_num();
}

function count_char_num() {
	for( var i=0; i<names.length; i++ ) {
		var elm = document.getElementsByName(names[i]).item(0);
		if( ! elm ) { continue; }
		var char_num = document.getElementById(names[i] + "_char_num");
		if( ! char_num ) { continue; }
		var max_char_num = document.getElementById(names[i] + "_max_char_num");
		if( ! max_char_num ) { continue; }
		var min_char_num = document.getElementById(names[i] + "_min_char_num");
		var n = elm.value.length;
		var max = parseInt(max_char_num.innerHTML);
		var min = 0;
		if(min_char_num) {
			min = parseInt(min_char_num.innerHTML);
		}
		if(n > max || n < min) {
			n = '<span class="input_length_err">' + n + '</span>';
		}
		char_num.innerHTML = n;
	}
}

})();
