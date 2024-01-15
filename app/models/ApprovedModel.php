<?php

namespace App\Models;

use Wattanar\Sqlsrv;
use App\Controllers\ConnectionController;

use App\Models\EmailModel;

class ApprovedModel
{	

	public function __construct()
	{
		$this->conn = new ConnectionController;
        $this->mail = new \PHPMailer;
        $this->email = new EmailModel;//tan_edit_20180704
	}

	public function request($id)
	{
		return Sqlsrv::array(
			$this->conn->connect(),
			"SELECT *
			FROM REPAIR R
			LEFT JOIN MASTER_CAR C
			ON C.CARID = R.CARID
			WHERE R.REPAIRID = '$id'"
		);
	}

	public function directer($id)
	{
		return Sqlsrv::array(
			$this->conn->connect(),
			"SELECT *
			FROM REPAIR R
			LEFT JOIN MASTER_CAR C
			ON C.CARID = R.CARID
			WHERE R.REPAIRID = '$id'"
		);
	}

	public function approved_request($status,$app,$id) 
	{	
		if (Sqlsrv::begin($this->conn->connect()) === false) {
			return 	[
				"result" => false,
				"message" => "Error start transaction."
			];
		}
		try
		{

				$reply = $this->email->reply($status,$id,$app);//tan_edit_20180704

				if($reply==true)
				{
					$updatestatus = sqlsrv_query(
											$this->conn->connect(),
											"UPDATE REPAIR SET STATUSREPAIR=?,APPROVEDBY=?,APPROVEDDATE=GetDate(),APPROVALREQUEST=?
											WHERE REPAIRID=?",
											array(
												$status,$app,1,$id
											)
								);
					if($updatestatus)
					{

						return 	[
								"result" => true,
								"message" => "Approved successful."
						];
									
					}
					else
					{
						return 	[
								"result" => false,
								"message" => "Approved Failed."
						];
					}
				}

				return 	[
								"result" => false,
								"message" => "Approved Failed."
						];
				

		}catch (Exception $e) {
			Sqlsrv::rollback($this->conn->connect());
			return 	[
				"result" => false,
				"message" => $e->getMessage()
			];
		}	    
	}


