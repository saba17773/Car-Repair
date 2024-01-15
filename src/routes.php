<?php

$app->get("/", "App\Controllers\PageController:index")->add($auth);
$app->get("/home", "App\Controllers\PageController:home")->add($auth);
$app->get("/homeMaster", "App\Controllers\PageController:homeMaster")->add($auth);
$app->get("/user/auth", "App\Controllers\PageController:auth");
$app->get("/user/logout", "App\Controllers\UserController:logout");
$app->get("/usermaster", "App\Controllers\PageController:user")->add($auth);
$app->get("/custmaster", "App\Controllers\PageController:cust")->add($auth);
$app->get("/companymaster", "App\Controllers\PageController:com")->add($auth);
$app->get("/carTypeMaster", "App\Controllers\PageController:cartype")->add($auth);
$app->get("/brandMaster", "App\Controllers\PageController:brand")->add($auth);
$app->get("/capMaster", "App\Controllers\PageController:cap")->add($auth);
$app->get("/regiMaster", "App\Controllers\PageController:regi")->add($auth);
$app->get("/InsComMaster", "App\Controllers\PageController:Ins")->add($auth);
$app->get("/DriverMaster", "App\Controllers\PageController:driver")->add($auth);
$app->get("/CradleMaster", "App\Controllers\PageController:Cradle")->add($auth);
$app->get("/CarMaster", "App\Controllers\PageController:car")->add($auth);
$app->get("/CarDetail", "App\Controllers\PageController:cardetail")->add($auth);
$app->get("/Claim", "App\Controllers\PageController:claim")->add($auth);
$app->get("/ApprovalRequest", "App\Controllers\PageController:Approval_Request");
$app->get("/ApprovalRepair", "App\Controllers\PageController:Approval_Repair");
$app->get("/ApprovalDirecter", "App\Controllers\PageController:Approval_Directer");
$app->get("/CauseMaster", "App\Controllers\PageController:Cause")->add($auth);
$app->get("/CauseDetail", "App\Controllers\PageController:CauseDetail")->add($auth);
// $app->get("/Repairitem", "App\Controllers\PageController:item")->add($auth);
$app->get("/Department", "App\Controllers\PageController:Department")->add($auth);
$app->get("/Section", "App\Controllers\PageController:Section")->add($auth);
$app->get("/ClaimByCar", "App\Controllers\PageController:ClaimByCar")->add($auth);
$app->get("/changepass", "App\Controllers\PageController:changepass")->add($auth);


// Report
$app->get("/Alert_report", "App\Controllers\PageController:Alert_report")->add($auth);
$app->get("/Test_report", "App\Controllers\PageController:Test_report")->add($auth);

