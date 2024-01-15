<?php

namespace App\Controllers;

use App\Models\EmailModel;

class EmailController
{
	public function __construct()
	{
		$this->email = new EmailModel;
	}

	public function sent($request, $response, $args)
	{
		$parsedBody = $request->getParsedBody();
 		$managerid 	= $_POST["managerid"];
		$manager_id = explode(",", $managerid);

		//tan_edit_20180704
		/*
		if ($parsedBody["form_email"]=="mail_re") {

			foreach($manager_id as $manager_v){
				// var_dump($manager_v);
				if($manager_v){
					if($response->withjson($this->email->send_re($parsedBody["inp_RepairID_sent"],$manager_v)) === false) {
						echo json_encode(["status" => 404, "message" => "sent email Failed"]);
						exit;
					}
				}
			}
			// exit();

			header("Location: /home");
			exit();

		}else{

			// var_dump($parsedBody,$managerid);exit();
			foreach($manager_id as $manager_v){
				// var_dump($manager_v);
				if($manager_v){
					if($response->withjson($this->email->send_hr($parsedBody["inp_RepairID_sent"],$manager_v)) === false) {
						echo json_encode(["status" => 404, "message" => "sent email Failed"]);
						exit;
					}
				}
			}
			header("Location: /home");
			exit();

		}

	*///tan_edit_20180704
	
		//tan_edit_20180704
		$result = $response->withjson($this->email->send($parsedBody["form_email"]
														,$parsedBody["inp_RepairID_sent"]
														,$manager_id));
		echo json_encode($result);

		header("Location: /home");
		exit();

	}

	public function sendpass($request, $response, $args)
	{
		$parsedBody = $request->getParsedBody();
		if($response->withjson($this->email->sendpass($parsedBody["inp_mailpass"]))===false){
			echo json_encode(["status" => 404, "message" => "Send email false"]);
			exit;
		}else{
			echo json_encode(["status" => 200, "message" => "Send email success"]);
		}
	}

	public function senttest($request, $response, $args)
	{
		$parsedBody = $request->getParsedBody();
 		$managerid 	= $_POST["managerid"];
		$manager_id = explode(",", $managerid);

		$result = $response->withjson($this->email->sendtest($parsedBody["form_email"]
														,$parsedBody["inp_RepairID_sent"]
														,$manager_id));
		echo json_encode($result);

		header("Location: /home");
		exit();

	}


}
