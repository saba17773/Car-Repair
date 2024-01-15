<?php

namespace App\Models;

use Wattanar\Sqlsrv;
use App\Controllers\ConnectionController;

class CauseDetailModel
{	

	public function __construct()
	{
		$this->conn = new ConnectionController;
	}

	public function all($causeid)
	{
		return Sqlsrv::array(
			$this->conn->connect(),
			"SELECT CD.ID,CD.DESCRIPTION,CD.CAUSEID,C.CAUSE,CD.STATUS
			FROM MASTER_CAUSEDETAIL CD
			LEFT JOIN MASTER_CAUSE C
			ON CD.CAUSEID = C.ID
			WHERE CD.CAUSEID = ?",
				[
					$causeid
				]
		);
	}

	public function causeInfo($inp_causedetail,$id)
	{
		$causedetail =  Sqlsrv::array(
			$this->conn->connect(),
			"SELECT * FROM MASTER_CAUSEDETAIL
			WHERE DESCRIPTION = ?
			AND ID != ?",
			[
				$inp_causedetail,$id
			]
		);

		return $causedetail;
	}

	public function create($inp_causeid
						,$inp_causedetail
						,$status) 
	{	
		// var_dump($sel_causeid,$inp_causedetail); exit();
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
											"INSERT INTO MASTER_CAUSEDETAIL(CAUSEID
														,DESCRIPTION
														,STATUS)
											VALUES(?,?,?)",
											array(
												$inp_causeid
												,$inp_causedetail
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

	public function update($inp_causeid
						,$inp_causedetail
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
											"UPDATE MASTER_CAUSEDETAIL 
											SET CAUSEID=?
												,DESCRIPTION=?
												,STATUS=?
											WHERE ID=?",
											array(
												 $inp_causeid
												,$inp_causedetail
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
											"DELETE FROM MASTER_CAUSEDETAIL 
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

	public function causedetailfrom($causeid)
	{
		return Sqlsrv::array(
			$this->conn->connect(),
			"SELECT CD.ID,CD.DESCRIPTION,CD.CAUSEID,C.CAUSE,CD.STATUS
			FROM MASTER_CAUSEDETAIL CD
			LEFT JOIN MASTER_CAUSE C
			ON CD.CAUSEID = C.ID
			WHERE CD.CAUSEID = ?",
				[
					$causeid
				]
		);
	}

	public function CauseDeCheck($id)
	{
		$causedecheck =  Sqlsrv::array(
			$this->conn->connect(),
			"SELECT * FROM REPAIRDETAIL
			WHERE DETAIL = ?",
			[
				$id
			]
		);

		return $causedecheck;
	}


}	