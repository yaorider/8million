(function () {

dom.event.addEventListener(window, "load", init);

function init() {
	dom.event.addEventListener(document.getElementById("tpltype_1"), "click", tpltypeChange);
	dom.event.addEventListener(document.getElementById("tpltype_2"), "click", tpltypeChange);
	dom.event.addEventListener(document.getElementById("loadBtn"), "click", loadTpl);
	dom.event.addEventListener(document.getElementById("previewBtn"), "click", showPreview);
	tpltypeChange();
}

function tpltypeChange() {
	if( document.getElementById("tpltype_1").checked == true || document.getElementById("tpltype_2").checked == true ) {
		document.getElementById("loadBtn").disabled = false;
	} else {
		document.getElementById("loadBtn").disabled = true;
	}
}

function loadTpl() {
	if( document.getElementById("tpl").value != "" ) {
		var res = confirm("すでにテンプレートがセットされています。上書きしてもよろしいですか？");
		if( res == false ) {
			return false;
		}
	}
	var frm = document.getElementById("tpl").form;
	var url = frm.action + "?m=tplmaifrm&amp;tpltype=";
	if( document.getElementById("tpltype_1").checked == true ) {
		url += "1";
	} else if( document.getElementById("tpltype_2").checked == true ) {
		url += "2";
	} else {
		alert("モードを選択してください。");
	}
	document.location.href = url;
}

function showPreview() {
	var formElm = document.forms.item(0);
	var formElmTarget = formElm.target;
	var mElm = document.getElementsByName("m").item(0);
	var mElmVal = mElm.value;
	formElm.target = "_blank";
	mElm.value = "tplmaipvw";
	formElm.submit();
	formElm.target = formElmTarget;
	mElm.value = mElmVal;
}

})();
