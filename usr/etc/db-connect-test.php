<?php
# Fill out the db* vars below and run from the command line:
# -c <path>|<file>  Look for php.ini file in this directory
# -f <file>         Parse and execute <file>
# On Guix:
#   php -c /usr/etc -f /etc/db-connect-test.php
# On Ubuntu:
#   php -c $HOME/dec/fdk/etc -f $HOME/dec/fdk/etc/db-connect-test.php

$php_inipath = php_ini_loaded_file();

// WTF?!?
// To be able to display line breaks when using single quotation marks, they
// must be surrounded by double quotation marks and linked to the first string.


if ($php_inipath) {
    echo "$php_inipath loaded\n";
} else {
    die("php.ini file is not loaded");
}

// When developing, use '127.0.0.1' if 'localhost' leads to:
//   Uncaught mysqli_sql_exception: No such file or directory ...
$db_host = '127.0.0.1';
$db_user = $_ENV["USER"];
$db_pass = '';
$db_name = 'associations';

echo "Connecting to db_host: '$db_host' db_user: '$db_user' db_name: '$db_name' ...\n";

/*
  TODO mysqli_connect is deprecated
  This extension was deprecated in PHP 5.5.0, and it was removed in PHP 7.0.0.
  Instead, the MySQLi or PDO_MySQL extension should be used. See also MySQL:
  choosing an API guide. Alternatives to this function include:

 mysqli_connect()
 PDO::__construct()
 */
$link = mysqli_connect($db_host, $db_user, $db_pass, $db_name);
if (mysqli_connect_errno()) {
    echo "Failed to connect: " . mysqli_connect_error() . "\n";
    exit();
}
mysqli_select_db($link, $db_name) or die("Couldn't connect to '$db_name'\n");

$test_query = "SHOW TABLES FROM $db_name";
$result = mysqli_query($link, $test_query);

$tblCnt = 0;
while($tbl = mysqli_fetch_array($result)) {
    $tblCnt++;
    #echo $tbl[0]."<br />\n";
}

echo "Database $db_name contains $tblCnt tables.\n";
?>
