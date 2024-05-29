<?php
  include '../connection.php';

  $idOrderProduct  = $_POST['idOrderProduct'];
  $idProduct = $_POST['idProduct'];
  $idOrder  = $_POST['idOrder']; 
  $quantity = $_POST['quantity'];
  $size  = $_POST['size']; 

  $sqlQuery = "INSERT INTO OrderProduct SET idOrderProduct = '$idOrderProduct', idProduct = '$idProduct', idOrder = '$idOrder', quantity = '$quantity', size = '$size'";

  $resultOfQuery = $connectNow->query($sqlQuery); //if data is inserted successfully result is 1 - no error

  if($resultOfQuery) {
    echo json_encode(array("success"=>true));
  } else {
    echo json_encode(array("success"=>false));
  }