<!DOCTYPE html>
<html>
<head>
  	<meta charset="utf-8">
  	<meta http-equiv="x-ua-compatible" content="ie=edge">
  	<meta name="viewport" content="width=device-width, initial-scale=1">
  	<link rel="shortcut icon" type="image/png" href="/resources/logo.png"/>
  	<title>Car Repair</title>
  	<link rel="stylesheet" href="/resources/css/bootstrap.min.css">
  	<link rel="stylesheet" href="/resources/jqwidgets/styles/jqx.base.css">
  	<link rel="stylesheet" href="/resources/css/multiple-select.css" />
  	<link rel="stylesheet" href="/resources/css/app.css" />
  	<link rel="stylesheet" href="/resources/css/sandstone.min.css" />
  	<link rel="stylesheet" href="/resources/jqwidgets/styles/themeorange2.css"/>
  	<link rel="stylesheet" href="/resources/css/jquery-ui.min.css" />
    <link rel="stylesheet" href="/resources/sweetalert-master/dist/sweetalert.css" />
    <link rel="stylesheet" href="/resources/chosen/chosen.css" />
  	<link rel="stylesheet" href="/resources/css/msgBoxLight.css" type="text/css" />
  <script src="/resources/js/jquery-1.12.0.min.js"></script>
  <script src="/resources/js/jquery-ui.min.js"></script>
  <script src="/resources/js/bootstrap.min.js"></script>
  <script src="/resources/jqwidgets/jqxcore.js"></script>
  <script src="/resources/jqwidgets/jqxdata.js"></script> 
  <script src="/resources/jqwidgets/jqxbuttons.js"></script>
  <script src="/resources/jqwidgets/jqxscrollbar.js"></script>
  <script src="/resources/jqwidgets/jqxmenu.js"></script>
  <script src="/resources/jqwidgets/jqxcheckbox.js"></script>
  <script src="/resources/jqwidgets/jqxlistbox.js"></script>
  <script src="/resources/jqwidgets/jqxdropdownlist.js"></script>
  <script src="/resources/jqwidgets/jqxdropdownbutton.js"></script> 
  <script src="/resources/jqwidgets/jqxgrid.js"></script>
  <script src="/resources/jqwidgets/jqxgrid.sort.js"></script> 
  <script src="/resources/jqwidgets/jqxgrid.pager.js"></script> 
  <script src="/resources/jqwidgets/jqxgrid.selection.js"></script> 
  <script src="/resources/jqwidgets/jqxgrid.edit.js"></script> 
  <script src="/resources/jqwidgets/jqxgrid.filter.js"></script> 
  <script src="/resources/jqwidgets/jqxgrid.columnsresize.js"></script>
  <script src="/resources/jqwidgets/jqxcore.js"></script>
  <script src="/resources/jqwidgets/jqxbuttongroup.js"></script>
  <script src="/resources/jqwidgets/jqxbuttons.js"></script>
  <script src="/resources/jqwidgets/jqxradiobutton.js"></script>
  <script src="/resources/jqwidgets/jqxdatetimeinput.js"></script>
  <script src="/resources/jqwidgets/jqxcalendar.js"></script>
  <script src="/resources/jqwidgets/jqxgrid.aggregates.js"></script>
  <script src="/resources/jqwidgets/jqxwindow.js"></script>
  <script src="/resources/js/gojax.min.js"></script>
  <script src="/resources/js/functions.js"></script>
  <script src="/resources/js/app.js"></script>
  <script src="/resources/js/gotify.min.js"></script>
  <script src="/resources/js/multiple-select.js"></script>
  <script src="/resources/js/jquery.msgBox.js"></script>
  <script src="/resources/js/jqueryui_datepicker_thai_min.js"></script>
  <script src="/resources/sweetalert-master/dist/sweetalert.min.js"></script>
  <script src="/resources/chosen/chosen.jquery.min.js"></script>

	<!--[if lt IE 9]>
		<script src="resources/js/html5shiv.js"></script>
		<script src="resources/js/respond.js"></script>
	<![endif]-->
