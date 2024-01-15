<?php

namespace App\Models;

use Wattanar\Sqlsrv;
use App\Controllers\ConnectionController;

class ClaimModel
{	

	public function __construct()
	{
		$this->conn = new ConnectionController;
	}

	public function all()
	{
		$userid = $_SESSION["userid"];	
		return Sqlsrv::array(
			$this->conn->connect(),
			"SELECT M.ID
					,M.CLAIMID
					,M.CARID
					,M.INSURANCE
					-- ,M.CLAIMDATE
					,CONVERT(DATETIME, CONVERT(NVARCHAR(4),YEAR(M.CLAIMDATE)+543)+'/'+CONVERT(NVARCHAR(4),MONTH(M.CLAIMDATE))+'/'+CONVERT(NVARCHAR(4),DAY(M.CLAIMDATE))) [CLAIMDATE]
					,M.CLAIMDETAIL
					,C.CARID
					,C.REGCAR
					,I.ID
					,I.INSURANCEDES 
			FROM CLAIM M
			LEFT JOIN MASTER_CAR C 
			ON M.CARID = C.CARID
			LEFT JOIN MASTER_INSURANCE I 
			ON I.ID = M.INSURANCE
			WHERE M.CarID IN (
								SELECT CM.CARID
								FROM MASTER_CAR CM
								WHERE CM.COMPANY IN (
														SELECT F.COMPANY
														FROM FACTORY F
														WHERE F.USERID = '$userid'
														)
								)"
		);
	}

	public function car()
	{
		$userid = $_SESSION["userid"];
		return Sqlsrv::array(
			$this->conn->connect(),
			"SELECT C.*
					,INS.INSURANCEDES
					,INS.CLOSINGDATE[INS]
					,INS.ID [INSURANCEID]
					,CASE WHEN INS.CLOSINGDATE <= GETDATE() THEN 0 
			  			  WHEN INS.CLOSINGDATE >= GETDATE() THEN 1
						  ELSE 2 END [StatusINS]	
					FROM MASTER_CAR C
					LEFT JOIN MASTER_BRAND B 
					ON B.ID = C.BRAND
					LEFT JOIN(
								SELECT CD.CarID
										,IC.INSURANCEDES
										,CD.CLOSINGDATE
										,CD.DetailType
										,IC.ID
								FROM CARDETAIL CD
								LEFT JOIN MASTER_INSURANCE IC 
								ON IC.ID = CD.INSURANCE
								WHERE CD.DetailType = 'INS'
								AND CD.STATUS = 1
				  			)INS ON INS.CarID = C.CarID
				  	WHERE C.COMPANY IN (
											SELECT F.COMPANY
											FROM FACTORY F
											WHERE F.USERID = '$userid'
											)"
		);
	}

	public function ins($carid)
	{
		return Sqlsrv::array(
			$this->conn->connect(),
			"SELECT C.*
					,INS.INSURANCE[INSURANCEID]
					,INS.INSURANCEDES
					,INS.CLOSINGDATE[Insurance]
					,CASE WHEN INS.CLOSINGDATE <= GETDATE() THEN 0 
			  			WHEN INS.CLOSINGDATE >= GETDATE() THEN 1
						ELSE 2 END[StatusInsurance]	
			FROM MASTER_CAR C
			LEFT JOIN MASTER_BRAND B ON B.ID = C.BRAND
			LEFT JOIN(
						SELECT CD.CarID
								,CD.INSURANCE
								,IC.INSURANCEDES
								,CD.CLOSINGDATE
								,CD.DetailType
						FROM CARDETAIL CD
						LEFT JOIN MASTER_INSURANCE IC 
						ON IC.ID = CD.INSURANCE
						WHERE CD.DetailType = 'INS'
						AND CD.STATUS = 1
				  	)INS ON INS.CarID = C.CarID
			WHERE  C.CarID='$carid'"
		);
	}

	public function insedit($insid)
	{
		return Sqlsrv::array(
			$this->conn->connect(),
			"SELECT *
			FROM MASTER_INSURANCE I
			WHERE  I.ID='$insid'"
		);
	}

