<?php

namespace App\Models;

use Wattanar\Sqlsrv;
use App\Controllers\ConnectionController;

class DriverModel
{	

	public function __construct()
	{
		$this->conn = new ConnectionController;
	}

	public function all()
	{
		return Sqlsrv::array(
			$this->conn->connect(),
			"SELECT DM.ID [dm_id]
					,DM.*
					,C.ID [c_id]
					,C.*
					,P.ID [p_id]
					,P.*
					,D.ID [d_id]
					,D.*
					,S.ID [s_id]
					,S.*
			FROM MASTER_DRIVER DM
			LEFT JOIN MASTER_COMPANY C ON DM.COMPANY=C.ID
		    LEFT JOIN MASTER_POSITION P ON DM.POSITION=P.ID
		    LEFT JOIN MASTER_DEPARTMENT D ON DM.DEPARTMENT=D.ID
		    LEFT JOIN MASTER_SECTION S ON DM.SECTION=S.ID"
		);
	}

	public function driverInfo($inp_drivername,$id)
	{
		$driver =  Sqlsrv::array(
			$this->conn->connect(),
			"SELECT * FROM MASTER_DRIVER
			WHERE DRIVERNAME = ?
			AND ID != ?",
			[
				$inp_drivername,$id
			]
		);

		return $driver;
	}

	public function create($inp_drivername,$sel_comid,$sel_posid,$sel_depid,$sel_secid) 
	{	
		if (Sqlsrv::begin($this->conn->connect()) === false) {
			return 	[
				"result" => false,
				"message" => "Error start transaction."
			];
		}
		try
		{
			
				$insertDriver = sqlsrv_query(
											$this->conn->connect(),
											"INSERT INTO MASTER_DRIVER(DRIVERNAME,COMPANY,POSITION,DEPARTMENT,SECTION)
											VALUES(?,?,?,?,?)",
											array(
												$inp_drivername,$sel_comid,$sel_posid,$sel_depid,$sel_secid
											)
								);
				if($insertDriver)
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

	public function update($inp_drivername,$sel_comid,$sel_posid,$sel_depid,$sel_secid,$id) 
	{	
		if (Sqlsrv::begin($this->conn->connect()) === false) {
			return 	[
				"result" => false,
				"message" => "Error start transaction."
			];
		}
		try
		{

// var_dump($inp_drivername,$sel_comid,$sel_posid,$sel_depid,$sel_secid,$id);
				$insertDriver = sqlsrv_query(
											$this->conn->connect(),
											"UPDATE MASTER_DRIVER SET DRIVERNAME=?,COMPANY=?,POSITION=?,DEPARTMENT=?,SECTION=?
											WHERE ID=?",
											array(
												$inp_drivername,$sel_comid,$sel_posid,$sel_depid,$sel_secid,$id
											)
								);

				if($insertDriver)
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
				$insertDriver = sqlsrv_query(
											$this->conn->connect(),
											"DELETE FROM MASTER_DRIVER WHERE ID=?",
											array(
												$id
											)
								);
				if($insertDriver)
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

	public function DriverCheck($id)
	{
		$drivercheck =  Sqlsrv::array(
			$this->conn->connect(),
			"SELECT * FROM REPAIR
			WHERE DRIVER = ?",
			[
				$id
			]
		);

		return $drivercheck;
	}


}	