<?php

require 'environment.php';
require 'database.php';

function lg($s) {
    $now = DateTime::createFromFormat('U.u', microtime(true));
    $ds = $now->format("m-d H:i:s.u");
    $d = substr($ds, 0, -3);
    /*
      https://www.php.net/manual/en/function.error-log.php
      string $message,
      int $message_type = 0,
      ?string $destination = null,
      ?string $additional_headers = null
     */
    error_log("[".$d."] ".$s."\n", 3, LOG_FILE);
}

// TODO check if sensitive info leaks in the log when something goes wrong

function authorize($con) {
    $authorized = true;
    $not_authorized = !$authorized;

    // foreach ($_SERVER as $key => $value) {
    //     lg("_SERVER[$key]: $value");
    // }
    $username = $_SERVER['PHP_AUTH_USER'];
    if (!$username) {
        lg("ERR: undefined _SERVER['PHP_AUTH_USER']");
        return $not_authorized;
    }
    $password = $_SERVER['PHP_AUTH_PW'];
    if (!$password) {
        lg("ERR: undefined _SERVER['PHP_AUTH_PW']");
        return $not_authorized;
    }

    $curl = curl_init();
    curl_setopt($curl, CURLOPT_URL, AUTH_SRVC_URI);
    curl_setopt($curl, CURLOPT_POST, true);
    curl_setopt($curl, CURLOPT_RETURNTRANSFER, true);

    $headers = array(
        "Content-Type: application/json",
    );
    $data = '{"username":"' . $username . '","password":"' . $password .'"}';
    // lg("INF: data: $data");

    curl_setopt($curl, CURLOPT_HTTPHEADER, $headers);
    curl_setopt($curl, CURLOPT_POSTFIELDS, $data);
    curl_setopt($curl, CURLOPT_SSL_VERIFYHOST, false);
    curl_setopt($curl, CURLOPT_SSL_VERIFYPEER, false);

    lg("INF: Authorize using AUTH_SRVC_URI: ".AUTH_SRVC_URI);
    $resp = curl_exec($curl);
    $status = curl_getinfo($curl, CURLINFO_HTTP_CODE);
    $err = curl_error($curl);
    curl_close($curl);
    // lg("status: '$status' err: '$err' resp: '$resp'");
    // var_dump($resp);
    $expected_status = 200;
    if ($err) {
        lg("ERR: status: $status, expected: $expected_status");
        return $not_authorized;
    }
    else if ($err) {
        lg("ERR: error(s) present in the authorization response: $err");
        return $not_authorized;
    }
    else {
        $user = $dec['user_display_name'];
        $dec = json_decode($resp, true);
        // var_dump($dec);
        $token = $dec['token'];
        // just check if the token exists
        if (!$token) {
            lg("ERR: token not present in the authorization response. user: $user");
            return $not_authorized;
        }
        $user_roles = $dec['user_roles'];
        if (!$user_roles) {
            lg("ERR: user_roles not present in the authorization response. user: $user");
            return $not_authorized;
        }
        foreach ($user_roles as $role) {
            if ($role == 'administrator' || $role == 'editor') {
                $user = $dec['user_display_name'];
                lg("INF: user authorized. user: $user, role: $role, token: <PRESENT>");
                return $authorized;
            }
        }
        lg("ERR: None of the user_roles is authorized. user: $user, user_roles: $user_roles");
        return $not_authorized;
    }
}

$con = connect();

?>
