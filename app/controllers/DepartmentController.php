<?php 

namespace App\Controllers;

use App\Models\DepartmentModel;

class DepartmentController
{
	public function __construct()
	{
		$this->department = new DepartmentModel;
	}

	public function all($request, $response, $args)
	{
		return $response->withJson($this->department->all());
	}

	public function create($request, $response, $args)
	{

		$parsedBody = $request->getParsedBody();

		if ($parsedBody["form_type"]=="create") {
			$id = 0;
			if($getDPInfo = $this->department->DPInfo($parsedBody["inp_DP"],$id))
			{
				echo json_encode(["status" => 404, "message" => "ชื่อนี้มีอยู่แล้ว"]);
				exit;
			}

			if($response->withJson($this->department->create($parsedBody["inp_DP"])) === false) {
				echo json_encode(["status" => 404, "message" => "Create Failed"]);
				exit;
			}else{
				echo json_encode(["status" => 200, "message" => "Create Successful"]);
			}

		}else{

			if($getDPInfo = $this->department->DPInfo($parsedBody["inp_DP"],$parsedBody["id"]))
			{
				echo json_encode(["status" => 404, "message" => "ชื่อนี้มีอยู่แล้ว"]);
				exit;
			}		

			if($response->withJson($this->department->update($parsedBody["inp_DP"],$parsedBody["id"])) === false) {
					echo json_encode(["status" => 404, "message" => "Update Failed"]);
					exit;
			}
			if($getdepartcheck = $this->department->DepartCheck($parsedBody["id"]))
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

			if($getdepartcheck = $this->department->DepartCheck($parsedBody["id"]))
			{
				echo json_encode(["status" => 404, "message" => "ข้อมูลใช้งานอยู่ กรุณาลบภายหลัง"]);
				exit;
			}
		
			if($response->withJson($this->department->delete($parsedBody["id"])) === false) {
					echo json_encode(["status" => 404, "message" => "Delete Failed"]);
					exit;
				}
				echo json_encode(["status" => 200, "message" => "Delete Successful"]);

		}

	}


}