<?php
  include '../connection.php';

  $currentOnlineUserID = $_POST["currentOnlineUserID"];

  $sqlQuery = "SELECT * FROM Cart CROSS JOIN Product WHERE Cart.idUser = '$currentOnlineUserID' AND Cart.idProduct = Product.idProduct";
   
  $resultOfQuery = $connectNow->query($sqlQuery); //if data is inserted successfully result is 1 - no error

  if($resultOfQuery->num_rows > 0) { //allow user to log in
    $cartRecord = array();
    while($rowFound = $resultOfQuery->fetch_assoc()){ //rowFound gets data from result as an associative array
      $cartRecord[] = $rowFound;
    }
    echo json_encode(array("success"=>true,
                           "currentUserCartData"=>$cartRecord,
                          )); //transmits user info to the application
  } else { 
    echo json_encode(array("success"=>false));
  }