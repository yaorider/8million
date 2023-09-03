<?php
header("Content-Type: application/json; charset=utf-8");
if(isset($_POST["height"]) && isset($_POST["weight"]) && isset($_POST["sex"]) && isset($_POST["age"]) ) {
	$height = $_POST["height"];
	$weight = $_POST["weight"];
	$sex = $_POST["sex"];
	$age = $_POST["age"];

	$bmi = round(($weight / ($height*$height)) * 10000,2);
	$bestWeight = round((($height*$height) * 22) / 10000,2);
	$diffWeight = round($weight - $bestWeight);

	if ($sex==1) {
		$basalmetabolism = round(66 + 13.7 * $weight + 5.0 * $height - 6.8 * $age);
	} else if ($sex==2) {
		$basalmetabolism = round(665 + 9.6 * $weight + 1.7 * $height - 7.0 * $age);
	}


	$rturnJson = array("bmi" => $bmi, "bestWeight" => $bestWeight, "diffWeight" => $diffWeight, "basalmetabolism" => $basalmetabolism);
#	echo $bmi;
#	echo $bestWeight;
	echo json_encode($rturnJson);
}
?>
