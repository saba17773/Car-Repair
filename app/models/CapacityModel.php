<?php

namespace App\Models;

use Wattanar\Sqlsrv;
use App\Controllers\ConnectionController;

class CapacityModel
{	

	public function __construct()
	{
		$this->conn = new ConnectionController;
	}

	public function all()
	{
		return Sqlsrv::array(
			$this->conn->connect(),
			"SELECT * FROM MASTER_CAPACITY"
		);
	}
	
	public function CapacityInfo($inp_capacityname,$id)
	{
		$Capacity =  Sqlsrv::array(
			$this->conn->connect(),
			"SELECT * 
			FROM MASTER_CAPACITY
			WHERE CAPACITY = ?
			AND ID != ?",
			[
				$inp_capacityname,$id
			]
		);

		return $Capacity;
	}

	public function create($inp_capacityname) 
	{	
		if (Sqlsrv::begin($this->conn->connect()) === false) {
			return 	[
				"result" => false,
				"message" => "Error start transaction."
			];
		}
		try
		{
			
				$insertCap = sqlsrv_query(
											$this->conn->connect(),
											"INSERT INTO MASTER_CAPACITY(CAPACITY)
											VALUES(?)",
											array(
												$inp_capacityname
											)
								);
				if($insertCap)
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

	public function update($inp_capacityname,$id) 
	{	
		if (Sqlsrv::begin($this->conn->connect()) === false) {
			return 	[
				"result" => false,
				"message" => "Error start transaction."
			];
		}
		try
		{
				$insertCap = sqlsrv_query(
											$this->conn->connect(),
											"UPDATE MASTER_CAPACITY SET CAPACITY=?
											WHERE ID=?",
											array(
												$inp_capacityname,$id
											)
								);

				if($insertCap)
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
				$insertCap = sqlsrv_query(
											$this->conn->connect(),
											"DELETE FROM MASTER_CAPACITY 
											WHERE ID=?",
											array(
												$id
											)
								);
				if($insertCap)
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

	public function CapCheck($id)
	{
		$capcheck =  Sqlsrv::array(
			$this->conn->connect(),
			"SELECT * FROM MASTER_CAR
			WHERE CAPACITY = ?",
			[
				$id
			]
		);

		return $capcheck;
	}


}	