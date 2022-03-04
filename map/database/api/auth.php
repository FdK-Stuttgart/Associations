<?php

require '../database.php';

// TODO check if sensitive info leaks in the log when something goes wrong

function authorize($con) {
    // $log_file = "/var/log/php-server.log";
    // foreach ($_SERVER as $key => $value) {
    //     error_log("_SERVER[$key]: $value\n", 3, $log_file);
    // }
    $username = $_SERVER['PHP_AUTH_USER'];
    if (!$username) {
        return false;
    }
    $password = $_SERVER['PHP_AUTH_PW'];
    if (!$password) {
        return false;
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
