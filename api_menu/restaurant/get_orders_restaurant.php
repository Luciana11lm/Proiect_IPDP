<?php

include '../connection.php';

  $idRestaurant = $_POST['idRestaurant'];

  $sqlQuery = "SELECT * FROM `Orders` WHERE idRestaurant = '$idRestaurant' ORDER BY orderDateTime";
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