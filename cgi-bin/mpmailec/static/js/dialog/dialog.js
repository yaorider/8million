/* -------------------------------------------------------------------
* define objects ( name space) for this library.
* ----------------------------------------------------------------- */
var dialog = new Object();

(function () {

/* -------------------------------------------------------------------
* ウィンドウ表示
* ----------------------------------------------------------------- */
dialog.show = function(title, msg, propertyObj) {
	/* ウィンドウ枠を生成 */
	var frame = dialog._makeFrame(title, msg);
	/* ボタンを生成 */
	var buttons = dialog._makeButtom(propertyObj);
	/* ボタン領域にボタンを追加 */
	var btnarea = frame.getElementsByTagName('DIV').item(2);
	for(var i=0; i<buttons.length; i++) {
		btnarea.appendChild(buttons[i]);
	}
	/* ウィンドウ表示 */
	dialog._display(frame);
};

/* -------------------------------------------------------------------
* ▼以降、内部処理用関数
* ----------------------------------------------------------------- */

/* -------------------------------------------------------------------
* ウィンドウ削除処理
* ----------------------------------------------------------------- */
dialog._clear = function(evt) {
	/* ダイアログウィンドウ削除 */
	var frame = document.getElementById('dialog_frame');
	frame.parentNode.removeChild(frame);
	/* シャドー・レイヤー削除 */
	var shadow = document.getElementById('dialog_shadow');
	shadow.parentNode.removeChild(shadow);
};

/* -------------------------------------------------------------------
* ウィンドウ表示処理
* ----------------------------------------------------------------- */
dialog._display = function(elm) {
	/* 画面全体を覆うシャドー・レイヤーを生成表示 */
	dialog._makeShadowMask();
	/* BODYタグ内にウィンドウを追加 */
	elm.style.visibility = 'hidden';
	document.body.appendChild(elm);
	/* 位置をウィンドウ中央に移動 */
	dialog._setPositionCenter(elm);
	/* ウィンドウを可視化 */
	elm.style.visibility = 'visible';
	/* ドラッグ可能にする */
	var titlebar = document.getElementById('dialog_titlebar');
	dom.event.drag(elm, titlebar);
};

/* -------------------------------------------------------------------
* ウィンドウ枠を組み立てる
* ----------------------------------------------------------------- */
dialog._makeFrame = function(title, msg) {
	/* ウィンドウ枠を生成 */
	var frame = document.createElement('DIV');
	frame.id = 'dialog_frame';
	/* タイトルバー生成 */
	var titlebar = document.createElement('DIV');
	titlebar.id = 'dialog_titlebar';
	titlebar.appendChild( document.createTextNode(title) );
	/* メッセージ領域生成 */
	var msgarea = document.createElement('DIV');
	msgarea.id = 'dialog_msgarea';
	// msgarea.appendChild( document.createTextNode(msg) );
	msgarea.innerHTML = msg;
	/* ボタン領域生成 */
	var btnarea = document.createElement('DIV');
	btnarea.id = 'dialog_btnarea';
	/* ウィンドウの組み立て */
	frame.appendChild(titlebar);
	frame.appendChild(msgarea);
	frame.appendChild(btnarea);
	/* 要素ノードオブジェクトを返す */
	return frame;
};

/* -------------------------------------------------------------------
* ボタンを生成
* ----------------------------------------------------------------- */
dialog._makeButtom = function(buttonPropertyArray) {
	var buttons = new Array();
	for(var i=0; i<buttonPropertyArray.length; i++) {
		/* ボタン用のタグを生成 */
		var btn = document.createElement('INPUT');
		btn.type = 'button';
		btn.name = 'dialog_btn_' + i;
		btn.value = buttonPropertyArray[i].caption;
		btn.className = 'btn';
		/* clickイベントリスナーをセット */
		dom.event.addEventListener(btn, 'click', dialog._clear);
		var callback = buttonPropertyArray[i].callback
		dom.event.addEventListener(btn, 'click', callback);
		/* BUTTONタグのノードオブジェクトを配列に追加 */
		buttons.push(btn);
	}
	return buttons;
};

/* -------------------------------------------------------------------
* シャドー・レイヤーを生成・表示
* ----------------------------------------------------------------- */
dialog._makeShadowMask = function() {
	var shadow = document.createElement('DIV');
	shadow.id = 'dialog_shadow';
	document.body.appendChild(shadow);
	shadow.style.width = '100%';
	shadow.style.height = '100%';
	/* Internet Explorer 6対策*/
	var wsize = dom.misc.getWindowSize();
	var shadow_width = parseInt(shadow.offsetWidth);
	var shadow_height = parseInt(shadow.offsetHeight);
	if(shadow_width < wsize.width || shadow_height < wsize.height) {
		shadow.style.width = wsize.width + 'px';
		shadow.style.height = wsize.height + 'px';
		var shadowResize = function() {
			var new_wsize = dom.misc.getWindowSize();
			shadow.style.width = new_wsize.width + 'px';
			shadow.style.height = new_wsize.height + 'px';
		};
		dom.event.addEventListener(window, 'resize', shadowResize);
	}
};

/* -------------------------------------------------------------------
* 要素をブラウザー表示領域中央に移動
* ----------------------------------------------------------------- */
dialog._setPositionCenter = function(elm) {
	/* ブラウザー表示領域のサイズを取得 */
	var wsize = dom.misc.getWindowSize();
	/* 中心に移動 */
	var left = ( wsize.width - elm.offsetWidth ) / 2;
	elm.style.left = parseInt(left) + 'px';
	var top = ( wsize.height - elm.offsetHeight ) / 2;
	elm.style.top = parseInt(top) + 'px';
	/* IE6対策 */
	if( document.uniqueID && elm.currentStyle.getAttribute('position') == 'absolute' ) {
		elm.style.top = document.documentElement.scrollTop + top + 'px';
	}
};

/* -------------------------------------------------------------------
* ▼以降、DOM関連の処理
* ----------------------------------------------------------------- */
var dom = new Object();
dom.event = new Object();
dom.misc = new Object();

/* ------------------------------------------------------------------
[文法]
  dom.event.preventDefault(evt)
[説明]
  evtにセットされているイベントのデフォルト・アクションを抑止する。
[引数]
  ・evt
      Eventインタフェース・オブジェクト
[戻値]
  なし
------------------------------------------------------------------- */
dom.event.preventDefault = function(evt) {
	/* W3C DOM準拠ブラウザー */
	if(evt && evt.preventDefault) {
		evt.preventDefault();
		/* Safari 1.3対策 */
		evt.currentTarget['on'+evt.type] = function() {return false;};
	/* Internet Explorer */
	} else if(window.event) {
		window.event.returnValue = false;
	}
};

/* ------------------------------------------------------------------
[文法]
  dom.event.stopPropagation(evt)
[説明]
  evtにセットされているイベントの伝播を抑止する。
[引数]
  ・evt
      Eventインタフェース・オブジェクト
[戻値]
  なし
------------------------------------------------------------------- */
dom.event.stopPropagation = function(evt) {
	/* W3C DOM準拠ブラウザー */
	if(evt && evt.stopPropagation) {
		evt.stopPropagation();
	/* Internet Explorer */
	} else if(window.event) {
		window.event.cancelBubble = true;
	}
};

/* ------------------------------------------------------------------
[文法]
  dom.event.addEventListener(elm, type, func, useCapture)
[説明]
  イベント・リスナーをセットする。
[引数]
  ・elm
      要素ノードオブジェクト
  ・type
      イベント・タイプ
  ・func
      イベント・リスナー関数（コールバック関数）の関数オブジェクト
  ・useCapture
      trueが指定されればキャプチャー・フェーズを有効にする。
      ただし、Internet Explorerでは、trueを指定しても、有効にならず、
      バブリング・フェーズとしてセットされるので、注意すること。
[戻値]
  成功すればtrueを、失敗すればfalseを返す。
------------------------------------------------------------------- */
dom.event.addEventListener = function(elm, type, func, useCapture) {
	if(! elm) { return false; }
	if(! useCapture) {
		useCapture = false;
	}
	if(elm.addEventListener) {
		elm.addEventListener(type, func, false);
	} else if(elm.attachEvent) {
		elm.attachEvent('on'+type, func);
	} else {
		return false;
	}
	return true;
};

/* ------------------------------------------------------------------
[文法]
  dom.event.removeEventListener(elm, type, func, useCapture)
[説明]
  イベント・リスナーを解除する。引数には、リスナーをセットした際に指
  定したものと、すべて同じにすること。
[引数]
  ・elm
      要素ノードオブジェクト
  ・type
      イベント・タイプ
  ・func
      イベント・リスナー関数（コールバック関数）の関数オブジェクト
  ・useCapture
      キャプチャー・フェーズ（trueもしくはfalse）
[戻値]
  成功すればtrueを、失敗すればfalseを返す。
------------------------------------------------------------------- */
dom.event.removeEventListener = function(elm, type, func, useCapture) {
	if(! elm) { return false; }
	if(! useCapture) {
		useCapture = false;
	}
	if(elm.removeEventListener) {
		elm.removeEventListener(type, func, false);
	} else if(elm.detachEvent) {
		elm.detachEvent('on'+type, func);
	} else {
		return false;
	}
	return true;
};

/* ------------------------------------------------------------------
[文法]
  dom.event.drag(targetElm, dragableElm)
[説明]
  targetElmをドラッグ可能にする。dragableElmが指定されれば、その領域
  をドラッグ可能領域としてセットする。指定されなければ、targetElm全体
  がドラッグ可能領域としてセットする。
[引数]
  ・targetElm
      ドラッグの際に動かしたい領域の要素のノードオブジェクト
  ・dragableElm
      ドラッグ可能な領域の要素ノードオブジェクト（省略可）
[戻値]
  なし
------------------------------------------------------------------- */
dom.event.drag = function(targetElm, dragableElm) {
	if( ! targetElm ) { return; }
	if( ! dragableElm ) {
		dragableElm = targetElm;
	}
	/* 変数の初期化 */
	var mouseX, mouseY, targetX, targetY;
	/* ブラウザーウィンドウサイズ */
	var winSize = dom.misc.getWindowSize();
	/* -------------------------------------
	* ドラッグ終了時のコールバック関数
	* ------------------------------------*/
	var dragEnd = function(evt) {
		/* documentのmousemoveイベントリスナーを解除 */
		dom.event.removeEventListener(document, 'mousemove', dragMove, false);
		/* documentのmouseupイベントリスナーを解除 */
		dom.event.removeEventListener(document, 'mouseup', dragEnd, false);
		/* イベント伝播の抑止 */
		dom.event.stopPropagation(evt);
		/* デフォルト・アクションの抑止 */
		dom.event.preventDefault(evt);
	};
	/* -------------------------------------
	* ドラッグ中のコールバック関数
	* ------------------------------------*/
	var dragMove = function(evt) {
		/* 移動先の座標を計算 */
		var left = targetX - mouseX + evt.clientX;
		var top = targetY - mouseY + evt.clientY;
		var right = left + targetElm.offsetWidth;
		var bottom = top + targetElm.offsetHeight;
		/* 要素がブラウザー内であれば要素を移動 */
		if(
			left > 0 &&  right < winSize.width &&
			top > 0 && bottom < winSize.height
		) {
		targetElm.style.left = left + 'px';
		targetElm.style.top  = top + 'px';
		/* 要素がブラウザーからはみ出すようであればドラッグ終了 */
		} else {
			dragEnd();
		}
		/* イベント伝播の抑止 */
		dom.event.stopPropagation(evt);
		/* デフォルト・アクションの抑止 */
		dom.event.preventDefault(evt);
	};
	/* -------------------------------------
	* ドラッグ開始時のコールバック関数
	* ------------------------------------*/
	var dragStart = function(evt) {
		/* ブラウザーウィンドウサイズ */
		winSize = dom.misc.getWindowSize();
		/* ドラッグ開始時のマウスの座標 */
		mouseX = evt.clientX;
		mouseY = evt.clientY;
		/* ドラッグ開始時の要素の座標 */
		targetX = targetElm.offsetLeft;
		targetY = targetElm.offsetTop;
		/* documentにmousemoveイベントリスナーをセット */
		dom.event.addEventListener(document, 'mousemove', dragMove, false);
		/* documentにmouseupイベントリスナーをセット */
		dom.event.addEventListener(document, 'mouseup', dragEnd, false);
		/* イベント伝播の抑止 */
		dom.event.stopPropagation(evt);
		/* デフォルト・アクションの抑止 */
		dom.event.preventDefault(evt);
	};
	/* -------------------------------------
	* mousedownイベントリスナーをセット
	* ------------------------------------*/
	dom.event.addEventListener(dragableElm, 'mousedown', dragStart, false);
};

/* ------------------------------------------------------------------
[文法]
  dom.misc.getWindowSize()
[説明]
  ブラウザーのHTML表示領域のサイズをオブジェクトで返す。
[引数]
  なし
[戻値]
  サイズを格納したオブジェクト。widthプロパティに横長の値が、height
  プロパティに縦長の値がセットされる。
------------------------------------------------------------------- */
dom.misc.getWindowSize = function() {
	/* サイズを格納するオブジェクトを生成 */
	var obj = new Object();
	/* Internet Explorerの場合 */
	if( document.uniqueID ) {
		obj.width = document.documentElement.clientWidth;
		obj.height = document.documentElement.clientHeight;
	/* それ以外の場合 */
	} else {
		obj.width = window.innerWidth;
		obj.height = window.innerHeight;
	}
	/* サイズオブジェクトを返す */
	return obj;
};

})();
