<?php $this->layout("layouts/main") ?>

<style type="text/css">
  input[type=checkbox] {
      width: 20px;
        height: 20px;
    } 
</style>
<meta charset="UTF-8">

<h2>สาเหตุการซ่อม&nbsp;:&nbsp;<input type="label" name="lab_causeid" id="lab_causeid" style="border: 0px"/></h2>
<button id="btn_create" onclick="return modal_create_open()"  class="btn btn-default" data-backdrop="static" data-toggle="modal" data-target="#modal_create">เพิ่ม</button>
<button class="btn btn-primary" id="edit">แก้ไข</button>
<button class="btn btn-danger" id="delete">ลบ</button>
<hr>

<div id="gridcausedetail"></div>

<div class="modal" id="modal_create" tabindex="-1" role="dialog">
  <div class="modal-dialog" role="document">
    <div class="modal-content">
      <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
          <span aria-hidden="true" class="glyphicon glyphicon-remove-circle"></span>
        </button>
        <h4 class="modal-title">this title</h4><br>
        <h4><input type="label" name="lab_title" id="lab_title" style="border: 0px"></h4>
      </div>
      <div class="modal-body">
        <form id="form_create" onsubmit="return submit_create_user()">
          <div class="form-group">
            <label for="inp_causedetail">รายการซ่อม</label>
            <input type="name" name="inp_causedetail" id="inp_causedetail" class="form-control" autocomplete="off" required>
          </div>
          <div class="form-group">
            <label for="inp_status" id="inp_status">Active</label>&nbsp;&nbsp;&nbsp;&nbsp;
            <input type="checkbox" name="inp_status" id="inp_status" value="1">
          </div>
          
            <input type="hidden" name="id">
            <input type="hidden" name="form_type">
            <input type="hidden" name="inp_causeid">

          <label>
            <button class="btn btn-primary" id="Save"><i class="glyphicon glyphicon-floppy-save"></i>&nbsp;บันทึก</button>
          </label>
        </form>
      </div>
    </div>
  </div>
</div>
<div id="dialog" title="ลบข้อมูล"><label for="Delete">ต้องการลบข้อมูลหรือไม่?</label></div>

<script type="text/javascript">
  $('#dialog').hide();
  var session_useredit = '<?php echo $_SESSION["userEdit"] ; ?>';
  var causeid = '<?php echo urlencode($_GET["inp_sentid"]); ?>';
 


