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



<?php
  if (!isset($_GET["repairId"])) {
    echo "no params";
    exit();
  }

	$id = $_GET["repairId"];
	$idapp = $_GET["idapp"];

    use Wattanar\Sqlsrv;
    use App\Controllers\ConnectionController;

 	if(ConnectionController::connect() !== false)
    {
        $sql = "SELECT *
                FROM REPAIR R
                WHERE R.REPAIRID='$id'";

	  	$sql_rep = Sqlsrv::array(ConnectionController::connect(),$sql);

	  foreach($sql_rep as $rep){
    
	  if($rep->STATUSREPAIR >=3 && $rep->APPROVALREQUEST == 1){ 
  
		?>
			<div class="alert alert-dismissible alert-warning">
			  <button type="button" class="close" data-dismiss="alert">&times;</button>
			   <!-- <h4>Warning!</h4> note_edit_20180622 -->
        <h4>อนุมัติเรียบร้อย</h4>
			  <p>รายการนี้ได้ดำเนินการอนุมัติไปแล้ว</p>
			</div>
	<?php
    
		}else{
?>

<h2>Car Repair Approval</h2>

<div id="dialog" title="approved"><label for="approved">ยืนยันการอนุมัติ</label></div>
<table id="records" cellspacing="0"  border="1">
<script type="text/javascript">
  $('#dialog').hide();
jQuery(document).ready(function($) {

	// var IDR = "C04-201708-0014";
	var IDR = '<?php echo urlencode($_GET["repairId"]); ?>';
	var idapp = '<?php echo urlencode($_GET["idapp"]); ?>';

	gojax('get', '/api/v1/request/repair', {id:IDR})
    	.done(function(data) {
        $.each(data, function(index, val) {
            var html =
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
		            "<td width='200' COLSPAN=2><button id='btnSubmit' class='btn btn-info btn-sm'>ยืนยัน</button></td></tr>";
		          	$("<tr/></table>").html(html).appendTo("#records");

        });
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
					              	gotify(data.message,"Approved Successful");
					              	$('#dialog').dialog("close");
									         location.reload();

					            } else {
					                gotify(data.message,"danger");
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
</script>
<?php		}
		}
    }
?>
