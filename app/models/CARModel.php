<?php

namespace App\Models;

use Wattanar\Sqlsrv;
use App\Controllers\ConnectionController;

class CARModel
{	

	public function __construct()
	{
		$this->conn = new ConnectionController;
	}

	public function all()
	{
		$user_id = $_SESSION["userid"];

		return Sqlsrv::array(
			$this->conn->connect(),
			"SELECT C.ID
					,C.CARID
					,C.BRAND
					,C.CARTYPE
					,C.REGISTERTYPE
					,C.CAPACITY
					,C.DRIVER
					-- ,C.DATEREG
					,CONVERT(DATETIME, CONVERT(NVARCHAR(4),YEAR(C.DATEREG)+543)+'/'+CONVERT(NVARCHAR(4),MONTH(C.DATEREG))+'/'+CONVERT(NVARCHAR(4),DAY(C.DATEREG))) [DATEREG]
					,C.REGCAR
					,C.REGCARDES
					,C.COMPANY
					,C.SECTION
					,C.ASSET
					,C.MILESCHECK
					,MB.BRAND[BRANDNAME]
					,MCT.CARTYPE[CARTYPENAME]
					,MRT.REGISTERTYPE[REGISTERTYPENAME]
					,MCP.CAPACITY[CAPACITYNAME]
					,MS.SECTIONDES
					,MC.DESCRIPTION[COMPANYNAME]
					,MD.DRIVERNAME
					,INS.INSURANCEDES
					,INS.INSURANCE
					,MP.PRVTH 
					-- ,INS.CLOSINGDATE[INS]
					,CONVERT(DATETIME, CONVERT(NVARCHAR(4),YEAR(INS.CLOSINGDATE)+543)+'/'+CONVERT(NVARCHAR(4),MONTH(INS.CLOSINGDATE))+'/'+CONVERT(NVARCHAR(4),DAY(INS.CLOSINGDATE))) [INS]
					,CASE WHEN INS.CLOSINGDATE <= GETDATE() THEN 0 
						  WHEN INS.CLOSINGDATE >= GETDATE() THEN 1
					ELSE 2 END[STATUS_INS]
					,TAX.CLOSINGDATE[TAX]
					,CASE WHEN TAX.CLOSINGDATE <= GETDATE() THEN 0 
						  WHEN TAX.CLOSINGDATE >= GETDATE() THEN 1
					ELSE 2 END[STATUS_TAX]	
					,ACT.CLOSINGDATE[ACT]
					,CASE WHEN ACT.CLOSINGDATE <= GETDATE() THEN 0 
						  WHEN ACT.CLOSINGDATE >= GETDATE() THEN 1
					ELSE 2 END[STATUS_ACT]	
			FROM MASTER_CAR C
			LEFT JOIN MASTER_BRAND MB 
			ON MB.ID = C.BRAND
			LEFT JOIN MASTER_CARTYPE MCT 
			ON MCT.ID = C.CARTYPE
			LEFT JOIN MASTER_REGISTERTYPE MRT 
			ON MRT.ID = C.REGISTERTYPE
			LEFT JOIN MASTER_CAPACITY MCP 
			ON MCP.ID = C.CAPACITY
			LEFT JOIN MASTER_SECTION MS 
			ON MS.ID = C.SECTION
			LEFT JOIN MASTER_COMPANY MC
			ON MC.ID = C.COMPANY 
			LEFT JOIN MASTER_DRIVER MD 
			ON MD.ID = C.DRIVER
			LEFT JOIN MASTER_PROVINCE MP
			ON C.REGCARDES = MP.ID
			LEFT JOIN(
						SELECT CDI.CARID,MI.INSURANCEDES,CDI.CLOSINGDATE,CDI.DETAILTYPE,CDI.INSURANCE
						FROM CARDETAIL CDI
						LEFT JOIN MASTER_INSURANCE MI ON MI.ID = CDI.INSURANCE
						WHERE CDI.DetailType = 'INS'
						AND CDI.STATUS = 1
					  )INS ON INS.CarID = C.CarID
			LEFT JOIN(
						SELECT CDT.CarID,CDT.CLOSINGDATE,CDT.DetailType
						FROM CARDETAIL CDT
						WHERE CDT.DetailType = 'TAX'
						AND CDT.STATUS = 1
					  )TAX ON TAX.CarID = C.CarID	
			LEFT JOIN(
						SELECT CDA.CarID,CDA.CLOSINGDATE,CDA.DetailType
						FROM CARDETAIL CDA
						WHERE CDA.DetailType = 'ACT'
						AND CDA.STATUS = 1
					  )ACT ON ACT.CarID = C.CarID
		  	WHERE C.COMPANY IN (
						select F.COMPANY
						from FACTORY F
						where F.USERID = '$user_id'
					  )"
		);
	}

	public function gennumberseq($conn)
	{
		
		$sql = "SELECT TOP(1)
				STUFF(S.NUMBER_SEQ,LEN(S.NUMBER_SEQ) +1 -LEN(CONVERT(NVARCHAR(10),S.NEXTREC))
				,LEN(CONVERT(NVARCHAR(10),S.NEXTREC))
				,CONVERT(NVARCHAR(10),S.NEXTREC))[GENNUMBER]
				FROM MASTER_NUMBERSEQ S
				WHERE S.ACTIVE = 1
				AND S.NUMBER_SEQ like 'C-%'
				AND LEN(CONVERT(NVARCHAR(10),S.NEXTREC)) <= LEN(SUBSTRING(S.NUMBER_SEQ,CHARINDEX('-', S.NUMBER_SEQ)+1,LEN(S.NUMBER_SEQ)))";

		$results = array();

		$query = sqlsrv_query(
			$conn,
			$sql
		);

		while ($f = sqlsrv_fetch_object($query)) 
		{
			$results[] = $f;	
		}
		return  $results[0]->GENNUMBER;
	}

