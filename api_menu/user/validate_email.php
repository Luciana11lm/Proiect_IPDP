<?php
  //verify in mysql database if the email exists or not
  include '../connection.php';

  $email = $_POST['email'];
                                      //coloana //valoarea introdusa
  $sqlQuery = "SELECT * FROM Users WHERE email='$email'";

  $resultOfQuery = $connectNow->query($sqlQuery); //if data is inserted successfully result is 1 - no error

  // if number of rows is greter than 0 means there is another user having this email
  if($resultOfQuery->num_rows > 0) {
    //num rows length == 1 - email already in use - Error
    echo json_encode(array("emailFound"=>true));
  } else {
    //num rows length == 0 - nobody uses this email - user can sign up with it
    echo json_encode(array("emailFound"=>false));
  }