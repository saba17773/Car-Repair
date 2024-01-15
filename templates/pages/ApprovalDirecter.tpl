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
    $sql_t = "select P.STATUSREPAIR
                  ,P.REPAIRID
                  ,MC.REGCAR
                  ,B.BRAND
                  ,P.MILESNO
                  ,S.SECTIONDES
              from REPAIR P
              LEFT JOIN MASTER_CAR MC
              ON MC.CARID = P.CARID
              LEFT JOIN MASTER_BRAND B
              ON B.ID = MC.BRAND
              LEFT JOIN MASTER_SECTION S
              ON S.ID = P.SECTION
              WHERE P.REPAIRID = '$id'";
    $sql = "SELECT ROW_NUMBER() OVER (Order by RD.REPAIRID) AS RowNumber,R.*,RD.*,C.*
            FROM REPAIR R
            JOIN REPAIRDETAIL RD 
            ON RD.REPAIRID = R.REPAIRID
            LEFT JOIN MASTER_CAR C
            ON C.CARID = R.CARID
            WHERE R.REPAIRID = '$id'";
  
    $sql_rep_t = Sqlsrv::array(ConnectionController::connect(),$sql_t);
    $sql_rep = Sqlsrv::array(ConnectionController::connect(),$sql);

    foreach($sql_rep_t as $rep_t){

    if($rep_t->STATUSREPAIR >= 8 && $rep_t->APPROVALDIRECTOR == 1){

		?>
			<div class="alert alert-dismissible alert-warning">
			  <button type="button" class="close" data-dismiss="alert">&times;</button>
			  <h4>Warning!</h4>
			  <p>รายการนี้ได้ดำเนินการอนุมัติไปแล้ว</p>
			</div>
	<?php
		}else{
?>
    <h2>Repair Approval HR</h2>
      <form method="post" action="/api/v1/report/all" target="_blank" >
        <input type="hidden" name="inp_carid_report" value='<?php echo urlencode($_GET["repairId"]); ?>' />
        <input type="hidden" name="type" id="type" value=2>
        <button class="btn btn-info btn-sm" type="submit" id="printItem" onclick="return Item()">ประวัติการซ่อม</button>
      </form>


        เลขที่การแจ้งซ่อม : <?php echo $rep_t->REPAIRID; ?> <br>
        ทะเบียนรถยนต์ : <?php echo $rep_t->REGCAR; ?> <br>
        รุ่นรถยนต์ : <?php echo $rep_t->BRAND; ?> <br>
        เลขไมล์ : <?php echo $rep_t->MILESNO; ?> <br>
        ฝ่าย : <?php echo $rep_t->SECTIONDES; ?> <br>
        <form id="form_approved">
          <table width="1000" border="1">
            <tr>
              <td align="Center">อันดับ</td>
              <td align="Center">รายการซ่อม</td>
              <td align="Center">สาเหตุการซ่อม</td> 
              <td align="Center">หมายเหตุ</td> 
              <td align="Center">ราคา</td> 
              <td align="Center" colspan="3">สถานะ</td> 
            </tr>
<?php        
        $i = 0;
        $TotalPrice = 0;
        foreach($sql_rep as $rep){
          $i++;
          $TotalPrice = $TotalPrice + $rep->PRICE;
          $arr[] =$i."YES";
?>          
            <tr>
              <td><?php echo $rep->RowNumber; ?></td>
              <td><?php echo $rep->ITEM; ?></td> 
              <td><?php echo $rep->REASON; ?></td> 
              <td><?php echo $rep->NOTE; ?></td> 
              <td align="Right"><?php echo number_format($rep->PRICE, 2, '.', ','); ?>&nbsp;</td> 
              <td><input type="radio" value='8' name='<?php echo $i."_status"; ?>' id='<?php echo $i."YES"; ?>'>อนมุัติ</td>
              <td><input type="radio" value='6' name='<?php echo $i."_status"; ?>' id='<?php echo $i."NO"; ?>'>ไม่อนมุัติ</td>
            </tr>
            <?php 
            if($rep->STATUS == 8)
            {
            ?>
            <script type="text/javascript">
              $("#<?php echo $i."YES"; ?>").attr('checked',true);
            </script>
            <?php
            }else if($rep->STATUS == 6){
            ?>
            <script type="text/javascript">
              $("#<?php echo $i."NO"; ?>").attr('checked',true);
            </script>
            <?php
            }
            ?>
              <input type="hidden" value='<?php echo $rep->REPAIRID; ?>' name='RepairID'>
              <input type="hidden" value='<?php echo $rep->LINENUM; ?>' name='<?php echo $i."_idline"; ?>'>
<!--  -->
<?php   }
?>
              <tr>
              <td colspan="4">ราคาสุทธิ</td> 
              <td align="Right"><?php echo number_format($TotalPrice, 2, '.', ','); ?>&nbsp;</td>
              <td><input type="radio" name='ALL' id='YESALL'>อนมุัติทั้งหมด</td></td> 
              <td><input type="radio" name='ALL' id='NOALL'>ไม่อนมุัติทั้งหมด</td></td> 
              </tr>
              </table>

              <input type="hidden" value='<?php echo $idapp; ?>' name='idapp'>
          </form>
<br>
<button class="btn btn-primary btn-sm" id="Save">ยืนยัน </button>
<div id="dialog" title="approved"><label for="approved">ยืนยันการอนุมัติ</label></div>


<?php  }   
    }
  }  
?>


<script type="text/javascript">
  $('#dialog').hide(); 

  $('#YESALL').on('click', function (event){  
    var  i = "<?php echo $i; ?>";
    for(var x=1;x<=i;x++)
    {
      radiobtn = document.getElementById(x+"YES");
      radiobtn.checked = true;
    }

  });
  $('#NOALL').on('click', function (event){  
    var  i = "<?php echo $i; ?>";
    for(var x=1;x<=i;x++)
    {
      radiobtn = document.getElementById(x+"NO");
      radiobtn.checked = true;
    }

  });

  $('#Save').on('click', function(e) {  

        $("#dialog").dialog({
          buttons : {
            "OK" : function() {
// ///////////////////////////////////////////////////////////////
                $.ajax({
                  url : '/api/v1/directer/approved',
                  type : 'post',
                  cache : false,
                  dataType : 'json',
                  data : $('form#form_approved').serialize()
                })
                  .done(function(data) {
                    if (data.status == 200) 
                    {
                      gotify(data.message,"Approved successful.");
                      $('#dialog').dialog("close"); 
                      location.reload();
                    } else {
                      gotify(data.message,"danger");
                    }
                  });
                return false;

// ///////////////////////////////////////////////////////////////
            },
            "Cancel" : function() {
              $(this).dialog("close");
            }
          }
        });

  });

  function Item() {     
    $('#type').val(2);
  } 

</script>
