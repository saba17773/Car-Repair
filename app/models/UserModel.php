<?php

namespace App\Models;

use Wattanar\Sqlsrv;
use App\Controllers\ConnectionController;

class UserModel
{	
	protected $mailer;
	public function __construct()
	{
		$this->conn = new ConnectionController;
	}

	public function all()
	{	
		return Sqlsrv::array(
			$this->conn->connect(),
			"SELECT U.ID
			  	,U.USERNAME
			  	,U.NAME
			  	,U.EMAIL
			  	,U.SECTION
			  	,U.DEPARTMENT
			  	,U.POSITION
			  	,U.STATUS
			  	,U.EDIT
			  	,U.EMPLOYEEID
			  	,D.DEPARTMENTDES
			  	,P.POSITIONDES
			  	,S.SECTIONDES
			  	,CASE WHEN U.PASSWORD != '' THEN '*****' END [PASSWORD]
		    FROM MASTER_USER U
		    LEFT JOIN MASTER_DEPARTMENT D 
		    ON U.DEPARTMENT = D.ID
		    LEFT JOIN MASTER_POSITION P 
		    ON U.POSITION = P.ID
		    LEFT JOIN MASTER_SECTION S 
		    ON U.SECTION = S.ID"
		);
	}

	public function comp()
	{
		return Sqlsrv::array(
			$this->conn->connect(),
			"SELECT * 
			FROM MASTER_COMPANY"
		);
	}

	public function compedit($userid)
	{
		return Sqlsrv::array(
			$this->conn->connect(),
			"SELECT C.*
					,CASE WHEN A.USERID != '' 
						  THEN 1 
						  ELSE 0 
					END [check]
			FROM MASTER_COMPANY C
			LEFT JOIN ( SELECT *
						FROM FACTORY F
						WHERE F.USERID = '$userid'
					  )A ON A.COMPANY = C.ID"
		);
	}

	public function manageredit($userid)
	{
		return Sqlsrv::array(
			$this->conn->connect(),
			"SELECT U.*
	   				,CASE WHEN A.MANAGERID != '' 
	   					  THEN 1 
	   					  ELSE 0 
	   				END [check]
			FROM MASTER_USER U
			LEFT JOIN ( 
						SELECT UM.USERID,UM.MANAGERID
						FROM USERMANAGER UM
						WHERE UM.USERID = '$userid'
					  )A ON A.MANAGERID = U.ID"
		);
	}

