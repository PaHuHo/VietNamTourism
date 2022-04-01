<?php
$userId=$_GET["user_id"];
$baiVietId=$_GET["bai_viet_id"];
require('../db.php');
$ds = $conn->prepare("SELECT * FROM 
(
 SELECT trang_thai_like FROM tuong_tac WHERE bai_viet_id = $baiVietId AND tai_khoan_id=$userId
 UNION
 SELECT '0'
) AS subquery
LIMIT 1");
$ds->execute();
$ds->setFetchMode(PDO::FETCH_ASSOC);
$result = $ds->fetchAll();
$conn=null;
echo json_encode($result);
?>