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
  <script src="/resources/js/gojax.min.js"></script>
  <script src="/resources/js/functions.js"></script>
  <script src="/resources/js/app.js"></script>
  <script src="/resources/js/gotify.min.js"></script>
  <script src="/resources/js/multiple-select.js"></script>
  <script src="/resources/js/jquery.msgBox.js"></script>
  <script src="/resources/sweetalert-master/dist/sweetalert.min.js"></script>

<div id="myModalApprove" class="modal">
    <br><br><br>
    <center class="container">
    <div class="panel panel-success">
      <div class="panel-heading">
        <h1 class="panel-title">แจ้งสถานะการอนุมัติ</h1>
      </div>
      <div class="panel-body">
        <h1 id="alert_text">อนุมัติเรียบร้อยแล้ว</h1> 
      </div>
    </div>
    </center>
</div>

<div id=div_show>
  <h2>Car Repair Approval</h2>
  <span id='showdata'> </span> 
</div>    


<?php
use Wattanar\Sqlsrv;
use App\Controllers\ConnectionController;
  if (!isset($_GET["repairId"])) 
  {
      echo "no params";
      exit();
  }
	$id = $_GET["repairId"];
	$idapp = $_GET["idapp"];

 	if(ConnectionController::connect() !== false)
  {
        $sql = "SELECT *
                FROM REPAIR R
                WHERE R.REPAIRID='$id'";

	  $sql_rep = Sqlsrv::array(ConnectionController::connect(),$sql);

	    foreach($sql_rep as $rep)
      {
          $statusid = $rep->STATUSREPAIR;
      }
  }
?>



<div id="dialog" title="approved"><label for="approved">ยืนยันการอนุมัติ</label></div>

<script type="text/javascript">
$('#dialog').hide();

jQuery(document).ready(function($) {

  var statusid = "<?php echo $statusid ?>";
  showapprove(statusid);
 

  html = '<table id="records" cellspacing="0"  border="1">';

	var IDR = '<?php echo urlencode($_GET["repairId"]); ?>';
	var idapp = '<?php echo urlencode($_GET["idapp"]); ?>';

	gojax('get', '/api/v1/request/repair', {id:IDR})
    	.done(function(data) {
        $.each(data, function(index, val) {
            html +=
             		"<tr><td width='150'>เลขที่ใบขออนุมัติ</td>" +
		            "<td width='200' COLSPAN=2>" + val.REPAIRID + "</td></tr>" +
		            "<tr><td>ทะเบียนรถ</td>" +
		            "<td width='200' COLSPAN=2>" + val.REGCAR + "</td></tr>" +
		            "<tr><td>สาเหตุการซ่อม</td>" +
		            "<td width='200' COLSPAN=2>" + val.REMARK + "</td></tr>" +
		            "<td><input type='hidden' name='PASS' placeholder='"+index+"' /></td>" +
		            "<td><input type='radio' value='4' name='PASS'/>อนุมัติ</td>"+
		            "<td><input type='radio' value='3' name='PASS'/>ไม่อนุมัติ</td>"+
		            "<tr><td></td>" +
		            "<td width='200' COLSPAN=2><button id='btnSubmit' class='btn btn-info btn-sm'>ยืนยัน</button></td></tr><tr/></table>";
		          	// $("<tr/></table>").html(html).appendTo("#records");

        });

        $('#showdata').append(html);
        $('input[name="PASS"]').on('change', function() {
		    $(this).parents("tr").find('input[type="hidden"]').val($(this).val());
		});
		$('#btnSubmit').on('click', function(e) {
			if($('input[type="hidden"]').val()){

				$("#dialog").dialog({
		          	buttons : {
			            "OK" : function() {
			            	// alert($('input[type="hidden"]').val());
			            	var status = $('input[type="hidden"]').val();
				            gojax('post', '/api/v1/request/approved', {id:IDR,app:idapp,status:status})
				            .done(function(data) {
				              if (data.status == 200)
					            {
                          if(status==4)
                          {
                              $('#alert_text').text('อนุมัติเรียบร้อยแล้ว');
                              swal("อนุมัติ", "You clicked the button!", "success");                
                          
                          }else
                          {
                              $('#alert_text').text('ยกเลิกรายการอนุมัติซ่อมรถเรียบร้อยแล้ว'); 
                              swal("ไม่อนุมัติ", "You clicked the button!", "error");   
                          }
					              
                          $('#div_show').hide();
                          $('#myModalApprove').show();
                          $('#dialog').dialog("close");
					            } else {
					                // gotify(data.message,"danger");

					            }
				            });
          						return false;

				        },
				        "Cancel" : function() {
				                $(this).dialog("close");
				        }
			        }
			    });

			} else{
				alert('Please  select status');
			}
  		});
    });
});


function showapprove(statusid)
{
    
    if(statusid==4){
        $('#div_show').hide();
        $('#alert_text').text('รายการนี้ได้ดำเนินการอนุมัติไปแล้ว');
        $('#myModalApprove').show();
    }
    else if(statusid==3){
        $('#div_show').hide();
        $('#alert_text').text('รายการนี้ได้ดำเนินการยกเลิกไปแล้ว');
        $('#myModalApprove').show();
    }
    else{
      $('#div_show').show();
      $('#myModalApprove').hide();
    }
}
</script>
