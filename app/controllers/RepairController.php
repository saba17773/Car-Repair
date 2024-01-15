<?php

namespace App\Controllers;

use App\Models\RepairModel;

class RepairController
{

	public function __construct()
	{
		$this->Repair = new RepairModel;
	}

	public function all($request, $response, $args)
	{
		return $response->withJson($this->Repair->all());
	}

	public function allclick($request, $response, $args)
	{
		$RepairID = $request->getQueryParams();
		return $response->withJson($this->Repair->allclick($RepairID["RepairID"]));
	}

	public function Manager($request, $response, $args)
	{
		return $response->withJson($this->Repair->Manager());
	}

	public function Cradle($request, $response, $args)
	{
		return $response->withJson($this->Repair->Cradle());
	}

	public function car($request, $response, $args)
	{
		return $response->withJson($this->Repair->car());
	}
	public function carbycom($request, $response, $args)
	{
		// return $response->withJson($this->Repair->car());
		$RepairID = $request->getQueryParams();
		return $response->withJson($this->Repair->carbycom($RepairID["com"]));
	}
	public function Driver($request, $response, $args)
	{
		return $response->withJson($this->Repair->Driver());
	}
	public function cardetail($request, $response, $args)
	{
		$parsedBody = $request->getParsedBody();
		return $response->withJson($this->Repair->cardetail($parsedBody["car"]));

	}

	public function causedetail($request, $response, $args)
	{
		$parsedBody = $request->getParsedBody();
		return $response->withJson($this->Repair->causedetail($parsedBody["causeid"]));

	}

	public function causedetailtest($request, $response, $args)
	{
		$parsedBody = $request->getParsedBody();
		$causeid = $_GET['causeid'];
		return $response->withJson($this->Repair->causedetailtest($causeid));

	}

	public function com($request, $response, $args)
	{
		return $response->withJson($this->Repair->com());
	}

	public function dep($request, $response, $args)
	{
		return $response->withJson($this->Repair->dep());
	}

	public function sec($request, $response, $args)
	{
		return $response->withJson($this->Repair->sec());
	}

	public function create($request, $response, $args)
	{

		$parsedBody = $request->getParsedBody();

		// $milesNo = $parsedBody["inp_milesNo"];//note_edit_20180622
		//
		// if(strlen($milesNo) > 7)//note_edit_20180622
		// {
		// 	echo json_encode(["status" => 404, "message" => "ป้อนเลขไมล์มากกว่ากำหนด"]);
		// 	exit;
		// }

		// var_dump($parsedBody["dd_car_id"]); exit();
		if(!isset($parsedBody["inp_milesNo"])){
			$inp_milesNo = 0;
		}else{
			$inp_milesNo = $parsedBody["inp_milesNo"];
			// $ischeck_mile = $this->Repair->ischeckmiles($parsedBody["dd_car_id"],$inp_milesNo);
			// if($ischeck_mile["status"]===404){
			// 	echo json_encode($ischeck_mile);
			// 	exit;
			// }
		}
	  	
	 //  	echo json_encode(["status" => 404, "message" => "EXIT"]);
		// exit;

		if ($parsedBody["form_type"]=="create") {
		//Insert
			$status = 1;
			if($response->withJson($this->Repair->create($parsedBody["sel_com"]
														,$parsedBody["sel_Department"]
														,$parsedBody["sel_Section"]
														,$parsedBody["dd_driver_id"]
														,$parsedBody["dd_car_id"]
														,$inp_milesNo
														,$parsedBody["inp_remark"]
														,$parsedBody["inp_createBy"]
														,$status)) === false)
			{
				echo json_encode(["status" => 404, "message" => "Create Failed"]);
				exit;
			}
			else
			{
				echo json_encode(["status" => 200, "message" => "Create Successful"]);
			}


		}else{
		//Update
			// var_dump($parsedBody);exit();
			if($response->withJson($this->Repair->update($parsedBody["sel_com"]
														,$parsedBody["sel_Section"]
														,$parsedBody["sel_Department"]
														,$parsedBody["dd_driver_id"]
														,$parsedBody["dd_car_id"]
														,$inp_milesNo
														,$parsedBody["inp_remark"]
														,$parsedBody["inp_updateBy"]
														,$parsedBody["id"])) === false)
			{
				echo json_encode(["status" => 404, "message" => "Update Failed"]);
				exit;
			}
			else
			{
				echo json_encode(["status" => 200, "message" => "Update Successful"]);
			}


		}

	}

