<?php 

namespace App\Controllers;

use App\Models\BrandModel;

class BrandController
{
	public function __construct()
	{
		$this->brand = new BrandModel;
	}

	public function all($request, $response, $args)
	{
		return $response->withJson($this->brand->all());
	}

	public function create($request, $response, $args)
	{


		$parsedBody = $request->getParsedBody();

		if ($parsedBody["form_type"]=="create") {	
			$id =0;
			if($getbrandInfo = $this->brand->brandInfo($parsedBody["inp_brandname"],$id))
			{
				echo json_encode(["status" => 404, "message" => "ชื่อนี้มีอยู่แล้ว"]);
				exit;
			}

			if($response->withJson($this->brand->create($parsedBody["inp_brandname"])) === false) {
				echo json_encode(["status" => 404, "message" => "Create Failed"]);
				exit;
			}else{
				echo json_encode(["status" => 200, "message" => "Create Successful"]);
			}

		}else{

			if($getbrandInfo = $this->brand->brandInfo($parsedBody["inp_brandname"],$parsedBody["id"]))
			{
				echo json_encode(["status" => 404, "message" => "ชื่อนี้มีอยู่แล้ว"]);
				exit;
			}
			if($response->withJson($this->brand->update($parsedBody["inp_brandname"],$parsedBody["id"])) === false) {
					echo json_encode(["status" => 404, "message" => "Update Failed"]);
					exit;
			}

			if($getbrandcheck = $this->brand->BrandCheck($parsedBody["id"]))
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

			if($getbrandcheck = $this->brand->BrandCheck($parsedBody["id"]))
			{
				echo json_encode(["status" => 404, "message" => "ข้อมูลใช้งานอยู่ กรุณาลบภายหลัง"]);
				exit;
			}
		
			if($response->withJson($this->brand->delete($parsedBody["id"])) === false) {
					echo json_encode(["status" => 404, "message" => "Delete Failed"]);
					exit;
				}
				echo json_encode(["status" => 200, "message" => "Delete Successful"]);

		}

	}


}