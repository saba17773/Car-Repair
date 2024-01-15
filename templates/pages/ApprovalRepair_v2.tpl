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
  <h2>Repair Approval HR</h2>
  <form method="post" action="/api/v1/report/all" target="_blank" >
        <input type="hidden" name="inp_carid_report" value='<?php echo urlencode($_GET["repairId"]); ?>' />
        <input type="hidden" name="type" id="type" value=2>
        <button class="btn btn-info btn-sm" type="submit" id="printItem" onclick="return Item()">ประวัติการซ่อม</button>
  </form>
  <form id= 'form_approved' >
    <span id='showdata'> </span> 
     <input type="hidden" name="inp_year">
     <input type="hidden" name="inp_company">
  </form>
</div>  

<div id="dialog" title="approved"><label for="approved">ยืนยันการอนุมัติ</label></div>

<?php 
  use Wattanar\Sqlsrv;
  use App\Controllers\ConnectionController; 

  if (!isset($_GET["repairId"])) {
    echo "no params";
    exit();
  }

  $id = $_GET["repairId"];
  $idapp = $_GET["idapp"];

   

  if(ConnectionController::connect() !== false)
  {
    $sql_t = "select *
              from REPAIR P
              WHERE P.REPAIRID = '$id'";
    $sql_rep_t = Sqlsrv::array(ConnectionController::connect(),$sql_t);
    foreach($sql_rep_t as $rep_t){
        $statusid = $rep_t->STATUSREPAIR;
        $repairid = $rep_t->REPAIRID;
    }

  }

?>