	public function gennumberseqfile()
	{
		$gennumber = Sqlsrv::array(
				$this->conn->connect(),
				"SELECT TOP(1)
				STUFF(S.NUMBER_SEQ,LEN(S.NUMBER_SEQ) +1 -LEN(CONVERT(NVARCHAR(10),S.NEXTREC))
				,LEN(CONVERT(NVARCHAR(10),S.NEXTREC))
				,CONVERT(NVARCHAR(10),S.NEXTREC))[GENNUMBER]
				FROM MASTER_NUMBERSEQ S
				WHERE S.ACTIVE = 1
				AND S.NUMBER_SEQ like 'CMFile-%'
				AND LEN(CONVERT(NVARCHAR(10),S.NEXTREC)) <= LEN(SUBSTRING(S.NUMBER_SEQ,CHARINDEX('-', S.NUMBER_SEQ)+1,LEN(S.NUMBER_SEQ)))"
		);
		// var_dump($gennumber); exit();
		foreach ($gennumber as $key) {
            $numberfile = $key->GENNUMBER;
        }

        if($numberfile)
        {
        	$updatenumber = sqlsrv_query(
										$this->conn->connect(),
										"UPDATE MASTER_NUMBERSEQ
										SET NEXTREC = NEXTREC+1
										WHERE ACTIVE =1
										AND NUMBER_SEQ like 'CMFile-%'"
								);
			if($updatenumber)
			{
				return $numberfile;
			}
			else
			{
				return false; 
			}

        }
        else
        {
        	return false; 
        }

	}

	public function gennumberseq($conn)
	{
		
		$sql = "SELECT TOP(1)
				STUFF(S.NUMBER_SEQ,LEN(S.NUMBER_SEQ) +1 -LEN(CONVERT(NVARCHAR(10),S.NEXTREC))
				,LEN(CONVERT(NVARCHAR(10),S.NEXTREC))
				,CONVERT(NVARCHAR(10),S.NEXTREC))[GENNUMBER]
				FROM MASTER_NUMBERSEQ S
				WHERE S.ACTIVE = 1
				AND S.NUMBER_SEQ like 'CM-%'
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
				AND NUMBER_SEQ like 'CM-%'";

		if(Sqlsrv::query($conn,$sql))
		{
			return true;
		}
		return false; 
	}

