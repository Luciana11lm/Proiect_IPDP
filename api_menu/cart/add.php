<?php
  include '../connection.php';

  $idProduct = $_POST['idProduct'];
  $idRestaurant = $_POST['idRestaurant'];
  $idUser  = $_POST['idUser'];
  $quantity  = $_POST['quantity']; 
  $sizeCart = $_POST['sizeCart'];

  error_log("Received data: idProduct=$idProduct, idRestaurant=$idRestaurant, idUser=$idUser, quantity=$quantity, sizeCart=$sizeCart");

  $sqlQuery = "INSERT INTO Cart SET idProduct = '$idProduct', idRestaurant = '$idRestaurant', idUser = '$idUser', quantity = '$quantity', sizeCart = '$sizeCart'";

  $resultOfQuery = $connectNow->query($sqlQuery); //if data is inserted successfully result is 1 - no error

  if($resultOfQuery) {
    echo json_encode(array("success"=>true));
  } else {
    echo json_encode(array("success"=>false));
  }