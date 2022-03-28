<?php

require 'environment.php';

header("Access-Control-Allow-Methods: GET,POST");
header("Access-Control-Allow-Headers:*");

function connect()
{
    /*
      TODO mysqli_connect is deprecated
      This extension was deprecated in PHP 5.5.0, and it was removed in PHP
      7.0.0. Instead, the MySQLi or PDO_MySQL extension should be used. See also
      MySQL: choosing an API guide. Alternatives to this function include:
      mysqli_connect()
      PDO::__construct()
    */
  $connect = mysqli_connect(DB_HOST ,DB_USER ,DB_PASS ,DB_NAME);

  if (mysqli_connect_errno()) {
    die("Failed to connect:" . mysqli_connect_error());
  }

  mysqli_set_charset($connect, "utf8");

  return $connect;
}

$con = connect();

?>