	public function uploadfile($conn,$detailid,$filename)
	{
		$checkerror = 1;
		// echo '<pre>' .print_r($filename,true). "</pre>";
		// exit;
		foreach ($filename as $key => $row) 
		{

			// echo "<pre>" . print_r($key,true) . "</pre>";exit;
			$insertfile = sqlsrv_query(
						$conn,
						"INSERT INTO DATAFILE(
									TRANSID,
									FILENAME,
									FILENAMEORIGINAL
									)
						VALUES(?,?,?)",
						array(
								$detailid,
								$row['old'],
								$row['new']
							 )
						);
			// var_dump(sqlsrv_errors());exit;
			if(!$insertfile)
			{
				$checkerror = 2;
				break;
			}
			else
			{
				$checkerror = 3;
			}
		}
		if($checkerror ===2 || $checkerror ===1)
		{
			return false;
		}
		return true;

	}

	public function datafile($id)
	{
		return 	Sqlsrv::array(
				$this->conn->connect(),
				"SELECT *
				FROM DATAFILE 
				WHERE TRANSID = ?",
				array($id)
				);

	}

	public function getfiledelete($claimid)
	{
		$getfilename = Sqlsrv::array(
				$this->conn->connect(),
				"SELECT FILENAME
				FROM DATAFILE
				WHERE TRANSID=?",
				array(
					$claimid
				)
		);

		return $getfilename; 
        
	}

	public function deletedatafile($filename)
	{
		// var_dump($filename);exit();
		$insertrep =  sqlsrv_query(
					$this->conn->connect(),
					"DELETE FROM DATAFILE 
					WHERE FILENAME = ?",
					array($filename)
					);
		if($insertrep)
		{
			$path = "./upload/" . $filename;
			$flgDelete = unlink("$path");
			if($flgDelete)
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
				"message" => sqlsrv_errors()
				];
			}
			
		}
		else
		{
			return 	[
				"result" => false,
				"message" => sqlsrv_errors()
			];
		}
	}

	public function createclaim($carid
								,$insid
								,$claimdate
								,$claimdetail
								,$filename)
	{

		 $conn 	= $this->conn->connect();
		 if (sqlsrv_begin_transaction($conn) === false)
		 {
         	die( print_r( sqlsrv_errors(), true ));
         }

		try
		{
			
			$claimid = self::gennumberseq($conn);
		// var_dump($claimid,$carid
		// 						,$insid
		// 						,$claimdate
		// 						,$claimdetail
		// 						,$filename);exit();

			if(isset($claimid))
			{
				$insertclaim = sqlsrv_query(
										$this->conn->connect(),
										"INSERT INTO CLAIM(
															CLAIMID
															,CARID
															,INSURANCE
															,CLAIMDATE 
															,CLAIMDETAIL							
														)													
										VALUES(?,?,?,?,?)",
										array(				$claimid
															,$carid
															,$insid
															,$claimdate
															,$claimdetail
											)
									);
			}

			if($insertclaim)
			{
				if(self::updatenumberseq($conn))
				{
					if(!(count($filename) == 1 && in_array('',$filename, true)))
					{
						if(self::uploadfile($conn,$claimid,$filename))
						{
							$checkerror = true;
						}
						else
						{
							$checkerror = false;
						}
					}
					else
					{
						$checkerror = true;
					}
				}
				else
				{
					$checkerror = false;
				}
			}
			else
			{
				$checkerror = false;	
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
			Sqlsrv::rollback($this->conn->connect());
			return 	[
				"result" => false,
				"message" => $e->getMessage()
			];

		}

	}

	public function updateclaim( $carid
								 ,$insid
								 ,$claimdate
								 ,$claimdetail
								 ,$claimid
								 ,$filename
								)
	{
		 $conn 	= $this->conn->connect();
		 if ( sqlsrv_begin_transaction($conn) === false ) 
		 {
         	die( print_r( sqlsrv_errors(), true ));
         }
		try
		{			

			$updateclaim = sqlsrv_query(
									$this->conn->connect(),
									"UPDATE CLAIM SET
											CARID = ?
											,INSURANCE = ?
											,CLAIMDATE = ?
											,CLAIMDETAIL =?
									WHERE CLAIMID = ?",
									array(
										 $carid
										 ,$insid
										 ,$claimdate
										 ,$claimdetail
										 ,$claimid
										)
									);
		

			if($updateclaim)
			{
				
				if(!(count($filename) == 1 && in_array('',$filename, true)))
				{
					if(self::uploadfile($conn,$claimid,$filename))
					{
						$checkerror = true;
					}
					else
					{
						$checkerror = false;
					}
				}
				else
				{
					$checkerror = true;
				}

			}
			else
			{
				$checkerror = false;
			}


			if($checkerror)
			{
				sqlsrv_commit($conn);
				return 	[
					"result" => true,
					"message" => "Update successful."
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
		catch (Exception $e) 
		{
			Sqlsrv::rollback($this->conn->connect());
			return 	[
				"result" => false,
				"message" => $e->getMessage()
			];

		}
		
	}

	public function delete($claimid) 
	{	
		if (Sqlsrv::begin($this->conn->connect()) === false) {
			return 	[
				"result" => false,
				"message" => "Error start transaction."
			];
		}
		try
		{
				$deleteclaim = sqlsrv_query(
											$this->conn->connect(),
											"DELETE FROM CLAIM 
											WHERE CLAIMID=?",
											array(
												$claimid
											)
								);
				if($deleteclaim)
				{
					$deletefile = sqlsrv_query(
											$this->conn->connect(),
											"DELETE FROM DATAFILE 
											WHERE TRANSID=?",
											array(
												$claimid
											)
									);

					if($deletefile)
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

	public function loadpicture($idcliam)
    {
		$datafile = Sqlsrv::array(
				$this->conn->connect(),
				"SELECT FILENAME
				FROM DATAFILE
				WHERE TRANSID=?",
				array(
					$idcliam
				)
		);
		// return $datafile[0]->FILENAME; 
		return $datafile;
    }	

}