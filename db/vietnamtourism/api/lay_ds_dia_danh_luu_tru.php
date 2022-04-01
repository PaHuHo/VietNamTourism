<?php
$id=$_GET["id"];
require('../db.php');
if($id==0){
    $ds = $conn->prepare("SELECT * FROM dia_danh_luu_tru Order By sao_danh_gia DESC");
    $ds->execute();
    $ds->setFetchMode(PDO::FETCH_ASSOC);
    $result = $ds->fetchAll();
    $conn=null;
    echo json_encode($result);
}else{
    $ds = $conn->prepare("SELECT * FROM dia_danh_luu_tru WHERE dia_danh_id=$id");
    $ds->execute();
    $ds->setFetchMode(PDO::FETCH_ASSOC);
    $result = $ds->fetchAll();
    $conn=null;
    echo json_encode($result);
}

?>