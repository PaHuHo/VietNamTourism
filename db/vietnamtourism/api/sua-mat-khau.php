<?php

$id=$_GET["id"];
$mat_khau = $_GET["pass"];
require('../db.php');
$stmt = $conn->prepare("UPDATE tai_khoan SET mat_khau='$mat_khau' WHERE id=$id ");
$stmt->execute();
$result = $stmt->fetchAll();
$conn = null;
echo json_encode($result);