	public function approved_directer($status,$app,$id) 
	{	
		if (Sqlsrv::begin($this->conn->connect()) === false) {
			return 	[
				"result" => false,
				"message" => "Error start transaction."
			];
		}
		try
		{
				$updatestatus = sqlsrv_query(
											$this->conn->connect(),
											"UPDATE REPAIR SET STATUSREPAIR=?,APPROVEDBYDIRECTOR=?,APPROVEDDATEDIRECTOR=GetDate()
											WHERE REPAIRID=?",
											array(
												$status,$app,$id
											)
								);
				if($updatestatus)
				{

					return 	[
							"result" => true,
							"message" => "Approved successful."
					];
								
				}
				else
				{
					return 	[
							"result" => false,
							"message" => "Approved Failed."
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

	public function approved_repair_line($status,$idline) 
	{	
		if (Sqlsrv::begin($this->conn->connect()) === false) {
			return 	[
				"result" => false,
				"message" => "Error start transaction."
			];
		}
		try
		{
			$updatestatus = sqlsrv_query(
										$this->conn->connect(),
										"UPDATE REPAIRDETAIL 
										SET STATUS=?
										WHERE LINENUM=?",
										array(
											$status,$idline
										)
							);
			if($updatestatus)
			{
				return 	[
						"result" => true,
						"message" => "Approved successful."
				];								
			}
			else
			{
				return 	[
						"result" => false,
						"message" => "Approved Failed."
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

	public function approved_repair($s,$idapp,$RepairID,$director=false) 
	{	
		if (Sqlsrv::begin($this->conn->connect()) === false) {
			return 	[
				"result" => false,
				"message" => "Error start transaction."
			];
		}
		try
		{
	
			if($director == false){
				$reply = $this->email->reply($s,$RepairID,$idapp);//tan_edit_20180704
			}else{
				$reply = $this->email->reply($s,$RepairID,$idapp,true);//tan_edit_20180704
			}
			
			$check = true;//tan_edit_20180704
		
			if($reply == true)//tan_edit_20180704
			{
				if($s==8)//tan_edit_20180704
				{
					// $directer = Sqlsrv::array($this->conn->connect(),
					//             "SELECT TOP(1) A.MANAGERID,B.ID,B.EMAIL
					//             FROM MASTER_USER U
					//             LEFT JOIN (
					// 							select *
					// 							from USERMANAGER UM
					// 						)A ON A.USERID = U.ID
					// 						LEFT JOIN  (
					// 									select *
					// 									from MASTER_USER U 
					// 									)B ON B.ID = A.MANAGERID
					//             WHERE U.ID = ?",[$idapp]);

					// foreach ($directer as $d) {
					// 	$email_directer [] = $d->ID;
					// }
					
					// $send_directer = $this->email->send("mail_directer",$RepairID,$email_directer);

					// if($send_directer){
						$updatestatus = sqlsrv_query(
								$this->conn->connect(),
								"UPDATE REPAIR 
								SET STATUSREPAIR=?
									,APPROVEDBYHR=?
									,APPROVEDDATEHR=GetDate()
									,APPROVALREPAIR=?
								WHERE REPAIRID=?",
								array(
									$s,$idapp,1,$RepairID
								));
					

				}//tan_edit_20180704
				else{
					$updatestatus = sqlsrv_query(
								$this->conn->connect(),
								"UPDATE REPAIR 
								SET STATUSREPAIR=?
									,APPROVEDBYDIRECTOR=?
									,APPROVEDDATEDIRECTOR=GetDate()
									,APPROVALDIRECTOR=?
								WHERE REPAIRID=?",
								array(
									$s,$idapp,1,$RepairID
								));
				}

				

				if($updatestatus)
				{
					return 	[
							"result" => true,
							"message" => "Approved successful."
					];								
				}
				else
				{
					return 	[
							"result" => false,
							"message" => "Approved Failed."
					];
				}
			}
			

		}catch (Exception $e) {
			Sqlsrv::rollback($this->conn->connect());
			return 	[
				"result" => false,
				"message" => $e->getMessage()
			];
		}	    
	}

	public function approved_Dr($s,$idapp,$RepairID) 
	{	
		if (Sqlsrv::begin($this->conn->connect()) === false) {
			return 	[
				"result" => false,
				"message" => "Error start transaction."
			];
		}
		try
		{
			// var_dump($s,$RepairID,$idapp);
			$updatestatus = sqlsrv_query(
										$this->conn->connect(),
										"UPDATE REPAIR 
										SET STATUSREPAIR=?
											,APPROVEDBYDIRECTOR=?
											,APPROVEDDATEDIRECTOR=GetDate()
										WHERE REPAIRID=?",
										array(
											$s,$idapp,$RepairID
										)
							);
			if($updatestatus)
			{
				return 	[
						"result" => true,
						"message" => "Approved successful."
				];								
			}
			else
			{
				return 	[
						"result" => false,
						"message" => "Approved Failed."
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

	public function send_directer($RepairID,$idapp)
    {
    	// var_dump($RepairID,$idapp);
        $email_a = Sqlsrv::array(
            $this->conn->connect(),
            "SELECT TOP(1) A.MANAGERID,B.ID,B.EMAIL
            FROM MASTER_USER U
            LEFT JOIN (
							select *
							from USERMANAGER UM
						)A ON A.USERID = U.ID
						LEFT JOIN  (
									select *
									from MASTER_USER U 
									)B ON B.ID = A.MANAGERID
            WHERE U.ID = '$idapp'"
        );

        foreach ($email_a as $key) {
            $email 		= $key->EMAIL;
            $idApproved	= $key->ID;
        }

  //       var_dump($RepairID,$email,$idApproved);
		// exit;

        // $email = 'surapon_o@deestone.com';
        // $idApproved = $idapp;

        //$mail = new PHPMailer;
        $this->mail->isSMTP();
        $this->mail->Host = 'smtp-relay.gmail.com';
        $this->mail->SMTPAuth = true;
        $this->mail->SMTPSecure = "ssl";
        $this->mail->Username = 'noreply@deestone.com';
        $this->mail->Password = "tckpwktdnrpahmem";
        $this->mail->CharSet = "utf-8";
        $this->mail->Port = 465 ;

        $this->mail->From = 'carrepair_system@deestone.com';
        $this->mail->FromName = 'carrepair_system@deestone.com';
        $this->mail->addAddress($email);
        $this->mail->isHTML(true);
        $this->mail->SMTPOptions = array(
            'ssl' => array(
                'verify_peer' => false,
                'verify_peer_name' => false,
                'allow_self_signed' => true
            )
        );
        $this->mail->Subject =  "Request for car repair";
        $this->mail->Body    = "เลขที่ใบขออนุมัติ : "."<font color='red'>".$RepairID."</font>"
                               ."<br>"."อนุมัติ : "."<a href='http://lungryn.deestonegrp.com:8812/ApprovalDirecter?repairId=$RepairID&idapp=$idApproved'>Link</A> ";

        if($this->mail->send())
        {
   
			return 	[
				"result" => true,
				"message" => "Approved successful."
			];	
        }
        else
        {
			return 	[
				"result" => false,
				"message" => "Approved Failed."
			];
        }
    }

    public function send_Complete($RepairID)
    {
    	// var_dump($RepairID,$idapp);
        $email_a = Sqlsrv::array(
            $this->conn->connect(),
            "SELECT C.EMAIL [EMAILREQUEST]
				   ,AR.EMAIL [EMAILAPPREQUEST]
				   ,AH.EMAIL [EMAILHR]
				   ,AMH.EMAIL [EMAILAPPHR]
			FROM REPAIR P
			LEFT JOIN (
						select *
						from MASTER_USER
						)C ON C.ID = P.CREATEBY
			LEFT JOIN (
						select *
						from MASTER_USER
						)AR ON AR.ID = P.APPROVEDBY
			LEFT JOIN (
						select *
						from MASTER_USER
						)AH ON AH.ID = P.HRADMIN
			LEFT JOIN (
						select *
						from MASTER_USER
						)AMH ON AMH.ID = P.APPROVEDBYHR	
            WHERE P.REPAIRID = '$RepairID'"
        );

        foreach ($email_a as $key) {
            $EMAILREQUEST 		= $key->EMAILREQUEST;
            $EMAILAPPREQUEST	= $key->EMAILAPPREQUEST;
            $EMAILHR			= $key->EMAILHR;
            $EMAILAPPHR			= $key->EMAILAPPHR;
        }

        $Head = Sqlsrv::array(
            $this->conn->connect(),
            "SELECT P.STATUSREPAIR
                  ,P.REPAIRID
                  ,MC.REGCAR
                  ,B.BRAND
                  ,P.MILESNO
                  ,S.SECTIONDES
              from REPAIR P
              LEFT JOIN MASTER_CAR MC
              ON MC.CARID = P.CARID
              LEFT JOIN MASTER_BRAND B
              ON B.ID = MC.BRAND
              LEFT JOIN MASTER_SECTION S
              ON S.ID = P.SECTION
            	WHERE P.REPAIRID = '$RepairID'"
        );

        foreach ($Head as $keyHead) {
            $REPAIRID 		= $keyHead->REPAIRID;
            $REGCAR			= $keyHead->REGCAR;
            $BRAND			= $keyHead->BRAND;
            $MILESNO		= $keyHead->MILESNO;
            $SECTIONDES		= $keyHead->SECTIONDES;
        }

  //       var_dump($RepairID,$email,$idApproved);
		// exit;

        // $email = 'surapon_o@deestone.com';
        // $idApproved = $idapp;

        //$mail = new PHPMailer;
        $this->mail->isSMTP();
        $this->mail->Host = 'smtp-relay.gmail.com';
        $this->mail->SMTPAuth = true;
        $this->mail->SMTPSecure = "ssl";
        $this->mail->Username = 'noreply@deestone.com';
        $this->mail->Password = "tckpwktdnrpahmem";
        $this->mail->CharSet = "utf-8";
        $this->mail->Port = 465 ;

        $this->mail->From = 'carrepair_system@deestone.com';
        $this->mail->FromName = 'carrepair_system@deestone.com';
        $this->mail->addAddress($EMAILREQUEST);
        $this->mail->addAddress($EMAILAPPREQUEST);
        $this->mail->addAddress($EMAILHR);
        $this->mail->addAddress($EMAILAPPHR);
        $this->mail->isHTML(true);
        $this->mail->SMTPOptions = array(
            'ssl' => array(
                'verify_peer' => false,
                'verify_peer_name' => false,
                'allow_self_signed' => true
            )
        );
        $this->mail->Subject =  "อนุมัติการซ่อมรถยนต์";
        $this->mail->Body    = "เลขที่ใบขออนุมัติ : "."<font color='red'>".$RepairID."</font>"
                               ."<br>"."สถานะการร้องขอ : Complete"
                               ."<br>"
                               ."<br>"."ทะเบียนรถยนต์ : ".$REGCAR
                               ."<br>"."รุ่นรถยนต์ : ".$BRAND
                               ."<br>"."เลขไมล์ : ".$MILESNO
                               ."<br>"."ฝ่าย : ".$SECTIONDES
                               ."<br>";


        if($this->mail->send())
        {
   
			return 	[
				"result" => true,
				"message" => "Approved successful."
			];	
        }
        else
        {
			return 	[
				"result" => false,
				"message" => "Approved Failed."
			];
        }
    }

    public function all($getQueryParams)//tan_edit_20180704
    {
    	return  Sqlsrv::array($this->conn->connect(),
    			"SELECT ROW_NUMBER() OVER (Order by RD.REPAIRID) AS RowNumber
				,R.REPAIRID
	                  ,MC.REGCAR
	                  ,B.BRAND
	                  ,R.MILESNO
	                  ,S.SECTIONDES
	                  ,ISNULL(CA.CAUSE,'') [CAUSE]
	                  ,CONVERT(NUMERIC(28,2),RD.PRICE) [PRICE]
	                  ,RD.NOTE
	                  ,CB.DESCRIPTION [DETAIL]
	                  ,RD.STATUS
	                  ,RD.LINENUM
	            FROM REPAIR R
	            JOIN REPAIRDETAIL RD 
	            ON RD.REPAIRID = R.REPAIRID
	            LEFT JOIN MASTER_CAR C
	            ON C.CARID = R.CARID
	            LEFT JOIN MASTER_CAR MC
	            ON MC.CARID = R.CARID
	            LEFT JOIN MASTER_BRAND B
	            ON B.ID = MC.BRAND
	            LEFT JOIN MASTER_SECTION S
	            ON S.ID = R.SECTION
	            LEFT JOIN MASTER_CAUSE CA
	            ON CA.ID = RD.CAUSE
	            LEFT JOIN MASTER_CAUSEDETAIL CB
	            ON CB.ID = RD.DETAIL
	            WHERE R.REPAIRID =?",[$getQueryParams["id"]]);
    }
    
    // Nattapon_edit_20180710
    public function createrunning($RepairID
    							,$inp_year
    							,$inp_company)
    {
    	 $conn 	= $this->conn->connect();

		 $repairid = self::gennumberseq($conn);
		 $repairid = sprintf("%04d", $repairid);
		 $running = self::gennumberseq($conn);
		 $running = $inp_year.'/'.$inp_company.sprintf("%04d", $running);
			// var_dump($repairid, $running); exit();
		 if(isset($repairid, $running))
			{
    	 $createtest = sqlsrv_query(
    		$this->conn->connect(),
						"INSERT INTO DSGRUNNING(
												RUNNUMBER
												,RUNNINGDSG
												,REPAIRID
												,YEAR
												,COMPANY)
						VALUES (?,?,?,?,?)",
						array(
							$repairid
							,$running
							,$RepairID
							,$inp_year
							,$inp_company
						)
			);
    	}
    	 if($createtest)
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

    	 if($createtest)
			{
				return 	[
						"result" => true,
						"message" => "Approved successful."
				];								
			}

    }

    public function selectrepair($reid)
    {
    	return Sqlsrv::array(
			$this->conn->connect(),
			"SELECT *
			FROM REPAIR R
			LEFT JOIN MASTER_COMPANY CP
			ON R.COMPANY = CP.ID
			WHERE  R.REPAIRID = '$reid'"
		);
    }

    public function gennumberseq($conn)
	{
		
		$sql = "SELECT TOP(1)
				STUFF(S.NUMBER_SEQ,LEN(S.NUMBER_SEQ) +1 -LEN(CONVERT(NVARCHAR(10),S.NEXTREC))
				,LEN(CONVERT(NVARCHAR(10),S.NEXTREC))
				,CONVERT(NVARCHAR(10),S.NEXTREC))[GENNUMBER]
				FROM NUMBERSEQ_DSG S
				WHERE S.ACTIVE = 1
				AND S.NUMBER_SEQ = '0000'
				AND S.SERIES = year(getdate())
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
		$sql = "UPDATE NUMBERSEQ_DSG
				SET NEXTREC = NEXTREC+1
				WHERE ACTIVE =1
				AND NUMBER_SEQ = '0000'
				AND SERIES = year(getdate())";

		if(Sqlsrv::query($conn,$sql))
		{
			return true;
		}
		return false; 
	}
// End_Nattapon_edit_20180710

}

