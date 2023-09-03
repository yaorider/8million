(function () {

dom.event.addEventListener(window, "load", init);

function init() {
	dom.event.addEventListener(document.getElementById("log_enable_1"), "click", log_enable_change);
	log_enable_change();
}

function log_enable_change() {
	var log_box = document.getElementById("log_box");
	if(document.getElementById("log_enable_1").checked == true) {
		log_box.style.display = 'block';
	} else {
		log_box.style.display = 'none';
	}
}

})();
