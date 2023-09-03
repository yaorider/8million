(function () {

dom.event.addEventListener(window, "load", init);

function init() {
	dom.event.addEventListener(document.getElementById("a8f_enable_1"), "click", a8f_enable_change);
	dom.event.addEventListener(document.getElementById("a8f_type_1"), "click", a8f_type_change);
	dom.event.addEventListener(document.getElementById("a8f_type_2"), "click", a8f_type_change);
	a8f_enable_change();
	a8f_type_change();
}

function a8f_type_change() {
	var a8f_item_num_box = document.getElementById("a8f_item_num_box");
	if(document.getElementById("a8f_type_1").checked == true) {
		a8f_item_num_box.style.display = 'block';
	} else {
		a8f_item_num_box.style.display = 'none';
	}
}

function a8f_enable_change() {
	var a8f_box = document.getElementById("a8f_box");
	if(document.getElementById("a8f_enable_1").checked == true) {
		a8f_box.style.display = 'block';
	} else {
		a8f_box.style.display = 'none';
	}
}

})();
