(function () {

dom.event.addEventListener(window, "load", init);

function init() {
	var delform = document.getElementById("delform");
	dom.event.addEventListener(delform, "submit", item_del_submit);
	var del_link_list = dom.core.getElementsByClassName(delform, "del_link");
	for( var i=0; i<del_link_list.length; i++ ) {
		dom.event.addEventListener(del_link_list.item(i), "click", del_link_click);
	}
	var del_chk_list = document.getElementsByName("target");
	for( var i=0; i<del_chk_list.length; i++ ) {
		dom.event.addEventListener(del_chk_list.item(i), "click", del_chk_click);
	}
	del_chk_click();
}

function del_chk_click() {
	var del_chk_list = document.getElementsByName("target");
	var delBtn_disabled = true;
	for( var i=0; i<del_chk_list.length; i++ ) {
		var chk = del_chk_list.item(i);
		if(chk.checked == true) {
			delBtn_disabled = false;
			break;
		}
	}
	var delBtn = document.getElementsByName("delBtn").item(0);
	if(delBtn) {
		delBtn.disabled = delBtn_disabled;
	}
}

function item_del_submit(evt) {
	dom.event.preventDefault(evt);
	var resAction = function() {
		var delBtn = document.getElementsByName("delBtn").item(0);
		delBtn.disabled = true;
		var frm = document.getElementById("delform");
		frm.submit();
	};
	/* ボタン情報 */
	var buttonProperties = new Array(
		{
			"caption":"はい",
			"callback":resAction
		},
		{
			"caption":"いいえ",
			"callback":function() {}
		}
	);
	/* チェックされている項目 */
	var checked_name_list = [];
	var checkbox_list = document.getElementsByName("target");
	for( var i=0; i<checkbox_list.length; i++ ) {
		var checkbox = checkbox_list.item(i);
		if(checkbox.checked == true) {
			checked_name_list.push(checkbox.value);
		}
	}
	if(checked_name_list.length == 0) { return false; }
	/* タイトル */
	var title = "項目の一括削除";
	/* メッセージ */
	var msg = "選択された以下の項目を本当に削除してもよろしいですか？ よろしければ「はい」を押してください。<br />";
	for( var i=0; i<checked_name_list.length; i++ ) {
		var m = checked_name_list[i].match(/\d+_(\d+)/);
		var seq = m[1];
		var serial = "";
		var span = document.getElementById("serial_"+seq);
		if(span) {
			serial = span.firstChild.nodeValue;
		}
		msg += " ・";
		msg += serial;
		if( i != checked_name_list.length - 1 ) {
			msg += "<br />";
		}
	}
	msg += "</ul>";
	/* ダイアログ表示 */
	dialog.show(title, msg, buttonProperties);
}

function del_link_click(evt) {
	dom.event.preventDefault(evt);
	dom.event.stopPropagation(evt);
	var target = dom.event.target(evt);
	var anchor = find_parent_node(target, "A");
	var resAction = function() {
		document.location.href = anchor.href;
	};
	/* ボタン情報 */
	var buttonProperties = new Array(
		{
			"caption":"はい",
			"callback":resAction
		},
		{
			"caption":"いいえ",
			"callback":function() {}
		}
	);
	/* チェックされている項目 */
	var row = find_parent_node(target, "TR");
	var inputs = row.getElementsByTagName("INPUT");
	var m = inputs.item(0).value.match(/\d+_(\d+)/);
	var seq = m[1];
	var serial = "";
	var span = document.getElementById("serial_"+seq);
	if(span) {
		serial = span.firstChild.nodeValue;
	}
	/* タイトル */
	var title = "項目の個別削除";
	/* メッセージ */
	var msg = "選択された以下の項目を本当に削除してもよろしいですか？ よろしければ「はい」を押してください。<br />";
	msg += " ・";
	msg += serial;
	/* ダイアログ表示 */
	dialog.show(title, msg, buttonProperties);
}

function find_parent_node(child, tag) {
	var elm = child;
	var node;
	while( node = elm.parentNode ) {
		if(node.nodeName == tag) {
			return node;
		} else {
			elm = node;
		}
	}
}

})();
