<?php

namespace App\Controllers;

use Interop\Container\ContainerInterface;

class PageController
{
	protected $container;

	public function __construct( $container)
	{
		$this->container = $container;
		$this->template = $this->container->get('plate');
	}

	public function index($request, $response, $args)
	{
		return $response->withRedirect("/home");
	}

	public function auth($request, $response, $args)
	{
		return $this->template->render("pages/auth");
	}

	public function home()
	{
		return $this->template->render("pages/home");
	}

	public function homeMaster()
	{
		return $this->template->render("pages/Home_Master");
	}

	public function user()
	{
		return $this->template->render("pages/user_Master");
	}

	public function cust()
	{
		return $this->template->render("pages/cust_Master");
	}

	public function com()
	{
		return $this->template->render("pages/company_Master");
	}

	public function cartype()
	{
		return $this->template->render("pages/carType_Master");
	}

	public function brand()
	{
		return $this->template->render("pages/brand_Master");
	}

	public function cap()
	{
		return $this->template->render("pages/Capacity_Master");
	}

	public function regi()
	{
		return $this->template->render("pages/RegisterType_Master");
	}
	
	public function Ins()
	{
		return $this->template->render("pages/InsCom_Master");
	}

	public function driver()
	{
		return $this->template->render("pages/Driver_Master");
	}

	public function Cradle()
	{
		return $this->template->render("pages/Cradle_Master");
	}

	public function car()
	{
		return $this->template->render("pages/CAR_Master");
	}

	public function cardetail()
	{
		return $this->template->render("pages/CAR_Master_Detail");
	}

	public function claim()
	{
		return $this->template->render("pages/Claim");
	}

	public function Approval_Request()
	{
		// return $this->template->render("pages/ApprovalRequest");//tan_edit_20180703
		return $this->template->render("pages/ApprovalRequest_v2");
	}

	public function Approval_Repair()
	{
		// return $this->template->render("pages/ApprovalRepair");//tan_edit_20180703
		return $this->template->render("pages/ApprovalRepair_v2");
	}

	public function Approval_Directer()
	{
		// return $this->template->render("pages/ApprovalDirecter");//tan_edit_20180703
		return $this->template->render("pages/ApprovalDirecter_v2");
	}

	public function item()
	{
		return $this->template->render("pages/CarRepairItem");
	}
	public function Requests()
	{
		return $this->template->render("pages/RequestsRepair");
	}
	public function Department()
	{
		return $this->template->render("pages/Department_Master");
	}
	public function Section()
	{
		return $this->template->render("pages/Section_Master");
	}
	public function changepass()
	{
		return $this->template->render("pages/Change_password");
	}



	//Report
	public function Alert_report()
	{
		return $this->template->render("report/Alert_Report");
	}

	public function Test_report()
	{
		return $this->template->render("report/Test_Report");
	}

	public function Cause()
	{
		return $this->template->render("pages/Cause_Master");
	}

	public function CauseDetail()
	{
		return $this->template->render("pages/Cause_Master_Detail");
	}

	public function ClaimByCar()
	{
		return $this->template->render("pages/ClaimByCar");
	}


}