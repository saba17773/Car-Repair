<?php 

namespace App\Controllers;

use Wattanar\Sqlsrv;

class ConnectionController
{
	public static function connect()
	{
		

		$server = "xxxx";
		$user = "xxx";
		$password = "xxx";
		$database = "xxx";

		return Sqlsrv::connect(
			$server, 
			$user,
			$password,
			$database
		);
	}
}