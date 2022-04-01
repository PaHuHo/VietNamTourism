<?php

$ten_dia_danh = $_GET["ten_dia_danh"];
$mo_ta = $_GET["mo_ta"];
$loai_dia_danh_id = $_GET["loai_dia_danh_id"];
$vung_id = $_GET["vung_id"];
$mien_id = $_GET["mien_id"];
$danh_gia = $_GET["sao_danh_gia"];
require('../db.php');

$ktra = $conn->prepare("SELECT * FROM dia_danh WHERE ten_dia_danh='$ten_dia_danh'");
$ktra->execute();
if ($ktra->rowCount() < 1) {
    $update = $conn->prepare("INSERT INTO dia_danh(ten_dia_danh, sao_danh_gia, mo_ta, kinh_do, vi_do, loai_dia_danh_id, vung_id, mien_id) VALUES ('$ten_dia_danh', '$danh_gia', '$mo_ta', '11.920071', '108.514857', '$loai_dia_danh_id', '$vung_id', '$mien_id')");
    $update->execute();
    echo "pass";
} else {
    echo "failed";
}
