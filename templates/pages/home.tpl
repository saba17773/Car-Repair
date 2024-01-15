<?php $this->layout("layouts/main") ?>
<style type="text/css">
  input[type=checkbox] {
      width: 20px;
      height: 20px;
  }
  textarea {
      resize: none;
  }
 .ui-dialog { z-index: 9999 !important ;}
 .ui-datepicker { z-index: 9999 !important ;}
</style>
<!-- connect -->
  <?php
    use Wattanar\Sqlsrv;
    use App\Controllers\ConnectionController;
  ?>

<!-- Popup Alert  -->
  <div class="modal" id="modal_popUp" tabindex="-1" role="dialog">
    <div class="modal-dialog" role="document">
      <div class="modal-content">
        <div class="modal-header">
          <button type="button" class="close" data-dismiss="modal" aria-label="Close">
            <span aria-hidden="true" class="glyphicon glyphicon-remove-circle"></span>
          </button>
          <h4 class="modal-title">
            <label for="ActCompanyID" id="ActCompanyID">แจ้งเตือนประจำเดือน</label>&nbsp;&nbsp;
                  <script type="text/javascript">
                    var date = new Date();
                        switch(date.getMonth()) {
                            case 0:
                                document.write('มกราคม');
                                break;
                            case 1:
                                document.write('กุมภาพันธ์');
                                break;
                            case 2:
                                document.write('มีนาคม');
                                break;
                            case 3:
                                document.write('เมษายน');
                                break;
                            case 4:
                                document.write('พฤษภาคม');
                                break;
                            case 5:
                                document.write('มิถุนายน');
                                break;
                            case 6:
                                document.write('กรกฎาคม');
                                break;
                            case 7:
                                document.write('สิงหาคม');
                                break;
                            case 8:
                                document.write('กันยายน');
                                break;
                            case 9:
                                document.write('ตุลาคม');
                                break;
                            case 10:
                                document.write('พฤศจิกายน');
                                break;
                            default:
                                document.write('ธันวาคม');
                        }
                  </script>
                  &nbsp; - &nbsp;
                  <script type="text/javascript">
                      var nextmonth = new Date();
                        switch(nextmonth.getMonth()+1) {
                            case 0:
                                document.write('มกราคม');
                                break;
                            case 1:
                                document.write('กุมภาพันธ์');
                                break;
                            case 2:
                                document.write('มีนาคม');
                                break;
                            case 3:
                                document.write('เมษายน');
                                break;
                            case 4:
                                document.write('พฤษภาคม');
                                break;
                            case 5:
                                document.write('มิถุนายน');
                                break;
                            case 6:
                                document.write('กรกฎาคม');
                                break;
                            case 7:
                                document.write('สิงหาคม');
                                break;
                            case 8:
                                document.write('กันยายน');
                                break;
                            case 9:
                                document.write('ตุลาคม');
                                break;
                            case 10:
                                document.write('พฤศจิกายน');
                                break;
                            case 11:
                                document.write('ธันวาคม');
                                break;
                            default:
                                document.write('มกราคม');
                        }

                  </script>
                </label>
          </h4>
        </div>
        <div class="modal-body">
          <form id="form_create">
            <div class="form-group">
              <label for="Insurance" id="Insurance" >&nbsp;&nbsp;&nbsp;&nbsp;ประกันภัย</label>

                <?php
                    if(ConnectionController::connect() !== false)
                    {
                      $user_id = $_SESSION["userid"];
                      $sql = "SELECT C.REGCAR
                                  ,INS.CLOSINGDATE[Insurance]
                              FROM MASTER_CAR C
                              LEFT JOIN(
                                    SELECT CD.CARID,IC.INSURANCEDES,CD.CLOSINGDATE,CD.DETAILTYPE
                                    FROM CARDETAIL CD
                                    LEFT JOIN MASTER_INSURANCE IC ON IC.ID = CD.INSURANCE
                                    WHERE CD.DetailType = 'INS'
                                    AND CD.STATUS = 1
                                    )INS ON INS.CarID = C.CarID
                              WHERE INS.CLOSINGDATE <= DATEADD(d,-1, DATEADD(mm, DATEDIFF(mm,'',GETDATE())+2,''))
                              AND C.COMPANY IN (
                                                SELECT F.COMPANY
                                                FROM FACTORY F
                                                WHERE F.USERID = '$user_id'
                                                )";
                ?>
                  <table width="400" border="1" cellspacing="2" cellpadding="0" align="center">
                        <tr>
                          <td width="30" bgcolor="F0F08E" align="center">ทะเบียน</td>
                          <td width="30" bgcolor="F0F08E" align="center">วันที่หมด</td>
                        </tr>
                    <?php
                      $sql_car = Sqlsrv::array(ConnectionController::connect(),$sql);
                      foreach($sql_car as $car){
                    ?>
                        <tr>
                         <td width="50">&nbsp;&nbsp; <?php echo "$car->REGCAR" ?> </td>
                         <td width="50">&nbsp;&nbsp; <?php echo "$car->Insurance" ?> </td>
                        </tr>
                    <?php
                      }
                    ?>
                  </table>
                <?php
                    }
                ?>

            </div>
            <div class="form-group">
              <label for="DateAct">&nbsp;&nbsp;&nbsp;&nbsp;พรบ.</label>

                <?php
                    if(ConnectionController::connect() !== false)
                    {
                      $user_id = $_SESSION["userid"];
                      $sql = "SELECT C.REGCAR
                                   ,ACT.CLOSINGDATE[Act]
                              FROM MASTER_CAR C
                               LEFT JOIN(
                                    SELECT CDA.CarID,CDA.CLOSINGDATE,CDA.DETAILTYPE
                                    FROM CARDETAIL CDA
                                    WHERE CDA.DETAILTYPE = 'ACT'
                                    AND CDA.STATUS = 1
                                    )ACT ON ACT.CarID = C.CarID
                              WHERE ACT.CLOSINGDATE <= DATEADD(d,-1, DATEADD(mm, DATEDIFF(mm,'',GETDATE())+2,''))
                              AND C.COMPANY IN (
                                                SELECT F.COMPANY
                                                FROM FACTORY F
                                                WHERE F.USERID = '$user_id'
                                                )";
                ?>
                  <table width="400" border="1" cellspacing="2" cellpadding="0" align="center">
                      <tr>
                          <td width="30" bgcolor="F0F08E" align="center">ทะเบียน</td>
                          <td width="30" bgcolor="F0F08E" align="center">วันที่หมด</td>
                      </tr>
                    <?php
                      $sql_car = Sqlsrv::array(ConnectionController::connect(),$sql);
                      foreach($sql_car as $car){
                    ?>
                      <tr>
                       <td width="50">&nbsp;&nbsp; <?php echo "$car->REGCAR" ?> </td>
                       <td width="50">&nbsp;&nbsp; <?php echo "$car->Act" ?> </td>
                      </tr>

                    <?php
                      }
                    ?>
                  </table>
                <?php
                    }
                ?>

            </div>
            <div class="form-group">
              <label for="DateRepair">&nbsp;&nbsp;&nbsp;&nbsp;ภาษี</label>

                <?php
                    if(ConnectionController::connect() !== false)
                    {
                      $user_id = $_SESSION["userid"];
                      $sql = "SELECT C.*
                                  ,TAX.CLOSINGDATE[Tax]
                              FROM MASTER_CAR C
                              LEFT JOIN(
                                    SELECT CDT.CarID,CDT.CLOSINGDATE,CDT.DetailType
                                    FROM CARDETAIL CDT
                                    WHERE CDT.DetailType = 'TAX'
                                    AND CDT.STATUS = 1
                                    )TAX ON TAX.CarID = C.CarID
                              WHERE TAX.CLOSINGDATE <= DATEADD(d,-1, DATEADD(mm, DATEDIFF(mm,'',GETDATE())+2,''))
                              AND C.COMPANY IN (
                                                SELECT F.COMPANY
                                                FROM FACTORY F
                                                WHERE F.USERID = '$user_id'
                                                )";
                ?>
                  <table width="400" border="1" cellspacing="2" cellpadding="0" align="center">
                      <tr>
                          <td width="30" bgcolor="F0F08E" align="center">ทะเบียน</td>
                          <td width="30" bgcolor="F0F08E" align="center">วันที่หมด</td>
                      </tr>
                    <?php
                      $sql_car = Sqlsrv::array(ConnectionController::connect(),$sql);
                      foreach($sql_car as $car){
                    ?>
                      <tr>
                       <td width="50">&nbsp;&nbsp; <?php echo "$car->REGCAR" ?> </td>
                       <td width="50">&nbsp;&nbsp; <?php echo "$car->Tax" ?> </td>
                      </tr>

                    <?php
                      }
                    ?>
                  </table>
                <?php
                    }
                ?>

            </div>
                <div class="modal-footer">
                  <input class="btn btn-info btn-sm" name="text" type="button" value="Report" onclick="window.open('/Alert_report')"/>

                </div>
          </form>
        </div>
      </div>
    </div>
  </div>
