(function () {

addEventListener(window, "load", init);

/* -------------------------------------------------------------------
* 初期化
* ----------------------------------------------------------------- */
function init() {
	var row_list = getElementsByClassName(document, "expand-row");
	for( var i=0; i<row_list.length; i++ ) {
		var row = row_list.item(i);
		if(row.nodeName != "TR") { continue; }
		if( ! /^expand\-row\-[\d\_\-]+$/.test(row.id) ) { continue; }
		addEventListener(row, "mouseover", row_mouse_over);
		addEventListener(row, "mouseout", row_mouse_out);
		addEventListener(row, "click", row_mouse_click);
		row.style.cursor = "pointer";
		var m = row.id.match(/^expand\-row\-([\d\_\-]+)$/);
		var box = document.getElementById("detail-row-" + m[1]);
		if(box) {
			box.style.display = "none";
		}
	}
}

/* -------------------------------------------------------------------
* 各種マウスアクション時の処理
* ----------------------------------------------------------------- */

function row_mouse_over(evt) {

}

function row_mouse_out(evt) {

}
function row_mouse_click(evt) {
	var target_elm = event_target(evt);
	if( target_elm ) {
		var tag = target_elm.nodeName;
		if(tag != "TR" && tag != "TD" && tag != "TH") {
			return;
		}
	}
	var row_id = this.id;
	if( ! row_id ) { return; }
	var m = row_id.match(/^expand\-row\-([\d\_\-]+)$/);
	if( m.length == 0 ) { return; }
	var box = document.getElementById("detail-row-" + m[1]);
	if( ! box ) { return; }
	if(box.style.display == "none") {
		box.style.display = "";
	} else {
		box.style.display = "none";
	}
}

/* -------------------------------------------------------------------
* ▼以降、DOM関連の処理
* ----------------------------------------------------------------- */

/* ------------------------------------------------------------------
[文法]
  addEventListener(elm, type, func, useCapture)
[説明]
  イベント・リスナーをセットする。
[引数]
  ・elm
      要素ノードオブジェクト
  ・type
      イベント・タイプ
  ・func
      イベント・リスナー関数（コールバック関数）の関数オブジェクト
[戻値]
  成功すればtrueを、失敗すればfalseを返す。
------------------------------------------------------------------- */
function addEventListener(elm, type, func) {
	if(! elm) { return false; }
	if(elm.addEventListener) {
		elm.addEventListener(type, func, false);
	} else if(elm.attachEvent) {
		/* 参考URL： http://ejohn.org/projects/flexible-javascript-events/ */
		elm['e'+type+func] = func;
		elm[type+func] = function(){elm['e'+type+func]( window.event );}
		elm.attachEvent( 'on'+type, elm[type+func] );
	} else {
		return false;
	}
	return true;
}

/* ------------------------------------------------------------------
[文法]
  getElementsByClassName(element, classNames)
[説明]
  指定の要素の子要素からclass属性値に一致する要素のリストを返す
[引数]
  ・element
      要素ノードオブジェクト
  ・classNames
      class属性値
[戻値]
  class属性値から要素のnodeListを返す
------------------------------------------------------------------- */
function getElementsByClassName(element, classNames) {
	if(element.getElementsByClassName) {
		return element.getElementsByClassName(classNames);
	}
	/* split a string on spaces */
	var split_a_string_on_spaces = function(string) {
		string = string.replace(/^[\t\s]+/, "");
		string = string.replace(/[\t\s]+$/, "");
		var tokens = string.split(/[\t\s]+/);
		return tokens;
	};
	var tokens = split_a_string_on_spaces(classNames);
	var tn = tokens.length;
	var nodes = element.all ? element.all : element.getElementsByTagName("*");
	var n = nodes.length;
	var array = new Array();
	if( tn > 0 ) {
		if( document.evaluate ) {
			var contains = new Array();
			for(var i=0; i<tn; i++) {
				contains.push('contains(concat(" ",@class," "), " '+ tokens[i] + '")');
			}
			var xpathExpression = "/descendant::*[" + contains.join(" and ") + "]";
			var iterator = document.evaluate(xpathExpression, element, null, XPathResult.ORDERED_NODE_SNAPSHOT_TYPE, null);
			var inum = iterator.snapshotLength;
			for( var i=0; i<inum; i++ ) {
				var elm = iterator.snapshotItem(i);
				if( elm != element ) {
					array.push(iterator.snapshotItem(i));
				}
			}
		} else {
			for(var i=0; i<n; i++) {
				var elm = nodes.item(i);
				if( elm.className == "" ) { continue; }
				var class_list = split_a_string_on_spaces(elm.className);
				var class_name = class_list.join(" ");
				var f = true;
				for(var j=0; j<tokens.length; j++) {
					var re = new RegExp('(^|\\s)' + tokens[j] + '(\\s|$)')
					if( ! re.test(class_name) ) {
						f = false;
						break;
					}
				}
				if(f == true) {
					array.push(elm);
				}
			}
		}
	}
	/* add item(index) method to the array as if it behaves such as a NodeList interface. */
	array.item = function(index) {
		if(array[index]) {
			return array[index];
		} else {
			return null;
		}
	};
	//
	return array;
}

function event_target(evt) {
	if(evt && evt.target) {
		if(evt.target.nodeType == 3) {
			return evt.target.parentNode;
		} else {
			return evt.target;
		}
	} else if(window.event && window.event.srcElement) {
		return window.event.srcElement;
	} else {
		return null;
	}
}

})();
