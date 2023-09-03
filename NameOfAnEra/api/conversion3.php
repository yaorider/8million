<?php
header("Content-Type: application/json; charset=utf-8");
if(isset($_POST["eraname"]) && isset($_POST["nengo"])){
	$eraname = $_POST["eraname"];
	$nengo = $_POST["nengo"];
	$url = "../data/nengo.json";
	$json = file_get_contents($url);
	$arr = json_decode($json,true);
	$returnJson = array();

	// 和暦から西暦に変換
	foreach ($arr as $value) {
		if ($eraname . $nengo == $value["wareki"] ) {
#			$returnJson = array("seireki" => $value["seireki"], "wareki" => $value["wareki"]);
			$seireki = $value["seireki"];
		}
	}

	foreach ($arr as $key => $value) {
		if ($seireki <= $value["seireki"]) {
			$returnJson = array_merge($returnJson,array("seireki". $key => $value["seireki"], "wareki" . $key => $value["wareki"]));
#			$returnJson += array("seireki". $key => $value["seireki"], "wareki" . $key => $value["wareki"]);
		}
	}
	echo json_encode($returnJson);
#var_dump($returnJson);
}
?>