<!-- Menu -->
 <table>
  <td>
    <button id="btn_create" onclick="return modal_create_open()"  class="btn btn-default btn-sm" data-backdrop="static" data-toggle="modal" data-target="#modal_create">สร้างรายการ</button>
  </td><td>
    <button id="btn_edit" class="btn btn-primary btn-sm">แก้ไขรายการ</button>
  </td><td>
    <button id="btn_delete" class="btn btn-danger btn-sm">ลบรายการ</button>
  </td><td>
    <button id="btn_repiared_date" class="btn btn-default btn-sm">เพิ่ม/ลบวันที่ซ่อมเสร็จ</button>
  </td><td>
    <button id="btn_sent" class="btn btn-info btn-sm">ส่งเมลล์อนุมัติใบแจ้งซ่อม</button>
  </td><td>
    <!-- <button id="btn_edit_new" class="btn btn-primary btn-sm">แก้ไขรายการใหม่</button> -->
  </td><td>
    <button id="btn_sentHR" class="btn btn-warning btn-sm">ส่งเมลล์อนุมัติรายการซ่อม</button>
  </td><td>
    <button id="btn_cancel" class="btn btn-danger btn-sm">cancel</button>
  </td><td>
    <form onsubmit="return printsub()" method="post" action="/api/v1/report/all" target="_blank" >
      <input type="hidden" name="inp_Repair_report" value="" />
      <input type="hidden" name="type" id="type">&nbsp;
      <!-- <button class="btn btn-info btn-sm" type="submit" id="btn_report">ใบอนุมัติซ่อม</button> tan_edit_180625 -->
    </form>
  </td>
  <td>
    <form onsubmit="return printsub()" method="post" action="/api/v1/report/account" target="_blank">
      <input type="hidden" name="inp_acc_report" value="" />
      <input type="hidden" name="typeac" id="typeac">
      <button class="btn btn-success btn-sm" type="submit" id="btn_report_acc">ใบอนุมัติเบิกบัญชี</button>
    </form>
  </td>
 </table>
<!-- Grid-->

  <div id="gridrepair"></div><br>
  <div id="griditem"></div><br>
<!-- popup sent Email -->
  <div class="modal" id="modal_sent_email" tabindex="-1" role="dialog">
    <div class="modal-dialog" role="document">
      <div class="modal-content">
        <div class="modal-header">
          <button type="button" class="close" data-dismiss="modal" aria-label="Close">
            <span aria-hidden="true" class="glyphicon glyphicon-remove-circle"></span>
          </button>
          <h4 class="modal-title">ส่งอีเมลล์</h4>
        </div>
        <div class="modal-body">
           <form id="form_sent" method="post" action="/api/v1/email/sent"  enctype="multipart/form-data">
          <!-- <form id="form_sent" onsubmit="return submit_sent_email()"> -->

            <div class="form-group">
              <label for="lab_RepairID_sent" id="lab_RepairID">รหัสแจ้งซ่อม</label>
              <input type="name" name="inp_RepairID_sent" id="inp_RepairID_sent" class="form-control" autocomplete="off" required>
            </div>
             <div class="form-group">
              <label for="lab_Repair_mail" id="lab_Repair_mail">Email</label>
              <!-- <input type="name" name="inp_Repairmail_sent" id="inp_Repairmail_sent" class="form-control" autocomplete="off" required> -->
              <div id="managerid" type="checked" name="managerid"></div>
            </div>
              <input type="hidden" name="form_email">
            <button class="btn btn-primary" id="sent"><i class="glyphicon glyphicon-send"></i>&nbsp;Sent</button>
          </form>
        </div>
      </div>
    </div>
  </div>
<!-- popup create Request -->
  <div class="modal" id="modal_create" tabindex="-1" role="dialog">
    <div class="modal-dialog" role="document">
      <div class="modal-content">
        <div class="modal-header">
          <button type="button" class="close" data-dismiss="modal" aria-label="Close">
            <span aria-hidden="true" class="glyphicon glyphicon-remove-circle"></span>
          </button>
          <h4 class="modal-title">this title</h4>
        </div>
        <div class="modal-body">
          <form id="form_create" onsubmit="return submit_create_repair()">

            <div class="form-group">
              <label for="lab_Repair_ID" id="lab_Repair_ID">รหัสแจ้งซ่อม</label>
              <input type="name" name="inp_RepairID" id="inp_RepairID" class="form-control" autocomplete="off">
            </div>
            <label for="lab_com">บริษัท</label>
              <select name="sel_com" id="sel_com" class="form-control" required></select>
            <label for="leb_Department">แผนก</label>
              <select name="sel_Department" id="sel_Department" class="form-control" required></select>
            <label for="leb_Section">ฝ่าย</label>
              <select name="sel_Section" id="sel_Section" class="form-control" required></select>
            <label for="leb_Driver">ผู้ขับ</label>
              <!-- <select name="sel_Driver" id="sel_Driver" class="form-control" required></select> -->
              <div name="dropdowndriver" id="dropdowndriver" required>
                <div id="griddriver"></div>
              </div>
            <label for="leb_car">ทะเบียนรถ</label>
              <!-- <select name="sel_car" id="sel_car" class="form-control" required></select> -->
             <!-- <div class="form-group"> -->
              <div name="dropdowncar" id="dropdowncar" required>
                <div id="gridcar"></div>
              </div>
              <label for="lab_brand" id="lab_brand">รุ่น</label>
              <input type="name" name="inp_brand" id="inp_brand" class="form-control" autocomplete="off" required>
            <!-- </div> -->
             <div class="form-group">
              <label for="lab_rType" id="lab_rType">ประเภท</label>
              <input type="name" name="inp_rType" id="inp_rType" class="form-control" autocomplete="off" required>
            </div>
            <div class="form-group">
              <label for="lab_milesNo">เลขไมล์</label>
              <input type="number" name="inp_milesNo" id="inp_milesNo" min="0" class="form-control" autocomplete="off" onkeyup="intOnly(this)" required>
            </div>
            <div class="form-group">
              <label for="lab_remark">สาเหตุ</label>
              <input type="name" name="inp_remark" id="inp_remark" class="form-control" autocomplete="off" required>
            </div>

            <input type="hidden" name="inp_createBy">
            <input type="hidden" name="inp_updateBy">
            <input type="hidden" name="form_type">
            <input type="hidden" name="id">
            <input type="hidden" name="dd_car_id">
            <input type="hidden" name="dd_driver_id">

            <button class="btn btn-primary" id="Save"><i class="glyphicon glyphicon-floppy-save"></i>&nbsp;Save</button>
          </form>
        </div>
      </div>
    </div>
  </div>
  <div id="dialog" title="ลบรายการ"><label for="Delete">ต้องการลบข้อมูลหรือไม่?</label></div>
  <div id="dialogedit" title="แก้ไขรายการซ่อมใหม่"><label for="Delete">ต้องแก้ไขรายการซ่อมใหม่หรือไม่?</label></div>
<!-- create line -->
  <form id="form_createline">
    <table width="100%" border="0" align="center">
      <tr>
      
        <td align="right" width="10%">
          <div class="form-group">
            <label>เลขที่แจ้งซ่อม :&nbsp;&nbsp;</label>
          </div>
        </td>
        <td width="20%">
          <div class="form-group">
            <input class="form-control input-sm" type="name" name="inp_repair_line" id="inp_repair_line">
          </div>
        </td>
        <td align="right" width="5%">
          <div class="form-group">
            <label>วันที่ซ่อม :&nbsp;&nbsp;</label>
          </div>
        </td>
        <td width="20%">
          <div class="input-group">
            <input type="text" class="form-control input-sm" name="inp_daterepair" id="inp_daterepair" placeholder="เลือกวันที่..." autocomplete="off" required readonly="true">
            <span class="input-group-btn">
              <button class="form-control input-sm" id="bt_daterepair" type="button">
                <span class="glyphicon glyphicon-calendar" aria-hidden="true"></span>
              </button>
            </span>
          </div>
        </td>
      </tr>
      <tr>
        <td align="right" width="10%">
          <div class="form-group">
            <label>สาเหตุการซ่อม :&nbsp;&nbsp;</label>
          </div>
        </td>
        <td width="20%">
          <div class="form-group">
           <select name="sel_cause" id="sel_cause" class="form-control input-sm" required></select>
          </div>           
        </td>
        <td align="right" >
          <div class="form-group">
            <label>อู่ซ่อม :&nbsp;&nbsp;</label>
          </div>
        </td>
        <td width="20%">
          <div class="form-group">
            <div name="dropdowncradle" id="dropdowncradle" required>
                <div id="gridcradle"></div>
            </div>           
            <!-- <select name="sel_cradle" id="sel_cradle" class="form-control input-sm" required></select> -->
          </div>
        </td>
      </tr>
    </table>
    <table width="100%" align="center">
      <tr>
        <td align="right" width="5%">
            <input name="causedetailplus" id="causedetailplus" type="button" class="btn btn-primary btn-sm" value="+"></button><br>
        </td>
        <td align="right" width="10%">
          <div class="form-group">
            <label>รายการซ่อม :&nbsp;&nbsp;</label>
          </div>
        </td>
        <td width="20%">
          <div class="form-group">
            <div class="input-group">
              <input type="text" class="form-control input-sm" name="inp_causedetail" id="inp_causedetail" placeholder="เลือกรายการซ่อม..." autocomplete="off" required readonly="true">
              <span class="input-group-btn">
                <button class="form-control input-sm" id="btn_causedetail" type="button">
                  <span class="glyphicon glyphicon-option-horizontal" aria-hidden="true"></span>
                </button>
              </span>
            </div>
          </div>
            <!-- <select name="sel_causedetail" id="sel_causedetail" class="form-control input-sm" required></select> -->
        </td>
        <td align="right" width="5%">
          <div class="form-group">
            <label>ราคา :&nbsp;&nbsp;</label>
          </div>
        </td>
        <td width="10%">
          <div class="form-group">           
            <input class="form-control input-sm" type="number" min="0" name="inp_price" id="inp_price" required>
          </div>
        </td>
        <td align="right" width="8%">
          <div class="form-group">
            <label>หมายเหตุ :&nbsp;&nbsp;</label>
          </div>
        </td>
        <td width="20%">
          <div class="form-group">
            <textarea class="form-control input-sm" rows="1" name="text_note" id="text_note"></textarea>
          </div>
        </td>
      </tr>
      <tr>
        <td>&nbsp;</td>
        <td colspan="6" align="left"> 
          <span id="mySpancausedetail"></span>
        </td>
      </tr>
    </table>
        <input type="hidden" name="inp_line_num">
        <input type="hidden" name="form_type_line">
        <input type="hidden" name="inp_createByline">
        <input type="hidden" name="inp_updateByline">
        <input type="hidden" name="dd_cradle_id">
        <input type="hidden" name="dd_detail_id">
        <br>
  </form>&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;
  <button id="btn_save" class="btn btn-primary btn-sm"><i class="glyphicon glyphicon-floppy-save"></i>&nbsp;save</button>
  <button id="btn_deleteline" class="btn btn-danger btn-sm"><i class="glyphicon glyphicon-floppy-remove"></i>&nbsp;Delete</button>
  <button id="btn_clearline" class="btn btn-success btn-sm"><i class="glyphicon glyphicon-remove"></i>&nbsp;Clear</button>

