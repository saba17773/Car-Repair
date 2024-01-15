<?php

namespace App\Models;

use Wattanar\Sqlsrv;
use App\Controllers\ConnectionController;

class RepairModel
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
			"SELECT R.ID
					,R.REPAIRID
					-- ,R.CREATEDATE
					,CONVERT(DATETIME, CONVERT(NVARCHAR(4),YEAR(R.CREATEDATE)+543)+'/'+CONVERT(NVARCHAR(4),MONTH(R.CREATEDATE))+'/'+CONVERT(NVARCHAR(4),DAY(R.CREATEDATE))) [CREATEDATE]
					,CONVERT(DATETIME, CONVERT(NVARCHAR(4),YEAR(R.REPAIREDDATE)+543)+'/'+CONVERT(NVARCHAR(4),MONTH(R.REPAIREDDATE))+'/'+CONVERT(NVARCHAR(4),DAY(R.REPAIREDDATE))) [REPAIRED]
					,R.COMPANY [COMPANYID]
					,R.STATUSRENEW
					,CM.INTERNALCODE
					,R.DEPARTMENT [DEPARTMENTID]
					,R.SECTION [SECTIONID]
					,R.DRIVER [DRIVERID]
					,DM.DRIVERNAME
					,R.CARID
					,C.BRAND [BRANDID]
					,BM.BRAND
					,C.REGISTERTYPE [REGISTERTYPEID]
					,RTM.REGISTERTYPE
					,C.REGCAR
					,R.MILESNO
					,R.REMARK
					,R.STATUSREPAIR
					,R.CREATEBY
					,R.UPDATEBY
					,R.UPDATEDATE
					,SM.STATUSEN
					,SM.STATUSTH
					,U.DEPARTMENT
					,C.MILESCHECK
					,Case when (SELECT TOP(1) 1 FROM REPAIRDETAIL L WHERE L.REPAIRID = R.REPAIRID) = 1 THEN 1 ELSE 0 END [CHECKLINE] 
					-- ,DN.RUNNINGDSG
					,m1.RUNNINGDSG 
			FROM REPAIR R
			LEFT JOIN MASTER_COMPANY CM ON CM.ID = R.COMPANY
			LEFT JOIN MASTER_DRIVER DM ON DM.ID = R.DRIVER
			LEFT JOIN MASTER_CAR C ON C.CarID = R.CarID
			LEFT JOIN MASTER_BRAND BM ON BM.ID=C.BRAND
			LEFT JOIN MASTER_REGISTERTYPE RTM ON RTM.ID=C.REGISTERTYPE
			LEFT JOIN MASTER_STATUS SM ON SM.ID=R.STATUSREPAIR
			LEFT JOIN MASTER_USER U ON U.ID = R.CREATEBY
			-- LEFT JOIN DSGRUNNING DN ON R.REPAIRID = DN.REPAIRID
			LEFT JOIN DSGRUNNING m1
			ON R.REPAIRID = m1.REPAIRID 
			AND m1.ID = (
					SELECT MAX(m2.ID)
					FROM DSGRUNNING m2 
					WHERE m2.REPAIRID = R.REPAIRID
				)
			WHERE R.COMPANY IN (
									select F.COMPANY
									from FACTORY F
									where F.USERID = '$user_id'
								  )
			ORDER BY Year(R.CREATEDATE) DESC,CONVERT(int,SUBSTRING(R.RepairID,14,4)) DESC,R.STATUSREPAIR ASC"
		);
	}

	public function allclick($RepairID)
	{
		return Sqlsrv::array(
			$this->conn->connect(),
			"SELECT	ROW_NUMBER() OVER (Order by RD.REPAIRID) AS RowNumber
					,RD.REPAIRID
					,RD.LINENUM
					-- ,RD.REPAIRDATE
					-- ,CONVERT(DATETIME, CONVERT(NVARCHAR(4),YEAR(RD.REPAIRDATE)+543)+'/'+CONVERT(NVARCHAR(4),MONTH(RD.REPAIRDATE))+'/'+CONVERT(NVARCHAR(4),DAY(RD.REPAIRDATE))) [REPAIRDATE]
					,CONVERT(NVARCHAR(4),YEAR(RD.REPAIRDATE)+543) +'/'+ CONVERT(NVARCHAR(4),MONTH(RD.REPAIRDATE)) +'/'+ CONVERT(NVARCHAR(4),DAY(RD.REPAIRDATE)) AS REPAIRDATE
					-- ,RD.ITEM
					-- ,RD.REASON
					,RD.DETAIL[DETAILID]
					,CD.DESCRIPTION
					,RD.CAUSE[CAUSEID]
					,CA.CAUSE
					,RD.CRADLE[CRADLEID]
					,C.CRADLE
					,RD.NOTE
					,RD.PRICE
					,RD.STATUS	
			FROM REPAIRDETAIL RD
			LEFT JOIN MASTER_CRADLE C ON C.ID = RD.CRADLE
			LEFT JOIN MASTER_CAUSE CA ON CA.ID = RD.CAUSE
			LEFT JOIN MASTER_CAUSEDETAIL CD ON CD.ID = RD.DETAIL
			WHERE RD.RepairID='$RepairID'"
		);
	}

	public function Manager()
	{
		$userid = $_SESSION["userid"];
		return Sqlsrv::array(
			$this->conn->connect(),
			"SELECT U.*
		    FROM MASTER_USER U
		    WHERE U.ID IN (
					select M.MANAGERID
					from USERMANAGER M
					where M.USERID = '$userid'
					)"
		);
	}

	public function Cradle()
	{
		return Sqlsrv::array(
			$this->conn->connect(),
			"SELECT * FROM MASTER_CRADLE"
		);
	}

	public function Driver()
	{
		$user_id = $_SESSION["userid"];
		$secid = $_SESSION["secid"];
		return Sqlsrv::array(
			$this->conn->connect(),
			"SELECT *
			FROM MASTER_DRIVER D
			WHERE D.COMPANY IN (
									select F.COMPANY
									from FACTORY F
									where F.USERID = '$user_id'
								  )
			-- AND D.SECTION='$secid'
			"
		);
	}
	public function car()
	{
		$user_id = $_SESSION["userid"];
		$secid = $_SESSION["secid"];
		return Sqlsrv::array(
			$this->conn->connect(),
			"SELECT *
			FROM MASTER_CAR C
			LEFT JOIN MASTER_BRAND BM
			ON BM.ID=C.BRAND
			LEFT JOIN MASTER_REGISTERTYPE MRT
			ON MRT.ID=C.REGISTERTYPE
			WHERE C.COMPANY IN (
									select F.COMPANY
									from FACTORY F
									where F.USERID = '$user_id'
								  )
			-- AND C.SECTION='$secid'
			"
		);
	}
	public function carbycom($com)
	{
		$user_id = $_SESSION["userid"];
		$secid = $_SESSION["secid"];
		return Sqlsrv::array(
			$this->conn->connect(),
			"SELECT *
			FROM MASTER_CAR C
			LEFT JOIN MASTER_BRAND BM
			ON BM.ID=C.BRAND
			LEFT JOIN MASTER_REGISTERTYPE MRT
			ON MRT.ID=C.REGISTERTYPE
			WHERE C.COMPANY ='$com'
			-- WHERE C.COMPANY IN (
			-- 						select F.COMPANY
			-- 						from FACTORY F
			-- 						where F.USERID = '$user_id'
			-- 					  )
			-- AND C.SECTION='$com'
			"
		);
	}

	public function com()
	{
		$user_id = $_SESSION["userid"];
		return Sqlsrv::array(
			$this->conn->connect(),
			"SELECT * FROM MASTER_COMPANY C
			WHERE C.ID IN (
									select F.COMPANY
									from FACTORY F
									where F.USERID = '$user_id'
								  )"
		);
	}

	public function dep()
	{
		$Depid = $_SESSION["depid"];
		return Sqlsrv::array(
			$this->conn->connect(),
			"SELECT * FROM MASTER_DEPARTMENT D"
		);
	}

	public function sec()
	{
		$Secid = $_SESSION["secid"];
		return Sqlsrv::array(
			$this->conn->connect(),
			"SELECT * FROM MASTER_SECTION S
			-- WHERE S.ID = '$Secid'
			"
		);
	}

	public function cardetail($car)
	{
		return Sqlsrv::array(
			$this->conn->connect(),
			"SELECT C.CARID
					,C.REGCAR
					,C.MILESCHECK
					,BM.BRAND
					,RTM.REGISTERTYPE
			FROM MASTER_CAR C
			LEFT JOIN MASTER_BRAND BM ON BM.ID=C.BRAND
			LEFT JOIN MASTER_REGISTERTYPE RTM ON RTM.ID=C.REGISTERTYPE
			WHERE  C.CarID='$car'"
		);
	}

	public function gennumberseq($conn)
	{

		$query = Sqlsrv::queryArray(
			$conn,
			"SELECT TOP(1)
				STUFF(S.NUMBER_SEQ,LEN(S.NUMBER_SEQ) +1 -LEN(CONVERT(NVARCHAR(10),S.NEXTREC))
				,LEN(CONVERT(NVARCHAR(10),S.NEXTREC))
				,CONVERT(NVARCHAR(10),S.NEXTREC))[GENNUMBER]
				FROM MASTER_NUMBERSEQ S
				WHERE S.ACTIVE = 1
				AND S.NUMBER_SEQ = '0000'
				AND S.SERIES = year(getdate())
				AND LEN(CONVERT(NVARCHAR(10),S.NEXTREC)) <= LEN(SUBSTRING(S.NUMBER_SEQ,CHARINDEX('-', S.NUMBER_SEQ)+1,LEN(S.NUMBER_SEQ)))"
		);
		// $sql = "SELECT TOP(1)
		// 		STUFF(S.NUMBER_SEQ,LEN(S.NUMBER_SEQ) +1 -LEN(CONVERT(NVARCHAR(10),S.NEXTREC))
		// 		,LEN(CONVERT(NVARCHAR(10),S.NEXTREC))
		// 		,CONVERT(NVARCHAR(10),S.NEXTREC))[GENNUMBER]
		// 		FROM MASTER_NUMBERSEQ S
		// 		WHERE S.ACTIVE = 1
		// 		AND S.NUMBER_SEQ = '0000'
		// 		AND S.SERIES = year(getdate())
		// 		AND LEN(CONVERT(NVARCHAR(10),S.NEXTREC)) <= LEN(SUBSTRING(S.NUMBER_SEQ,CHARINDEX('-', S.NUMBER_SEQ)+1,LEN(S.NUMBER_SEQ)))";

		// $results = array();

		// $query = sqlsrv_query(
		// 	$conn,
		// 	$sql
		// );

		// while ($f = sqlsrv_fetch_object($query))
		// {
		// 	$results[] = $f;
		// }
		return  $query[0]['GENNUMBER'];
	}

	public function updatenumberseq($conn)
	{
		// $sql = "UPDATE MASTER_NUMBERSEQ
		// 		SET NEXTREC = NEXTREC+1
		// 		WHERE ACTIVE =1
		// 		AND NUMBER_SEQ = '0000'
		// 		AND SERIES = year(getdate())";

		$sql = sqlsrv_query(
			$conn,
			"UPDATE MASTER_NUMBERSEQ
			SET NEXTREC = NEXTREC+1
			WHERE ACTIVE =1
			AND NUMBER_SEQ = '0000'
			AND SERIES = year(getdate())"
		);

		if($sql){
			return true;
		}else{
			return false;
		}
	}

	public function create($sel_com
						  ,$sel_Department
						  ,$sel_Section
						  ,$sel_Driver
						  ,$sel_car
						  ,$inp_milesNo
						  ,$inp_remark
						  ,$inp_createBy
						  ,$status)
	{

		$conn 	= $this->conn->connect();
		if (sqlsrv_begin_transaction($conn) === false)
		{
         	die( print_r( sqlsrv_errors(), true ));
        }


        try
		{

			$repairid = self::gennumberseq($conn);
			// echo $repairid;
			// exit();
			$repairid = $sel_car.'-'.date('Y').sprintf("%02d", date('m')).'-'.$repairid;
			// var_dump($repairid);exit();

			if(isset($repairid))
			{
				$insertrepair = sqlsrv_query(
										$this->conn->connect(),
										"INSERT INTO REPAIR(REPAIRID
															,COMPANY
															,DEPARTMENT
															,SECTION
															,DRIVER
															,CARID
															,MILESNO
															,REMARK
															,CREATEBY
															,CREATEDATE
															,STATUSREPAIR)
											VALUES(?,?,?,?,?,?,?,?,?,getDate(),?)",
											array(
												$repairid
												,$sel_com
												,$sel_Department
												,$sel_Section
												,$sel_Driver
												,$sel_car
												,$inp_milesNo
												,$inp_remark
												,$inp_createBy
												,$status
											)
									);
			}

			if($insertrepair)
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
			Sqlsrv::rollback($this->conn->connect());
			return 	[
				"result" => false,
				"message" => $e->getMessage()
			];

		}

	}

	public function update($sel_com
						  ,$sel_Department
						  ,$sel_Section
						  ,$sel_Driver
						  ,$sel_car
						  ,$inp_milesNo
						  ,$inp_remark
						  ,$inp_updateBy
						  ,$id)
	{
		$conn 	= $this->conn->connect();
	 	if ( sqlsrv_begin_transaction($conn) === false )
		{
	    	die( print_r( sqlsrv_errors(), true ));
	    }

		try
		{
			$updaterepair = sqlsrv_query(
										$this->conn->connect(),
										"UPDATE REPAIR
											SET COMPANY=?
												,DEPARTMENT=?
		 										,SECTION=?
		 										,DRIVER=?
	 											,CARID=?
		 										,MILESNO=?
		 										,REMARK=?
		 										,UPDATEBY=?
		 										,UPDATEDATE=GetDate()
										WHERE ID=?",
										array(
											   $sel_com
											  ,$sel_Department
											  ,$sel_Section
											  ,$sel_Driver
											  ,$sel_car
											  ,$inp_milesNo
											  ,$inp_remark
											  ,$inp_updateBy
											  ,$id
										)
							);
			if($updaterepair)
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

	public function delete($id,$repairid)
	{
		if (Sqlsrv::begin($this->conn->connect()) === false) {
			return 	[
				"result" => false,
				"message" => "Error start transaction."
			];
		}
		try
		{
				$deleterep = sqlsrv_query(
											$this->conn->connect(),
											"DELETE FROM REPAIR WHERE ID=?",
											array(
												$id
											)
								);
				if($deleterep)
				{
					$deleterepline = sqlsrv_query(
											$this->conn->connect(),
											"DELETE FROM REPAIRDETAIL WHERE REPAIRID=?",
											array(
												$repairid
											)
								);

					if($deleterepline)
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

	public function create_line(
								// $sel_causedetail
								$dd_detail_id
								,$sel_cause
								,$inp_price
								,$inp_daterepair
								,$text_note
								// ,$sel_cradle
								,$dd_cradle_id
								,$inp_createByline
								,$inp_repair_line)
	{
		if (Sqlsrv::begin($this->conn->connect()) === false) {
			return 	[
				"result" => false,
				"message" => "Error start transaction."
			];
		}
		try
		{
				$insertrepline = sqlsrv_query(
					$this->conn->connect(),
					"INSERT INTO REPAIRDETAIL(DETAIL										 
											 ,CAUSE
											 ,PRICE
											 ,STATUS
											 ,REPAIRDATE
											 ,NOTE
											 ,CRADLE
											 ,CREATEBY
											 ,REPAIRID)
					VALUES(?,?,?,5,?,?,?,?,?)",
					array(
								// $sel_causedetail
								$dd_detail_id
								,$sel_cause
								,$inp_price
								,$inp_daterepair
								,$text_note
								// ,$sel_cradle
								,$dd_cradle_id
								,$inp_createByline
								,$inp_repair_line)
				);
				if($insertrepline)
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

	public function update_line(
								// $sel_causedetail
								$dd_detail_id
								,$sel_cause
								,$inp_price
								,$inp_daterepair
								,$text_note
								// ,$sel_cradle
								,$dd_cradle_id
								,$inp_updateByline
								,$inp_repair_line
								,$inp_line_num)
	{
		if (Sqlsrv::begin($this->conn->connect()) === false) {
			return 	[
				"result" => false,
				"message" => "Error start transaction."
			];
		}
		try
		{

			$updaterepline = sqlsrv_query(
				$this->conn->connect(),
				"UPDATE REPAIRDETAIL 
				SET DETAIL=?
					,CAUSE=?
					,PRICE=?
					,STATUS='5'
					,REPAIRDATE=?
					,NOTE=?
					,CRADLE=?
					,UPDATEBY=?
				WHERE REPAIRID=? 
				AND LINENUM=?",
				array(
					// $sel_causedetail
					$dd_detail_id
					,$sel_cause
					,$inp_price
					,$inp_daterepair
					,$text_note
					// ,$sel_cradle
					,$dd_cradle_id
					,$inp_updateByline
					,$inp_repair_line
					,$inp_line_num)
			);

			
			if($updaterepline == true){
				$updaterepstatus = sqlsrv_query(
					$this->conn->connect(),
					"UPDATE REPAIR  
					SET STATUSREPAIR = '5' 
					WHERE REPAIRID = '$inp_repair_line'"
					
				);
			}

			if($updaterepline)
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

	public function delete_line($id_line
								,$RepairNum_line)
	{
		if (Sqlsrv::begin($this->conn->connect()) === false) {
			return 	[
				"result" => false,
				"message" => "Error start transaction."
			];
		}
		try
		{
				$deleterepline = sqlsrv_query(
											$this->conn->connect(),
											"DELETE FROM REPAIRDETAIL
											WHERE REPAIRID=?
											AND LINENUM=?",
											array(
												$id_line
												,$RepairNum_line
											)
								);
				if($deleterepline)
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

	public function updatenew($id)
	{
		if (Sqlsrv::begin($this->conn->connect()) === false) {
			return 	[
				"result" => false,
				"message" => "Error start transaction."
			];
		}
		try
		{
				$updaterep = sqlsrv_query(
											$this->conn->connect(),
											"UPDATE REPAIR
											SET STATUSREPAIR = 4
											WHERE ID=?",
											array(
												$id
											)
								);
				if($updaterep)
				{
					return true;

				}
				else
				{
					return false;
				}

		}catch (Exception $e) {
			Sqlsrv::rollback($this->conn->connect());
			return 	[
				"result" => false,
				"message" => $e->getMessage()
			];
		}
	}

	public function ischeckmiles($CarID, $milesNo)//note_edit_20180622
	{

	  if(strlen($milesNo) > 7)
	  {
	   	return ["status" => 404, "message" => "ป้อนเลขไมล์มกกว่ากำหนด"];
	  }

		  $query = "SELECT R.* FROM REPAIR R
					    JOIN
					    (
					     SELECT MAX(ID)[ID],R.CARID
					     from REPAIR R
					     WHERE R.CARID = '$CarID' AND R.STATUSREPAIR != 9
					     GROUP BY R.CARID
					    )M
					    ON R.ID = M.ID
					    AND R.CARID = M.CARID";

	  	$isrow = Sqlsrv::hasRows($this->conn->connect(),$query);
	  	if($isrow == true){
		   	$result = Sqlsrv::queryArray($this->conn->connect(),$query);
		   	foreach ($result as $k) {
			   	if( $milesNo >= $k['MILESNO']){
			     	return ["status" => 200, "message" => "Complete"];
			    }
			    else{
			     	return ["status" => 404, "message" => "ป้อนเลขไมล์น้อยกว่าข้อมูลเดิม"];
			    }
		   	}
	  }
	  else{
	   	return ["status" => 200, "message" => "Complete"];
	  }
	}

	public function causedetail($causeid)
	{
		return Sqlsrv::array(
			$this->conn->connect(),
			"SELECT *
			FROM MASTER_CAUSEDETAIL CD
			WHERE  CD.CAUSEID='$causeid'
			AND CD.STATUS = 1"
		);
	}

	public function causedetailtest($causeid)
	{
		return Sqlsrv::array(
			$this->conn->connect(),
			"SELECT *
			FROM MASTER_CAUSEDETAIL CD
			WHERE CD.STATUS = 1
			AND CD.CAUSEID='$causeid'"
		);
	}

	public function loadrepairitem($idrepair)
    {
     
		$datafile = Sqlsrv::array(
				$this->conn->connect(),
				"SELECT LINENUM
				FROM REPAIRDETAIL
				WHERE REPAIRID=?",
				array(
					$idrepair
				)
		);

		return $datafile[0]->LINENUM; 

    }

    public function repaireddate($inp_repaired, $statusrenew , $repairid)
    {
    	
    	$user_id = $_SESSION["userid"];
    	$repaireddate = sqlsrv_query(
				$this->conn->connect(),
				"UPDATE REPAIR 
				SET REPAIREDDATE = ?	
					,STATUSRENEW = ?
					,REPAIREDBY = '$user_id'
					,REPAIREDLOGDATE = GetDate()
				WHERE REPAIRID = ?",
				array(
					$inp_repaired
					,$statusrenew
					,$repairid)
			);

			if($repaireddate)
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

     public function deleterepaireddate($inp_repaired, $statusrenew , $repairid)
    {
    	
    	$user_id = $_SESSION["userid"];
    	$repaireddate = sqlsrv_query(
				$this->conn->connect(),
				"UPDATE REPAIR 
				SET REPAIREDDATE = ?	
					,STATUSRENEW = ?
					,UNREPAIREDBY = '$user_id'
					,UNREPAIREDLOGDATE = GetDate()
				WHERE REPAIRID = ?",
				array(
					$inp_repaired
					,$statusrenew
					,$repairid)
			);

			if($repaireddate)
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

    public function cancel($id)
	{
		if (Sqlsrv::begin($this->conn->connect()) === false) {
			return 	[
				"result" => false,
				"message" => "Error start transaction."
			];
		}

		try
		{
				$cancel = sqlsrv_query(
					$this->conn->connect(),
					"UPDATE REPAIR SET STATUSREPAIR =? WHERE ID=?",
					array(
						9,$id
					)
				);

				if($cancel)
				{
					return true;
				}
				else
				{
					return false;
				}

		}catch (Exception $e) {
			Sqlsrv::rollback($this->conn->connect());
			return 	[
				"result" => false,
				"message" => $e->getMessage()
			];
		}

	}

}
