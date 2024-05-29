<?php
  include '../connection.php';

  $idUser  = $_POST['idUser'];
  $idRestaurant = $_POST['idRestaurant'];
  $orderDateTime  = $_POST['orderDateTime']; 
  $bookingDateTime = $_POST['bookingDateTime'];
  $numberOfPeople  = $_POST['numberOfPeople']; 
  $totalPrice  = $_POST['totalPrice']; 

  $sqlQuery = "INSERT INTO Orders SET idUser = '$idUser', idRestaurant = '$idRestaurant', orderDateTime = '$orderDateTime', bookingDateTime = '$bookingDateTime', numberOfPeople = '$numberOfPeople', totalPrice='$totalPrice'";

  $resultOfQuery = $connectNow->query($sqlQuery); //if data is inserted successfully result is 1 - no error

  if($resultOfQuery) {
    echo json_encode(array("success"=>true));
  } else {
    echo json_encode(array("success"=>false));
  }