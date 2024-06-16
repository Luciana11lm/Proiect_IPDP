<?php
  include '../connection.php';

  $idOrder = $_POST['idOrder'];
  $status  = $_POST['status'];

  $sqlQuery = "UPDATE `Orders` SET status='$status' WHERE idOrder = '$idOrder'";

  $resultOfQuery = $connectNow->query($sqlQuery);

  if($resultOfQuery) {
    echo json_encode(array("success"=>true));
  } else {
    echo json_encode(array("success"=>false));
  }