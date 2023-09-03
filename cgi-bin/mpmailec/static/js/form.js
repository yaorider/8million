(function () {

addEventListener(window, "load", init);
var label_map = new Object();

function init() {
	var frms = document.forms;
	for( var i=0; i<frms.length; i++ ) {
		addEventListener(frms.item(i), "submit", submitForm);
	}
	if(frms.length > 0) {
		for( var j=0; j<frms.length; j++ ) {
			var ctrls = frms.item(j).elements;
			for( var k=0; k<ctrls.length; k++ ) {
				var ctrl = ctrls.item(k);
				if( ( ctrl.nodeName == "INPUT" && ctrl.type.match(/^(text|password)$/) ) || ctrl.nodeName == "TEXTAREA" || ctrl.nodeName == "SELECT" ) {
					addEventListener(ctrl, "focus", ctrlFocus);
					addEventListener(ctrl, "blur", ctrlBlur);
				}
			}
		}
		var ctrls = frms.item(0).elements;
		for( var i=0; i<ctrls.length; i++ ) {
			var elm = ctrls.item(i);
			if( elm.disabled == true ) { continue; }
			if( elm.nodeName == "TEXTAREA" || elm.nodeName == "SELECT" || (elm.nodeName == "INPUT" && elm.type == "text") ) {
				elm.focus();
				/* カーソルの位置を変更 */
				if( elm.nodeName == "TEXTAREA" || (elm.nodeName == "INPUT" && elm.type == "text") ) {
					if(elm.setSelectionRange) {
						/* Firefox,Opera,Safariの場合 */
						elm.setSelectionRange(elm.value.length,elm.value.length); 
					} else if(elm.createTextRange) {
						/* Internet Explorerの場合 */
						var range = elm.createTextRange();
						range.move('character', elm.value.length);
						range.select();
					}
				}
				break;
			} else if( elm.nodeName == "INPUT" && (elm.type == "checkbox" || elm.type == "radio") ) {
				elm.focus();
				break;
			}
		}
	}
	buttonDisabled(false);
}

function ctrlFocus(e) {
	preventDefault(e)
	var ctrl = event_target(e);
	if( ! ctrl.className.match(/(^|\s)err(\s|$)/) ) {
		ctrl.style.backgroundColor = "#ffffff";
		ctrl.style.border = "1px solid #5794bf";
	}
}

function ctrlBlur(e) {
	preventDefault(e)
	var ctrl = event_target(e);
	if( ! ctrl.className.match(/(^|\s)err(\s|$)/) ) {
		ctrl.style.backgroundColor = "#fdfdfd";
		ctrl.style.border = "1px solid #abadb3";
	}
}

function submitForm(e) {
	preventDefault(e)
	buttonDisabled(true);
	var f = event_target(e);
	if(f.nodeName != 'FORM') {
		f = f.form;
	}
	f.submit();
}

function buttonDisabled(disabled) {
	var inputs = document.getElementsByTagName("INPUT");
	for( var i=0; i<inputs.length; i++ ) {
		var elm = inputs.item(i);
		if(elm.type == "submit" || elm.type == "reset" || elm.type == "image") {
			elm.disabled = disabled;
		}
	}
	var btns = document.getElementsByTagName("BUTTON");
	for( var i=0; i<btns.length; i++ ) {
		var elm = btns.item(i);
		elm.disabled = disabled;
	}
}

/* -------------------------------------------------------------------
* DOM
* ----------------------------------------------------------------- */

function addEventListener(elm, type, func) {
	if(! elm) { return false; }
	if(elm.addEventListener) {
		elm.addEventListener(type, func, false);
	} else if(elm.attachEvent) {
		elm['e'+type+func] = func;
		elm[type+func] = function(){elm['e'+type+func]( window.event );}
		elm.attachEvent( 'on'+type, elm[type+func] );
	} else {
		return false;
	}
	return true;
}

function event_target(evt) {
	if(evt && evt.target) {
		if(evt.target.nodeType == 3) {
			return evt.target.parentNode;
		} else {
			return evt.target;
		}
	} else if(window.event && window.event.srcElement) {
		return window.event.srcElement;
	} else {
		return null;
	}
}

function preventDefault(evt) {
	if(evt && evt.preventDefault) {
		evt.preventDefault();
		evt.currentTarget['on'+evt.type] = function() {return false;};
	} else if(window.event) {
		window.event.returnValue = false;
	}
}

})();
