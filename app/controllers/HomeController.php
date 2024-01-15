<?php 

namespace App\Controllers;

use App\Models\HomeModel;

class HomeController
{
	public function __construct()
	{
		$this->home = new HomeModel;
	}

	public function all($request, $response, $args)
	{
		if ($_SESSION["Department"] == 1) {
			$sid = 'OS';
		}
		else
		{
			$sid = 'FG';
		}

		return $response->withJson($this->home->all($sid));
	}



}