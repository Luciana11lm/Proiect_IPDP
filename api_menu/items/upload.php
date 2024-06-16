<?php
  include '../connection.php';

  $name = $_POST['name'];
  $price = $_POST['price'];
  $ingredients = $_POST['ingredients'];
  $description = $_POST['description'];
  $imageUrl = $_POST['imageUrl'];
  $rating = $_POST['rating'];
  $tags = $_POST['tags'];
  $idRestaurant = $_POST['idRestaurant'];

  $sqlQuery = "INSERT INTO Product SET name='$name', price='$price', ingredients='$ingredients', description='$description', imageUrl='$imageUrl', rating='$rating', tags='$tags', idRestaurant='$idRestaurant'";

  $resultOfQuery = $connectNow->query($sqlQuery);

  if($resultOfQuery) {
    echo json_encode(array("success"=>true));
  } else {
    echo json_encode(array("success"=>false));
  }