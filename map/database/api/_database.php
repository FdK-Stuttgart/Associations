<?php

/* fill in database connection params */
define('DB_HOST', '');
define('DB_NAME', '');
define('DB_USER', '');
define('DB_PASS', '');
/* fill in the SERVER_AND_BASE_URI */
define('AUTH_SRVC_URI', 'https://<SERVER_AND_BASE_URI>/wp-json/jwt-auth/v1/token');

header("Access-Control-Allow-Methods: GET,POST");
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

// TODO check if sensitive info leaks in the log when something goes wrong

function getPrm($prm, $con) {
    $val = $_GET[$prm];
    if ($val != null) {
        return mysqli_real_escape_string($con, trim($val));
    }
    else {
        $log_file = "/var/log/php-server.log";
        error_log("err getPrm; prm: '$prm' \n", 3, $log_file);
        return false;
    }
}

function authorize($con) {
    $username = getPrm('username', $con);
    if (!$username) {
        return http_response_code(400);
    }
    $password = getPrm('password', $con);
    if (!$password) {
        return http_response_code(400);
    }

    $curl = curl_init();
    curl_setopt($curl, CURLOPT_URL, AUTH_SRVC_URI);
    curl_setopt($curl, CURLOPT_POST, true);
    curl_setopt($curl, CURLOPT_RETURNTRANSFER, true);

    $headers = array(
        "Content-Type: application/json",
    );
    $data = '{"username":"' . $username . '","password":"' . $password .'"}';
    $log_file = "/var/log/php-server.log";
    // error_log("data: $data \n", 3, $log_file);

    curl_setopt($curl, CURLOPT_HTTPHEADER, $headers);
    curl_setopt($curl, CURLOPT_POSTFIELDS, $data);
    curl_setopt($curl, CURLOPT_SSL_VERIFYHOST, false);
    curl_setopt($curl, CURLOPT_SSL_VERIFYPEER, false);

    $resp = curl_exec($curl);
    $status = curl_getinfo($curl, CURLINFO_HTTP_CODE);
    $err = curl_error($curl);
    curl_close($curl);
    // error_log("status: '$status' err: '$err' resp: '$resp' \n", 3, $log_file);
    // var_dump($resp);
    if ($status != 200 || $err) {
        error_log("status: '$status' err: '$err' resp: '$resp' \n", 3, $log_file);
        return http_response_code(401);
    }
    else {
        $errUnauthorized = 401;
        $dec = json_decode($resp, true);
        // var_dump($dec);
        $token = $dec['token'];
        // just check if the token exists
        if (!$token) {
            return http_response_code($errUnauthorized);
        }
        $user_roles = $dec['user_roles'];
        if (!$user_roles) {
            return http_response_code($errUnauthorized);
        }
        $authorized = false;
        foreach ($user_roles as $r) {
            if ($r == 'administrator' || $r == 'editor') {
                $user = $dec['user_display_name'];
                error_log("user: $user, role: $r, token: <PRESENT> \n", 3, $log_file);
                $authorized = true;
                return $authorized;
            }
        }
        if (!$authorized) {
            $log_file = "/var/log/php-server.log";
            error_log("Not authorized \n", 3, $log_file);
            return http_response_code($errUnauthorized);
        }
    }
    return false;
}

$con = connect();

?>