<div class="modal" id="modal_repaired_date" tabindex="-1" role="dialog">
  <div class="modal-dialog" role="document">
    <div class="modal-content">
      <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
          <span aria-hidden="true" class="glyphicon glyphicon-remove-circle"></span>
        </button>
        <h4>วันที่ซ่อมเสร็จ</h4>
      </div>
      <div class="modal-body">
        <table width="100%">
          <tr>
            <td>
              <form id="form_repaired_date" onsubmit="return submit_repaired_date()">
                <div class="input-group">
                  <input type="text" class="form-control input-sm" name="inp_repaired_date" id="inp_repaired_date" placeholder="เลือกวันที่..." autocomplete="off" required readonly="true">
                  <span class="input-group-btn">
                    <button class="form-control input-sm" id="bt_daterepair" type="button">
                      <span class="glyphicon glyphicon-calendar" aria-hidden="true"></span>
                    </button>
                  </span>
                </div><br>
            </td>
          </tr>
          <tr>
            <td>
                  <button class="btn btn-primary" id="Save"><i class="glyphicon glyphicon-floppy-save"></i>&nbsp;บันทึก</button>
                <input type="hidden" name="inp_repaireddate_id">
                <input type="hidden" name="inp_statusrenew">
              </form>
                <button class="btn btn-danger" id="btn_delete_repaired"><i class="glyphicon glyphicon-floppy-remove"></i>&nbsp;ลบวันที่ซ่อมเสร็จ</button>
            </td>
          </tr>
        </table>
      </div>
    </div>
  </div>
</div>
<div id = "modal_causedetail">
    <div class="modal-title"><h5>รายการซ่อม</h5></div>
    <div id="grid_causedetail"></div>
</div>

<script type="text/javascript">
  $( function() {
    $( "#inp_daterepair" ).datepicker_thai({
      dateFormat: 'dd-mm-yy',
      altField:"#h_dateinput",
      altFormat: "yy-mm-dd",
      langTh:true,
      yearTh:true,
      changeYear: true,
    });
  });

  $( function() {
    $( "#inp_repaired_date" ).datepicker_thai({
      dateFormat: 'dd-mm-yy',
      altField:"#h_dateinput",
      altFormat: "yy-mm-dd",
      langTh:true,
      yearTh:true,
      changeYear: true,
    });
  });

  $('#dialog').hide();
  $('#dialogedit').hide();
  $('#btn_cancel').hide();
  var session_userid = '<?php echo $_SESSION["userid"]; ?>';
  var session_depid = '<?php echo $_SESSION["depid"]; ?>';
  var session_posid = '<?php echo $_SESSION["posid"]; ?>';
  var session_secid = '<?php echo $_SESSION["secid"] ; ?>';
  var session_useredit = '<?php echo $_SESSION["userEdit"] ; ?>';

// user control
  // if (session_secid == 1 || session_secid == 3){  //reques
  //   $('#btn_report').hide();
  //   $('#griditem').hide();
  //   $('#form_createline').hide();
  //   $('#btn_save').hide();
  //   $('#btn_deleteline').hide();
  //   $('#btn_clearline').hide();
  //   $('#btn_sentHR').hide();
  //   // $('#btn_edit_new').hide();
  // }else if(session_secid == 2){
  //   $('#btn_report').show();
  //   $('#griditem').show();
  //   $('#form_createline').show();
  //   // $('#btn_create').hide();
  //   // $('#btn_edit').hide();
  //   // $('#btn_delete').hide();
  //   // $('#btn_sent').hide();
  // }else if(session_posid == 5 || session_posid == 3){
  //   $("#btn_report_acc").show();
  // }else{
  //   $('#btn_report').show();
  //   $('#griditem').show();
  //   $('#form_createline').show();
  //   $('#btn_create').show();
  //   $('#btn_edit').show();
  //   $('#btn_delete').show();
  //   $('#btn_sent').show();
  // }

  if(session_posid == 2){
    $('#btn_report').hide();
    $('#griditem').hide();
    $('#form_createline').hide();
    $('#btn_save').hide();
    $('#btn_deleteline').hide();
    $('#btn_clearline').hide();
    $('#btn_sentHR').hide();
    document.getElementById("btn_sentHR").disabled = true;
    $('#btn_edit_new').hide();
    // $('btn_report_acc').hide();
    document.getElementById("btn_report_acc").disabled = true;

  }
  if(session_posid == 6){
    $("#btn_repiared_date").show();
  }

  if(session_useredit == 0){
    document.getElementById("btn_create").disabled = true;
    // document.getElementById("btn_sent").disabled = true;
    document.getElementById("btn_sentHR").disabled = true;
    $("#btn_sent").hide();
    // $("#btn_sentHR").hide();
    document.getElementById("btn_edit").disabled = true;
    document.getElementById("btn_delete").disabled = true;
    document.getElementById("btn_save").disabled = true;
    document.getElementById("btn_deleteline").disabled = true;
    // document.getElementById("btn_edit_new").disabled = true;
    $("#btn_repiared_date").hide();
  }else{
    document.getElementById("btn_create").disabled = false;
    // document.getElementById("btn_sent").disabled = false;
    // document.getElementById("btn_sentHR").disabled = false;
    $("#btn_sent").show();
    $("#btn_sentHR").show();
    document.getElementById("btn_edit").disabled = false;
    document.getElementById("btn_delete").disabled = false;
    document.getElementById("btn_save").disabled = false;
    document.getElementById("btn_deleteline").disabled = false;
    // document.getElementById("btn_edit_new").disabled = false;
    $("#btn_repiared_date").show();
  }

