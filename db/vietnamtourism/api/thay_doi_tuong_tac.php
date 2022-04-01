<?php

$ttLike = $_GET["trang_thai_like"];
$baiVietId = $_GET["bai_viet_id"];
$userId = $_GET["user_id"];
$trangThai=$_GET["islike"];
require('../db.php');
$ktra = $conn->prepare("SELECT * FROM tuong_tac WHERE tai_khoan_id=$userId AND bai_viet_id=$baiVietId");
$ktra->execute();
if ($trangThai=="0"&& $ktra->rowCount() <1) {
    $update = $conn->prepare("INSERT INTO tuong_tac(tai_khoan_id, bai_viet_id, trang_thai_like) VALUES ($userId,$baiVietId,$ttLike)");
    $update->execute();
    if ($ttLike == 1) {
        $update = $conn->prepare("UPDATE bai_viet SET so_luong_like=so_luong_like+1,so_luong_view=so_luong_view+1 WHERE id=$baiVietId ");
        $update->execute();
        $result = $update->fetchAll();
    } else {
        $update = $conn->prepare("UPDATE bai_viet SET so_luong_unlike=so_luong_unlike+1,so_luong_view=so_luong_view+1 WHERE id=$baiVietId ");
        $update->execute();
        $result = $update->fetchAll();
    }
    echo json_encode($result);
    die();
} else {
    if($trangThai!=$ttLike&&$trangThai!="0"){
        if ($ttLike == 1) {
            $update = $conn->prepare("UPDATE bai_viet SET so_luong_like=so_luong_like+1,so_luong_unlike=so_luong_unlike-1 WHERE id=$baiVietId ");
            $update->execute();
            $update = $conn->prepare("UPDATE tuong_tac SET trang_thai_like=$ttLike WHERE tai_khoan_id=$userId AND bai_viet_id=$baiVietId ");
            $update->execute();
        } else {
            $update = $conn->prepare("UPDATE bai_viet SET so_luong_like=so_luong_like-1,so_luong_unlike=so_luong_unlike+1 WHERE id=$baiVietId ");
            $update->execute();
            $update = $conn->prepare("UPDATE tuong_tac SET trang_thai_like=$ttLike WHERE tai_khoan_id=$userId AND bai_viet_id=$baiVietId ");
            $update->execute();
        }
    }else{
        if ($ttLike == 1) {
            $update = $conn->prepare("UPDATE bai_viet SET so_luong_like=so_luong_like-1 WHERE id=$baiVietId ");
            $update->execute();
            $update = $conn->prepare("DELETE FROM tuong_tac WHERE tai_khoan_id=$userId AND bai_viet_id=$baiVietId ");
            $update->execute();
        } else {
            $update = $conn->prepare("UPDATE bai_viet SET so_luong_unlike=so_luong_unlike-1 WHERE id=$baiVietId ");
            $update->execute();
            $update = $conn->prepare("DELETE FROM tuong_tac WHERE tai_khoan_id=$userId AND bai_viet_id=$baiVietId ");
            $update->execute();
        }
    }
    $result = $update->fetchAll();
    $conn = null;
    echo json_encode($result);
}
