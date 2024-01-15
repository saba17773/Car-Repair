<?php

namespace App\Models;

use Wattanar\Sqlsrv;
use App\Controllers\ConnectionController;

class RegisterTypeModel
{	

	public function __construct()
	{
		$this->conn = new ConnectionController;
	}

	public function all()
	{
		return Sqlsrv::array(
			$this->conn->connect(),
			"SELECT * FROM MASTER_REGISTERTYPE"
		);
	}

	public function RegtypeInfo($inp_registername,$id)
	{
		$Regtype =  Sqlsrv::array(
			$this->conn->connect(),
			"SELECT * FROM MASTER_REGISTERTYPE
			WHERE REGISTERTYPE = ?
			AND ID != ?",
			[
				$inp_registername,$id
			]
		);

		return $Regtype;
	}

	public function create($inp_registername) 
	{	
		if (Sqlsrv::begin($this->conn->connect()) === false) {
			return 	[
				"result" => false,
				"message" => "Error start transaction."
			];
		}
		try
		{
			
				$insertReg = sqlsrv_query(
											$this->conn->connect(),
											"INSERT INTO MASTER_REGISTERTYPE(REGISTERTYPE)
											VALUES(?)",
											array(
												$inp_registername
											)
								);
				if($insertReg)
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

	public function update($inp_registername,$id) 
	{	
		if (Sqlsrv::begin($this->conn->connect()) === false) {
			return 	[
				"result" => false,
				"message" => "Error start transaction."
			];
		}
		try
		{
			$insertReg = sqlsrv_query(
											$this->conn->connect(),
											"UPDATE MASTER_REGISTERTYPE 
											SET REGISTERTYPE=?
											WHERE ID = ?",
											array(
												$inp_registername,$id
											)
								);

				if($insertReg)
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
				$insertReg = sqlsrv_query(
											$this->conn->connect(),
											"DELETE FROM MASTER_REGISTERTYPE WHERE ID=?",
											array(
												$id
											)
								);
				if($insertReg)
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

	public function RegCheck($id)
	{
		$regcheck =  Sqlsrv::array(
			$this->conn->connect(),
			"SELECT * FROM MASTER_CAR
			WHERE REGISTERTYPE = ?",
			[
				$id
			]
		);

		return $regcheck;
	}


}	