(function () {

dom.event.addEventListener(window, "load", init);

function init() {
	var delBtn = document.getElementById("delBtn");
	if( delBtn ) {
		dom.event.addEventListener(document.getElementById("delBtn"), "click", debBtnClick);
	}
}

function debBtnClick() {
	var delBtn = document.getElementById("delBtn");
	delBtn.disabled = true;
	var name = document.getElementById("name").value;
	var pkey = "";
	for( var i=0; i<=delBtn.form.elements.length; i++ ) {
		var cntl = delBtn.form.elements.item(i);
		if(cntl.type == "hidden" && cntl.name == "pkey") {
			pkey = cntl.value;
			break;
		}
	}
	var url = delBtn.form.action + "?m=divdelset&name=" + name + "&pkey=" + pkey;
	document.location.href = url;
}

})();