<script type="text/javascript">
  var i = 0;

  jQuery(document).ready(function($) {

      var statusid = "<?php echo $statusid ?>";
      showapprove(statusid);


      var IDR = '<?php echo urlencode($_GET["repairId"]); ?>';

      

      var totalprice1 = 0;
      var html = '<input type="hidden" value="<?php echo $repairid;?>" name="RepairID">';

      gojax('get', '/api/v1/all/repair', {id:IDR})
        .done(function(data) {
          $.each(data, function(index, val) {

              i++;
              totalprice1 = Number(totalprice1) + Number(val.PRICE);
              totalprice = totalprice1.toFixed(2);
              var check8 = '';
              var check6 = '';
              if(val.STATUS == 8){
                  check8 = 'checked';
                  check6 = '';
              }
              else if (val.STATUS ==6){
                  check8 = '';
                  check6 = 'checked';
              }
              else{
                  check8 = '';
                  check6 = '';
              }

              html += '<input type="hidden" value=' + val.LINENUM + ' name=' + i + "_idline" + '>';

              if(i==1)
              {
                  html += "<b>เลขที่การแจ้งซ่อม : </b>" + val.REPAIRID + '<br>'; 
                  html += "<b>ทะเบียนรถยนต์  : </b>" + val.REGCAR + '<br>'; 
                  html += "<b>รุ่นรถยนต์  : </b>" + val.BRAND + '<br>'; 
                  html += "<b>เลขไมล์  : </b>" + val.MILESNO + '<br>'; 
                  html += "<b>ฝ่าย  : </b>" + val.SECTIONDES + '<br>'; 
                  html += '<table  width= "1000" cellspacing="0"  border="1">';
                  html += '<tr><td>อันดับ</td>';
                  html += '<td>สาเหตุการซ่อม</td>';
                  html += '<td>รายการซ่อม</td>';
                  html += '<td>หมายเหตุ </td>';
                  html += '<td>ราคา</td>';
                  html += '<td colspan="3">สถานะ</td>';
                  html += '</tr>'
                  html += '<tr><td>' + val.RowNumber + '</td>';
                  html += '<td>' + val.CAUSE + '</td>';
                  html += '<td>' + val.DETAIL + '</td>';
                  html += '<td>' + val.NOTE + '</td>';
                  html += '<td>' + val.PRICE + '</td>';
                  html += '<td><input type="radio" value="8"  name="' + i + "_status\"" + ' id="'  + i + "YES\"" + check8 +' checked> อนุมัติ</td>'
                  html += '<td><input type="radio" value="6"  name="' + i + "_status\"" + ' id="'  + i + "NO\"" + check6 +'> ไม่อนุมัติ</td>'
                  html += '</tr>';
                  
              } 
              else
              { 
                  html += '<tr><td>' + val.RowNumber + '</td>';
                  html += '<td>' + val.CAUSE + '</td>';
                  html += '<td>' + val.DETAIL + '</td>';
                  html += '<td>' + val.NOTE + '</td>';
                  html += '<td>' + val.PRICE + '</td>';
                  html += '<td><input type="radio" value="8"  name="' + i + "_status\"" + ' id="'  + i + "YES\"" + check8 +' checked> อนุมัติ</td>'
                  html += '<td><input type="radio" value="6"  name="' + i + "_status\"" + ' id="'  + i + "NO\"" + check6 +'> ไม่อนุมัติ</td>'
                  html += '</tr>';
              }
              
          });
          html += '<tr><td colspan="4" align="Right"><b>ราคาสุทธิ</b></td>';
          html += '<td align="Right"><b>' + totalprice + '</b></td></tr>'
          html += "</table>"
          html += '<input type="hidden" value="<?php echo $idapp; ?>" name="idapp">';
          html += '<br><button class="btn btn-primary btn-sm" id="Save">ยืนยัน </button>';
          // console.log(html);
          $('#showdata').html(html);
          $('#dialog').hide();
      });

  });


    $('#form_approved').submit(function(event) {
       event.preventDefault();

       if(checkInput()==false)
       {
          alert('Input data!!');
       }
       else
       {  
            $('#dialog').show();
            $("#dialog").dialog({
              buttons : {
                "OK" : function() {
                    $.ajax({
                      url : '/api/v1/getrepair/approved',
                      type : 'post',
                      cache : false,
                      dataType : 'json',
                      data : $('form#form_approved').serialize()
                    })
                      .done(function(data) {
                        if (data.status == 200) 
                        {
                          if(data.statusid ==8){
                            showapprove(data.statusid);
                            $('#alert_text').text('อนุมัติเรียบร้อยแล้ว');
                            swal("อนุมัติ", "You clicked the button!", "success");
                          }else if(data.statusid ==6){
                            showapprove(data.statusid);
                            $('#alert_text').text('ยกเลิกรายการอนุมัติซ่อมรถเรียบร้อยแล้ว');
                            swal("ไม่อนุมัติ", "You clicked the button!", "error");
                          }
                          gotify(data.message,"Approved successful.");
                          $('#dialog').dialog("close"); 
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
       }  
       

  });

  

  function checkInput()
  {
      var check = 1;
      if(i >0){
          for (var  j = 1; j <= i; j++) {
             var idyes =  j + "YES";
             var idno  =  j + "NO"; 
             if(document.getElementById(idyes).checked == false && document.getElementById(idno).checked == false){
                check = 0;
             }
          }
      }
      return check;

  }


  function showapprove(statusid)
  {
      if(statusid==8){
          $('#div_show').hide();
          $('#alert_text').text('รายการนี้ได้ดำเนินการอนุมัติไปแล้ว');
          $('#myModalApprove').show();
      }
      else if(statusid==6){
          $('#div_show').hide();
          $('#alert_text').text('รายการนี้ได้ดำเนินการยกเลิกไปแล้ว');
          $('#myModalApprove').show();
      }
      else{
        $('#div_show').show();
        $('#myModalApprove').hide();
      }
  }

  // function Item() {     
  //   $('#type').val(2);
  // }

  jQuery(document).ready(function($) {

    $reid = '<?php echo urlencode($_GET["repairId"]); ?>';
    selectrepair($reid)
      .done(function(data) {
        $.each(data, function(index, val) {
          CREATEDATE = new Date(val.CREATEDATE);
          
          $('input[name=inp_year]').val(CREATEDATE.getFullYear());
          $('input[name=inp_company]').val(val.INTERNALCODE);
        });
    }); 
   }); 

  function selectrepair($reid) 
  {
    return gojax('post', '/api/v1/selectrepair/load', {reid:$reid})
  }


</script>


