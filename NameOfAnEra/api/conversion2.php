<?php
header("Content-Type: application/json; charset=utf-8");
if(isset($_POST["eraname"]) && isset($_POST["nengo"])){
	$eraname = $_POST["eraname"];
	$nengo = $_POST["nengo"];
	$url = "../data/nengo.json";
	$json = file_get_contents($url);
	$arr = json_decode($json,true);

	// 和暦から西暦に変換
	foreach ($arr as $value) {
		if (($eraname . $nengo) == $value["wareki"] ) {
			$rturnJson = array("seireki" => $value["seireki"], "wareki" => $value["wareki"]);
			echo json_encode($rturnJson);
			break;
		}
	}
}
?>
