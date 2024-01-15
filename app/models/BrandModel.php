<?php

namespace App\Models;

use Wattanar\Sqlsrv;
use App\Controllers\ConnectionController;

class BrandModel
{	

	public function __construct()
	{
		$this->conn = new ConnectionController;
	}

	public function all()
	{
		return Sqlsrv::array(
			$this->conn->connect(),
			"SELECT * FROM MASTER_BRAND"
		);
	}

	public function brandInfo($inp_brandname,$id)
	{
		$brand =  Sqlsrv::array(
			$this->conn->connect(),
			"SELECT * FROM MASTER_BRAND
			WHERE BRAND = ?
			AND ID != ?",
			[
				$inp_brandname,$id
			]
		);

		return $brand;
	}

	public function create($inp_brandname) 
	{	
		if (Sqlsrv::begin($this->conn->connect()) === false) {
			return 	[
				"result" => false,
				"message" => "Error start transaction."
			];
		}
		try
		{
			
			$insertBrand = sqlsrv_query(
										$this->conn->connect(),
										"INSERT INTO MASTER_BRAND(BRAND)
										VALUES(?)",
										array(
											$inp_brandname
										)
							);
			if($insertBrand)
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

	public function update($inp_brandname,$id) 
	{	
		if (Sqlsrv::begin($this->conn->connect()) === false) {
			return 	[
				"result" => false,
				"message" => "Error start transaction."
			];
		}
		try
		{
				$insertBrand = sqlsrv_query(
											$this->conn->connect(),
											"UPDATE MASTER_BRAND SET BRAND=?
											WHERE ID=?",
											array(
												$inp_brandname,$id
											)
								);

				if($insertBrand)
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
				$insertBrand = sqlsrv_query(
											$this->conn->connect(),
											"DELETE FROM MASTER_BRAND WHERE ID=?",
											array(
												$id
											)
								);
				if($insertBrand)
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

	public function BrandCheck($id)
	{
		$brandcheck =  Sqlsrv::array(
			$this->conn->connect(),
			"SELECT * FROM MASTER_CAR
			WHERE BRAND = ?",
			[
				$id
			]
		);

		return $brandcheck;
	}


}	