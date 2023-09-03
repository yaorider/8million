(function () {

dom.event.addEventListener(window, "load", init);

function init() {
	var delform = document.getElementById("delform");
	dom.event.addEventListener(delform, "submit", item_del_submit);
	var del_link_list = dom.core.getElementsByClassName(delform, "del_link");
	for( var i=0; i<del_link_list.length; i++ ) {
		dom.event.addEventListener(del_link_list.item(i), "click", del_link_click);
	}
	var mod_link_list = dom.core.getElementsByClassName(delform, "mod_link");
	for( var i=0; i<mod_link_list.length; i++ ) {
		dom.event.addEventListener(mod_link_list.item(i), "click", mod_link_click);
	}
	var del_chk_list = document.getElementsByName("name");
	for( var i=0; i<del_chk_list.length; i++ ) {
		dom.event.addEventListener(del_chk_list.item(i), "click", del_chk_click);
	}
	var cell_list = delform.getElementsByTagName("TBODY").item(0).getElementsByTagName("TD");
	for( var i=0; i<cell_list.length; i++ ) {
		dom.event.addEventListener(cell_list.item(i), "click", cell_click);
	}
	dom.event.addEventListener(delform.getElementsByTagName("TBODY").item(0), "click", del_chk_click);
	del_chk_click();
}

function cell_click(evt) {
	var target = dom.event.target(evt);
	var row = find_parent_node(target, "TR");
	var inputs  = row.getElementsByTagName("INPUT");
	if( inputs.length == 0 || inputs.item(0).name != "name" ) {
		dom.event.stopPropagation(evt);
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
	var checkbox_list = document.getElementsByName("name");
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
		msg += " ・";
		msg += checked_name_list[i];
		if( i != checked_name_list.length - 1 ) {
			msg += "<br />";
		}
	}
	msg += "</ul>";
	/* ダイアログ表示 */
	dialog.show(title, msg, buttonProperties);
}

function del_chk_click() {
	var del_chk_list = document.getElementsByName("name");
	var delBtn_disabled = true;
	for( var i=0; i<del_chk_list.length; i++ ) {
		var chk = del_chk_list.item(i);
		if(chk.checked == true) {
			delBtn_disabled = false;
			break;
		}
	}
	var delBtn = document.getElementsByName("delBtn").item(0);
	delBtn.disabled = delBtn_disabled;
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
	var checked_value = inputs.item(0).value;
	/* タイトル */
	var title = "項目の個別削除";
	/* メッセージ */
	var msg = "選択された以下の項目を本当に削除してもよろしいですか？ よろしければ「はい」を押してください。<br />";
	msg += " ・";
	msg += checked_value;
	/* ダイアログ表示 */
	dialog.show(title, msg, buttonProperties);
}

function mod_link_click(evt) {
	dom.event.preventDefault(evt);
	dom.event.stopPropagation(evt);
	var target = dom.event.target(evt);
	var anchor = find_parent_node(target, "A");
	document.location.href = anchor.href;
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
