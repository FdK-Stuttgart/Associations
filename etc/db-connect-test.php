<?php
# Fill out the db* vars below and run from the command line:
#   php -c /usr/etc -f /etc/db-connect-test.php

$php_inipath = php_ini_loaded_file();

// WTF?!?
// To be able to display line breaks when using single quotation marks, they
// must be surrounded by double quotation marks and linked to the first string.


if ($php_inipath) {
    echo "Loaded php.ini: " . $php_inipath . "\n";
} else {
    die("php.ini file is not loaded");
}

$dbhost = '';
$dbuser = $_ENV["USER"];
$dbpass = '';
$dbname = 'associations';

echo "Connecting to dbhost: '$dbhost' dbuser: '$dbuser' dbname: '$dbname' ...\n";

$link = mysqli_connect($dbhost, $dbuser, $dbpass, $dbname);
if (mysqli_connect_errno()) {
    echo "Failed to connect: " . mysqli_connect_error() . "\n";
    exit();
}
mysqli_select_db($link, $dbname) or die("Couldn't connect to '$dbname'\n");

$test_query = "SHOW TABLES FROM $dbname";
$result = mysqli_query($link, $test_query);

$tblCnt = 0;
while($tbl = mysqli_fetch_array($result)) {
    $tblCnt++;
    #echo $tbl[0]."<br />\n";
}

echo "Database $dbname contains $tblCnt tables.\n";
?>
