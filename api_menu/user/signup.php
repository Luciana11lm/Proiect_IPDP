<?php
  include '../connection.php';

  // save/send data = POST
  // get data from mysql database = GET

  $firstName = $_POST['firstName'];
  $lastName  = $_POST['lastName'];
  $email     = $_POST['email'];
  $password  = md5($_POST['password']); //send password in database in binary format for security

  $sqlQuery = "INSERT INTO Users SET firstName = '$firstName', lastName = '$lastName', email = '$email', password = '$password'";

  $resultOfQuery = $connectNow->query($sqlQuery); //if data is inserted successfully result is 1 - no error

  if($resultOfQuery) {
    echo json_encode(array("success"=>true));
  } else {
    echo json_encode(array("success"=>false));
  }