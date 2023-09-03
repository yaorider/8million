(function () {

dom.event.addEventListener(window, "load", init);

function init() {
	dom.event.addEventListener(document.getElementById("rpy_enable_1"), "click", rpy_enable_change);
	rpy_enable_change();
}

function rpy_enable_change() {
	var rpy_box = document.getElementById("rpy_box");
	if(document.getElementById("rpy_enable_1").checked == true) {
		rpy_box.style.display = 'block';
	} else {
		rpy_box.style.display = 'none';
	}
}

})();
