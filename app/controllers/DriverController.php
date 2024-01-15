<?php 

namespace App\Controllers;

use App\Models\DriverModel;

class DriverController
{
	public function __construct()
	{
		$this->driver = new DriverModel;
	}

	public function all($request, $response, $args)
	{
		return $response->withJson($this->driver->all());
	}

	public function create($request, $response, $args)
	{
		$parsedBody = $request->getParsedBody();

		if ($parsedBody["form_type"]=="create") {
			$id=0;
			if($getdriverInfo = $this->driver->driverInfo($parsedBody["inp_drivername"],$id))
			{
				echo json_encode(["status" => 404, "message" => "ชื่อนี้มีอยู่แล้ว"]);
				exit;
			}
			if($response->withJson($this->driver->create($parsedBody["inp_drivername"],$parsedBody["sel_comid"],$parsedBody["sel_posid"],$parsedBody["sel_depid"],$parsedBody["sel_secid"])) === false) {
				echo json_encode(["status" => 404, "message" => "Create Failed"]);
				exit;
			}
				echo json_encode(["status" => 200, "message" => "Create Successful"]);	

		}else{
			if($getdriverInfo = $this->driver->driverInfo($parsedBody["inp_drivername"],$parsedBody["id"]))
			{
				echo json_encode(["status" => 404, "message" => "ชื่อนี้มีอยู่แล้ว"]);
				exit;
			}
			if($response->withJson($this->driver->update($parsedBody["inp_drivername"],$parsedBody["sel_comid"],$parsedBody["sel_posid"],$parsedBody["sel_depid"],$parsedBody["sel_secid"],$parsedBody["id"])) === false) {
					echo json_encode(["status" => 404, "message" => "Update Failed"]);
					exit;
			}
			// if($getdrivercheck = $this->driver->DriverCheck($parsedBody["id"]))
			// {
			// 	echo json_encode([	"status" => 404, "message" => "ข้อมูลใช้งานอยู่ กรุณาลบภายหลัง"]);
			// 	exit;
			// }
				echo json_encode(["status" => 200, "message" => "Update Successful"]);

		}
	}

	public function delete($request, $response, $args)
	{

		$parsedBody = $request->getParsedBody();
		
		if ($parsedBody) {

			if($getdrivercheck = $this->driver->DriverCheck($parsedBody["id"]))
			{
				echo json_encode(["status" => 404, "message" => "ข้อมูลใช้งานอยู่ กรุณาลบภายหลัง"]);
				exit;
			}
		
			if($response->withJson($this->driver->delete($parsedBody["id"])) === false) {
					echo json_encode(["status" => 404, "message" => "Delete Failed"]);
					exit;
				}
				echo json_encode(["status" => 200, "message" => "Delete Successful"]);

		}

	}


}