jQuery(document).ready(function($){
  
  gridcausedetail(causeid);

  $causeid = causeid ;
    getCauseDetail($causeid)
    .done(function(data) {
      $.each(data, function(index, val) {
      $('input[name=lab_causeid]').val(val.CAUSE);
      });
  });

    document.getElementById('lab_causeid').disabled = true;
    document.getElementById('lab_title').disabled = true;

    if(session_useredit != 1)
    { 
      document.getElementById("btn_create").disabled = true;  
      document.getElementById("edit").disabled = true;
      document.getElementById("delete").disabled = true;  
    }
    else
    {
      document.getElementById("btn_create").disabled = false;  
      document.getElementById("edit").disabled = false;
      document.getElementById("delete").disabled = false;  
    }     
});
  
  $('#edit').on('click', function(e) {
      var rowdata = row_selected("#gridcausedetail");
      if (typeof rowdata !== 'undefined') {
        $('#modal_create').modal({backdrop: 'static'});
        $('input[name=form_type]').val('update');
        $('.modal-title').text('แก้ไขสาเหตุการซ่อม');
        $('.modal-story').text(rowdata.CAUSE);
        $('input[name=inp_causedetailid]').show();
        $('#inp_causedetailid').show();
        $('input[name=inp_causedetailid]').val(rowdata.ID);
        $('input[name=inp_causedetailid]').prop('readonly', true);
        $('input[name=inp_causedetail]').val(rowdata.DESCRIPTION);
        $('input[name=id]').val(rowdata.ID);
        $('input[name=inp_causeid]').val(causeid);

       if (rowdata.STATUS == 1){
        $('input[name=inp_status]').prop('checked' , true);
      }else{
        $('input[name=inp_status]').prop('checked' , false);
      }
      }else
      {
        alert('กรุณาเลือกข้อมูล');    
      }     
    });
    $('#delete').on('click', function(e) {
        var rowdata = row_selected("#gridcausedetail");
      if (typeof rowdata !== 'undefined') {
        $("#dialog").dialog({
          buttons : {
            "OK" : function() {

            gojax('post', '/api/v1/causedetail/delete', {id:rowdata.ID})

            .done(function(data) {
              if (data.status == 200) 
            {
              gotify(data.message,"success");
                $('#dialog').dialog("close");
                    $('#gridcausedetail').jqxGrid('updatebounddata');
                          
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

        }else
        {
          alert('กรุณาเลือกข้อมูล'); 
        }   
    });

  function modal_create_open(){
        $('#form_create').trigger('reset');
        $('.modal-title').text('เพิ่มรายการซ่อม');
        $('input[name=form_type]').val('create');
        $('#inp_causedetailid').hide();
        $('input[name=inp_causedetailid]').hide().val('0');
        $('#inp_causeid').hide();
        $('input[name=inp_causeid]').val(causeid);
        $('input[name=inp_status]').prop('checked' , true);
        $causeid = causeid ;
        getCauseDetail($causeid)
          .done(function(data) {
            $.each(data, function(index, val) {
            $('input[name=lab_title]').val(val.CAUSE);
            });
        });
        }
  
  function submit_create_user() {
        
        $.ajax({
            url : '/api/v1/causedetail/create',
            type : 'post',
            cache : false,
            dataType : 'json',
            data : $('form#form_create').serialize()
          })
          .done(function(data) {
            if (data.status != 200) {
              gotify(data.message,"danger");
            }else{
              gotify(data.message,"success");
              $('#modal_create').modal('hide');
              $('#gridcausedetail').jqxGrid('updatebounddata');
            }
          });
       return false;
  }

  function gridcausedetail(causeid){
  
    var dataAdapter = new $.jqx.dataAdapter({
    datatype: "json",
        datafields: [
            { name: "ID", type: "int" },
            { name: "CAUSEID", type: "int" },
            { name: "CAUSE", type: "int" },
            { name: "DESCRIPTION", type: "string" },
            { name: "STATUS", type: "int" },
        ],
        url : '/api/v1/causedetail/load?causeid='+causeid,
        sortcolumn: 'ID',
        // sortdirection: 'desc',
    });

    return $("#gridcausedetail").jqxGrid({
          width: '130%',
          source: dataAdapter,
          autoheight: true,
          columnsresize: true,
          pageable: true,
          filterable: true,
          showfilterrow: true,
          theme : 'themeorange2',
          columns: [
            { text:"รหัส", datafield: "ID",width:"10%"},
            // { text:"สาเหตุ", datafield: "CAUSE",width:"10%"},
            { text:"รายละเอียด", datafield: "DESCRIPTION"},
            { text: 'สถานะ', dataField: 'STATUS', cellsAlign: 'center', align: 'center', width: '10%',
            cellsrenderer: function (index, datafield, value, defaultvalue, column, rowdata){
              var status;

                 if (value ==1) {
                     status =  "<div style='padding: 5px; background:#00BB00 ; color:#ffffff;'>Active</div>";
                 }else if (value ==0) {
                     status =  "<div style='padding: 5px; background:#EE0000 ; color:#ffffff;'>NotActive</div>";
                 }
                 console.log(status);
                 return status;
                 }
            }
              
            ]
    });  
  }

  function getCauseDetail($causeid) 
  {
    return gojax('post', '/api/v1/causedetail/from', {causeid:$causeid})
  }

</script>