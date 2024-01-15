<?php 

namespace App\Controllers;

use App\Models\ComModel;

class ComController
{
	public function __construct()
	{
		$this->com = new ComModel;
	}

	public function all($request, $response, $args)
	{
		return $response->withJson($this->com->all());
	}

	public function create($request, $response, $args)
	{

		$parsedBody = $request->getParsedBody();

		if ($parsedBody["form_type"]=="create") {

			$id = 0;
			if($getcomInfo1 = $this->com->check($parsedBody["inp_internalcode"],$id))
			{
				echo json_encode(["status" => 404, "message" => "ชื่อนี้มีอยู่แล้ว"]);
				exit;
			}
			else
			{
				if($getcomInfo2 = $this->com->checkcom($parsedBody["inp_description"],$id))
				{
					echo json_encode(["status" => 404, "message" => "ชื่อนี้มีอยู่แล้ว"]);
					exit;
				}
			}
	
			if($response->withJson($this->com->create($parsedBody["inp_internalcode"],$parsedBody["inp_description"],$parsedBody["inp_descriptionth"])) === false) 
			{
				echo json_encode(["status" => 404, "message" => "Create Failed"]);
				exit;
			}
			else
			{
				echo json_encode(["status" => 200, "message" => "Create Successful"]);			
			}
			
		}else{
			
			if($getcomInfo1 = $this->com->check($parsedBody["inp_internalcode"],$parsedBody["id"]))
			{
				echo json_encode(["status" => 404, "message" => "ชื่อนี้มีอยู่แล้ว"]);
				exit;
			}
			else
			{
				if($getcomInfo2 = $this->com->checkcom($parsedBody["inp_description"],$parsedBody["id"]))
				{
					echo json_encode(["status" => 404, "message" => "ชื่อนี้มีอยู่แล้ว"]);
					exit;
				}
			}
			if($getcomcheck = $this->com->ComCheck($parsedBody["id"]))
			{
				echo json_encode(["status" => 404, "message" => "ข้อมูลใช้งานอยู่ กรุณาแก้ไขภายหลัง"]);
				exit;
			}
			if($response->withJson($this->com->update($parsedBody["inp_internalcode"],$parsedBody["inp_description"],$parsedBody["inp_descriptionth"],$parsedBody["id"])) === false) 
			{
					echo json_encode(["status" => 404, "message" => "Update Failed"]);
					exit;
			}
			else
			{
				echo json_encode(["status" => 200, "message" => "Update Successful"]);
			}		
		}
	}

	public function delete($request, $response, $args)
	{

		$parsedBody = $request->getParsedBody();
		
		if ($parsedBody) {

			if($getcomcheck = $this->com->ComCheck($parsedBody["id"]))
			{
				echo json_encode(["status" => 404, "message" => "ข้อมูลใช้งานอยู่ กรุณาลบภายหลัง"]);
				exit;
			}
		
			if($response->withJson($this->com->delete($parsedBody["id"])) === false) {
					echo json_encode(["status" => 404, "message" => "Delete Failed"]);
					exit;
				}
				echo json_encode(["status" => 200, "message" => "Delete Successful"]);

		}

	}



}

?>