</head>
<body>
	<!-- GOTIFY -->
  	<div class="gotify-overlay"></div>

  	<div class="gotify">
      <div class="gotify-wrap">
          <div class="close-gotify" onclick="return close_gotify()"></div>
          <div class="gotify-content"></div>
      </div>
  	</div>

	<nav class="navbar navbar-default">		  
		    <!-- Collect the nav links, forms, and other content for toggling -->
		    <div class="collapse navbar-collapse" id="bs-example-navbar-collapse-1">
		    	<a class="navbar-brand" href="/"><img  src="/resources/DN2.png" style="padding-left:10px;height:15px; width:auto;" />
				</a>
		      <ul class="nav navbar-nav">/DriverMaster
		       <li><a href="/home"><font size ="2px">ซ่อมรถยนต์</font></a></li>
           <!-- <li><a href="/DriverMaster"><font size ="2px">ผู้ขับรถ</font></a></li> -->
        <?php if ($_SESSION["secid"] == 2 || $_SESSION["posid"] == 3 || $_SESSION["posid"] == 5){ ?>
            <li><a href="/Claim"><font size ="2px">เคลมประกัน</font></a></li>    
            <li><a href="/CarMaster"><font size ="2px">ข้อมูลรถยนต์</font></a></li>
		        <li class="dropdown">
		          <a href="#" class="dropdown-toggle" data-toggle="dropdown" role="button" aria-haspopup="true" aria-expanded="false"><font size ="1px">Master Setup</font><span class="caret"></span></a>
		          <ul class="dropdown-menu">        
  		            <li><a href="/companymaster"><font size ="2px">บริษัท</font></a></li>
                  <li><a href="/carTypeMaster"><font size ="2px">ประเภทรถยนต์</font></a></li>
                  <li><a href="/brandMaster"><font size ="2px">ยี่ห้อรถยนต์</font></a></li>
                  <li><a href="/capMaster"><font size ="2px">ขนาดความจุของเครื่องยนต์</font></a></li>
                  <li><a href="/regiMaster"><font size ="2px">ประเภทการจดทะเบียน</font></a></li>
                  <li><a href="/InsComMaster"><font size ="2px">บริษัทประกันภัย</font></a></li>
                  <li><a href="/DriverMaster"><font size ="2px">ผู้ขับรถ</font></a></li>
                  <li><a href="/CradleMaster"><font size ="2px">อู่ซ่อมรถยนต์</font></a></li>
                  <li><a href="/Department"><font size ="2px">แผนก</font></a></li>
                  <li><a href="/Section"><font size ="2px">ฝ่าย</font></a></li>
                  <li><a href="/CauseMaster"><font size ="2px">สาเหตุการซ่อม</font></a></li> 
                  <li><a href="/usermaster?check=$check"><font size ="2px">ผู้เข้าใช้งานระบบ</font></a></li>
		          </ul>
		        </li>  

            <!-- <li><a href="https://www.google.co.th/" target="blank"><font size ="2px">รายงานสรุปยอดรายปี</font></a></li> -->

        <?php } ?>
            <li class="dropdown">
              <a href="#" class="dropdown-toggle" data-toggle="dropdown" role="button" aria-haspopup="true" aria-expanded="false"><font size ="2px">คู่มือการใช้งาน</font><span class="caret"></span></a>
              <ul class="dropdown-menu">        
                  <li><a href="./Manual/Manual_CarRepair Update 25-9-2018.pdf" target="blank"><font size ="2px">การร้องขอแจ้งซ่อม & การดำเนินการซ่อม</font></a></li>
                  <!-- <li><a href="./Manual/Manual_CarRepair_Repair.pdf" target="blank"><font size ="2px">การดำเนินการซ่อม</font></a></li> -->
              </ul>
            </li>
		      </ul>
		      <ul class="nav navbar-nav navbar-right">
              <li>
                <a href="#" class="dropdown-toggle" data-toggle="dropdown" role="button" aria-haspopup="true" aria-expanded="false"><font size ="2px"></font><span class="glyphicon glyphicon-user"></span><?php echo " ".$_SESSION["username"]; ?></a>
                  <ul class="dropdown-menu">        
                  <li><a href="/changepass"><font size ="2px">เปลี่ยนรหัสผ่าน</font></a></li>
                  <!-- <li><a href="./Manual/Manual_CarRepair_Repair.pdf" target="blank"><font size ="2px">การดำเนินการซ่อม</font></a></li> -->
              </ul>
              </li>
        			<li><a href="/user/logout"><span class="glyphicon glyphicon-log-out"></span>Logout</a></li>
        	 	</ul>
		    </div><!-- /.navbar-collapse -->
		  </div><!-- /.container-fluid -->
	</nav>
	<div class="col-md-9">
			<?= $this->section('content'); ?>
	</div>
</body>
</html>
<script type="text/javascript">

function CloseSession(){
    session_destroy();
}

window.onbeforeunload = CloseSession;
</script> 