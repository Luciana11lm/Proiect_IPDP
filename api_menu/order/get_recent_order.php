<?php

include '../connection.php';

  $idUser = $_POST['idUser'];

  $sqlQuery = "SELECT * FROM `Orders` WHERE idUser = '$idUser' AND orderDateTime = (SELECT MAX(orderDateTime) FROM orders)";
  $resultOfQuery = $connectNow->query($sqlQuery);

  if($resultOfQuery->num_rows > 0)
   { 
    $itemsRecord = array();
    while($rowFound = $resultOfQuery->fetch_assoc()){ 
      $itemsRecord[] = $rowFound;
    }
    echo json_encode(array("success"=>true,
                           "orderData"=>$itemsRecord[0],
                          )); 
   } else { 
    echo json_encode(array("success"=>false));
   }