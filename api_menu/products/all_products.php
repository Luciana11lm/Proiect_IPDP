<?php
  include '../connection.php';

  $sqlQuery = "SELECT * FROM Product ORDER BY idProduct DESC";

  $resultOfQuery = $connectNow->query($sqlQuery);

  if($resultOfQuery->num_rows > 0)
   { 
    $itemsRecord = array();
    while($rowFound = $resultOfQuery->fetch_assoc()){ 
      $itemsRecord[] = $rowFound;
    }
    echo json_encode(array("success"=>true,
                           "itemsData"=>$itemsRecord,
                          )); 
   } else { 
    echo json_encode(array("success"=>false));
   }