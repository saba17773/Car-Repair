<?php

namespace App\Models;

use Wattanar\Sqlsrv;
use App\Controllers\ConnectionController;

class InsComModel
{	

	public function __construct()
	{
		$this->conn = new ConnectionController;
	}

	public function all()
	{
		return Sqlsrv::array(
			$this->conn->connect(),
			"SELECT * FROM MASTER_INSURANCE"
		);
	}

	public function InsuranceInfo($inp_insurancename,$id)
	{
		$Insurance =  Sqlsrv::array(
			$this->conn->connect(),
			"SELECT * FROM MASTER_INSURANCE
			WHERE INSURANCEDES = ?
			AND ID != ?",
			[
				$inp_insurancename,$id
			]
		);

		return $Insurance;
	}

	public function create($inp_insurancename) 
	{	
		if (Sqlsrv::begin($this->conn->connect()) === false) {
			return 	[
				"result" => false,
				"message" => "Error start transaction."
			];
		}
		try
		{
			
				$insertIns = sqlsrv_query(
											$this->conn->connect(),
											"INSERT INTO MASTER_INSURANCE(INSURANCEDES)
											VALUES(?)",
											array(
												$inp_insurancename
											)
								);
				if($insertIns)
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

	public function update($inp_insurancename,$id) 
	{	
		if (Sqlsrv::begin($this->conn->connect()) === false) {
			return 	[
				"result" => false,
				"message" => "Error start transaction."
			];
		}
		try
		{

				$insertIns = sqlsrv_query(
											$this->conn->connect(),
											"UPDATE MASTER_INSURANCE SET INSURANCEDES=?
											WHERE ID=?",
											array(
												$inp_insurancename,$id
											)
								);

				if($insertIns)
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
				$insertIns = sqlsrv_query(
											$this->conn->connect(),
											"DELETE FROM MASTER_INSURANCE WHERE ID=?",
											array(
												$id
											)
								);
				if($insertIns)
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

	public function InsCheck($id)
	{
		$insheck =  Sqlsrv::array(
			$this->conn->connect(),
			"SELECT * FROM CARDETAIL
			WHERE INSURANCE = ?",
			[
				$id
			]
		);

		return $insheck;
	}


}	