<?php
$id=$_GET["id"];
require('../db.php');
$ds = $conn->prepare("SELECT bai_viet.*, ten_dia_danh FROM bai_viet, dia_danh WHERE dia_danh_id=dia_danh.id AND tai_khoan_id=$id ORDER BY bai_viet.ngay_tao DESC");
$ds->execute();
$ds->setFetchMode(PDO::FETCH_ASSOC);
$result = $ds->fetchAll();
$conn=null;
echo json_encode($result);
?>