(function () {

dom.event.addEventListener(window, "load", init);

function init() {
	dom.event.addEventListener(document.getElementById("atc_thumb_show_1"), "click", atc_thumb_show_change);
	atc_thumb_show_change();
}

function atc_thumb_show_change() {
	var atc_thumb_box = document.getElementById("atc_thumb_box");
	if(document.getElementById("atc_thumb_show_1").checked == true) {
		atc_thumb_box.style.display = 'block';
	} else {
		atc_thumb_box.style.display = 'none';
	}
}

})();
