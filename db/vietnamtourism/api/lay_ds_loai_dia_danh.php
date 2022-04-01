<?php
$ver = $_GET["ver"];
require('../db.php');
$ds = $conn->prepare("SELECT * FROM loai_dia_danh ");
$ds->execute();
$ds->setFetchMode(PDO::FETCH_ASSOC);
$result = $ds->fetchAll();
$conn=null;
if ($ver == 1) {
    $reTemp = $result["0"];
    $reTemp["id"] = "0";
    $reTemp["ten"] = "Tat ca";
    array_unshift($result, $reTemp);
}
echo json_encode($result,JSON_UNESCAPED_UNICODE);
?>