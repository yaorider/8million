(function () {

dom.event.addEventListener(window, "load", init);

function init() {
	dom.event.addEventListener(document.getElementById("thx_type_0"), "click", thx_type_change);
	dom.event.addEventListener(document.getElementById("thx_type_1"), "click", thx_type_change);
	thx_type_change();
}

function thx_type_change() {
	var thx_box = document.getElementById("thx_box");
	if(document.getElementById("thx_type_1").checked == true) {
		thx_box.style.display = 'block';
	} else {
		thx_box.style.display = 'none';
	}
}

})();
