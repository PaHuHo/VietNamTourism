<?php
$userId=$_GET["id"];

require('../db.php');
$ds = $conn->prepare("SELECT * FROM trang_thai WHERE tai_khoan_id=$userId");
$ds->execute();
$ds->setFetchMode(PDO::FETCH_ASSOC);
$result = $ds->fetchAll();
$conn=null;
echo json_encode($result);
?>