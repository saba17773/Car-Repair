<?php 

namespace App\Controllers;

use App\Models\CapacityModel;

class CapacityController
{
	public function __construct()
	{
		$this->cap = new CapacityModel;
	}

	public function all($request, $response, $args)
	{
		return $response->withJson($this->cap->all());
	}

	public function create($request, $response, $args)
	{

		$parsedBody = $request->getParsedBody();


		if ($parsedBody["form_type"]=="create") {
			$id=0;

			if($getCapacityInfo = $this->cap->CapacityInfo($parsedBody["inp_capacityname"],$id))
			{
				echo json_encode(["status" => 404, "message" => "ชื่อนี้มีอยู่แล้ว"]);
				exit;
			}
			if($response->withJson($this->cap->create($parsedBody["inp_capacityname"])) === false) {
				echo json_encode(["status" => 404, "message" => "Create Failed"]);
				exit;
			}
				echo json_encode(["status" => 200, "message" => "Create Successful"]);	

		}else{

			if($getCapacityInfo = $this->cap->CapacityInfo($parsedBody["inp_capacityname"],$parsedBody["id"]))
			{
				echo json_encode(["status" => 404, "message" => "ชื่อนี้มีอยู่แล้ว"]);
				exit;
			}
			if($response->withJson($this->cap->update($parsedBody["inp_capacityname"],$parsedBody["id"])) === false) {
					echo json_encode(["status" => 404, "message" => "Update Failed"]);
					exit;
			}
			if($getcapcheck = $this->cap->CapCheck($parsedBody["id"]))
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

			if($getcapcheck = $this->cap->CapCheck($parsedBody["id"]))
			{
				echo json_encode(["status" => 404, "message" => "ข้อมูลใช้งานอยู่ กรุณาลบภายหลัง"]);
				exit;
			}
		
			if($response->withJson($this->cap->delete($parsedBody["id"])) === false) {
					echo json_encode(["status" => 404, "message" => "Delete Failed"]);
					exit;
				}
				echo json_encode(["status" => 200, "message" => "Delete Successful"]);

		}

	}


}