	public function delete($request, $response, $args)
	{

		$parsedBody = $request->getParsedBody();

		if ($parsedBody) {

			if($response->withJson($this->Repair->delete($parsedBody["id"]
														,$parsedBody["repairid"])) === false) {
					echo json_encode(["status" => 404, "message" => "Delete Failed"]);
					exit;
				}
				echo json_encode(["status" => 200, "message" => "Delete Successful"]);

		}

	}

	public function create_line($request, $response, $args)
	{
		$parsedBody = $request->getParsedBody();
		$Date = DATE($parsedBody["inp_daterepair"]);
		$Year = (int)substr($Date,6)-543;
		$Date  =  substr($Date,3,2) .'-'.substr($Date,0,2) .'-'.$Year;
		

		if (isset($parsedBody['causedetail'])) {
		  $get_causedetail = $parsedBody['causedetail'];
		  $get_price = $parsedBody['cause_price'];
		  $get_note = $parsedBody['cause_note'];

		if (count($get_causedetail>0)) {
		    $_causedetail = array_combine($get_causedetail, $get_price);
		  }else{
		    $_causedetail = "";
		  }
		}
		// var_dump($parsedBody["dd_detail_id"]); exit();
		if ($parsedBody["form_type_line"]=="create") {
			// insert 1 row
			if($response->withJson(
				$this->Repair->create_line(
					// $parsedBody["sel_causedetail"]
					$parsedBody["dd_detail_id"]
					,$parsedBody["sel_cause"]
					,$parsedBody["inp_price"]
					,$Date
					,$parsedBody["text_note"]
					// ,$parsedBody["sel_cradle"]
					,$parsedBody["dd_cradle_id"]
					,$parsedBody["inp_createByline"]
					,$parsedBody["inp_repair_line"])) === true){

				
				echo json_encode(["status" => 404, "message" => "Create Failed"]);

			}else{
				if (isset($_causedetail)) {
					foreach ($get_causedetail as $i => $causedetail) {
						$price = $get_price[$i];
						$note = $get_note[$i];
						// echo $k."=>".$price ."<br>"; 
						$response->withJson(
							$this->Repair->create_line(
								$causedetail
								,$parsedBody["sel_cause"]
								,$price
								,$Date
								,$note
								// ,$parsedBody["sel_cradle"]
								,$parsedBody["dd_cradle_id"]
								,$parsedBody["inp_createByline"]
								,$parsedBody["inp_repair_line"]
							)
						);
					}
				}	
				echo json_encode(["status" => 200, "message" => "Create Successful"]);
			}
		}else{
			
			if($response->withJson($this->Repair->update_line(
															// $parsedBody["sel_causedetail"]
															$parsedBody["dd_detail_id"]
															,$parsedBody["sel_cause"]
															,$parsedBody["inp_price"]
															,$Date
															,$parsedBody["text_note"]
															// ,$parsedBody["sel_cradle"]
															,$parsedBody["dd_cradle_id"]
															,$parsedBody["inp_updateByline"]
															,$parsedBody["inp_repair_line"]
															,$parsedBody["inp_line_num"])) === false) 
			{
				echo json_encode(["status" => 404, "message" => "Update Failed"]);
				exit;
			}
				echo json_encode(["status" => 200, "message" => "Update Successful"]);
		}
	}

	// Original
	// 	if ($parsedBody["form_type_line"]=="create") {

	// 		if($response->withJson($this->Repair->create_line($parsedBody["sel_causedetail"]
	// 														,$parsedBody["sel_cause"]
	// 														,$parsedBody["inp_price"]
	// 														,$Date
	// 														,$parsedBody["text_note"]
	// 														,$parsedBody["sel_cradle"]
	// 														,$parsedBody["inp_createByline"]
	// 														,$parsedBody["inp_repair_line"])) === false)
	// 		{
	// 			echo json_encode(["status" => 404, "message" => "Create Failed"]);
	// 			exit;
	// 		}
	// 			echo json_encode(["status" => 200, "message" => "Create Successful"]);

