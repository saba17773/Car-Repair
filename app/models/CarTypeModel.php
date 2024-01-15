<?php

namespace App\Models;

use Wattanar\Sqlsrv;
use App\Controllers\ConnectionController;

class CarTypeModel
{	

	public function __construct()
	{
		$this->conn = new ConnectionController;
	}

	public function all()
	{
		return Sqlsrv::array(
			$this->conn->connect(),
			"SELECT * 
			FROM MASTER_CARTYPE"
		);
	}

	public function typeInfo($inp_cartypename,$id)
	{
		$cartype =  Sqlsrv::array(
			$this->conn->connect(),
			"SELECT * FROM MASTER_CARTYPE
			WHERE CARTYPE = ?
			AND ID != ?",
			[
				$inp_cartypename,$id
			]
		);

		return $cartype;
	}

	public function create($inp_cartypename) 
	{	
		if (Sqlsrv::begin($this->conn->connect()) === false) {
			return 	[
				"result" => false,
				"message" => "Error start transaction."
			];
		}
		try
		{
			
				$insertCarType = sqlsrv_query(
											$this->conn->connect(),
											"INSERT INTO MASTER_CARTYPE(CARTYPE)
											VALUES(?)",
											array(
												$inp_cartypename
											)
								);
				if($insertCarType)
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

	public function update($inp_cartypename,$id) 
	{	
		if (Sqlsrv::begin($this->conn->connect()) === false) {
			return 	[
				"result" => false,
				"message" => "Error start transaction."
			];
		}
		try
		{
			$insertCarType = sqlsrv_query(
											$this->conn->connect(),
											"UPDATE MASTER_CARTYPE 
											SET CARTYPE=?
											WHERE ID=?",
											array(
												$inp_cartypename,$id
											)
								);

				if($insertCarType)
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
				$insertCarType = sqlsrv_query(
											$this->conn->connect(),
											"DELETE FROM MASTER_CARTYPE 
											WHERE ID=?",
											array(
												$id
											)
								);
				if($insertCarType)
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

	public function CartypeCheck($id)
	{
		$cartypecheck =  Sqlsrv::array(
			$this->conn->connect(),
			"SELECT * FROM MASTER_CAR
			WHERE CARTYPE = ?",
			[
				$id
			]
		);

		return $cartypecheck;
	}


}	