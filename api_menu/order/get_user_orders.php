<?php

include '../connection.php';

  $idUser = $_POST['idUser'];

  $sqlQuery = "SELECT * FROM `Orders` WHERE idUser = '$idUser' ORDER BY orderDateTime DESC";
  $resultOfQuery = $connectNow->query($sqlQuery);

  if($resultOfQuery->num_rows > 0)
   { 
    $orderRecord = array();
    while($rowFound = $resultOfQuery->fetch_assoc()){ 
      $orderRecord[] = $rowFound;
    }
    echo json_encode(array("success"=>true,
                           "orderData"=>$orderRecord,
                          )); 
   } else { 
    echo json_encode(array("success"=>false));
   }