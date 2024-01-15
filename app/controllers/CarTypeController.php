<?php 

namespace App\Controllers;

use App\Models\CarTypeModel;

class CarTypeController
{
	public function __construct()
	{
		$this->carType = new CarTypeModel;
	}

	public function all($request, $response, $args)
	{
		return $response->withJson($this->carType->all());
	}

	public function create($request, $response, $args)
	{

		$parsedBody = $request->getParsedBody();

		if ($parsedBody["form_type"]=="create") {
			$id = 0;
			if($gettypeInfo = $this->carType->typeInfo($parsedBody["inp_cartypename"],$id))
			{
				echo json_encode(["status" => 404, "message" => "ชื่อนี้มีอยู่แล้ว"]);
				exit;
			}

			if($response->withJson($this->carType->create($parsedBody["inp_cartypename"])) === false) {
				echo json_encode(["status" => 404, "message" => "Create Failed"]);
				exit;
			}else{
				echo json_encode(["status" => 200, "message" => "Create Successful"]);
			}

		}else{

			if($gettypeInfo = $this->carType->typeInfo($parsedBody["inp_cartypename"],$parsedBody["id"]))
			{
				echo json_encode(["status" => 404, "message" => "ชื่อนี้มีอยู่แล้ว"]);
				exit;
			}		

			if($response->withJson($this->carType->update($parsedBody["inp_cartypename"],$parsedBody["id"])) === false) {
					echo json_encode(["status" => 404, "message" => "Update Failed"]);
					exit;
			}	
			if($getcartypecheck = $this->carType->CartypeCheck($parsedBody["id"]))
			{
				echo json_encode(["status" => 404, "message" => "ข้อมูลใช้งานอยู่ กรุณาแก้ไขภายหลัง"]);
				exit;

			}else{
				echo json_encode(["status" => 200, "message" => "Update Successful"]);
			}
		}	

	}

	public function delete($request, $response, $args)
	{

		$parsedBody = $request->getParsedBody();
		
		if ($parsedBody) {

			if($getcartypecheck = $this->carType->CartypeCheck($parsedBody["id"]))
			{
				echo json_encode(["status" => 404, "message" => "ข้อมูลใช้งานอยู่ กรุณาลบภายหลัง"]);
				exit;
			}
		
			if($response->withJson($this->carType->delete($parsedBody["id"])) === false) {
					echo json_encode(["status" => 404, "message" => "Delete Failed"]);
					exit;
				}
				echo json_encode(["status" => 200, "message" => "Delete Successful"]);

		}

	}


}