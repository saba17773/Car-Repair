<?php 

namespace App\Controllers;

use App\Models\CARModel;

class CARController
{
	public function __construct()
	{
		$this->car = new CARModel;
	}

	public function all($request, $response, $args)
	{
		return $response->withJson($this->car->all());
	}

	public function create($request, $response, $args)
	{

		$parsedBody = $request->getParsedBody();
		$Date = DATE($parsedBody["inp_datereg"]);
		$Year = (int)substr($Date,6)-543;
		$Date  =  substr($Date,3,2) .'-'.substr($Date,0,2) .'-'.$Year;
		$asset = trim($parsedBody["inp_asset"]);

		if (!isset($parsedBody['milesac'])) {
			$milesac = 0;
		}else{
			$milesac = 1;
		}

		if ($parsedBody["form_type"]=="create") {

			if($getcarAsset = $this->car->carAsset($asset))
			{
				echo json_encode(["status" => 404, "message" => "รหัสทรัพย์สินนี้มีอยู่แล้ว"]);
				exit;
			}
			if($getcarreg = $this->car->carProvince($parsedBody["inp_regcar"]
													,$parsedBody["sel_regcardes"]))
			{
				echo json_encode(["status" => 404, "message" => "ข้อมูลทะเบียนรถและจังหวัดมีอยู่แล้ว"]);
				exit;
			}

			if($response->withJson($this->car->createcar($parsedBody["inp_brandid"]
														,$parsedBody["inp_cartypeid"]
														,$parsedBody["inp_registerid"]
														,$parsedBody["sel_capid"]
														,$parsedBody["sel_driverid"]
														,$Date
														// ,$parsedBody["inp_milesno"]
														,$parsedBody["inp_regcar"]
														,$parsedBody["sel_regcardes"]
														,$parsedBody["sel_comid"]
														,$asset
														,$parsedBody["sel_secid"]
														,$milesac)) === false) 
			{
				echo json_encode(["status" => 404, "message" => "Create Failed"]);
				exit;
			}
			else
			{
				echo json_encode(["status" => 200, "message" => "Create Successful"]);
			}
			

		}else{

			if($response->withJson($this->car->updatecar($parsedBody["inp_brandid"]
														,$parsedBody["inp_cartypeid"]
														,$parsedBody["inp_registerid"]
														,$parsedBody["sel_capid"]
														,$parsedBody["sel_driverid"]
														,$Date
														// ,$parsedBody["inp_milesno"]
														,$parsedBody["inp_regcar"]
														,$parsedBody["sel_regcardes"]
														,$parsedBody["sel_comid"]
														,$parsedBody["sel_secid"]
														,$asset
														,$milesac
														,$parsedBody["id"])) === false)
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
		
			if($response->withJson($this->car->delete($parsedBody["id"])) === false) {
					echo json_encode(["status" => 404, "message" => "Delete Failed"]);
					exit;
				}
				echo json_encode(["status" => 200, "message" => "Delete Successful"]);

		}
	}

	public function provinceload($request, $response, $args)
	{
		return $response->withJson($this->car->provinceload());
	}

}