<?php

namespace App\Models;

use Wattanar\Sqlsrv;
use App\Controllers\ConnectionController;

class SectionModel
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
			FROM MASTER_SECTION"
		);
	}

	public function secInfo($inp_section,$id)
	{
		$cause =  Sqlsrv::array(
			$this->conn->connect(),
			"SELECT * FROM MASTER_SECTION
			WHERE SECTIONDES = ?
			AND ID != ?",
			[
				$inp_section,$id
			]
		);

		return $cause;
	}

	public function create($inp_section) 
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
											"INSERT INTO MASTER_SECTION(SECTIONDES)
											VALUES(?)",
											array(
												$inp_section
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

	public function update($inp_section,$id) 
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
											"UPDATE MASTER_SECTION 
											SET SECTIONDES=?
											WHERE ID=?",
											array(
												$inp_section,$id
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
											"DELETE FROM MASTER_SECTION 
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

	public function SecCheck($id)
	{
		$seccheck =  Sqlsrv::array(
			$this->conn->connect(),
			"SELECT * FROM MASTER_DRIVER
			WHERE SECTION = ?",
			[
				$id
			]
		);

		return $seccheck;
	}


}	