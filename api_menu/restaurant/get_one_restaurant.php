<?php

include '../connection.php';

  $idRestaurant     = $_POST['idRestaurant'];

  $sqlQuery = "SELECT * FROM Restaurant WHERE  idRestaurant = '$idRestaurant'";

  $resultOfQuery = $connectNow->query($sqlQuery); //if data is brought successfully result is 1 - no error

  if($resultOfQuery->num_rows > 0) { //allow user to log in
    $restaurantRecord = array();
    while($rowFound = $resultOfQuery->fetch_assoc()){ //rowFound gets data from result as an associative array
      $restaurantRecord[] = $rowFound;
    }
    echo json_encode(array("success"=>true,
                           "restaurantData"=>$restaurantRecord[0],
                          )); //transmits user info to the application
  } else { 
    echo json_encode(array("success"=>false));
  }