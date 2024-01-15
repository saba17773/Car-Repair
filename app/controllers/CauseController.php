<?php 

namespace App\Controllers;

use App\Models\CauseModel;

class CauseController
{
	public function __construct()
	{
		$this->cause = new CauseModel;
	}

	public function all($request, $response, $args)
	{
		return $response->withJson($this->cause->all());
	}

	public function allstatus($request, $response, $args)
	{
		return $response->withJson($this->cause->allstatus());
	}

	public function create($request, $response, $args)
	{

		$parsedBody = $request->getParsedBody();

		if (!isset($parsedBody["inp_status"])) {
			$status = 0;
		}else{
			$status = 1;
		}
		if ($parsedBody["form_type"]=="create") {
			$id = 0;
			if($getcauseInfo = $this->cause->causeInfo($parsedBody["inp_causename"],$id))
			{
				echo json_encode(["status" => 404, "message" => "ชื่อนี้มีอยู่แล้ว"]);
				exit;
			}

			if($response->withJson($this->cause->create($parsedBody["inp_causename"]
																	,$status)) === false) {
				echo json_encode(["status" => 404, "message" => "Create Failed"]);
				exit;
			}else{
				echo json_encode(["status" => 200, "message" => "Create Successful"]);
			}

		}else{

			if($getcauseInfo = $this->cause->causeInfo($parsedBody["inp_causename"],$parsedBody["id"]))
			{
				echo json_encode(["status" => 404, "message" => "ชื่อนี้มีอยู่แล้ว"]);
				exit;
			}		

			if($response->withJson($this->cause->update($parsedBody["inp_causename"]
														,$status
														,$parsedBody["id"])) === false) {
					echo json_encode(["status" => 404, "message" => "Update Failed"]);
					exit;
			}
			if($getcausecheck = $this->cause->CauseCheck($parsedBody["id"]))
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
			
			if($getcausecheck = $this->cause->CauseCheck($parsedBody["id"]))
			{
				echo json_encode(["status" => 404, "message" => "ข้อมูลใช้งานอยู่ กรุณาลบภายหลัง"]);
				exit;
			}
		
			if($response->withJson($this->cause->delete($parsedBody["id"])) === false) {
					echo json_encode(["status" => 404, "message" => "Delete Failed"]);
					exit;
				}
				echo json_encode(["status" => 200, "message" => "Delete Successful"]);

		}

	}


}