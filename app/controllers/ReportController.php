<?php 

namespace App\Controllers;

use App\Models\ReportModel;
use Wattanar\Sqlsrv;
use Interop\Container\ContainerInterface;

class ReportController
{
	protected $container;
	public function __construct(ContainerInterface $container)
	{
		$this->report = new ReportModel;
		$this->container = $container;
		$this->template = $this->container->get('plate');
	}

	public function reportRep($request, $response, $args)
	{
		$parsedBody = $request->getParsedBody();

		$type = $parsedBody["type"];
		if ($type==1) {
			$data = $this->report->reportApp($parsedBody["inp_Repair_report"]);
			$data_line = $this->report->reportApp_line($parsedBody["inp_Repair_report"]);
			// return $this->template->render("report/RepairApproval_Report",[
			// 	"data" => $data,
			//  	"data_line" => $data_line
			// ]);
			//echo "<pre>". print_r($data, true) . "</pre>";
			// echo "<pre>". print_r($data_line, true) . "</pre>";
		//echo "<h1><font color='red'>"."อยู่ระหว่างกำลังปรับปรุง"."</font></h1>";
			// header('Location: http://192.168.90.27:81/report_salequotation/recive_report_detail?docno='.$parsedBody["docno"].'&conno='.$parsedBody["conno"]);
			//exit;
			// $number_rows = 15;
			$fake_data   = [
				[0], //1
				[0], //2
				[0], //3
				[0], //4
				[0], //5
				[0], //6
				[0], //7
				[0], //8
				[0], //9
				[0], //10
				[0], //11
				[0], //12
				[0], //13
				[0], //14
				[0], //15
			]; 
			$Num = 0;
			foreach ($data_line as $value_num) {
				$Num++;
			}
			$number_rows = 15-$Num;
			for ($i=0; $i < $number_rows; $i++) { 
				foreach ($fake_data[$i] as $value) {
					$sorted = [];
					$data_line[] = (object) [
					  'RowNumber' => '',
					  'CAUSENAME' => '',
					  'DETAILNAME' => '',
					  'PRICE' => '',
					  'NOTE' => '',
					];

					$sorted = $data_line;
				}
			}
			// echo "<pre>". print_r($data, true) . "</pre>";
			// echo "<pre>". print_r($sorted, true) . "</pre>";
			return $this->template->render("report/RepairApproval_Report",[
				"data" => $data,
			 	"sorted" => $sorted
			]);

			// exit();
		}else{

			$data_i = $this->report->reportItem($parsedBody["inp_carid_report"]);
			$data_i_line = $this->report->reportItem_line($parsedBody["inp_carid_report"]);

			return $this->template->render("report/RepairItem_Report",[
				"data" => $data_i,
			 	"sorted" => $data_i_line
			]);

			exit;
		}


	}
// Nattapon_edit_20180710
	public function ReportAccount($request, $response, $args)
	{
		$parsedBody = $request->getParsedBody();

		$type = $parsedBody["typeac"];
		if($type==1){ 
			$data = $this->report->reportAppac($parsedBody["inp_acc_report"]);
			$data_line = $this->report->reportApp_lineac($parsedBody["inp_acc_report"]);
			// return $this->template->render("report/RepairApproval_Report",[
			// 	"data" => $data,
			//  	"data_line" => $data_line
			// ]);
			//echo "<pre>". print_r($data, true) . "</pre>";
			// echo "<pre>". print_r($data_line, true) . "</pre>";
		//echo "<h1><font color='red'>"."อยู่ระหว่างกำลังปรับปรุง"."</font></h1>";
			// header('Location: http://192.168.90.27:81/report_salequotation/recive_report_detail?docno='.$parsedBody["docno"].'&conno='.$parsedBody["conno"]);
			//exit;
			// $number_rows = 15;
			$fake_data   = [
				[0] //1
			]; 
			$Num = 0;
			foreach ($data_line as $value_num) {
				$Num++;
			}
			$number_rows = 500-$Num;
			for ($i=0; $i < $number_rows; $i++) { 
				foreach ($fake_data[$i] as $value) {
					$sorted = [];
					$data_line[] = (object) [
					  'RowNumber' => '',
					  'CAUSE' => '',
					  'DETAIL' => '',
					  'DESCRIPTION' =>'',
					  'PRICE' => '',
					  'NOTE' => '',
					];

					$sorted = $data_line;
				}
			}
			// echo "<pre>". print_r($data, true) . "</pre>";
			// echo "<pre>". print_r($sorted, true) . "</pre>";
			return $this->template->render("report/Report_Account",[
				"data" => $data,
			 	"sorted" => $sorted
			]);

			exit();
		}

	}
}