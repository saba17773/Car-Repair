<?php $this->layout("layouts/main") ?>

<style type="text/css">
  input[type=checkbox] {
      width: 20px;
        height: 20px;
    } 
</style>

<h2>แผนก</h2>
<button id="btn_create" onclick="return modal_create_open()"  class="btn btn-default" data-backdrop="static" data-toggle="modal" data-target="#modal_create">เพิ่ม</button>
<button class="btn btn-primary" id="edit">แก้ไข</button>
<button class="btn btn-danger" id="delete">ลบ</button>

<div id="griddepartment"></div>

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
        <form id="form_create" onsubmit="return submit_create_user()">
          <div class="form-group">
            <label for="lab_DPid" id="lab_DPid">รหัสแผนก</label>
            <input type="name" name="inp_DPid" id="inp_DPid" class="form-control" autocomplete="off" required>
          </div>
          <div class="form-group">
            <label for="lab_DP">ชื่อแผนก</label>
            <input type="name" name="inp_DP" id="inp_DP" class="form-control" autocomplete="off" required>
          </div>
          
            <input type="hidden" name="id">
            <input type="hidden" name="form_type">

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

jQuery(document).ready(function($){
  griddepartment(); 

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
      var rowdata = row_selected("#griddepartment");
      if (typeof rowdata !== 'undefined') {
        $('#modal_create').modal({backdrop: 'static'});
        $('input[name=form_type]').val('update');
        $('.modal-title').text('แก้ไขแผนก');
        $('input[name=inp_DPid]').show();
        $('#inp_DPid').show();
        $('input[name=inp_DPid]').val(rowdata.ID);
        $('input[name=inp_DPid]').prop('readonly', true);
        $('input[name=inp_DP]').val(rowdata.DEPARTMENTDES);
        $('input[name=id]').val(rowdata.ID);
      }else{
        alert('กรุณาเลือกข้อมูล');
      }        
    });

    $('#delete').on('click', function(e) {
        var rowdata = row_selected("#griddepartment");
      if (typeof rowdata !== 'undefined') {
        $("#dialog").dialog({
          buttons : {
            "OK" : function() {

            gojax('post', '/api/v1/department/delete', {id:rowdata.ID})

            .done(function(data) {
              if (data.status == 200) 
            {
              gotify(data.message,"success");
                $('#dialog').dialog("close");
                    $('#griddepartment').jqxGrid('updatebounddata');
                          
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

  function modal_create_open(){
        $('#form_create').trigger('reset');
        $('.modal-title').text('เพิ่มแผนก');
        $('input[name=form_type]').val('create');
        $('#lab_DPid').hide();
        $('input[name=inp_DPid]').hide().val('0');

  }

  function submit_create_user() {
        
        $.ajax({
            url : '/api/v1/department/create',
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
              $('#griddepartment').jqxGrid('updatebounddata');
            }
          });
       return false;
  }

  function griddepartment(){
  
    var dataAdapter = new $.jqx.dataAdapter({
    datatype: "json",
        datafields: [
            { name: "ID", type: "int" },
            { name: "DEPARTMENTDES", type: "string" }
        ],
        url : '/api/v1/department/load'
    });

    return $("#griddepartment").jqxGrid({
          width: '130%',
          source: dataAdapter,
          autoheight: true,
          columnsresize: true,
          pageable: true,
          filterable: true,
          showfilterrow: true,
          theme : 'themeorange2',
          columns: [
            { text:"รหัสแผนก", datafield: "ID",width:"15%"},
            { text:"ชื่อแผนก", datafield: "DEPARTMENTDES"}
              
            ]
    });  
  }


</script>