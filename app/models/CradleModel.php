<?php

namespace App\Models;

use Wattanar\Sqlsrv;
use App\Controllers\ConnectionController;

class CradleModel
{	

	public function __construct()
	{
		$this->conn = new ConnectionController;
	}

	public function all()
	{
		return Sqlsrv::array(
			$this->conn->connect(),
			"SELECT * FROM MASTER_CRADLE"
		);
	}
	public function CradleInfo($inp_cradlename,$id)
	{
		$Cradle =  Sqlsrv::array(
			$this->conn->connect(),
			"SELECT CRADLE 
			FROM MASTER_CRADLE
			WHERE CRADLE = ?
			AND ID != ?",
			[
				$inp_cradlename,$id
			]
		);

		return $Cradle;
	}

	public function create($inp_cradlename) 
	{	
		if (Sqlsrv::begin($this->conn->connect()) === false) {
			return 	[
				"result" => false,
				"message" => "Error start transaction."
			];
		}
		try
		{
			
				$insertCradle = sqlsrv_query(
											$this->conn->connect(),
											"INSERT INTO MASTER_CRADLE(CRADLE)
											VALUES(?)",
											array(
												$inp_cradlename
											)
								);
				if($insertCradle)
				{
					return 	[
						"result" => true,
						"message" => "Create successful."
					];
				}
				else
				{
					return 	[
						"result" => false,
						"message" => "Create Failed."
					];
				}

		}catch (Exception $e) {
			Sqlsrv::rollback($this->conn->connect());
			return 	[
				"result" => false,
				"message" => $e->getMessage()
			];

		}
	    
	}

	public function update($inp_cradlename,$id) 
	{	
		if (Sqlsrv::begin($this->conn->connect()) === false) {
			return 	[
				"result" => false,
				"message" => "Error start transaction."
			];
		}
		try
		{
				// if (!isset($status)) {
				// 	$status==0;
				// }

				$insertCradle = sqlsrv_query(
											$this->conn->connect(),
											"UPDATE MASTER_CRADLE SET CRADLE=?
											WHERE ID=?",
											array(
												$inp_cradlename,$id
											)
								);

				if($insertCradle)
				{
					return 	[
						"result" => true,
						"message" => "Update successful."
					];
				}
				else
				{
					return 	[
						"result" => false,
						"message" => "Update Failed."
					];
				}

		}catch (Exception $e) {
			Sqlsrv::rollback($this->conn->connect());
			return 	[
				"result" => false,
				"message" => $e->getMessage()
			];
		}  
	}

	public function delete($id) 
	{	
		if (Sqlsrv::begin($this->conn->connect()) === false) {
			return 	[
				"result" => false,
				"message" => "Error start transaction."
			];
		}
		try
		{
				$insertCradle = sqlsrv_query(
											$this->conn->connect(),
											"DELETE FROM MASTER_CRADLE WHERE ID=?",
											array(
												$id
											)
								);
				if($insertCradle)
				{
					return 	[
						"result" => true,
						"message" => "Delete successful."
					];
				}
				else
				{
					return 	[
						"result" => false,
						"message" => "Delete Failed."
					];
				}

		}catch (Exception $e) {
			Sqlsrv::rollback($this->conn->connect());
			return 	[
				"result" => false,
				"message" => $e->getMessage()
			];
		}	    
	}

	public function CradleCheck($id)
	{
		$cradlecheck =  Sqlsrv::array(
			$this->conn->connect(),
			"SELECT * FROM REPAIRDETAIL
			WHERE CRADLE = ?",
			[
				$id
			]
		);

		return $cradlecheck;
	}


}	