<?php
  include '../connection.php';

  // save/send data = POST
  // get data from mysql database = GET

  $idCart = $_POST['idCart'];
  
  $sqlQuery = "DELETE FROM Cart WHERE idCart = '$idCart'";

  $resultOfQuery = $connectNow->query($sqlQuery); //if data is inserted successfully result is 1 - no error

  if($resultOfQuery) {
    echo json_encode(array("success"=>true));
  } else {
    echo json_encode(array("success"=>false));
  }