<?php

namespace App\Models;

use Wattanar\Sqlsrv;
use App\Controllers\ConnectionController;

class HomeModel
{
	public function __construct()
	{
		$this->conn = new ConnectionController;
	}

	public function all($sid)
	{
		
		return Sqlsrv::array(
			$this->conn->connectAxCust(),
			"SELECT 
				I.ITEMID
				,I.ITEMNAME
				,I.ITEMGROUPID
				,I.NETWEIGHT
		    FROM INVENTTABLE I WHERE I.ITEMGROUPID = ?",[$sid]


		);
	}


}