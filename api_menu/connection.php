<?php
  $serverHost = "localhost";
  $user = "root";
  $password = "";
  $database = "menu_app";

  //$serverHost = "172.17.0.2";
  //$user = "root";
  //$password = "mkuit";
  //$database = "menu_app";

  $connectNow = new mysqli($serverHost, $user, $password, $database);

  if ($connectNow->connect_error) {
    die("Conexiunea la baza de date a eșuat: " . $connectNow->connect_error);
}


