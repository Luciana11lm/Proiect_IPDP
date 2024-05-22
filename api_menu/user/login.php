<?php

include '../connection.php';

  $email     = $_POST['email'];
  $password  = md5($_POST['password']); 

  $sqlQuery = "SELECT * FROM Users WHERE  email = '$email' AND password = '$password'";

  $resultOfQuery = $connectNow->query($sqlQuery); //if data is brought successfully result is 1 - no error

  if($resultOfQuery->num_rows > 0) { //allow user to log in
    $userRecord = array();
    while($rowFound = $resultOfQuery->fetch_assoc()){ //rowFound gets data from result as an associative array
      $userRecord[] = $rowFound;
    }
    echo json_encode(array("success"=>true,
                           "userData"=>$userRecord[0],
                          )); //transmits user info to the application
  } else { 
    echo json_encode(array("success"=>false));
  }