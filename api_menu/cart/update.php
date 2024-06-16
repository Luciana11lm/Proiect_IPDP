<?php
  include '../connection.php';


  $idCart = $_POST['idCart'];
  $quantity = $_POST['quantity'];
  
  $sqlQuery = "UPDATE Cart SET quantity = '$quantity' WHERE idCart = '$idCart'";

  $resultOfQuery = $connectNow->query($sqlQuery); //if data is inserted successfully result is 1 - no error

  if($resultOfQuery) {
    echo json_encode(array("success"=>true));
  } else {
    echo json_encode(array("success"=>false));
  }