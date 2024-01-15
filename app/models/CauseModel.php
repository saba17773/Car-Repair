<?php

namespace App\Models;

use Wattanar\Sqlsrv;
use App\Controllers\ConnectionController;

class CauseModel
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
			FROM MASTER_CAUSE"
		);
	}

	public function allstatus()
	{
		return Sqlsrv::array(
			$this->conn->connect(),
			"SELECT * 
			FROM MASTER_CAUSE
			WHERE STATUS = '1'"
		);
	}

	public function causeInfo($inp_causename,$id)
	{
		$cause =  Sqlsrv::array(
			$this->conn->connect(),
			"SELECT * FROM MASTER_CAUSE
			WHERE CAUSE = ?
			AND ID != ?",
			[
				$inp_causename,$id
			]
		);

		return $cause;
	}

	public function create($inp_causename
							,$status) 
	{	
		if (Sqlsrv::begin($this->conn->connect()) === false) {
			return 	[
				"result" => false,
				"message" => "Error start transaction."
			];
		}
		try
		{
			
				$insertCause = sqlsrv_query(
											$this->conn->connect(),
											"INSERT INTO MASTER_CAUSE(CAUSE
																		,STATUS)
											VALUES(?,?)",
											array(
												$inp_causename
												,$status
											)
								);
				if($insertCause)
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

	public function update($inp_causename
							,$status
							,$id) 
	{	
		if (Sqlsrv::begin($this->conn->connect()) === false) {
			return 	[
				"result" => false,
				"message" => "Error start transaction."
			];
		}
		try
		{
			$insertCause = sqlsrv_query(
											$this->conn->connect(),
											"UPDATE MASTER_CAUSE 
											SET CAUSE=?
												,STATUS=?
											WHERE ID=?",
											array(
												$inp_causename
												,$status
												,$id
											)
								);

				if($insertCause)
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
				$insertCause = sqlsrv_query(
											$this->conn->connect(),
											"DELETE FROM MASTER_CAUSE 
											WHERE ID=?",
											array(
												$id
											)
								);
				if($insertCause)
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

	public function CauseCheck($id)
	{
		$causecheck =  Sqlsrv::array(
			$this->conn->connect(),
			"SELECT * FROM REPAIRDETAIL
			WHERE CAUSE = ?",
			[
				$id
			]
		);

		return $causecheck;
	}


}	