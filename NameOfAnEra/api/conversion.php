<?php
header("Content-Type: application/json; charset=utf-8");
if(isset($_POST["nengo"])){
	$nengo = $_POST["nengo"];
	$url = "../data/nengo.json";
	$json = file_get_contents($url);
	$arr = json_decode($json,true);

	// 西暦から和暦に変換
	foreach ($arr as $value) {
		if ($nengo == $value["seireki"] ) {
			$rturnJson = array("seireki" => $value["seireki"], "wareki" => $value["wareki"]);
			echo json_encode($rturnJson);
			break;
		}
	}
}
?>
