<?php
$username = $_GET["username"];
$pass = $_GET["password"];
$nick = $_GET["nick"];

require('../db.php');
$ktra = $conn->prepare("SELECT * FROM tai_khoan WHERE email='$username'");
$ktra->execute();
if ($ktra->rowCount() > 0) {
    $ktra->setFetchMode(PDO::FETCH_ASSOC);
    $nhanVien = $ktra->fetchAll();
    echo json_encode($nhanVien);
    die();
}

$stmt = $conn->prepare("INSERT INTO tai_khoan(email, mat_khau,ten_nguoi_dung,loai_tai_khoan,trang_thai) VALUES('$username','$pass','$nick',2,1)");
$stmt->execute();

$ktra = $conn->prepare("SELECT * FROM tai_khoan WHERE email='$username'");
$ktra->execute();
$ktra->setFetchMode(PDO::FETCH_ASSOC);
$nhanVien = $ktra->fetch();

$id = $nhanVien["id"];
$stmt = $conn->prepare("INSERT INTO trang_thai(tai_khoan_id, tt_email, tt_ten, tt_sdt) VALUES ($id,'1','1','2')");
$stmt->execute();
$result = $stmt->fetchAll();
$conn = null;
echo json_encode($result);
