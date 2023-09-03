(function () {

dom.event.addEventListener(window, "load", init);

function init() {
	var tbl = document.getElementById("listtbl");
	if( ! tbl ) { return ; }
	var del_link_list = dom.core.getElementsByClassName(tbl, "del_link");
	for( var i=0; i<del_link_list.length; i++ ) {
		dom.event.addEventListener(del_link_list.item(i), "click", del_link_click);
	}
	var cell_list = tbl.getElementsByTagName("TBODY").item(0).getElementsByTagName("TD");
	for( var i=0; i<cell_list.length; i++ ) {
		dom.event.addEventListener(cell_list.item(i), "click", cell_click);
	}
}

function cell_click(evt) {
	dom.event.stopPropagation(evt);
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
	/* タイトル */
	var title = "再入力設定の削除";
	/* メッセージ */
	var msg = "選択した項目を本当に削除してもよろしいですか？ よろしければ「はい」を押してください。";
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
