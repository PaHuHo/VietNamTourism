<?php
require('../db.php');
$ds = $conn->prepare("SELECT bai_viet.*, ten_dia_danh, ten_nguoi_dung FROM bai_viet, dia_danh,tai_khoan WHERE tai_khoan_id=tai_khoan.id AND dia_danh_id=dia_danh.id ORDER BY bai_viet.ngay_tao DESC LIMIT 5");
$ds->execute();
$ds->setFetchMode(PDO::FETCH_ASSOC);
$result = $ds->fetchAll();
$conn=null;
echo json_encode($result);
?>