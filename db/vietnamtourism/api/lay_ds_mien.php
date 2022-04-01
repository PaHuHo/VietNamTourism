<?php
$ver = $_GET["ver"];
require('../db.php');
$ds = $conn->prepare("SELECT * FROM mien");
$ds->execute();
$ds->setFetchMode(PDO::FETCH_ASSOC);
$result = $ds->fetchAll();
$conn=null;
if ($ver == 1) {
    $reTemp = $result["0"];
    $reTemp["id"] = "0";
    $reTemp["ten_mien"] = "Tat ca";
    array_unshift($result, $reTemp);
}

echo json_encode($result);
?>