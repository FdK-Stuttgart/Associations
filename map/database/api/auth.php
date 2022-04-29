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
    // error_log("[".$d."] ".$s."\n", 3, LOG_FILE);
    error_log("[".$d."] ".$s, 0);
}

// TODO check if sensitive info leaks in the log when something goes wrong

function authorize($con) {
    $authorized = true;
    $not_authorized = !$authorized;

    // lg("vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv");
    // foreach ($_SERVER as $key => $value) {
    //     lg("DBG: _SERVER['$key']: $value");
    // }
    // lg("^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^");
    // lg("isset(PHP_AUTH_USER): '".isset($PHP_AUTH_USER)."'; isset(_SERVER['PHP_AUTH_USER']): '".isset($_SERVER['PHP_AUTH_USER'])."'");
    // lg("PHP_AUTH_USER: '".$PHP_AUTH_USER."'; _SERVER['PHP_AUTH_USER']: '".$_SERVER['PHP_AUTH_USER']."'");

    // lg("isset(PHP_AUTH_PW): ".isset($PHP_AUTH_PW)."'; isset(_SERVER['PHP_AUTH_PW']): '".isset($_SERVER['PHP_AUTH_PW'])."'");
    // lg("PHP_AUTH_PW: '".$PHP_AUTH_PW."'; _SERVER['PHP_AUTH_PW']: '".$_SERVER['PHP_AUTH_PW']."'");

    // lg("isset(PHP_AUTH_PW): ".isset($HTTP_AUTHORIZATION)."'; isset(_SERVER['HTTP_AUTHORIZATION']): '".isset($_SERVER['HTTP_AUTHORIZATION'])."'");
    // lg("HTTP_AUTHORIZATION: '".$HTTP_AUTHORIZATION."'; _SERVER['HTTP_AUTHORIZATION']: '".$_SERVER['HTTP_AUTHORIZATION']."'");

    $username = $PHP_AUTH_USER ? $PHP_AUTH_USER : $_SERVER['PHP_AUTH_USER'];
    if (!isset($username)) {
        lg("ERR: neither PHP_AUTH_USER nor _SERVER['PHP_AUTH_USER'] are defined");
        return $not_authorized;
    }
    $password = $PHP_AUTH_PW ? $PHP_AUTH_PW : $_SERVER['PHP_AUTH_PW'];
    if (!isset($password)) {
        lg("ERR: neither PHP_AUTH_PW nor _SERVER['PHP_AUTH_PW'] are defined");
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
