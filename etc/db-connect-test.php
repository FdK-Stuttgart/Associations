<?php
# Fill our vars and run on cli
# $ php -c /usr/etc -f db-connect-test.php

$php_inipath = php_ini_loaded_file();

if ($php_inipath) {
    echo 'Loaded php.ini is: ' . $php_inipath . "\n";
} else {
    die('php.ini file is not loaded');
}

$dbname = 'associations';
$dbuser = 'bost';
$dbpass = '';
$dbhost = '';

$link = mysqli_connect($dbhost, $dbuser, $dbpass, $dbname);
if (mysqli_connect_errno()) {
    echo "Failed to connect: " . mysqli_connect_error() . "\n";
    exit();
}
mysqli_select_db($link, $dbname) or die("Could not open the db '$dbname'\n");

$test_query = "SHOW TABLES FROM $dbname";
$result = mysqli_query($link, $test_query);

$tblCnt = 0;
while($tbl = mysqli_fetch_array($result)) {
    $tblCnt++;
    #echo $tbl[0]."<br />\n";
}

if (!$tblCnt) {
    echo "There are no tables<br />\n";
} else {
    echo "There are $tblCnt tables<br />\n";
}
?>
