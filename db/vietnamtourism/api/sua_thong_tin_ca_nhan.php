<?php

$id=$_GET["id"];
$ten = $_GET["ten"];
$sdt = $_GET["sdt"];

$tt_ten = $_GET["tt_ten"];
$tt_email = $_GET["tt_email"];
$tt_sdt = $_GET["tt_sdt"];

require('../db.php');
$ktra = $conn->prepare("UPDATE tai_khoan SET ten_nguoi_dung='$ten',sdt='$sdt' WHERE id=$id ");
$ktra->execute();

$stmt = $conn->prepare("UPDATE trang_thai SET tt_email='$tt_email',tt_ten='$tt_ten',tt_sdt='$tt_sdt' Where tai_khoan_id=$id");
$stmt->execute();
$result = $stmt->fetchAll();
$conn = null;
echo json_encode($result);


