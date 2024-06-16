<?php

include '../connection.php';

  $typedKeyWords = $_POST['typedKeyWords'];

  $sqlQuery = "SELECT * FROM Product WHERE Product.name LIKE '%$typedKeyWords%'";

  error_log("Received data: typedKeyWords=$typedKeyWords");
  
  $resultOfQuery = $connectNow->query($sqlQuery); 

  if($resultOfQuery->num_rows > 0) { 
    $foundItemsRecord = array();
    while($rowFound = $resultOfQuery->fetch_assoc()){ 
      $foundItemsRecord[] = $rowFound;
    }
    echo json_encode(array("success"=>true,
                           "itemsFoundData"=>$foundItemsRecord,
                          )); 
  } else { 
    echo json_encode(array("success"=>false));
  }