	public function updatenumberseq($conn)
	{
		$sql = "UPDATE MASTER_NUMBERSEQ
				SET NEXTREC = NEXTREC+1
				WHERE ACTIVE =1
				AND NUMBER_SEQ like 'C-%'";

		if(Sqlsrv::query($conn,$sql))
		{
			return true;
		}
		return false; 
	}

	public function createcar( $inp_brandid
								,$inp_cartypeid	
								,$inp_registerid
								,$sel_capid
								,$sel_driverid
								,$inp_datereg
								// ,$inp_milesno
								,$inp_regcar
								,$sel_regcardes
								,$sel_comid
								,$inp_asset
								,$sel_secid
								,$milesac )
	{
		$conn 	= $this->conn->connect();
		if (sqlsrv_begin_transaction($conn) === false)
		{
         	die( print_r( sqlsrv_errors(), true ));
        }

        try
		{

			$carid = self::gennumberseq($conn);

			if(isset($carid))
			{

				$insertcar = sqlsrv_query(
										$this->conn->connect(),
										"INSERT INTO MASTER_CAR(
													CARID
													,BRAND
													,CARTYPE
													,REGISTERTYPE
													,CAPACITY
													,DRIVER
													,DATEREG
													-- ,MILESNO
													,REGCAR
													,REGCARDES
													,COMPANY
													,ASSET
													,SECTION
													,MILESCHECK									
													)
													
										VALUES(?,?,?,?,?,?,?,?,?,?,?,?,?)",
										array(
												$carid
												,$inp_brandid
												,$inp_cartypeid	
												,$inp_registerid
												,$sel_capid
												,$sel_driverid
												,$inp_datereg
												// ,$inp_milesno
												,$inp_regcar
												,$sel_regcardes
												,$sel_comid
												,$inp_asset
												,$sel_secid
												,$milesac
											)
									);
			}

			if($insertcar)
			{
				if(self::updatenumberseq($conn))
				{
					$checkerror = true;
				}
				else
				{
					$checkerror = false;
				}
			}

			if($checkerror)
			{
				sqlsrv_commit($conn);
				return 	[
						"result" => true,
						"message" => "Create successful."
					];	
			}
			else
			{
				sqlsrv_rollback($conn);
				return 	[
					"result" => false,
					"message" => sqlsrv_errors()
				];
			}


		}
		catch (Exception $e) {
			Sqlsrv::rollback($conn);
			return 	[
				"result" => false,
				"message" => $e->getMessage()
			];

		}	
	}

	public function updatecar( $inp_brandid
								,$inp_cartypeid	
								,$inp_registerid
								,$sel_capid
								,$sel_driverid
								,$inp_datereg
								// ,$inp_milesno
								,$inp_regcar
								,$sel_regcardes
								,$sel_comid
								,$sel_secid
								,$inp_asset
								,$milesac
								,$id)
	{
		 $conn 	= $this->conn->connect();
	 	if ( sqlsrv_begin_transaction($conn) === false ) 
		{
	    	die( print_r( sqlsrv_errors(), true ));
	    }
	
		try
		{
			$updatecar = sqlsrv_query(
										$this->conn->connect(),
										"UPDATE MASTER_CAR 
											SET BRAND = ?
												,CARTYPE = ?
												,REGISTERTYPE = ?
												,CAPACITY = ?
												,DRIVER = ?
												,DATEREG = ?
												-- ,MILESNO = ?
												,REGCAR = ?
												,REGCARDES = ?
												,COMPANY = ?
												,SECTION = ?
												,ASSET = ?
												,MILESCHECK = ?
										WHERE ID = ?",
										array(
												$inp_brandid
												,$inp_cartypeid	
												,$inp_registerid
												,$sel_capid
												,$sel_driverid
												,$inp_datereg
												// ,$inp_milesno
												,$inp_regcar
												,$sel_regcardes
												,$sel_comid
												,$sel_secid
												,$inp_asset
												,$milesac
												,$id
										)
							);
			if($updatecar)
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

		}
		catch (Exception $e) 
		{
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
				$deletecar = sqlsrv_query(
											$this->conn->connect(),
											"DELETE FROM MASTER_CAR WHERE ID=?",
											array(
												$id
											)
								);
				if($deletecar)
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

	public function carAsset($inp_asset)
	{
		$carAsset =  Sqlsrv::array(
			$this->conn->connect(),
			"SELECT * FROM MASTER_CAR
			WHERE ASSET = ?",
			[
				$inp_asset
			]
		);

		return $carAsset;
	}

	public function carProvince($inp_regcar,$sel_regcardes)
	{
		$carProvince =  Sqlsrv::array(
			$this->conn->connect(),
			"SELECT * FROM MASTER_CAR
			WHERE REGCAR = ?
			AND REGCARDES = ?",
			[
				$inp_regcar
				,$sel_regcardes

			]
		);

		return $carProvince;
	}

	public function provinceload()
	{
		return Sqlsrv::array(
			$this->conn->connect(),
			"SELECT * 
			FROM MASTER_PROVINCE"
		);

	}


}	