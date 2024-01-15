<?php 

namespace App\Controllers;

use App\Models\RegisterTypeModel;

class RegisterTypeController
{
	public function __construct()
	{
		$this->reg = new RegisterTypeModel;
	}

	public function all($request, $response, $args)
	{
		return $response->withJson($this->reg->all());
	}

	public function create($request, $response, $args)
	{


		$parsedBody = $request->getParsedBody();

		if ($parsedBody["form_type"]=="create") {
			$id=0;
			if($getRegtypeInfo = $this->reg->RegtypeInfo($parsedBody["inp_registername"],$id))
			{
				echo json_encode(["status" => 404, "message" => "ชื่อนี้มีอยู่แล้ว"]);
				exit;
			}
			if($response->withJson($this->reg->create($parsedBody["inp_registername"])) === false) {
				echo json_encode(["status" => 404, "message" => "Create Failed"]);
				exit;
			}
				echo json_encode(["status" => 200, "message" => "Create Successful"]);	

		}else{

			if($getRegtypeInfo = $this->reg->RegtypeInfo($parsedBody["inp_registername"],$parsedBody["id"]))
			{
				echo json_encode(["status" => 404, "message" => "ชื่อนี้มีอยู่แล้ว"]);
				exit;
			}
			if($response->withJson($this->reg->update($parsedBody["inp_registername"],$parsedBody["id"])) === false) {
					echo json_encode(["status" => 404, "message" => "Update Failed"]);
					exit;
			}
			if($getregcheck = $this->reg->RegCheck($parsedBody["id"]))
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

			if($getregcheck = $this->reg->RegCheck($parsedBody["id"]))
			{
				echo json_encode(["status" => 404, "message" => "ข้อมูลใช้งานอยู่ กรุณาลบภายหลัง"]);
				exit;
			}
		
			if($response->withJson($this->reg->delete($parsedBody["id"])) === false) {
					echo json_encode(["status" => 404, "message" => "Delete Failed"]);
					exit;
				}
				echo json_encode(["status" => 200, "message" => "Delete Successful"]);

		}

	}


}