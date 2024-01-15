<?php
// Application middleware

// e.g: $app->add(new \Slim\Csrf\Guard);
$auth = function ($request, $response, $next) {
  if (isset($_SESSION["logged"]) && $_SESSION["logged"] === true) {
  	$response = $next($request, $response);
  } else {
  	return $response->withRedirect("/user/auth");
  }
  return $response;
};

// $chksess  = function ($request, $response, $next) {
//   if (isset($_SESSION["logged"]) && $_SESSION["logged"] === true) {
//   	$response = $next($request, $response);
//   } else {
//   	return $response->withRedirect("/user/auth");
//   }
//   return $response;
// };