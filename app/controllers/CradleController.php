<?php 

namespace App\Controllers;

use App\Models\CradleModel;

class CradleController
{
	public function __construct()
	{
		$this->Cradle = new CradleModel;
	}

	public function all($request, $response, $args)
	{
		return $response->withJson($this->Cradle->all());
	}

	public function create($request, $response, $args)
	{


		$parsedBody = $request->getParsedBody();

		if ($parsedBody["form_type"]=="create") {
			$id=0;
			if($getCradleInfo = $this->Cradle->CradleInfo($parsedBody["inp_cradlename"],$id))
			{
				echo json_encode(["status" => 404, "message" => "ชื่อนี้มีอยู่แล้ว"]);
				exit;
			}
			if($response->withJson($this->Cradle->create($parsedBody["inp_cradlename"])) === false) {
				echo json_encode(["status" => 404, "message" => "Create Failed"]);
				exit;
			}
				echo json_encode(["status" => 200, "message" => "Create Successful"]);	

		}else{
			if($getCradleInfo = $this->Cradle->CradleInfo($parsedBody["inp_cradlename"],$parsedBody["id"]))
			{
				echo json_encode(["status" => 404, "message" => "ชื่อนี้มีอยู่แล้ว"]);
				exit;
			}
			if($response->withJson($this->Cradle->update($parsedBody["inp_cradlename"],$parsedBody["id"])) === false) {
					echo json_encode(["status" => 404, "message" => "Update Failed"]);
					exit;
			}
			if($getcradlecheck = $this->Cradle->CradleCheck($parsedBody["id"]))
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

			if($getcradlecheck = $this->Cradle->CradleCheck($parsedBody["id"]))
			{
				echo json_encode(["status" => 404, "message" => "ข้อมูลใช้งานอยู่ กรุณาลบภายหลัง"]);
				exit;
			}
		
			if($response->withJson($this->Cradle->delete($parsedBody["id"])) === false) {
					echo json_encode(["status" => 404, "message" => "Delete Failed"]);
					exit;
				}
				echo json_encode(["status" => 200, "message" => "Delete Successful"]);

		}

	}


}