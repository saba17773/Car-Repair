<?php

namespace App\Controllers;

use App\Models\UserModel;


require_once './resources/Mobile-Detect-2.8.33/Mobile_Detect.php';

class UserController
{
	public function __construct()
	{
		$this->user = new UserModel;
	}

	public function all($request, $response, $args)
	{
		return $response->withJson($this->user->all());
	}

	public function comp($request, $response, $args)
	{
		return $response->withJson($this->user->comp());
	}

	public function compedit($request, $response, $args)
	{
		$parsedBody = $request->getParsedBody();
		return $response->withJson($this->user->compedit($parsedBody["userid"]));
	}

	public function manageredit($request, $response, $args)
	{
		$parsedBody = $request->getParsedBody();
		return $response->withJson($this->user->manageredit($parsedBody["userid"]));
	}

	public function pos($request, $response, $args)
	{
		return $response->withJson($this->user->pos());
	}
	public function depart($request, $response, $args)
	{
		return $response->withJson($this->user->depart());
	}
	public function section($request, $response, $args)
	{
		return $response->withJson($this->user->section());
	}

	public function createuser($request, $response, $args)
	{

		$parsedBody = $request->getParsedBody();
		$comid 		= $_POST['companyid'];
		$compamy_id = explode(",", $comid);
		$managerid 	= $_POST["managerid"];
		$manager_id = explode(",", $managerid);

		// var_dump($parsedBody);exit();

		if (!isset($parsedBody["Active"])) {
			$status=0;
		}else{
			$status=1;
		}
		if (!isset($parsedBody["inp_UserEdit"])) {
			$UserEdit=0;
		}else{
			$UserEdit=1;
		}

		$email = $parsedBody["inp_email"]."@deestone.com";
		if (!filter_var($email, FILTER_VALIDATE_EMAIL)) {

			header("Location: /usermaster");
			exit;
		}

		if ($parsedBody["form_type"]=="create") {
			// Insert User
			$id = "";
			if($this->user->checkusername($parsedBody["inp_username"]
									 ,$id))
			{
				$check = 0;
				header("Location: /usermaster?check=$check");
				exit;
			}

				if($response->withJson($this->user->createuser($parsedBody["inp_username"]
															  ,$parsedBody["inp_password"]
															  ,$parsedBody["inp_fullname"]
															  ,$parsedBody["inp_email"]
															  ,$parsedBody["sel_secid"]
															  ,$parsedBody["sel_depid"]
															  ,$parsedBody["sel_posid"]
															  ,$parsedBody["inp_empid"]
															  ,$status
															  ,$UserEdit)) === false)
				{
					$check = 0;
					header("Location: /usermaster?check=$check");
					exit;
				}
				else
				{

					foreach($compamy_id as $com_v){
						if($com_v){
							if($response->withJson($this->user->create_company($parsedBody["form_type"],$com_v)) === false) {
								$check = 0;
								header("Location: /usermaster?check=$check");
								exit;
							}
						}
					}
					foreach($manager_id as $manager_v){
						if($manager_v){
							if($response->withJson($this->user->create_user_manager($parsedBody["form_type"],$manager_v)) === false) {
								$check = 0;
								header("Location: /usermaster?check=$check");
								exit;
							}
						}
					}

					$check = 2;
					header("Location: /usermaster?check=$check");
					exit;
				}

		}else{
			// Update User
			if($this->user->checkusername($parsedBody["inp_username"]
									 ,$parsedBody["inp_userid"]))
			{
				header("Location: /usermaster");
				exit;
			}

			if($response->withJson($this->user->updateuser($parsedBody["inp_username"]
			 											   // ,$parsedBody["inp_password"]
			 											   ,$parsedBody["inp_fullname"]
			 											   ,$parsedBody["inp_email"]
			 											   ,$parsedBody["sel_secid"]
			 											   ,$parsedBody["sel_depid"]
			 											   ,$parsedBody["sel_posid"]
			 											   ,$parsedBody["inp_empid"]
			 											   ,$status
			 											   ,$UserEdit
			 											   ,$parsedBody["inp_userid"])) === false)
			{
				$check = 0;
				header("Location: /usermaster?check=$check");
				exit;
			}
			else
			{

				if($response->withJson($this->user->deleteFactoryManager($parsedBody["inp_userid"])) === false)
				{
					$check = 0;
					header("Location: /usermaster?check=$check");
					exit;
				}else{
					foreach($compamy_id as $com_v){
						if($com_v){
							if($response->withJson($this->user->create_company($parsedBody["inp_userid"]
																			  ,$com_v)) === false)
							{
								$check = 0;
								header("Location: /usermaster?check=$check");
								exit;
							}
						}
					}
					foreach($manager_id as $manager_v){
						if($manager_v){
							if($response->withJson($this->user->create_user_manager($parsedBody["inp_userid"]
																				   ,$manager_v)) === false)
							{
								$check = 0;
								header("Location: /usermaster?check=$check");
								exit;
							}
						}
					}
					$check = 2;
					// var_dump($parsedBody);
					header("Location: /usermaster?check=$check");
					exit;
				}
			}
		}
	}

