<?php 

namespace App\Controllers;

use App\Models\InsComModel;

class InsComController
{
	public function __construct()
	{
		$this->Ins = new InsComModel;
	}

	public function all($request, $response, $args)
	{
		return $response->withJson($this->Ins->all());
	}

	public function create($request, $response, $args)
	{

		$parsedBody = $request->getParsedBody();

		if ($parsedBody["form_type"]=="create") {
			$id=0;
			if($getInsInfo = $this->Ins->InsuranceInfo($parsedBody["inp_insurancename"],$id))
			{
				echo json_encode(["status" => 404, "message" => "ชื่อนี้มีอยู่แล้ว"]);
				exit;
			}
			if($response->withJson($this->Ins->create($parsedBody["inp_insurancename"])) === false) {
				echo json_encode(["status" => 404, "message" => "Create Failed"]);
				exit;
			}
				echo json_encode(["status" => 200, "message" => "Create Successful"]);	

		}else{

			if($getInsInfo = $this->Ins->InsuranceInfo($parsedBody["inp_insurancename"],$parsedBody["id"]))
			{
				echo json_encode(["status" => 404, "message" => "ชื่อนี้มีอยู่แล้ว"]);
				exit;
			}
			if($response->withJson($this->Ins->update($parsedBody["inp_insurancename"],$parsedBody["id"])) === false) {
					echo json_encode(["status" => 404, "message" => "Update Failed"]);
					exit;
			}
			if($getinscheck = $this->Ins->InsCheck($parsedBody["id"]))
			{
				echo json_encode(["status" => 404, "message" => "ข้อมูลใช้งานอยู่ กรุณาแก้ไขภายหลัง"]);
				exit;
			}
				echo json_encode(["status" => 200, "message" => "Update Successful"]);

		}
	}

	public function delete($request, $response, $args)
	{

		$parsedBody = $request->getParsedBody();
		
		if ($parsedBody) {

			if($getinscheck = $this->Ins->InsCheck($parsedBody["id"]))
			{
				echo json_encode(["status" => 404, "message" => "ข้อมูลใช้งานอยู่ กรุณาลบภายหลัง"]);
				exit;
			}
		
			if($response->withJson($this->Ins->delete($parsedBody["id"])) === false) {
					echo json_encode(["status" => 404, "message" => "Delete Failed"]);
					exit;
				}
				echo json_encode(["status" => 200, "message" => "Delete Successful"]);

		}

	}


}