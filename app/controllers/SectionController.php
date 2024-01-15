<?php 

namespace App\Controllers;

use App\Models\SectionModel;

class SectionController
{
	public function __construct()
	{
		$this->section = new SectionModel;
	}

	public function all($request, $response, $args)
	{
		return $response->withJson($this->section->all());
	}

	public function create($request, $response, $args)
	{

		$parsedBody = $request->getParsedBody();

		if ($parsedBody["form_type"]=="create") {
			$id = 0;
			if($getsecInfo = $this->section->secInfo($parsedBody["inp_section"],$id))
			{
				echo json_encode(["status" => 404, "message" => "ชื่อนี้มีอยู่แล้ว"]);
				exit;
			}

			if($response->withJson($this->section->create($parsedBody["inp_section"])) === false) {
				echo json_encode(["status" => 404, "message" => "Create Failed"]);
				exit;
			}else{
				echo json_encode(["status" => 200, "message" => "Create Successful"]);
			}

		}else{

			if($getsecInfo = $this->section->secInfo($parsedBody["inp_section"],$parsedBody["id"]))
			{
				echo json_encode(["status" => 404, "message" => "ชื่อนี้มีอยู่แล้ว"]);
				exit;
			}		

			if($response->withJson($this->section->update($parsedBody["inp_section"],$parsedBody["id"])) === false) {
					echo json_encode(["status" => 404, "message" => "Update Failed"]);
					exit;
			}
			if($getseccheck = $this->section->SecCheck($parsedBody["id"]))
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

			if($getseccheck = $this->section->SecCheck($parsedBody["id"]))
			{
				echo json_encode(["status" => 404, "message" => "ข้อมูลใช้งานอยู่ กรุณาลบภายหลัง"]);
				exit;
			}
		
			if($response->withJson($this->section->delete($parsedBody["id"])) === false) {
					echo json_encode(["status" => 404, "message" => "Delete Failed"]);
					exit;
				}
				echo json_encode(["status" => 200, "message" => "Delete Successful"]);

		}

	}


}