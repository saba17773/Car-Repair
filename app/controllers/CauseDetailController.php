<?php 

namespace App\Controllers;

use App\Models\CauseDetailModel;

class CauseDetailController
{
	public function __construct()
	{
		$this->causedt = new CauseDetailModel;
	}

	public function all($request, $response, $args)
	{
		// return $response->withJson($this->causedt->all());
		$parsedBody = $request->getQueryParams();
		return $response->withJson($this->causedt->all($parsedBody["causeid"]));
	}
	
	public function create($request, $response, $args)
	{

		$parsedBody = $request->getParsedBody();

		// var_dump($parsedBody); exit();
		if (!isset($parsedBody["inp_status"])) {
			$status = 0;
		}else{
			$status = 1;
		}

		if ($parsedBody["form_type"]=="create") {
			$id = 0;
			if($getcauseInfo = $this->causedt->causeInfo($parsedBody["inp_causedetail"],$id))
			{
				echo json_encode(["status" => 404, "message" => "ชื่อนี้มีอยู่แล้ว"]);
				exit;
			}

			if($response->withJson($this->causedt->create($parsedBody["inp_causeid"]
														,$parsedBody["inp_causedetail"]
														,$status)) === false) {
				echo json_encode(["status" => 404, "message" => "Create Failed"]);
				exit;
			}else{
				echo json_encode(["status" => 200, "message" => "Create Successful"]);
			}

		}else{
				// var_dump($parsedBody); exit();
			if($getcauseInfo = $this->causedt->causeInfo($parsedBody["inp_causedetail"],$parsedBody["id"]))
			{
				echo json_encode(["status" => 404, "message" => "ชื่อนี้มีอยู่แล้ว"]);
				exit;
			}		

			if($response->withJson($this->causedt->update($parsedBody["inp_causeid"]
														,$parsedBody["inp_causedetail"]
														,$status
														,$parsedBody["id"])) === false)
			{
					echo json_encode(["status" => 404, "message" => "Update Failed"]);
					exit;
			}
			if($getcausedecheck = $this->causedt->CauseDeCheck($parsedBody["id"]))
			{
				echo json_encode(["status" => 404, "message" => "ข้อมูลใช้งานอยู่ กรุณาแก้ไขภายหลัง"]);
				exit;
			}
			else{
				echo json_encode(["status" => 200, "message" => "Update Successful"]);
			}
		}	

	}

	public function delete($request, $response, $args)
	{

		$parsedBody = $request->getParsedBody();
		
		if ($parsedBody) {

			if($getcausedecheck = $this->causedt->CauseDeCheck($parsedBody["id"]))
			{
				echo json_encode(["status" => 404, "message" => "ข้อมูลใช้งานอยู่ กรุณาลบภายหลัง"]);
				exit;
			}
		
			if($response->withJson($this->causedt->delete($parsedBody["id"])) === false) {
					echo json_encode(["status" => 404, "message" => "Delete Failed"]);
					exit;
				}
				echo json_encode(["status" => 200, "message" => "Delete Successful"]);

		}

	}

	public function causedetailfrom($request, $response, $args)
	{
		$parsedBody = $request->getParsedBody();
		return $response->withJson($this->causedt->causedetailfrom($parsedBody["causeid"]));
	}


}