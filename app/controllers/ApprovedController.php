<?php 

namespace App\Controllers;

use App\Models\ApprovedModel;

class ApprovedController
{
		public function __construct()
	{
		$this->Approved = new ApprovedModel;
	}

	public function request($request, $response, $args)
	{
		$id = $request->getQueryParams();
		return $response->withJson($this->Approved->request($id["id"]));
	}

	public function approved_request($request, $response, $args)
	{
		$parsedBody = $request->getParsedBody();

		if ($parsedBody) {
			if($response->withJson($this->Approved->approved_request($parsedBody["status"],$parsedBody["app"],$parsedBody["id"])) === false) {
				echo json_encode(["status" => 404, "message" => "Approved Failed"]);
				exit;
			}else{
				echo json_encode(["status" => 200, "message" => "Approved Successful"]);
			}
		}
	}


	public function approved_repair($request, $response, $args)
	{
		$parsedBody = $request->getParsedBody();
		// $s = 6;
		$i = 1;
		// var_dump($parsedBody["RepairID"],$parsedBody["inp_year"],$parsedBody["inp_company"]); exit();
		foreach($parsedBody as $key => $v){
			if(substr($key, -6) === 'idline')
			{
			 	// var_dump($parsedBody[$i."_idline"],$parsedBody[$i."_status"]);	
			 	if ($parsedBody) {
					if($response->withJson($this->Approved->approved_repair_line($parsedBody[$i."_status"],$parsedBody[$i."_idline"])) === false) {
						echo json_encode(["status" => 404, "message" => "Approved Failed."]);
						exit;
					}

					if($parsedBody[$i."_status"] == 8){
						$s = 8;
					}
					if($parsedBody[$i."_status"] == 6 ){
						$s = 6;
					}
				}
				$i++;
			}

		}

		/*start tan_edit_20180705
		if($response->withJson($this->Approved->approved_repair($s,$parsedBody["idapp"],$parsedBody["RepairID"])) === false) {
			echo json_encode(["status" => 404, "message" => "Approved Failed."]);
			exit;
		}else{
				
			if($s == 7){
				if($response->withjson($this->Approved->send_directer($parsedBody["RepairID"],$parsedBody["idapp"])) === false) {
						echo json_encode(["status" => 404, "message" => "sent email Failed"]);
						exit;
				}else{
					echo json_encode(["status" => 200, "message" => "Approved successful."]);				
				}
			}			
		}
		end tan_edit_20180705*/

		//tan_edit_20180705
		
		if($response->withJson($this->Approved->approved_repair($s,$parsedBody["idapp"],$parsedBody["RepairID"])) == false) {
			echo json_encode(["status" => 404, "message" => "Approved Failed","statusid" => $s]);
			exit;
		}else{
			if($s == '8'){
						$this->Approved->createrunning($parsedBody["RepairID"]
															,$parsedBody["inp_year"]
															,$parsedBody["inp_company"]);
						// echo json_encode(["status" => 200, "message" => "Approved Successful","statusid" => $s]);
			}
				echo json_encode(["status" => 200, "message" => "Approved Successful","statusid" => $s]);
			
		}

	}

	public function approved_directer($request, $response, $args)
	{

		$parsedBody = $request->getParsedBody();

		// var_dump($parsedBody);exit();
		$s = 10;
		$i = 1;
		foreach($parsedBody as $key => $v){
			if(substr($key, -6) === 'idline')
			{
			 	// var_dump($parsedBody[$i."_idline"],$parsedBody[$i."_status"]);	
			 	if ($parsedBody) {
					if($response->withJson($this->Approved->approved_repair_line($parsedBody[$i."_status"]==7?8:6,$parsedBody[$i."_idline"])) === false) {
						echo json_encode(["status" => 404, "message" => "Approved Failed."]);
						exit;
					}

					if($parsedBody[$i."_status"] == 7){
						$s = 8;
					}

				}

				$i++;

			 }

		}
		
		/*start_tan_edit_20180705
		if($response->withJson($this->Approved->approved_Dr($s,$parsedBody["idapp"],$parsedBody["RepairID"])) === false) {
			echo json_encode(["status" => 404, "message" => "Approved Failed."]);
			exit;
		}else{
			//echo json_encode(["status" => 200, "message" => "Approved Successful"]);		
			if($s == 8){
				if($response->withjson($this->Approved->send_Complete($parsedBody["RepairID"])) === false) {
						echo json_encode(["status" => 404, "message" => "sent email Failed"]);
						exit;
				}else{
					echo json_encode(["status" => 200, "message" => "Approved successful."]);				
				}
			}
			else
			{
				echo json_encode(["status" => 200, "message" => "Approved Successful"]);
			}
		}

		end_tan_edit_20180705*/

		//tan_edit_20180705

		if($response->withJson($this->Approved->approved_repair($s,$parsedBody["idapp"],$parsedBody["RepairID"],true)) == false) {
			echo json_encode(["status" => 404, "message" => "Approved Failed","statusid" => $s]);
			exit;
		}else{
			if($s == '8'){
						$this->Approved->createrunning($parsedBody["RepairID"]
															,$parsedBody["inp_year"]
															,$parsedBody["inp_company"]);
						// echo json_encode(["status" => 200, "message" => "Approved Successful","statusid" => $s]);
			}
			echo json_encode(["status" => 200, "message" => "Approved Successful","statusid" => $s]);
		}


		
	}

	public function all($request, $response, $args)//tan_edit_20180704
	{
		$getQueryParams = $request->getQueryParams();
		return $response->withJson($this->Approved->all($getQueryParams));
	}

	public function selectrepair($request, $response, $args) //Nattapon_edit_20180710
	{
		$parsedBody = $request->getParsedBody();
		return $response->withJson($this->Approved->selectrepair($parsedBody["reid"]));
	}

}