	// 	}else{

	// 		if($response->withJson($this->Repair->update_line($parsedBody["sel_causedetail"]
	// 														,$parsedBody["sel_cause"]
	// 														,$parsedBody["inp_price"]
	// 														,$Date
	// 														,$parsedBody["text_note"]
	// 														,$parsedBody["sel_cradle"]
	// 														,$parsedBody["inp_updateByline"]
	// 														,$parsedBody["inp_repair_line"]
	// 														,$parsedBody["inp_line_num"])) === false)
	// 		{
	// 			echo json_encode(["status" => 404, "message" => "Update Failed"]);
	// 			exit;
	// 		}
	// 			echo json_encode(["status" => 200, "message" => "Update Successful"]);

	// 	}
	// }

	public function delete_line($request, $response, $args)
	{

		$parsedBody = $request->getParsedBody();

		if ($parsedBody) {

			if($response->withJson($this->Repair->delete_line($parsedBody["id_line"]
															 ,$parsedBody["RepairNum_line"])) === false)
			{
				echo json_encode(["status" => 404, "message" => "Delete Failed"]);
				exit;
			}
				echo json_encode(["status" => 200, "message" => "Delete Successful"]);

		}

	}

	public function updatenew($request, $response, $args)
	{

		$parsedBody = $request->getParsedBody();

		if ($parsedBody) {

			if($response->withJson($this->Repair->updatenew($parsedBody["id"])) === false) {
				echo json_encode(["status" => 404, "message" => "Update Failed"]);
				exit;
			}
				echo json_encode(["status" => 200, "message" => "สามารถดำเนินการแก้ไขได้แล้ว"]);

		}

	}
	
	public function loadrepairitem($request, $response, $args)
	{
		$parsedBody = $request->getQueryParams();
		return $response->withJson($this->Repair->loadrepairitem($parsedBody["idrepair"]));
	}
	
	public function repaireddate($request, $response, $args)
	{
		$parsedBody = $request->getParsedBody();
		$Date = DATE($parsedBody["inp_repaired_date"]);
		$Year = (int)substr($Date,6)-543;
		$Date  =  substr($Date,3,2) .'-'.substr($Date,0,2) .'-'.$Year;
		$statusrenew = 1 ;
		// var_dump($parsedBody["inp_repaireddate_id"],$Date,$statusrenew); exit();
		if($parsedBody["inp_repaired_date"] != ""){
			if ($parsedBody) {

				if($response->withJson($this->Repair->repaireddate($Date,$statusrenew,$parsedBody["inp_repaireddate_id"])) === false)
				{
					echo json_encode(["status" => 404, "message" => "Update Failed"]);
					exit;
				}
					echo json_encode(["status" => 200, "message" => "Update Successful"]);

			}
		}else{
			echo json_encode(["status" => 404, "message" => " กรุณากรอกข้อมูล"]);
		}
	}

	public function deleterepaireddate($request, $response, $args)
	{
		$parsedBody = $request->getParsedBody();
		$statusrenew = null ;
		$Date = null ;
		// var_dump($statusrenew, $parsedBody["id"], $parsedBody["repairid"]);
		if ($parsedBody) {
			if($response->withJson($this->Repair->deleterepaireddate($Date, $statusrenew, $parsedBody["repairid"])) === false)
			{
				echo json_encode(["status" => 404, "message" => "Update Failed"]);
				exit;
			}
				echo json_encode(["status" => 200, "message" => "Update Successful"]);
		}
	}

	public function cancel($request, $response, $args)
	{

		$parsedBody = $request->getParsedBody();

		// echo json_encode(["status"=>$parsedBody['id']]);
		
			if($response->withJson($this->Repair->cancel($parsedBody["id"])) === false) {
				echo json_encode(["status" => 404, "message" => "Cancel Failed"]);
				exit;
			}
			echo json_encode(["status" => 200, "message" => "Cancel Successful"]);

		

	}

}
