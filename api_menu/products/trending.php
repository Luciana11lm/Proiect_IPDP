<?php
  include '../connection.php';

  $minRating = 8.5;
  $limitProducts = 10;

  $sqlQuery = "SELECT * FROM Product WHERE rating >= '$minRating' ORDER BY rating DESC LIMIT $limitProducts";

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