$app->group("/api/v1", function() use ($app, $auth) {
	//user
	$app->post("/user/auths", "App\Controllers\UserController:auth");
	$app->get("/user/load", "App\Controllers\UserController:all");
	$app->get("/comp/load", "App\Controllers\UserController:comp");
	$app->post("/compedit/load", "App\Controllers\UserController:compedit");
	$app->post("/manager/load", "App\Controllers\UserController:manageredit");
	$app->get("/pos/load", "App\Controllers\UserController:pos");
	$app->get("/depart/load", "App\Controllers\UserController:depart");
	$app->get("/sec/load", "App\Controllers\UserController:section");
	$app->post("/user/create", "App\Controllers\UserController:createuser");
	$app->post("/user/delete", "App\Controllers\UserController:delete");	
	$app->post("/user/gen", "App\Controllers\UserController:gen");
	$app->post("/forget/password", "App\Controllers\UserController:forgetpassword");
	$app->post("/user/changepass", "App\Controllers\UserController:userchangepass");
	// company
	$app->get("/com/load", "App\Controllers\ComController:all");
	$app->post("/com/create", "App\Controllers\ComController:create");
	$app->post("/com/delete", "App\Controllers\ComController:delete");
	// car type
	$app->get("/carType/load", "App\Controllers\CarTypeController:all");
	$app->post("/carType/create", "App\Controllers\CarTypeController:create");
	$app->post("/carType/delete", "App\Controllers\CarTypeController:delete");
	// brand
	$app->get("/brand/load", "App\Controllers\BrandController:all");
	$app->post("/brand/create", "App\Controllers\BrandController:create");
	$app->post("/brand/delete", "App\Controllers\BrandController:delete");
	// capacity
	$app->get("/cap/load", "App\Controllers\CapacityController:all");
	$app->post("/cap/create", "App\Controllers\CapacityController:create");
	$app->post("/cap/delete", "App\Controllers\CapacityController:delete");
	// register
	$app->get("/regi/load", "App\Controllers\RegisterTypeController:all");
	$app->post("/regi/create", "App\Controllers\RegisterTypeController:create");
	$app->post("/regi/delete", "App\Controllers\RegisterTypeController:delete");
	// insurance
	$app->get("/Ins/load", "App\Controllers\InsComController:all");
	$app->post("/Ins/create", "App\Controllers\InsComController:create");
	$app->post("/Ins/delete", "App\Controllers\InsComController:delete");
	// driver
	$app->get("/driver/load", "App\Controllers\DriverController:all");
	$app->post("/driver/create", "App\Controllers\DriverController:create");
	$app->post("/driver/delete", "App\Controllers\DriverController:delete");
	// province
	$app->get("/province/load", "App\Controllers\CARController:provinceload");
	// Cradle
	$app->get("/Cradlemaster/load", "App\Controllers\CradleController:all");
	$app->post("/Cradle/create", "App\Controllers\CradleController:create");
	$app->post("/Cradle/delete", "App\Controllers\CradleController:delete");
	// Car
	$app->get("/car/load", "App\Controllers\CARController:all");
	$app->post("/car/gen", "App\Controllers\CARController:gen");
	$app->post("/car/create", "App\Controllers\CARController:create");
	$app->post("/car/delete", "App\Controllers\CARController:delete");
	// Car detail
	$app->get("/Detail/load", "App\Controllers\CAR_DetailController:all");
	$app->post("/Detail/create", "App\Controllers\CAR_DetailController:createdetail");	
	$app->post("/Detail/delete", "App\Controllers\CAR_DetailController:delete");
	$app->get("/datafile/load", "App\Controllers\CAR_DetailController:datafile");
	$app->post("/datafile/delete", "App\Controllers\CAR_DetailController:deletedatafile");	
	// Repair
	$app->get("/rep/load", "App\Controllers\RepairController:all");
	$app->get("/repclick/load", "App\Controllers\RepairController:allclick");
	$app->get("/repDriver/load", "App\Controllers\RepairController:Driver");
	$app->post("/repcardetail/load", "App\Controllers\RepairController:cardetail");	
	$app->get("/repcar/load", "App\Controllers\RepairController:car");
	$app->get("/repcar/load/bycom", "App\Controllers\RepairController:carbycom");
	$app->post("/repcom/load", "App\Controllers\RepairController:com");
	$app->post("/repdep/load", "App\Controllers\RepairController:dep");
	$app->post("/repsec/load", "App\Controllers\RepairController:sec");
	$app->post("/rep/gen", "App\Controllers\RepairController:gen");
	$app->post("/rep/create", "App\Controllers\RepairController:create");
	$app->post("/rep/delete", "App\Controllers\RepairController:delete");
	$app->get("/Cradle/load", "App\Controllers\RepairController:Cradle");
	$app->post("/repline/create", "App\Controllers\RepairController:create_line");
	$app->post("/repline/delete", "App\Controllers\RepairController:delete_line");
	$app->get("/rep/Manager", "App\Controllers\RepairController:Manager");
	$app->post("/rep/updatenew", "App\Controllers\RepairController:updatenew");
	$app->post("/repcausedetail/load", "App\Controllers\RepairController:causedetail");
	$app->get("/repcausedetailtest/load", "App\Controllers\RepairController:causedetailtest");
	$app->get("/load/repairitem", "App\Controllers\RepairController:loadrepairitem");
	$app->post("/update/repaireddate", "App\Controllers\RepairController:repaireddate");
	$app->post("/delete/repaireddate", "App\Controllers\RepairController:deleterepaireddate");

	// claim
	$app->get("/claim/load", "App\Controllers\ClaimController:all");
	$app->get("/claimclick/load", "App\Controllers\ClaimController:allclick");
	$app->post("/claim/gen", "App\Controllers\ClaimController:gen");
	$app->get("/claim/car", "App\Controllers\ClaimController:car");
	$app->post("/claim/ins", "App\Controllers\ClaimController:ins");
	$app->post("/claim/insedit", "App\Controllers\ClaimController:insedit");
	$app->post("/claim/create", "App\Controllers\ClaimController:create");
	$app->get("/claimfile/load", "App\Controllers\ClaimController:datafile");
	$app->post("/claimfile/delete", "App\Controllers\ClaimController:deletedatafile");		
	$app->post("/claim/delete", "App\Controllers\ClaimController:delete");
	$app->get("/load/picture", "App\Controllers\ClaimController:loadpicture");
	// mail
	// $app->post("/email/sent", "App\Controllers\EmailController:senttest");
	$app->post("/email/sent", "App\Controllers\EmailController:sent");
	$app->post("/email/sendpass", "App\Controllers\EmailController:sendpass");
	// approved
	$app->get("/request/repair", "App\Controllers\ApprovedController:request");
	$app->post("/request/approved", "App\Controllers\ApprovedController:approved_request");
	$app->post("/directer/approved", "App\Controllers\ApprovedController:approved_directer");
	$app->post("/getrepair/approved", "App\Controllers\ApprovedController:approved_repair");
	$app->get("/all/repair", "App\Controllers\ApprovedController:all");//tan_edit_20180704
	$app->post("/selectrepair/load", "App\Controllers\ApprovedController:selectrepair");//Nattapon_edit_20180704

	//Report
	$app->post("/report/all", "App\Controllers\ReportController:reportRep");
	$app->post("/report/account", "App\Controllers\ReportController:ReportAccount");
	// Cause
	$app->get("/Cause/load", "App\Controllers\CauseController:all");
	$app->post("/cause/create", "App\Controllers\CauseController:create");
	$app->post("/cause/delete", "App\Controllers\CauseController:delete");
	$app->get("/Causestatus/load", "App\Controllers\CauseController:allstatus");
	// CauseDetail
	$app->get("/causedetail/load", "App\Controllers\CauseDetailController:all");
	$app->post("/causedetail/create", "App\Controllers\CauseDetailController:create");
	$app->post("/causedetail/delete", "App\Controllers\CauseDetailController:delete");
	$app->post("/causedetail/from", "App\Controllers\CauseDetailController:causedetailfrom");
	// Department
	$app->get("/department/load", "App\Controllers\DepartmentController:all");
	$app->post("/department/create", "App\Controllers\DepartmentController:create");
	$app->post("/department/delete", "App\Controllers\DepartmentController:delete");
	// Section
	$app->get("/section/load", "App\Controllers\SectionController:all");
	$app->post("/section/create", "App\Controllers\SectionController:create");
	$app->post("/section/delete", "App\Controllers\SectionController:delete");
	// Employee
	$app->get("/employee/load", "App\Controllers\UserController:employee");
	// claimbycar
	$app->get("/claimbycar/load", "App\Controllers\ClaimByCarController:allbycar");
	$app->post("/claimbycar/create", "App\Controllers\ClaimByCarController:createbycar");
	$app->post("/claimbycar/insedit", "App\Controllers\ClaimByCarController:insedit");

	$app->post("/rep/cancel", "App\Controllers\RepairController:cancel");

	
});


