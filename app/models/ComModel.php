<?php

namespace App\Models;

use Wattanar\Sqlsrv;
use App\Controllers\ConnectionController;

class ComModel
{	

	public function __construct()
	{
		$this->conn = new ConnectionController;
	}

	public function all()
	{
		return Sqlsrv::array(
			$this->conn->connect(),
			"SELECT ID
					,INTERNALCODE
					,DESCRIPTION
					,DESCRIPTIONTH
			FROM MASTER_COMPANY"
		);
	}

	public function check($inp_internalcode,$id)
	{
		$check =  Sqlsrv::array(
			$this->conn->connect(),
			"SELECT * FROM MASTER_COMPANY
			WHERE INTERNALCODE = ?
			AND ID != ?",
			[
				$inp_internalcode,$id
			]
		);

		return $check;
	}

	public function checkcom($inp_description,$id)
	{
		$checkcom =  Sqlsrv::array(
			$this->conn->connect(),
			"SELECT * FROM MASTER_COMPANY
			WHERE DESCRIPTION = ?
			AND ID != ?",
			[
				$inp_description,$id
			]
		);

		return $checkcom;
	}


	public function create($inp_internalcode,$inp_description,$inp_descriptionth) 
	{	
		if (Sqlsrv::begin($this->conn->connect()) === false) {
			return 	[
						"result" => false,
						"message" => "Error start transaction."
					];
		}
		try
		{
			$insertcomp = sqlsrv_query(
										$this->conn->connect(),
										"INSERT INTO MASTER_COMPANY(INTERNALCODE,DESCRIPTION,DESCRIPTIONTH) 
										VALUES(?,?,?)",
										array(
											$inp_internalcode,$inp_description,$inp_descriptionth
										)
			);
			if($insertcomp)
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

	public function update($inp_internalcode,$inp_description,$inp_descriptionth,$id) 
	{	
		if (Sqlsrv::begin($this->conn->connect()) === false) {
			return 	[
				"result" => false,
				"message" => "Error start transaction."
			];
		}
		try
		{
			$insertcomp = sqlsrv_query(
										$this->conn->connect(),
										"UPDATE MASTER_COMPANY 
										SET INTERNALCODE = ?
											,DESCRIPTION = ?
											,DESCRIPTIONTH = ?
										WHERE ID = ?",
										array(
											$inp_internalcode,$inp_description,$inp_descriptionth,$id
										)
			);

			if($insertcomp)
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
				$insertcomp = sqlsrv_query(
											$this->conn->connect(),
											"DELETE FROM MASTER_COMPANY WHERE ID=?",
											array(
												$id
											)
								);
				if($insertcomp)
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

	public function ComCheck($id)
	{
		$comcheck =  Sqlsrv::array(
			$this->conn->connect(),
			"SELECT * FROM REPAIR
			WHERE COMPANY = ?",
			[
				$id
			]
		);

		return $comcheck;
	}

}	