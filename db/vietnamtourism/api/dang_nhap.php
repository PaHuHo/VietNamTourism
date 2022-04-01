<?php
$username=$_GET["username"];
$pass=$_GET["password"];
    require('../db.php');
    $stmt=$conn->prepare("SELECT * FROM tai_khoan WHERE mat_khau='$pass' AND email='$username'");
    $stmt->execute();
    $stmt->setFetchMode(PDO::FETCH_ASSOC);
    $nhanVien=$stmt->fetchAll();
    $conn=null;
    echo json_encode($nhanVien);