jQuery(document).ready(function($) {

  gridrepair();
  modal_popUp_open();

  // grid_detail();
  grid_car();
  grid_driver();

  $('#btn_report_acc').hide();
  $('input[name=inp_repair_line]').prop('readonly', true);
  $('#bt_daterepair').click(function() {
    $('#inp_daterepair').datepicker('show');
  });
// note 10/10/2018
  // getCradle()
  //   .done(function(data) {
  //     $('select[name=sel_cradle]').html("<option value=''>-- Select --</option>");
  //     $.each(data, function(index, val) {
  //       $('select[name=sel_cradle]').append('<option value="'+val.ID+'">'+val.CRADLE+'</option>');
  //     });
  // });

  getCause()
    .done(function(data) {
      $('select[name=sel_cause]').html("<option value=''>-- Select --</option>");
      $.each(data, function(index, val) {
        $('select[name=sel_cause]').append('<option value="'+val.ID+'">'+val.CAUSE+'</option>');
      });
  });
// note 10/10/2018
  // $('#sel_cause').on('change', function (event){
  //   $causeid = $('#sel_cause').val();
  //   getCauseDetail($causeid)
  //     .done(function(data) {
  //       $('select[name=sel_causedetail]').html("<option value=''>-- Select --</option>");
  //       $.each(data, function(index, val) {
  //       $('select[name=sel_causedetail]').append('<option value="'+val.ID+'">'+val.DESCRIPTION+'</option>');
  //       $('#inp_price').val('');
  //       $('#text_note').val('');
  //       });
  //   });  
  // });

  $("#managerid").jqxListBox({width: 565, checkboxes: true, height: 100});
    getUserManager()
      .done(function(data) {
      $('#managerid').jqxListBox('refresh');
      $.each(data, function(index, val) {
        $("#managerid").jqxListBox('addItem',{
          label: val.NAME,
          value: val.ID,
        });
      });
  });


    // if(session_useredit != 1)
    // {
    //   document.getElementById("btn_create").disabled = true;
    //   // document.getElementById("btn_sent").disabled = true;
    //   $("#btn_sent").hide();
    //   document.getElementById("btn_edit").disabled = true;
    //   document.getElementById("btn_delete").disabled = true;
    //   // document.getElementById("btn_sentHR").disabled = true;
    //   $("#btn_sentHR").hide();
    //   document.getElementById("btn_save").disabled = true;
    //   document.getElementById("btn_deleteline").disabled = true;
    //   // document.getElementById("btn_edit_new").disabled = true;
    // }
    // else
    // {
    //   document.getElementById("btn_create").disabled = false;
    //   // document.getElementById("btn_sent").disabled = false;
    //   $("#btn_sent").show();
    //   document.getElementById("btn_edit").disabled = false;
    //   document.getElementById("btn_delete").disabled = false;
    //   document.getElementById("btn_sentHR").disabled = false;
    //   document.getElementById("btn_save").disabled = false;
    //   document.getElementById("btn_deleteline").disabled = false;
    //   // document.getElementById("btn_edit_new").disabled = false;

    // }

});
// event Table Begin
  // $('#sel_car').on('change', function (event){
  //   $car = $('#sel_car').val();
  //   getCARdetail($car)
  //     .done(function(data) {
  //       $.each(data, function(index, val) {
  //         $('input[name=inp_brand]').val(val.BRAND);
  //         $('input[name=inp_rType]').val(val.REGISTERTYPE);
  //         if(val.MILESCHECK == 1){
  //           document.getElementById("inp_milesNo").disabled = true;
  //         }else{
  //           document.getElementById("inp_milesNo").disabled = false;
  //         }
  //       });
  //   });
  // });

  // $('#gridcar').on('change', function (event){
  //   $car = $('#dd_car_id').val();
  //   getCARdetail($car)
  //     .done(function(data) {
  //       $.each(data, function(index, val) {
  //         $('input[name=inp_brand]').val(val.BRAND);
  //         $('input[name=inp_rType]').val(val.REGISTERTYPE);
  //         if(val.MILESCHECK == 1){
  //           document.getElementById("inp_milesNo").disabled = true;
  //         }else{
  //           document.getElementById("inp_milesNo").disabled = false;
  //         }
  //       });
  //   });
  // });

  $('#gridrepair').on('rowclick', function (event){
    // align('aaa');
    var args = event.args;
    var boundIndex = args.rowindex;
    var datarow = $("#gridrepair").jqxGrid('getrowdata', boundIndex);

    if (session_userid=='U-037') {
      $('#btn_cancel').show();
    }

    if (session_depid==10 && session_secid==2) {
      $('#btn_cancel').show();
    }

    if(session_useredit == 1)
    {
      if(datarow.STATUSREPAIR == 1)//sent re
      {

        if(datarow.DEPARTMENT == session_depid)
        {
          // document.getElementById("btn_sent").disabled = false;
          document.getElementById("btn_edit").disabled = false;
          document.getElementById("btn_delete").disabled = false;
        }
        else
        {
          // document.getElementById("btn_sent").disabled = true;
          document.getElementById("btn_edit").disabled = true;
          document.getElementById("btn_delete").disabled = true;
        }

      }else{
        // document.getElementById("btn_sent").disabled = true;
        document.getElementById("btn_edit").disabled = true;
        document.getElementById("btn_delete").disabled = true;
      }
    if(datarow.STATUSREPAIR == 1 || datarow.STATUSREPAIR == 2)//sent re
    {

        if(datarow.DEPARTMENT == session_depid)
        {
          // document.getElementById("btn_sent").disabled = false;
          $("#btn_sent").show();
        }
        else
        {
          // document.getElementById("btn_sent").disabled = true;
          $("#btn_sent").hide();
        }

    }else{
        // document.getElementById("btn_sent").disabled = true;
        $("#btn_sent").hide();
      }

      if(datarow.STATUSREPAIR == 4 || datarow.STATUSREPAIR == 5 || datarow.STATUSREPAIR == 7)//sent hr
      {
        // document.getElementById("btn_sentHR").disabled = false;
        $("#btn_sentHR").show();
      }else{
        // document.getElementById("btn_sentHR").disabled = true;
        $("#btn_sentHR").hide();
      }
      if(datarow.STATUSREPAIR == 4)
      {
        
        document.getElementById("btn_save").disabled = false;
        document.getElementById("btn_deleteline").disabled = false;
      }else{
        //alert(datarow.STATUSREPAIR);//test_btnsave
        document.getElementById("btn_save").disabled = false;
        document.getElementById("btn_deleteline").disabled = true;
      }
      
    }
    else
    {
      document.getElementById("btn_create").disabled = true;
      // document.getElementById("btn_sent").disabled = true;
      $("#btn_sent").hide();
      document.getElementById("btn_edit").disabled = true;
      document.getElementById("btn_delete").disabled = true;
      // document.getElementById("btn_sentHR").disabled = true;
      $("#btn_sentHR").hide();
      document.getElementById("btn_save").disabled = true;
      document.getElementById("btn_deleteline").disabled = true;
      // document.getElementById("btn_edit_new").disabled = true;
    }
    if(datarow.STATUSREPAIR == 8){
      
      $("#btn_report_acc").show();
      $("#btn_repiared_date").show();
      // document.getElementById("btn_edit_new").disabled = false;
    }
    else{
      $("#btn_report_acc").hide();
      $("#btn_repiared_date").hide();
      // document.getElementById("btn_edit_new").disabled = true;
    }

    griditem(datarow.REPAIRID);
    // $('#btn_edit_new').hide();
    $('input[name=inp_repair_line]').val(datarow.REPAIRID);
    $('#griditem').jqxGrid('clearselection');
    $('input[name=inp_line_num]').val('');
    // notev 10/10/2018
      // $('select[name=sel_cradle]').val('');
      $('#dropdowncradle').val('');
      $('input[name=dd_cradle_id]').val('');
      $('input[name=dd_detail_id]').val('');
      $('input[name=inp_daterepair]').val('');
      $('input[name=inp_price]').val('');
      $('select[name=sel_cause]').val('');
      // note 9/10/2018
      // $('select[name=sel_causedetail]').val('');
      $('input[name=inp_causedetail]').val('');
      // $('textarea[name=text_item]').val('');
      // $('textarea[name=text_reason]').val('');
      $('textarea[name=text_note]').val('');
  });

  $('#btn_cancel').on('click', function (e){
    var rowdata = row_selected("#gridrepair");
    // alert(rowdata.ID);
    $.ajax({
      url : '/api/v1/rep/cancel',
      type : 'post',
      cache : false,
      dataType : 'json',
      data : {
        id : rowdata.ID
      }
    })
    .done(function(data) {
      if (data.status != 200) {
        gotify(data.message,"danger");
      }else{
        gotify(data.message,"success");        
        $('#griditem').jqxGrid('updatebounddata');
      }
      // alert(data.status);
    });

  });

  $('#btn_sent').on('click', function(e) {
    var rowdata = row_selected("#gridrepair");
    if (typeof rowdata !== 'undefined'){
      $('#modal_sent_email').modal({backdrop: 'static'});
      $('.modal-title').text('Sent email');
      $('#modal_sent_email').trigger('reset');
      $('input[name=inp_RepairID_sent]').val(rowdata.REPAIRID);
      $('input[name=form_email]').val('mail_re');
    }else{
      alert('กรุณาเลือกข้อมูล');
    }
  });
  $('#btn_edit').on('click', function(e) {
    var rowdata = row_selected("#gridrepair");
    if (typeof rowdata !== 'undefined') {
      $('#modal_create').modal({backdrop: 'static'});
      $('input[name=form_type]').val('update');
      $('#modal_create').trigger('reset');
      $('input[name=inp_RepairID]').show();
      $('#lab_Repair_ID').show();
      $('input[name=id]').val(rowdata.ID);
      $('input[name=inp_RepairID]').val(rowdata.REPAIRID);
      $('input[name=inp_RepairID]').prop('readonly', true);
      $('input[name=inp_brand]').prop('readonly', true);
      $('input[name=inp_rType]').prop('readonly', true);
       // if(rowdata.MILESNO == 0){
       //      document.getElementById("inp_milesNo").disabled = true;
       //    }else{
       //      document.getElementById("inp_milesNo").disabled = false;
       //    }

      gojax('post', '/api/v1/repcom/load')
        .done(function(data) {
        $('#sel_com').html('');
        $.each(data, function(index, val) {
           $('#sel_com').append('<option value="'+val.ID+'">'+val.DESCRIPTION+'</option>');
        });
        $('#sel_com').val(rowdata.COMPANYID);
      });
      gojax('post', '/api/v1/repdep/load')
        .done(function(data) {
          $('#sel_Department').html('');
          $.each(data, function(index, val) {
             $('#sel_Department').append('<option value="'+val.ID+'">'+val.DEPARTMENTDES+'</option>');
          });
          $('#sel_Department').val(rowdata.DEPARTMENTID);
      });
      gojax('post', '/api/v1/repsec/load')
        .done(function(data) {
          $('#sel_Section').html('');
          $.each(data, function(index, val) {
             $('#sel_Section').append('<option value="'+val.ID+'">'+val.SECTIONDES+'</option>');
          });
          $('#sel_Section').val(rowdata.SECTIONID);
      });
      // gojax('post', '/api/v1/repDriver/load')
      //   .done(function(data) {
      //     $('#sel_Driver').html('');
      //     $.each(data, function(index, val) {
      //        $('#sel_Driver').append('<option value="'+val.ID+'">'+val.DRIVERNAME+'</option>');
      //     });
      //     $('#sel_Driver').val(rowdata.DRIVERID);
      // });
      // gojax('post', '/api/v1/repcar/load')
      //   .done(function(data) {
      //     $('#sel_car').html('');
      //     $.each(data, function(index, val) {
      //       $('#sel_car').append('<option value="'+val.CARID+'">'+val.REGCAR+'</option>');
      //     });
      //     $('#sel_car').val(rowdata.CARID);
      // });

      $("#gridcar").on('rowselect', function (event) {
        var args = event.args;
        var datarow = $("#gridcar").jqxGrid('getrowdata', args.rowindex);
        var dropDownContent = '<div style="position: relative; margin-left: 3px; margin-top: 5px;">' + datarow.REGCAR+'</div>';
        $('input[name=dd_car_id]').val(datarow.CARID);
        $("#dropdowncar").jqxDropDownButton('setContent', dropDownContent);
        $("#dropdowncar").jqxDropDownButton('close');
        $('input[name=inp_brand]').val(datarow.BRAND);
        $('input[name=inp_rType]').val(datarow.REGISTERTYPE);
        if(datarow.MILESCHECK == 1){
          document.getElementById("inp_milesNo").disabled = true;
        }else{
          document.getElementById("inp_milesNo").disabled = false;
        }
      });
      $('#dropdowncar').val(rowdata.REGCAR);
      $('input[name=dd_car_id]').val(rowdata.CARID);
      $('input[name=inp_brand]').val(rowdata.BRAND);
      $('input[name=inp_rType]').val(rowdata.REGISTERTYPE);
      if(rowdata.MILESCHECK == 1){
        document.getElementById("inp_milesNo").disabled = true;
      }else{
        document.getElementById("inp_milesNo").disabled = false;
      }

      $("#griddriver").on('rowselect', function (event) {
        var args = event.args;
        var datarow = $("#griddriver").jqxGrid('getrowdata', args.rowindex);
        var dropDownContent = '<div style="position: relative; margin-left: 3px; margin-top: 5px;">' + datarow.DRIVERNAME+'</div>';
        $('input[name=dd_driver_id]').val(datarow.ID);
        $("#dropdowndriver").jqxDropDownButton('setContent', dropDownContent);
        $("#dropdowndriver").jqxDropDownButton('close');
      });
      $('#dropdowndriver').val(rowdata.DRIVERNAME);
      $('input[name=dd_driver_id]').val(rowdata.DRIVERID);

      // getCARdetail(rowdata.CARID)
      // .done(function(data) {
      //   $('input[name=inp_brand]').val('');
      //   $('input[name=inp_rType]').val('');
      //   $.each(data, function(index, val) {
      //     $('input[name=inp_brand]').val(val.BRAND);
      //     $('input[name=inp_rType]').val(val.REGISTERTYPE);
      //     if(val.MILESCHECK == 1){
      //       document.getElementById("inp_milesNo").disabled = true;
      //     }else{
      //       document.getElementById("inp_milesNo").disabled = false;
      //     }
      //   });
      // });

      $('input[name=inp_milesNo]').val(rowdata.MILESNO);
      $('input[name=inp_remark]').val(rowdata.REMARK);
      $('input[name=inp_updateBy]').val(session_userid);

      }else{
        alert('กรุณาเลือกข้อมูล');
      }
  });
  $('#btn_delete').on('click', function(e) {
    var rowdata = row_selected("#gridrepair");
      if (typeof rowdata !== 'undefined') {
        $("#dialog").dialog({
          buttons : {
            "OK" : function() {

            gojax('post', '/api/v1/rep/delete', {id:rowdata.ID,repairid:rowdata.REPAIRID})

            .done(function(data) {
              if (data.status == 200)
            {
              gotify(data.message,"success");
                $('#dialog').dialog("close");
                    $('#gridrepair').jqxGrid('updatebounddata');

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
    }else{
      alert('กรุณาเลือกข้อมูล');
    }
  });
// event Table End

// event Line Begin
  // $('#btn_edit_new').on('click', function(e) {
  //   var rowdata = row_selected("#gridrepair");
  //   if (typeof rowdata !== 'undefined') {

  //     $("#dialogedit").dialog({
  //         buttons : {
  //           "OK" : function() {

  //           gojax('post', '/api/v1/rep/updatenew', {id:rowdata.ID})

  //           .done(function(data) {
  //             if (data.status == 200)
  //             {
  //               gotify(data.message,"success");
  //                 $('#dialogedit').dialog("close");
  //                 $('#gridrepair').jqxGrid('updatebounddata');

  //             } else {
  //                 gotify(data.message,"danger");
  //             }
  //           });
  //         return false;

  //         },
  //           "Cancel" : function() {
  //               $(this).dialog("close");
  //         }
  //       }
  //     });

  //   }else{
  //     alert('กรุณาเลือกข้อมูล');
  //   }
  // });

  $('#btn_sentHR').on('click', function(e) {
    var rowdata = row_selected("#gridrepair");
    if (typeof rowdata !== 'undefined') {
      if(rowdata.STATUSREPAIR == 4 || rowdata.STATUSREPAIR == 5 || rowdata.STATUSREPAIR == 7){

        $('#modal_sent_email').modal({backdrop: 'static'});
        $('.modal-title').text('Sent HR email');
        $('#modal_sent_email').trigger('reset');
        $('input[name=inp_RepairID_sent]').val(rowdata.REPAIRID);
        $('input[name=form_email]').val('mail_hr');

      }

    }else{
      alert('Please  select data');
    }
  });
  //insert
  $('#btn_save').on('click', function(e) {
    var rowdata = row_selected("#gridrepair");
    if (typeof rowdata !== 'undefined') {
      if($('input[name=inp_repair_line]').val() != '' 
        // note 9/10/2018
        // && $('select[name=sel_cradle]').val() != ''
        && $('#dropdowncradle').val() != ''
        && $('input[name=dd_cradle_id]') != ''
        && $('input[name=dd_detail_id]') != ''
        && $('input[name=inp_daterepair]').val() != '' 
        && $('input[name=inp_price]').val() != '' 
        && $('select[name=sel_cause]').val() != ''
        // // note 9/10/2018
        // && $('select[name=sel_causedetail]').val() != ''
        && $('input[name=inp_causedetail]').val() != ''
        // && $('#mySpancausedetail').val() != ''
        && $('input[name=inp_createByline]').val(session_userid)){

        if($('input[name=inp_line_num]').val() == ''){
          $('input[name=form_type_line]').val('create');
          $('#gridrepair').jqxGrid('clearselection');
        }else{
          $('input[name=form_type_line]').val('update');
        }

        $.ajax({
            url : '/api/v1/repline/create',
            type : 'post',
            cache : false,
            dataType : 'json',
            data : $('form#form_createline').serialize()
          })
          .done(function(data) {
            if (data.status != 200) {
              gotify(data.message,"danger");
            }else{
              // gotify(data.message,"success");
              $('#griditem').jqxGrid('updatebounddata');
              $('#gridrepair').jqxGrid('updatebounddata');
              $('input[name=inp_line_num]').val('');
              // $('select[name=sel_cradle]').val('');
              $('#dropdowncradle').val('');
              $('input[name=dd_cradle_id]').val('');
              $('input[name=dd_detail_id]').val('');
              // $('input[name=inp_daterepair]').val('');
              $('input[name=inp_price]').val('');
              $('select[name=sel_cause]').val('');
              // // note 9/10/2018
              // $('select[name=sel_causedetail]').val('');
              $('input[name=inp_causedetail]').val('');
              // $('textarea[name=text_item]').val('');
              // $('textarea[name=text_reason]').val('');
              $('textarea[name=text_note]').val('');
            }
            $('#mySpancausedetail').html("");
          });
        return false;

      }else{
        alert('กรอกข้อมูลไม่ครบ');
      }
    }else{
        alert('Please  select data');
    }
  });
  $('#btn_deleteline').on('click', function(e) {
    // var rowdata = row_selected("#griditem");
    var repair_id = $('input[name=inp_repair_line]').val();
    var repair_id_line= $('input[name=inp_line_num]').val();

    if (repair_id && repair_id_line) {
        $("#dialog").dialog({
          buttons : {
            "OK" : function() {

            gojax('post', '/api/v1/repline/delete', {id_line:repair_id,RepairNum_line:repair_id_line})

            .done(function(data) {
              if (data.status == 200)
            {
              gotify(data.message,"success");
                $('#dialog').dialog("close");
                $('#griditem').jqxGrid('updatebounddata');
                $('#gridrepair').jqxGrid('clearselection');
                $('input[name=inp_line_num]').val('');
                // note 9/10/2018
                // $('select[name=sel_cradle]').val('');
                $('#dropdowncradle').val('');
                $('input[name=dd_cradle_id]').val('');
                $('input[name=dd_detail_id]').val('');
                $('input[name=inp_daterepair]').val('');
                $('input[name=inp_price]').val('');
                $('select[name=sel_cause]').val('');
                // note 9/10/2018
                // $('select[name=sel_causedetail]').val('');
                $('input[name=inp_causedetail]').val();
                // $('textarea[name=text_item]').val('');
                // $('textarea[name=text_reason]').val('');
                $('textarea[name=text_note]').val('');

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
    }else{
        alert('Please  select data');
    }
  });

// edit lineitem
  $('#griditem').on('rowclick', function (event){
    var args = event.args;
    var boundIndex = args.rowindex;
    var datarow = $("#griditem").jqxGrid('getrowdata', boundIndex);
      $('input[name=inp_repair_line]').val(datarow.REPAIRID);
      $('input[name=inp_line_num]').val(datarow.LINENUM);
      $('input[name=dd_cradle_id]').val(datarow.CRADLEID);
      $('input[name=dd_detail_id]').val(datarow.DETAILID);
      $('#inp_causedetail').val(datarow.DESCRIPTION);

// note 10/10/2018
      // gojax('get', '/api/v1/Cradle/load')
      //   .done(function(data) {
      //     $('#sel_cradle').html('');
      //     $.each(data, function(index, val) {
      //        $('#sel_cradle').append('<option value="'+val.ID+'">'+val.CRADLE+'</option>');
      //     });
      //     $('#sel_cradle').val(datarow.CRADLEID);
      // });

    $("#gridcradle").on('rowselect', function (event) {
      var args = event.args;
      var datarow = $("#gridcradle").jqxGrid('getrowdata', args.rowindex);
      var dropDownContent = '<div style="position: relative; margin-left: 3px; margin-top: 5px;">' + datarow.CRADLE+'</div>';
      $('input[name=dd_cradle_id]').val(datarow.ID);
      $("#dropdowncradle").jqxDropDownButton('setContent', dropDownContent);
      $("#dropdowncradle").jqxDropDownButton('close');
    });
    $('#dropdowncradle').val(datarow.CRADLE);

    gojax('get', '/api/v1/Cause/load')
      .done(function(data) {
        $('#sel_cause').html('');
        $.each(data, function(index, val) {
           $('#sel_cause').append('<option value="'+val.ID+'">'+val.CAUSE+'</option>');
        });
        $('#sel_cause').val(datarow.CAUSEID);
    }); 
// // note 9/10/2018
    // getCauseDetail(datarow.CAUSEID)
    //   .done(function(data) {
    //     $('select[name=sel_causedetail]').html("<option value=''>-- Select --</option>");
    //     $.each(data, function(index, val) {
    //     $('select[name=sel_causedetail]').append('<option value="'+val.ID+'">'+val.DESCRIPTION+'</option>');
    //     });
    //     $('#sel_causedetail').val(datarow.DETAILID);
    // });

      REPAIRDATE = new Date(datarow.REPAIRDATE);
      var month = REPAIRDATE.getMonth();
      var date = REPAIRDATE.getDate();
      month = month+1;
         if(month.toString().length==1){
          month = ("0"+month);
        }if(month.toString().length==2){
          month = month;
        }
        if(date.toString().length==1){
          date = ("0"+date);
        }
      $('input[name=inp_daterepair]').val(date + "-" + month + "-" + REPAIRDATE.getFullYear());
      // $('input[name=inp_daterepair]').val(datarow.REPAIRDATE);
      $('input[name=inp_price]').val(datarow.PRICE);
      $('select[name=sel_cause]').val(datarow.CAUSE);
      //  note 9/10/2018
      // $('select[name=sel_causedetail]').val(datarow.DESCRIPTION);
      // $('textarea[name=text_item]').val(datarow.ITEM);
      // $('textarea[name=text_reason]').val(datarow.REASON);
      $('textarea[name=text_note]').val(datarow.NOTE);
      $('input[name=inp_updateByline]').val(session_userid);
    });
    $('#btn_clearline').on('click', function(e) {
        $('input[name=inp_line_num]').val('');
        // note 9/10/2018
        // $('select[name=sel_cradle]').val('');
        $('#dropdowncradle').val('');
        $('input[name=dd_cradle_id]').val('');
        $('input[name=dd_detail_id]').val('');
        $('input[name=inp_daterepair]').val('');
        $('input[name=inp_price]').val('');
        $('select[name=sel_cause]').val('');
        // note 9/10/2018
        // $('select[name=sel_causedetail]').val('');
        $('input[name=inp_causedetail]').val('');
        // $('textarea[name=text_item]').val('');
        // $('textarea[name=text_reason]').val('');

        $('textarea[name=text_note]').val('');
    });

    var num = 1;

    $('#causedetailplus').bind('click',function(){
      
      var add ="add"+num;
      var select_ ="select_"+num;
      var select_1="select_1"+num;
      var input_  ="input_"+num;
      var note_ = "note_"+num;
      var br1 = "br1"+num;
      var lbprice = "lbprice_"+num;
      var input_1 = "input_1"+num;
      var inp_causedetail_1 = "inp_causedetail_1"+num;
      var btn_causedetail_1 = "btn_causedetail_1"+num;

     $('#mySpancausedetail').append("<button id='"+add+"' onclick='removeEle("+add+','+select_+','+select_1+','+br1+','+input_+','+note_+','+lbprice+','+input_1+','+inp_causedetail_1+','+btn_causedetail_1+")'type='button' class='btn btn-danger btn-sm' >-</button><label id='"+lbprice+"'>&nbsp;&nbsp;&nbsp;รายการซ่อม:&nbsp;&nbsp;</label><input class='btn-sm' type='text'name='inp_causedetail' id='"+inp_causedetail_1+"' placeholder='เลือกรายการซ่อม...' autocomplete='off' style='width: 210px' required readonly='true'><button class='input-sm' id='"+btn_causedetail_1+"' type='button'><span class='glyphicon glyphicon-option-horizontal'></button></span><input type='hidden' name='causedetail[]' id='"+input_1+"'><label id='"+lbprice+"'>&nbsp;&nbsp;ราคา : &nbsp; </label> <input type='number' name='cause_price[]' class='input-sm' min='0' id='"+input_+"' style='width: 125px' required> <label id='"+lbprice+"'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;หมายเหตุ : &nbsp;</label><input type='textarea' name='cause_note[]' class='input-sm' id='"+note_+"' style='width: 255px' required> <br id='"+br1+"'><div id='"+select_+"' style='width: 260px' class='input-sm' required><div class ='modal-title'>รายการซ่อม</div><div name='grid_causedetail1' id='"+select_1+"'></div></div>");

// test start
    
    $("#"+btn_causedetail_1+"").on('click', function(){
      $("#"+select_+"").jqxWindow('open');
      var $causeid = $('#sel_cause').val();
      loadgrid_causedetail_1($causeid);
    });

    $("#sel_cause").on("change", function (event) { 
      $("#"+add+"").remove();
      $("#"+select_+"").remove();
      $("#"+select_1+"").remove();
      $("#"+input_+"").remove();
      $("#"+note_+"").remove();
      $("#"+br1+"").remove();
      $("#"+lbprice+"").remove();
      $("#"+lbprice+"").remove();
      $("#"+lbprice+"").remove();
      $("#"+input_1+"").remove();
      $("#"+inp_causedetail_1+"").remove();
      $("#"+btn_causedetail_1+"").remove();
    });

    $("#"+select_+"").jqxWindow({
        width : 380,
        height : 480,
        autoOpen : false,
        isModal : true    
    });

    $("#"+select_1+"").on('rowdoubleclick', function(event) {
        var args = event.args;
        var row = $("#"+select_1+"").jqxGrid('getrowdata', args.rowindex);
        $("#"+inp_causedetail_1+"").val(row.DESCRIPTION);
        $("#"+input_1+"").val(row.ID);
        $("#"+select_+"").jqxWindow('close');
    });

    function loadgrid_causedetail_1(){
        var $causeid = $('#sel_cause').val();
        var dataAdapter = new $.jqx.dataAdapter({
        datatype: "json",
        datafields: [
            { name: "ID", type: "int"},
            { name: "DESCRIPTION", type: "string"},
          ],
          url : '/api/v1/repcausedetailtest/load?causeid='+$causeid,
        });

        return $("#"+select_1+"").jqxGrid({
            width: 360,
            source: dataAdapter,
            filterable: true,
            showfilterrow: true,
            theme: 'default',
            columns: [
              { text:"รหัส", dataField: "ID", align: 'center', cellsalign: 'center', width:60},
              { text:"ชื่อรายการซ่อม", dataField: "DESCRIPTION", align: 'center', width:300},
            ]
        });
    }

     num++;

    $('#btn_clearline').on('click', function(e) {
        $("#"+select_+"").val('');
        $("#"+input_+"").val('');
        $("#"+note_+"").val('');
    });

  });

  $("#gridcradle").on('rowselect', function (event) {
    var args = event.args;
    var datarow = $("#gridcradle").jqxGrid('getrowdata', args.rowindex);
    var dropDownContent = '<div style="position: relative; margin-left: 3px; margin-top: 5px;">' + datarow.CRADLE+'</div>';
    $('input[name=dd_cradle_id]').val(datarow.ID);
    $("#dropdowncradle").jqxDropDownButton('setContent', dropDownContent);
    $("#dropdowncradle").jqxDropDownButton('close');
  });

// event Line End

// function begin
  function removeEle(divid,_divid,divid_,divbr,divinput,divnote,divlbprice,divinput1,inp_causedetail_1,btn_causedetail_1){
    $(divid).remove(); 
    $(_divid).remove();
    $(divid_).remove();
    $(divbr).remove(); 
    $(divinput).remove();
    $(divnote).remove();
    $(divlbprice).remove();
    $(divinput1).remove();
    $(inp_causedetail_1).remove();
    $(btn_causedetail_1).remove();
  }

  function getUserManager(){
        return $.ajax({
      url : '/api/v1/rep/Manager',
      type : 'get',
      dataType : 'json',
      cache : false
    });
  }
  // note 10/10/2018
  // function getCradle() {
  //     return $.ajax({
  //       url : '/api/v1/Cradle/load',
  //       type : 'get',
  //       dataType : 'json',
  //       cache : false
  //     });
  // }
  function getCause() {
      return $.ajax({
        url : '/api/v1/Causestatus/load',
        type : 'get',
        dataType : 'json',
        cache : false
      });
  } 
  function getCauseDetail($causeid) 
  {
    return gojax('post', '/api/v1/repcausedetail/load', {causeid:$causeid})
  }
  function printsub(){
      var rowdata = row_selected('#gridrepair');
      if(!!rowdata){
          $('input[name=inp_Repair_report]').val(rowdata.REPAIRID);
          $('input[name=inp_acc_report]').val(rowdata.REPAIRID);
          $('#type').val(1);
          $('#typeac').val(1);
          return true;
      }else{
          alert('กรุณาเลือกข้อมูล');
          return false;
      }
  }
  function getCARdetail($car) {
      return gojax('post', '/api/v1/repcardetail/load', {car:$car})
  }
  function checkUser($userid) {
      return gojax('post', '/api/v1/check/user', {userid:$userid})
  }
  function modal_create_open(){
        $('#form_create').trigger('reset');
        $('.modal-title').text('สร้างใบแจ้งซ่อม');
        $('input[name=form_type]').val('create');
        $('#lab_Repair_ID').hide();
        $('input[name=inp_RepairID]').hide();
        gojax('post', '/api/v1/repcom/load')
          .done(function(data) {
            $('#sel_com').html('');
            $.each(data, function(index, val) {
               $('#sel_com').append('<option value="'+val.ID+'">'+val.DESCRIPTION+'</option>');
            });
            grid_car($('#sel_com').val());
        });
        gojax('post', '/api/v1/repdep/load')
          .done(function(data) {
            $('#sel_Department').html('');
            $.each(data, function(index, val) {
               $('#sel_Department').append('<option value="'+val.ID+'">'+val.DEPARTMENTDES+'</option>');
            });
        });
        gojax('post', '/api/v1/repsec/load')
          .done(function(data) {
            $('#sel_Section').html('');
            $.each(data, function(index, val) {
               $('#sel_Section').append('<option value="'+val.ID+'">'+val.SECTIONDES+'</option>');
            });
        });
        // gojax('post', '/api/v1/repDriver/load')
        //   .done(function(data) {
        //     $('select[name=sel_Driver]').html("<option value=''>-- Select --</option>");
        //     $.each(data, function(index, val) {
        //       $('select[name=sel_Driver]').append('<option value="'+val.ID+'">'+val.DRIVERNAME+'</option>');
        //     });
        // });
        $('input[name=inp_brand]').val('');
        $('input[name=inp_brand]').prop('readonly', true);
        $('input[name=inp_rType]').val('');
        $('input[name=inp_rType]').prop('readonly', true);
        $('input[name=inp_milesNo]').val('');
        $('input[name=inp_remark]').val('');

        // gojax('post', '/api/v1/repcar/load')
        //   .done(function(data) {
        //     $('select[name=sel_car]').html("<option value=''>-- Select --</option>");
        //     $.each(data, function(index, val) {
        //       $('select[name=sel_car]').append('<option value="'+val.CARID+'">'+val.REGCAR+'</option>');
        //     });
        // });

        
        $("#gridcar").on('rowselect', function (event) {
          var args = event.args;
          var datarow = $("#gridcar").jqxGrid('getrowdata', args.rowindex);
          var dropDownContent = '<div style="position: relative; margin-left: 3px; margin-top: 5px;">' + datarow.REGCAR+'</div>';
          $('input[name=dd_car_id]').val(datarow.CARID);
          $("#dropdowncar").jqxDropDownButton('setContent', dropDownContent);
          $("#dropdowncar").jqxDropDownButton('close');
            
          $('input[name=inp_brand]').val(datarow.BRAND);
          $('input[name=inp_rType]').val(datarow.REGISTERTYPE);
          if(datarow.MILESCHECK == 1){
            document.getElementById("inp_milesNo").disabled = true;
          }else{
            document.getElementById("inp_milesNo").disabled = false;
          }

        });

        $("#griddriver").on('rowselect', function (event) {
          var args = event.args;
          var datarow = $("#griddriver").jqxGrid('getrowdata', args.rowindex);
          var dropDownContent = '<div style="position: relative; margin-left: 3px; margin-top: 5px;">' + datarow.DRIVERNAME+'</div>';
          $('input[name=dd_driver_id]').val(datarow.ID);
          $("#dropdowndriver").jqxDropDownButton('setContent', dropDownContent);
          $("#dropdowndriver").jqxDropDownButton('close');
        });

        $('input[name=inp_createBy]').val(session_userid);
  }

  $("#sel_com").on('change', function() {
    grid_car($('#sel_com').val());
    $("#gridcar").on('rowselect', function (event) {
      var args = event.args;
      var datarow = $("#gridcar").jqxGrid('getrowdata', args.rowindex);
      var dropDownContent = '<div style="position: relative; margin-left: 3px; margin-top: 5px;">' + datarow.REGCAR+'</div>';
      $('input[name=dd_car_id]').val(datarow.CARID);
      $("#dropdowncar").jqxDropDownButton('setContent', dropDownContent);
      $("#dropdowncar").jqxDropDownButton('close');
        
      $('input[name=inp_brand]').val(datarow.BRAND);
      $('input[name=inp_rType]').val(datarow.REGISTERTYPE);
      if(datarow.MILESCHECK == 1){
        document.getElementById("inp_milesNo").disabled = true;
      }else{
        document.getElementById("inp_milesNo").disabled = false;
      }

    });
  });

  function submit_create_repair() {

    $('#Save').html('<span class="glyphicon glyphicon-floppy-save"> </span> Save...');
    $('#Save').attr('disabled', true);

    $.ajax({
      url : '/api/v1/rep/create',
      type : 'post',
      cache : false,
      dataType : 'json',
      data : $('form#form_create').serialize()
    }).done(function(data) {
      if (data.status != 200) {
        gotify(data.message,"danger");
      }else{
        gotify(data.message,"success");
        $('#modal_create').modal('hide');
        $('#gridrepair').jqxGrid('updatebounddata');
      }
      
      $('#Save').html('<span class="glyphicon glyphicon-floppy-save"> </span> Save');
      $('#Save').attr('disabled', false);

    });
    
    return false;
  }

  function modal_popUp_open(){
    if(session_posid == 6){
      $('#modal_popUp').modal({backdrop: 'static'});
    }
  }
  function gridrepair(){
      var dataAdapter = new $.jqx.dataAdapter({
      datatype: "json",
          datafields: [
              { name: "ID", type: "int"},
              { name: "REPAIRID", type: "string"},
              { name: "CREATEDATE", type: "date", cellsformat: "dd-MM-yyyy"},
              { name: "COMPANYID", type: "int"},
              { name: "INTERNALCODE", type: "string"},
              { name: "DEPARTMENTID", type: "int"},
              { name: "SECTIONID", type: "int"},
              { name: "DRIVERID", type: "int"},
              { name: "DRIVERNAME", type: "string"},
              { name: "CARID", type: "string"},
              { name: "BRANDID", type: "int"},
              { name: "BRAND", type: "string"},
              { name: "REGISTERTYPEID", type: "int"},
              { name: "REGISTERTYPE", type: "string"},
              { name: "REGCAR", type: "string"},
              { name: "MILESNO", type: "int"},
              { name: "REMARK", type: "string"},
              { name: "STATUSREPAIR", type: "int"},
              { name: "CREATEBY", type: "string"},
              { name: "UPDATEBY", type: "string"},
              { name: "UPDATEDATE", type: "datetime"},
              { name: "STATUSTH", type: "string"},
              { name: "DEPARTMENT", type: "int"},
              { name: "CHECKLINE", type: "int"}, //tan_edit_180625
              { name: "RUNNINGDSG", type: "string"},
              { name: "MILESCHECK", type: "int"},
              { name: "REPAIRED", type: "date", cellsformat: "dd-MM-yyyy"},
              { name: "STATUSRENEW", type: "int"},
          ],
          url : '/api/v1/rep/load'
      });
      return $("#gridrepair").jqxGrid({
          width: '130%',
          source: dataAdapter,
          autoheight: true,
          columnsresize: true,
          pageable: true,
          filterable: true,
          showfilterrow: true,
          theme : 'Office',
          columns: [
            { text:"รหัสแจ้งซ่อม", datafield: "REPAIRID",align: 'center'},
            { text:"วันที่",datafield:"CREATEDATE", align: 'center', cellsformat: "dd-MM-yyyy"},
            { text:"บริษัท", datafield: "INTERNALCODE",align: 'center', width: "4%"},
            { text:"ชื่อผู้ขับขี่", datafield: "DRIVERNAME", align: "center"},
            { text:"รุ่น", datafield: "BRAND", align: "center"},
            { text:"ประเภทรถ", datafield: "REGISTERTYPE", align: "center"},
            { text:"ทะเบียนรถ", datafield: "REGCAR", align: "center", width: "6%"},
            { text:"เลขไมล์", datafield: "MILESNO", align: "center", width: "6%"},
            { text:"สาเหตุ", datafield: "REMARK", align: "center"},
            { text:"วันที่ซ่อมเสร็จ",datafield: "REPAIRED", width: "8%", align: "center", cellsformat: "dd-MM-yyyy"},
            { text:"เลขที่อนุมัติ", datafield: "RUNNINGDSG", width: "8%", align: "center"},
            { text:'สถานะการดำเนินงาน',datafield: "STATUSTH" ,width: "15%", align: "center"},
            { text: 'สถานะการซ่อม', datafield: 'STATUSRENEW', width:"5%", filterable: false,
              cellsrenderer: function (index, datafield, value, defaultvalue, column, rowdata){
                var status;
                   if (value ==1) {
                       status =  "<div style='padding: 5px; background:#00BB00 ; color:#ffffff;'>ซ่อมเสร็จ</div>";
                   }else{
                       status =  "<div style='padding: 5px; background:#EE0000 ; color:#ffffff;'>ไม่เสร็จ</div>";
                   }                    
                   return status;
              }
            },
            ]
      });
  }
  function griditem(RepairID) {
    // console.log(RepairID);
    var dataAdapter = new $.jqx.dataAdapter({
      dataType: "json",
      dataFields: [
        { name: "RowNumber", type: "int"},
        { name: "REPAIRID", type: "string"},
        { name: "LINENUM", type: "int"},
        { name: "REPAIRDATE", type: "date", cellsformat: "dd-MM-yyyy"},
        // { name: "ITEM", type: "string"},
        // { name: "REASON", type: "string"},
        { name: "CRADLEID", type: "int"},
        { name: "CRADLE", type: "string"},
        { name: "CAUSEID", type: "int"},
        { name: "CAUSE", type: "string"},
        { name: "DETAILID", type: "int"},
        { name: "DESCRIPTION", type: "string"},
        { name: "NOTE", type: "string"},
        { name: "PRICE", type: "float"},
        { name: "STATUS", type: "int"}
      ],
        url : '/api/v1/repclick/load?RepairID='+RepairID,
        sortcolumn: 'RowNumber',
        sortdirection: 'asc',
    });
    return $("#griditem").jqxGrid({
        width: '130%',
        source: dataAdapter,
         showstatusbar: true,
         statusbarheight: 25,
         autoheight: true,
         pageable: true,
         altrows: true,
         showaggregates: true,
         width: '130%',
        // filterable: true,
        // showfilterrow: true,
        theme : 'Office',
      columns: [
          { text:"อันดับ", datafield: "RowNumber", width:60},
          { text:"วันที่ซ่อม", datafield: "REPAIRDATE", cellsformat: "dd-MM-yyyy"},
          { text:"สาเหตุการซ่อม", datafield: "CAUSE"},
          { text:"รายการ", datafield: "DESCRIPTION"},
          { text:"อู่ซ่อม", datafield: "CRADLE"},
          { text:"หมายเหตุ", datafield: "NOTE"},
          { text:"ราคาเทส", datafield: "PRICE", cellsformat: "d2", aggregates: ['sum'], width:"13%" },
          { text:'สถานะ',datafield:  'STATUS', filterable: false,
                  cellsrenderer: function (index, datafield, value, defaultvalue, column, rowdata){
                      var status;
                         if (value === 8 ) {
                             status =  "<div style='padding: 5px;'>อนุมัติ</div>";
                         }else if(value === 6 || value === 10){
                             status =  "<div style='padding: 5px;'>ไม่อนุมัติ</div>";
                         }else{
                             status =  "<div style='padding: 5px; '>รออนุมัติ</div>";
                         }
                         return status;
                  }
          },
      ]
    });
  }

  function intOnly(input)//note_edit_20180622
  {
    var regExp = /^[0.00-9.99]*$/;
    if(!regExp.test(input.value)){
      input.value = " ";
      alert("ป้อนข้อมูลไม่ถูกต้อง");
    }
  }

  $('#gridrepair').on('rowclick', function (event){

    var args = event.args;
    var boundIndex = args.rowindex;        
    var datarow = $("#gridrepair").jqxGrid('getrowdata', boundIndex);
    
    var idrepair = datarow.REPAIRID;
    if (!!idrepair) {
          $.ajax({
            url : '/api/v1/load/repairitem',
            type : 'get',
            cache : false,
            dataType : 'json',
            data : {
              idrepair  : idrepair
            },
            success: function (data) {
                if(datarow.STATUSREPAIR == 6 || datarow.STATUSREPAIR == 8 || datarow.STATUSREPAIR == 9 || datarow.STATUSREPAIR == 10){
                  // document.getElementById("btn_sentHR").disabled = true;
                  $("#btn_sentHR").hide();
                }else{
                  // document.getElementById("btn_sentHR").disabled = false; 
                  $("#btn_sentHR").show();
                }
              },
              error: function (data) {
               // document.getElementById("btn_sentHR").disabled = true; 
               $("#btn_sentHR").hide();
              }
          });
        // alert (idrepair);
    }

  });

  $(document).ready(function () {
      var source =
      {
          datatype: "json",
          datafields:
          [
              { name: "ID", type: "int"},
              { name: "CRADLE", type: "string"},
          ],
          url : '/api/v1/Cradle/load'
      };
      var dataAdapter = new $.jqx.dataAdapter(source);
      $("#gridcradle").jqxGrid(
       {
          // width: getWidth('Grid'),
         width: '360',
          source: dataAdapter,
          autoheight: true,
          columnsresize: true,
          pageable: true,
          filterable: true,
          showfilterrow: true,
          theme : 'themeorange2',
          columns: [
            { text:"รหัส", datafield: "ID", align: 'center', cellsalign: 'center', width:60},
            { text:"ชื่ออู่ซ่อม", datafield: "CRADLE",align: 'center', width:300},
          ]
      });
       $("#dropdowncradle").jqxDropDownButton({
          width: 350, height: 27
      });
  });

  function grid_car(com) {
  // $(document).ready(function () {
    var source = {
          datatype: "json",
          datafields:
          [
            { name: "ID", type: "int"},
            { name: "CARID", type: "string"},
            { name: "REGCAR", type: "string"},
            { name: "BRAND", type: "string"},
            { name: "REGISTERTYPE", type: "string"},
            { name: "MILESCHECK", type: "int"}
          ],
          // url : '/api/v1/repcar/load',
          url : '/api/v1/repcar/load/bycom?com='+com,
          // url : '/api/v1/repcausedetailtest/load',

    };
    var dataAdapter = new $.jqx.dataAdapter(source);
    $("#gridcar").jqxGrid({
        // width: getWidth('Grid'),
       width: '570',
        source: dataAdapter,
        autoheight: true,
        columnsresize: true,
        pageable: true,
        filterable: true,
        showfilterrow: true,
        theme : 'themeorange2',
        columns: [
          { text:"รหัส", dataField: "CARID", align: 'center', cellsalign: 'center', width:80},
          { text:"ทะเบียน", dataField: "REGCAR", align: 'center', width:490},
        ]
    });
     $("#dropdowncar").jqxDropDownButton({
        width: 567, height: 45
    });
  }

  function grid_driver() {
  // $(document).ready(function () {
    var source = {
          datatype: "json",
          datafields:
          [
            { name: "ID", type: "int"},
            { name: "DRIVERNAME", type: "string"},
          ],
          url : '/api/v1/repDriver/load',
          // url : '/api/v1/repcausedetailtest/load',

    };
    var dataAdapter = new $.jqx.dataAdapter(source);
    $("#griddriver").jqxGrid({
        // width: getWidth('Grid'),
       width: '570',
        source: dataAdapter,
        autoheight: true,
        columnsresize: true,
        pageable: true,
        filterable: true,
        showfilterrow: true,
        theme : 'themeorange2',
        columns: [
          { text:"รหัส", dataField: "ID", align: 'center', cellsalign: 'center', width:80},
          { text:"ชื่อผู้ขับ", dataField: "DRIVERNAME", align: 'center', width:490},
        ]
    });
     $("#dropdowndriver").jqxDropDownButton({
        width: 567, height: 45
    });
  }

  $('#btn_repiared_date').on('click', function(e) {
      var rowdata = row_selected("#gridrepair");
      if (typeof rowdata !== 'undefined') {
        REPAIRED = new Date(rowdata.REPAIRED);
        var month = REPAIRED.getMonth();
        var date = REPAIRED.getDate();
        month = month+1;
          if(month.toString().length==1){
            month = ("0"+month);
          }if(month.toString().length==2){
            month = month;
          }
          if(date.toString().length==1){
            date = ("0"+date);
          }
       
          $('#modal_repaired_date').modal({backdrop: 'static'});
          $('input[name=inp_repaireddate_id]').val(rowdata.REPAIRID);
            if(rowdata.REPAIRED == null){
              $('input[name=inp_repaired_date]').val("");
            }else{
              $('input[name=inp_repaired_date]').val(date + "-" + month + "-" + REPAIRED.getFullYear());
            }
          $('input[name=inp_repaired_date]').prop('readonly', true);
      }else{
        alert('กรุณาเลือกข้อมูล');
      }     
  });

  function submit_repaired_date() {
      $.ajax({
        url : '/api/v1/update/repaireddate',
        type : 'post',
        cache : false,
        dataType : 'json',
        data : $('form#form_repaired_date').serialize()
      })
      .done(function(data) {
        if (data.status != 200) {
          gotify(data.message,"danger");
        }else{
          gotify(data.message,"success");
          $('#modal_repaired_date').modal('hide');
          $('#gridrepair').jqxGrid('updatebounddata');
        }
      });
      return false;
  }

  $('#btn_delete_repaired').on('click', function(e) {
    var rowdata = row_selected("#gridrepair");
      if (typeof rowdata !== 'undefined') {
        $("#dialog").dialog({
          buttons : {
            "OK" : function() {

            gojax('post', '/api/v1/delete/repaireddate', {repairid:rowdata.REPAIRID})

            .done(function(data) {
              if (data.status == 200)
            {
              gotify(data.message,"success");
                $('#dialog').dialog("close");
                $('#modal_repaired_date').modal('hide');
                $('#gridrepair').jqxGrid('updatebounddata');

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
    }else{
      alert('กรุณาเลือกข้อมูล');
    }
  });

// causedetail
  $("#sel_cause").on("change", function (event) { 
    $('#btn_causedetail').on('click', function(){
        $('#modal_causedetail').jqxWindow('open');
        var $causeid = $('#sel_cause').val();
        loadgrid_causedetail($causeid);
    });
    $('#dd_detail_id').val('');
    $('#inp_causedetail').val('');
    $('#inp_price').val('');
    $('#text_note').val('');
  });

    $('#modal_causedetail').jqxWindow({
        width : 380,
        height : 480,
        autoOpen : false,
        isModal : true    
    });

    $("#grid_causedetail").on('rowdoubleclick', function(event) {
        var args = event.args;
        var row = $("#grid_causedetail").jqxGrid('getrowdata', args.rowindex);
        $('#inp_causedetail').val(row.DESCRIPTION);
        $('input[name=dd_detail_id]').val(row.ID);
        $('#modal_causedetail').jqxWindow('close');
    });

    function loadgrid_causedetail(){
        var $causeid = $('#sel_cause').val();
        var dataAdapter = new $.jqx.dataAdapter({
        datatype: "json",
        datafields: [
            { name: "ID", type: "int"},
            { name: "DESCRIPTION", type: "string"},
          ],
          url : '/api/v1/repcausedetailtest/load?causeid='+$causeid,
        });

        return $("#grid_causedetail").jqxGrid({
            width: 360,
            source: dataAdapter,
            filterable: true,
            showfilterrow: true,
            theme: 'default',
            columns: [
              { text:"รหัส", dataField: "ID", align: 'center', cellsalign: 'center', width:60},
              { text:"ชื่อรายการซ่อม", dataField: "DESCRIPTION", align: 'center', width:300},
            ]
        });
    }

// function end

</script>
