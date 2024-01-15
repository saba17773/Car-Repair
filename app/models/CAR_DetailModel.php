<?php

namespace App\Models;
use Wattanar\Sqlsrv;
use App\Controllers\ConnectionController;

class CAR_DetailModel
{
	public function __construct()
	{
		$this->conn = new ConnectionController;
	}

	public function all($carid)
	{
		return Sqlsrv::array(
				$this->conn->connect(),
				"SELECT MC.REGCAR
						,CD.ID
						,CD.CARDETAILID
						,CD.CARID
						,CD.INSURANCE
						-- ,CD.CREATEDATE
						-- ,CD.CLOSINGDATE
						,CONVERT(DATETIME, CONVERT(NVARCHAR(4),YEAR(CD.CREATEDATE)+543)+'/'+CONVERT(NVARCHAR(4),MONTH(CD.CREATEDATE))+'/'+CONVERT(NVARCHAR(4),DAY(CD.CREATEDATE))) [CREATEDATE]
						,CONVERT(DATETIME, CONVERT(NVARCHAR(4),YEAR(CD.CLOSINGDATE)+543)+'/'+CONVERT(NVARCHAR(4),MONTH(CD.CLOSINGDATE))+'/'+CONVERT(NVARCHAR(4),DAY(CD.CLOSINGDATE))) [CLOSINGDATE]
						,CD.DETAILTYPE
						,CD.STATUS
						,MI.INSURANCEDES
				FROM MASTER_CAR MC
				JOIN CARDETAIL CD
				ON MC.CARID = CD.CARID
				LEFT JOIN MASTER_INSURANCE MI
				ON CD.INSURANCE = MI.ID
			    WHERE MC.CARID = ?",
				[
					$carid
				]
		);
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

	public function createdetail($inp_carid
								,$sel_insuranceid
								,$inp_createdate
								,$inp_closingdate
								,$sel_type
								,$status
								,$filename)
	{

		 $conn 	= $this->conn->connect();
		 if (sqlsrv_begin_transaction($conn) === false)
		 {
         	die( print_r( sqlsrv_errors(), true ));
         }

		try
		{
			if($sel_type != 'INS')
			{
				$sel_insuranceid = "";
			}
			if($sel_type == 'IMG')
			{
				$inp_createdate = null;
				$inp_closingdate = null;
			}

			$detailid = self::gennumberseq($conn);

			if(isset($detailid))
			{
				$insertdetail = sqlsrv_query(
										$this->conn->connect(),
										"INSERT INTO CARDETAIL(
													CARDETAILID
													,CARID
													,INSURANCE
													,CREATEDATE
													,CLOSINGDATE
													,DETAILTYPE
													,STATUS								
													)
													
										VALUES(?,?,?,?,?,?,?)",
										array(
												$detailid
												,$inp_carid
												,$sel_insuranceid
												,$inp_createdate
												,$inp_closingdate
												,$sel_type
												,$status
											)
									);
			}

			if($insertdetail)
			{

				if(self::updatenumberseq($conn))
				{

							
					if(!(count($filename) == 1 && in_array('',$filename, true)))
					{
						if(self::uploadfile($conn,$detailid,$filename))
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

			if($sel_type != 'IMG')
			{
				$updatestatus = sqlsrv_query(
											$this->conn->connect(),
											"UPDATE CARDETAIL 
											SET STATUS = 0
											WHERE CARDETAILID != ?
											AND CARID = ?
											AND DETAILTYPE = ?",
											array(
													$detailid,
													$inp_carid,
													$sel_type
												)
										);
				if($insertdetail)
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
			Sqlsrv::rollback($this->conn->connect());
			return 	[
				"result" => false,
				"message" => $e->getMessage()
			];

		}

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
				AND S.NUMBER_SEQ like 'File-%'
				AND LEN(CONVERT(NVARCHAR(10),S.NEXTREC)) <= LEN(SUBSTRING(S.NUMBER_SEQ,CHARINDEX('-', S.NUMBER_SEQ)+1,LEN(S.NUMBER_SEQ)))"
		);

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
										AND NUMBER_SEQ like 'File-%'"
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
				AND S.NUMBER_SEQ like 'CD-%'
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
				AND NUMBER_SEQ like 'CD-%'";

		if(Sqlsrv::query($conn,$sql))
		{
			return true;
		}
		return false; 
	}

	public function updatedetail( $inp_detailid
								 ,$sel_insuranceid
								 ,$inp_createdate
								 ,$inp_closingdate
								 ,$inp_type
								 ,$status
								 ,$id
								 ,$inp_carid
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
			
			if($inp_type != 'INS')
			{
				$sel_insuranceid = "";
			}
			if($inp_type == 'IMG')
			{
				$inp_createdate = null;
				$inp_closingdate = null;
			}

			$updatedetail = sqlsrv_query(
									$this->conn->connect(),
									"UPDATE CARDETAIL SET
											INSURANCE = ?
											,CREATEDATE = ?
											,CLOSINGDATE = ?
											,DETAILTYPE =?
											,STATUS = ?
									WHERE ID = ?",
									array(
										 $sel_insuranceid
										 ,$inp_createdate
										 ,$inp_closingdate
										 ,$inp_type
										 ,$status
										 ,$id
										)
									);
			

			if($status == 1)
			{
				$updatedetail = sqlsrv_query(
									$this->conn->connect(),
									"UPDATE CARDETAIL 
									SET STATUS = 0
									WHERE DETAILTYPE = ?
									AND CARID = ?
									AND ID != ?",
									array(
										 $inp_type
										 ,$inp_carid
										 ,$id
										)
									);
			}
				


			if($updatedetail)
			{
				
				if(!(count($filename) == 1 && in_array('',$filename, true)))
				{
					if(self::uploadfile($conn,$inp_detailid,$filename))
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

	public function delete($detailid) 
	{	
		if (Sqlsrv::begin($this->conn->connect()) === false) {
			return 	[
				"result" => false,
				"message" => "Error start transaction."
			];
		}
		try
		{
				$deletedetail = sqlsrv_query(
											$this->conn->connect(),
											"DELETE FROM CARDETAIL 
											WHERE CARDETAILID=?",
											array(
												$detailid
											)
								);
				if($deletedetail)
				{
					$deletefile = sqlsrv_query(
											$this->conn->connect(),
											"DELETE FROM DATAFILE 
											WHERE TRANSID=?",
											array(
												$detailid
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

	public function getfiledelete($detailid)
	{
		$getfilename = Sqlsrv::array(
				$this->conn->connect(),
				"SELECT FILENAME
				FROM DATAFILE
				WHERE TRANSID=?",
				array(
					$detailid
				)
		);

		return $getfilename; 
        
	}


}