	public function delete($request, $response, $args)
	{

		$parsedBody = $request->getParsedBody();

		if ($parsedBody) {

			if($getucheck = $this->user->UserCheck($parsedBody["id"]))
			{
				echo json_encode(["status" => 404, "message" => "ข้อมูลใช้งานอยู่ กรุณาลบภายหลัง"]);
				exit;
			}
			if($response->withJson($this->user->delete($parsedBody["id"])) === false)
			{
				echo json_encode(["status" => 404, "message" => "Delete Failed"]);
				exit;
			}
			else
			{
				echo json_encode(["status" => 200, "message" => "Delete Successful"]);
			}
		}
	}

	public function auth($request, $response, $args)
	{  
		
		$parsedBody = $request->getParsedBody();
		$detect = new \Mobile_Detect;
		$computername = gethostbyaddr($_SERVER['REMOTE_ADDR']);
		$remark = $_SERVER['HTTP_USER_AGENT'];

		if($detect->isMobile()){
			$device = 2;
		}else{
			$device = 1;
		}

		try {
			
			
			$isRealUser = $this->user->isRealUser($parsedBody["txt_userId"]);
		} catch (Exception $e) {
			return $response->withJson([
				"result" => false,
				// "message" => $e->getMessage()
			]);
		}

		if ($isRealUser === false) {
			return $response->withJson([
				"result" => false,
				// "message" => "กรุณาเช็คชื่อผู้ใช้ และรหัสผ่าน"
			]);
		}else{
			$updatelogin = $this->user->updatelogin($parsedBody["txt_userId"]);
		}

		try {
			$getUserInfo = $this->user->userInfo($parsedBody["txt_userId"]);
		} catch (Exception $e) {
			return $response->withJson([
				"result" => false,
				"message" => $e->getMessage()
			]);
		}

		$_SESSION["logged"] 	= true;
		$_SESSION["userid"] 	= $getUserInfo[0]->ID;
		$_SESSION["username"]	= $getUserInfo[0]->USERNAME;
		$_SESSION["status"] 	= $getUserInfo[0]->STATUS;
		$_SESSION["posid"] 		= $getUserInfo[0]->POSITION;
		$_SESSION["depid"] 		= $getUserInfo[0]->DEPARTMENT;
		$_SESSION["secid"] 		= $getUserInfo[0]->SECTION;
		$_SESSION["userEdit"]   = $getUserInfo[0]->EDIT;
		$_SESSION["EMAIL"]		= $getUserInfo[0]->EMAIL;
		$_SESSION["empid"]      = $getUserInfo[0]->EMPLOYEEID;

		$updatelogin = $this->user->logWebCenter($parsedBody["txt_userId"], $_SESSION["empid"],$computername, $device , $remark ,'login');

		return $response->withJson([
			"result" => true,
			"message" => $_SESSION["status"]
		]);


	}

	// public function profile($request, $response, $args){
	// 	$parsedBody = $request->getParsedBody();
	// 	return $response->withJson($this->user->isChangPass($parsedBody["confirmpassword"],$parsedBody["iduser"]));
	// }

	public function logout($request, $response, $args)
	{
		$detect = new \Mobile_Detect;
		$computername = gethostbyaddr($_SERVER['REMOTE_ADDR']);
		$remark = $_SERVER['HTTP_USER_AGENT'];

		if($detect->isMobile()){
			$device = 2;
		}else{
			$device = 1;
		}
		
		$updatelogin = $this->user->logWebCenter($_SESSION["username"], $_SESSION["empid"],$computername, $device , $remark ,'logout');
		session_destroy();
		return $response->withRedirect("/user/auth");
	}

	public function employee($request, $response, $args)
	{
		return $response->withJson($this->user->employee());
	}

	// public function forgetpassword($request, $response, $args)
	// {
	// 	$parsedBody = $request->getParsedBody();
	// 	// $checkuser_forget = $this->user->checkuser_forget($parsedBody["inp_forgetusername"]);
	// 	$checkmail = $this->user->checkmail($parsedBody["inp_mailpass"]);
	// 	if($checkuser_forget){

			
	// 	}else{
	// 		echo "YES";
	// 	}
	// }

	public function userchangepass($request, $response, $args)
	{
		$parsedBody = $request->getParsedBody();
		// var_dump($parsedBody["inp_password"],$parsedBody["inp_passwordconfirm"]); exit();
		if($parsedBody["inp_password"] == $parsedBody["inp_passwordconfirm"])
		{
			if($response->withJson($this->user->userchangepass($parsedBody["inp_password"]
													,$parsedBody["userid"]))==false){
				echo json_encode(["status" => 404, "message" => "Update Failed"]);
				exit();
			}else{
				echo json_encode(["status" => 200, "message" => "Update Successful"]);	
			}

		}else{
			echo json_encode(["status" => 404, "message" => "รหัสผ่านไม่ตรงกัน หรือ รหัสผ่านผิด กรุณาตรวจสอบรหัสผ่าน"]);
		}
	}

	
}
