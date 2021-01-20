<?php

define('DB_HOST', 'mysql5.auskas.de');
define('DB_USER', 'db264270_120');
define('DB_PASS', 'vxP/qM>9c3tk');
define('DB_NAME', 'db264270_120');

header("Access-Control-Allow-Methods: GET,POST,PUT,OPTIONS");
header("Access-Control-Allow-Headers:*");

function connect()
{
  $connect = mysqli_connect(DB_HOST ,DB_USER ,DB_PASS ,DB_NAME);

  if (mysqli_connect_errno()) {
    die("Failed to connect:" . mysqli_connect_error());
  }

  mysqli_set_charset($connect, "utf8");

  return $connect;
}

$con = connect();

?>
