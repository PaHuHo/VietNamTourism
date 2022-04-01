<?php
$ver = $_GET["ver"];
require('../db.php');
$ds = $conn->prepare("SELECT * FROM vung");
$ds->execute();
$ds->setFetchMode(PDO::FETCH_ASSOC);
$result = $ds->fetchAll();
$conn = null;
if ($ver == 1) {
    $reTemp = $result["0"];
    $reTemp["id"] = "0";
    $reTemp["ten_vung"] = "Tat ca";
    array_unshift($result, $reTemp);
}

echo json_encode($result);
