<?php

namespace App\Models;

use Wattanar\Sqlsrv;
use App\Controllers\ConnectionController;

class DepartmentModel
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
			FROM MASTER_DEPARTMENT"
		);
	}

	public function DPInfo($inp_DP,$id)
	{
		$cause =  Sqlsrv::array(
			$this->conn->connect(),
			"SELECT * FROM MASTER_DEPARTMENT
			WHERE DEPARTMENTDES = ?
			AND ID != ?",
			[
				$inp_DP,$id
			]
		);

		return $cause;
	}

	public function create($inp_DP) 
	{	
		if (Sqlsrv::begin($this->conn->connect()) === false) {
			return 	[
				"result" => false,
				"message" => "Error start transaction."
			];
		}
		try
		{
			
				$insertDP = sqlsrv_query(
											$this->conn->connect(),
											"INSERT INTO MASTER_DEPARTMENT(DEPARTMENTDES)
											VALUES(?)",
											array(
												$inp_DP
											)
								);
				if($insertDP)
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

	public function update($inp_DP,$id) 
	{	
		if (Sqlsrv::begin($this->conn->connect()) === false) {
			return 	[
				"result" => false,
				"message" => "Error start transaction."
			];
		}
		try
		{
			$insertDP = sqlsrv_query(
											$this->conn->connect(),
											"UPDATE MASTER_DEPARTMENT 
											SET DEPARTMENTDES=?
											WHERE ID=?",
											array(
												$inp_DP,$id
											)
								);

				if($insertDP)
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
				$insertDP = sqlsrv_query(
											$this->conn->connect(),
											"DELETE FROM MASTER_DEPARTMENT 
											WHERE ID=?",
											array(
												$id
											)
								);
				if($insertDP)
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

	public function DepartCheck($id)
	{
		$departcheck =  Sqlsrv::array(
			$this->conn->connect(),
			"SELECT * FROM MASTER_DRIVER
			WHERE DEPARTMENT = ?",
			[
				$id
			]
		);

		return $departcheck;
	}


}	