	public function pos()
	{
		return Sqlsrv::array(
			$this->conn->connect(),
			"SELECT * 
			FROM MASTER_POSITION"
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
				AND S.NUMBER_SEQ like 'U-%'
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
				AND NUMBER_SEQ like 'U-%'";

		if(Sqlsrv::query($conn,$sql))
		{
			return true;
		}
			return false; 
	}

	public function depart()
	{
		return Sqlsrv::array(
			$this->conn->connect(),
			"SELECT * 
			FROM MASTER_DEPARTMENT"
		);
	}

	public function section()
	{
		return Sqlsrv::array(
			$this->conn->connect(),
			"SELECT * 
			FROM MASTER_SECTION"
		);
	}

	public function checkusername($username,$userid)
	{
		$checkusername =  Sqlsrv::array(
			$this->conn->connect(),
			"SELECT * 
			FROM MASTER_USER
			WHERE USERNAME = ?
			AND ID != ?",
			[
				$username,$userid
			]
		);

		return $checkusername;
	}

	public function checkemail($email,$userid)
	{
		$format = "@deestone.com";
		$email = $email.$format;
		$checkemail =  Sqlsrv::array(
			$this->conn->connect(),
			"SELECT * 
			FROM MASTER_USER
			WHERE EMAIL = ?
			AND ID != ?",
			[
				$email,$userid
			]
		);

		return $checkemail;
	}

	public function createuser( $username
								,$password
								,$name
								,$email
								,$section
								,$department
								,$position
								,$inp_empid
								,$status
								,$UserEdit )
	{
		$conn 	= $this->conn->connect();
		if (sqlsrv_begin_transaction($conn) === false)
		{
         	die( print_r( sqlsrv_errors(), true ));
        }

        try
		{

			$userid = self::gennumberseq($conn);

			if(isset($userid))
			{
				$format = "@deestone.com";
				$email = $email.$format;
				$insertuser = sqlsrv_query(
										$this->conn->connect(),
										"INSERT INTO MASTER_USER(
													ID
													,USERNAME
													,PASSWORD
													,NAME
													,EMAIL
													,SECTION
													,DEPARTMENT
													,POSITION
													,EMPLOYEEID
													,STATUS		
													,EDIT							
													)
													
										VALUES(?,?,?,?,?,?,?,?,?,?,?)",
										array(
												$userid
												,$username
												,$password
												,$name
												,$email
												,$section
												,$department
												,$position
												,$inp_empid
												,$status 
												,$UserEdit
											)
									);
			}

			if($insertuser)
			{
				if ($status==1) {
					$InsertLogUser = sqlsrv_query(
				        $this->conn->connect(),
				        "INSERT INTO [EA_APP].[dbo].[TB_USER_APP] (EMP_CODE,USER_NAME,HOST_NAME,PROJECT_NAME,CREATE_DATE)
				        VALUES (?,?,?,?,getdate())",
				        [
				          $inp_empid,
				          $username,
				          gethostbyaddr($_SERVER['REMOTE_ADDR']),
				          'Car Repair'
				        ]
				    );
				}

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

	public function create_company($type,$comid) 
	{	
		$conn 	= $this->conn->connect();
		if (sqlsrv_begin_transaction($conn) === false)
		{
         	die( print_r( sqlsrv_errors(), true ));
        }

		try
		{			
			if($type =="create")
			{
				$userid = self::gennumberseq($conn);
				$number = (int)substr($userid, -3) - 1;
				$userid = "U-".sprintf("%03d", $number);
			}else{
				$userid = $type;
			}	

			if(isset($userid))
			{
				$insertcomp = sqlsrv_query(
											$this->conn->connect(),
											"INSERT INTO FACTORY(USERID
																,COMPANY)
											VALUES(?,?)",
											array(
																$userid
																,$comid
											)
								);
			}
				
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
	public function create_user_manager($type,$managerid) 
	{	
		$conn 	= $this->conn->connect();
		if (sqlsrv_begin_transaction($conn) === false)
		{
         	die( print_r( sqlsrv_errors(), true ));
        }

		try
		{			
			if($type =="create")
			{
				$userid = self::gennumberseq($conn);
				$number = (int)substr($userid, -3) - 1;
				$userid = "U-".sprintf("%03d", $number);
			}else{
				$userid = $type;
			}	

			if(isset($userid))
			{
				$insertcomp = sqlsrv_query(
											$this->conn->connect(),
											"INSERT INTO USERMANAGER(USERID
																	,MANAGERID)
											VALUES(?,?)",
											array(
																	$userid
																	,$managerid
											)
								);
			}
			
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

	public function updateuser( $username
								// ,$password
								,$name
								,$email
								,$section
								,$department
								,$position
								,$inp_empid
								,$status
								,$UserEdit
								,$userid )
	{
		 $conn 	= $this->conn->connect();
	 	if ( sqlsrv_begin_transaction($conn) === false ) 
		{
	    	die( print_r( sqlsrv_errors(), true ));
	    }
	
		try
		{
			$format = "@deestone.com";
			$email = $email.$format;
			$updateuser = sqlsrv_query(
										$this->conn->connect(),
										"UPDATE MASTER_USER 
											SET USERNAME = ?
												-- ,PASSWORD = ?
												,NAME = ?
												,EMAIL = ?
												,SECTION = ?
												,DEPARTMENT = ?
												,POSITION = ?
												,EMPLOYEEID = ?
												,STATUS = ?
												,EDIT = ?
										WHERE ID=?",
										array(
												$username
												// ,$password
												,$name
												,$email
												,$section
												,$department
												,$position
												,$inp_empid
												,$status
												,$UserEdit
												,$userid
										)
							);
			if($updateuser)
			{
				if ($status==1) {
					$InsertLogUser = sqlsrv_query(
				        $this->conn->connect(),
				        "INSERT INTO [EA_APP].[dbo].[TB_USER_APP] (EMP_CODE,USER_NAME,HOST_NAME,PROJECT_NAME,CREATE_DATE)
				        VALUES (?,?,?,?,getdate())",
				        [
				          $inp_empid,
				          $username,
				          gethostbyaddr($_SERVER['REMOTE_ADDR']),
				          'Car Repair'
				        ]
				    );
				}
				if ($status==0) {
					// $InsertLogUser = sqlsrv_query(
				 //        $this->conn->connect(),
				 //        "DELETE FROM [EA_APP].[dbo].[TB_USER_APP] WHERE EMP_CODE = ? AND  USER_NAME= ? AND PROJECT_NAME = ?",
					// 	[
					// 		$inp_empid,
					//         $username,
					//         'Car Repair'
					// 	]
				 //    );

					sqlsrv_query(
						$this->conn->connect(),
						"UPDATE [MORMONT\DEVELOP].[EA_APP].[dbo].[TB_USER_APP] 
						SET UPDATE_DATE = GETDATE(), STATUS = 0
						WHERE EMP_CODE = ? AND PROJECT_NAME = ? AND STATUS = 1
						IF @@ROWCOUNT = 0
						BEGIN
							INSERT INTO [MORMONT\DEVELOP].[EA_APP].[dbo].[TB_USER_APP] (
								EMP_CODE, 
								[HOST_NAME], 
								[USER_NAME], 
								PROJECT_NAME, 
								CREATE_DATE, 
								UPDATE_DATE, 
								[STATUS]
							) VALUES (
								?, ?, ?, ?, ?,
								?, ?
							)
						END",
					    [
					      $inp_empid,
					      'Car Repair',
					      $inp_empid,
					      '-',
					      $username,
					      'Car Repair',
					      date("Y-m-d H:i:s"),
					      date("Y-m-d H:i:s"),
					      0
					  	]
					);
				}
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
				$deleteuser = sqlsrv_query(
											$this->conn->connect(),
											"DELETE FROM MASTER_USER
											WHERE ID = ?",
											array(
												$id
											)
								);
				if($deleteuser)
				{
					$deletefactory = sqlsrv_query(
												$this->conn->connect(),
												"DELETE FROM FACTORY 
												WHERE USERID = ?",
												array(
													$id
												)
									);
					$deleteManager = sqlsrv_query(
												$this->conn->connect(),
												"DELETE FROM USERMANAGER 
												WHERE USERID = ?",
												array(
													$id
												)
									);

					if($deletefactory && $deleteManager){						
							return 	[
								"result" => true,
								"message" => "Delete successful."
							];
					}else{
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

	public function deleteFactoryManager($id) 
	{	
		if (Sqlsrv::begin($this->conn->connect()) === false) {
			return 	[
				"result" => false,
				"message" => "Error start transaction."
			];
		}
		try
		{
			$deletefactory = sqlsrv_query(
										$this->conn->connect(),
										"DELETE FROM FACTORY 
										WHERE USERID = ?",
										array(
											$id
										)
							);
			$deleteManager = sqlsrv_query(
										$this->conn->connect(),
										"DELETE FROM USERMANAGER 
										WHERE USERID = ?",
										array(
											$id
										)
							);

			if($deletefactory && $deleteManager){						
					return 	[
						"result" => true,
						"message" => "Delete successful."
					];
			}else{
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

	public function isRealUser($usernameId)
	{	
		return Sqlsrv::hasRows(
			$this->conn->connect(),
			"SELECT * 
			FROM MASTER_USER
			WHERE UserId = ?",
			
			[
				$usernameId,
				
			]
		);
	}

	public function userInfo($userId)
	{
		$user =  Sqlsrv::array(
			$this->conn->connect(),
			"SELECT * 
			FROM MASTER_USER
			WHERE UserId = ?",
			[
				$userId
			]
		);
		return $user;
	}

	// public function isChangPass($confirmpassword,$iduser)
	// {	
	// 	$update = sqlsrv_query(
	// 							$this->conn->connect(),
	// 							"UPDATE UserMaster 
	// 							SET Password = ?,
	// 							    Status = ?
	// 							WHERE UserID = ?",
	// 							array(
	// 								$confirmpassword,1,$iduser
	// 							)
	// 					);
		
	// 	if($update)
	// 	{
	// 		return 	[
	// 			"result" => true,
	// 			"message" => 200
	// 		];
	// 	}else{
	// 		return 	[
	// 			"result" => false,
	// 			"message" => 404
	// 		];
	// 	}
	// }

	public function updatelogin($inp_username)
	{
	if (Sqlsrv::begin($this->conn->connect()) === false) {
			return 	[
				"result" => false,
				"message" => "Error start transaction."
			];
		}
		try
		{
			$updatelogin = sqlsrv_query(
											$this->conn->connect(),
											"UPDATE MASTER_USER 
											SET LASTLOGIN= GetDate()
											WHERE UserId=?",
											array(
												 $inp_username
											)
								);

				if($updatelogin)
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

	public function logWebCenter($inp_username, $empid, $computername, $device, $remark, $type)
	{
		// var_dump($computername, $empid); exit();
	if (Sqlsrv::begin($this->conn->connect()) === false) {
			return 	[
				"result" => false,
				"message" => "Error start transaction."
			];
		}
		try
		{
			if ($type=="login") {
			
				$logWebCenter = sqlsrv_query(
						$this->conn->connect(),
						"INSERT INTO [WEB_CENTER].[dbo].[LoginLogs] 
								(EmployeeID, ComputerName, Username, LoginDevice, LoginDate, ProjectID, Remark)
						VALUES (?,?,?,?,getdate(),?,?)",
						array(
							 $empid
							 ,$computername
							 ,$inp_username
							 ,$device
							 ,9
							 ,$remark
						)
				);

				if($logWebCenter)
				{
					$InsertlogApp = sqlsrv_query(
				    	$this->conn->connect(),
			            "INSERT INTO [EA_APP].[dbo].[TB_LOG_APP] (EMP_CODE,USER_NAME,HOST_NAME,LOGIN_DATE,PROJECT_NAME)
			            VALUES (?,?,?,?,?)",
			            array(
			                $empid,
				          	$inp_username,
				          	$computername,
				          	date('Y-m-d H:i:s'),
				          	'Car Repair'
			            )
			        );

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

			}else{

				$InsertlogApp = sqlsrv_query(
			    	$this->conn->connect(),
		            "INSERT INTO [EA_APP].[dbo].[TB_LOG_APP] (EMP_CODE,USER_NAME,HOST_NAME,LOGOUT_DATE,PROJECT_NAME)
		            VALUES (?,?,?,?,?)",
		            array(
		                $empid,
			          	$inp_username,
			          	$computername,
			          	date('Y-m-d H:i:s'),
			          	'Car Repair'
		            )
		        );
			}

		}catch (Exception $e) {
			Sqlsrv::rollback($this->conn->connect());
			return 	[
				"result" => false,
				"message" => $e->getMessage()
			];
		}  
	} 

	public function employee()
	{
		return Sqlsrv::array(
			$this->conn->connect(),
			"SELECT  E.CODEMPID
					,E.EMPNAME
					,E.EMPLASTNAME
					,T.EMAIL
			FROM [HRTRAINING].[dbo].[EMPLOYEE] E
			LEFT JOIN [HRTRAINING].[dbo].[TEMPLOY1] T
			ON E.CODEMPID = T.CODEMPID
			WHERE E.STATUS != 9" 
		);
	}

	public function UserCheck($id)
	{
		$usercheck =  Sqlsrv::array(
			$this->conn->connect(),
			"SELECT * FROM REPAIR
			WHERE CREATEBY = ?",
			[
				$id
			]
		);

		return $usercheck;
	}

	public function checkmail($inp_mailpass)
	{
		$usercheck =  Sqlsrv::array(
			$this->conn->connect(),
			"SELECT * FROM MASTER_USER
				WHERE EMAIL = ?",
			[
				$inp_mailpass
			]
		);

		return $usercheck;
	}

	public function userchangepass($inp_password, $userid)
	{
		if (Sqlsrv::begin($this->conn->connect()) === false) {
			return 	[
				"result" => false,
				"message" => "Error start transaction."
			];
		}
		try
		{
			$changepass = sqlsrv_query(
											$this->conn->connect(),
											"UPDATE MASTER_USER 
											SET PASSWORD=?
											WHERE ID=?",
											array(
												 $inp_password
												,$userid
											)
								);

				if($changepass)
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

}