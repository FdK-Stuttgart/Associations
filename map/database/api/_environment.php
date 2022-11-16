<?php
// Fill-in database connection parameters.
// When developing, use '127.0.0.1' if 'localhost' leads to:
//   Uncaught mysqli_sql_exception: No such file or directory ...
define('DB_HOST', '');
define('DB_NAME', '');
define('DB_USER', '');
define('DB_PASS', '');

/* fill in the SERVER_AND_BASE_URI */
define('AUTH_SRVC_URI', 'https://<SERVER_AND_BASE_URI>/wp-json/jwt-auth/v1/token');

define('LOG_FILE', '/var/log/php-server.log');
?>
