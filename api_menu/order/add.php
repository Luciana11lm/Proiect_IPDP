<?php

include '../connection.php';

  $idUser = $_POST['idUser'];
  $idRestaurant = $_POST['idRestaurant'];
  $selectedItems = $_POST['selectedItems'];
  $bookingDateTime = $_POST['bookingDateTime'];
  $numberOfPeople = $_POST['numberOfPeople'];
  $totalPrice = $_POST['totalPrice'];
  $status = $_POST['status'];


  $sqlQuery = "INSERT INTO `Orders` SET idUser='$idUser', idRestaurant='$idRestaurant', selectedItems='$selectedItems', bookingDateTime='$bookingDateTime', numberOfPeople='$numberOfPeople', totalPrice='$totalPrice', status='$status'";

  $resultOfQuery = $connectNow->query($sqlQuery);

  if($resultOfQuery) {
    echo json_encode(array("success"=>true));
  } else {
    echo json_encode(array("success"=>false));
  }
