<?php $this->layout("layouts/main") ?>

<style type="text/css">
  input[type=checkbox] {
      width: 20px;
        height: 20px;
    } 
</style>

<h2>สาเหตุการซ่อม</h2>
<button id="btn_create" onclick="return modal_create_open()"  class="btn btn-default" data-backdrop="static" data-toggle="modal" data-target="#modal_create">เพิ่ม</button>
<button class="btn btn-primary" id="edit">แก้ไข</button>
<button class="btn btn-danger" id="delete">ลบ</button>
<button class="btn btn-info btn-sm" id="detail">รายการซ่อม</button>

<div id="gridcause"></div>

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
            <label for="inp_causeid" id="inp_causeid">รหัสสาเหตุ</label>
            <input type="name" name="inp_causeid" id="inp_causeid" class="form-control" autocomplete="off" required>
          </div>
          <div class="form-group">
            <label for="inp_causename">ชื่อสาเหตุการซ่อม</label>
            <input type="name" name="inp_causename" id="inp_causename" class="form-control" autocomplete="off" required>
          </div>
            <div class="form-group">
              <label for="inp_status" id="inp_status">Active</label>&nbsp;&nbsp;&nbsp;&nbsp;
              <input type="checkbox" name="inp_status" id="inp_status" value="1">
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

<form action="/CauseDetail" method="get" id='CauseDetail' name='CauseDetail'>
    <input type="hidden" name="inp_sentid" value="" />
</form>

<script type="text/javascript">
  $('#dialog').hide();
  var session_useredit = '<?php echo $_SESSION["userEdit"] ; ?>';

jQuery(document).ready(function($){
  gridcause();

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
      var rowdata = row_selected("#gridcause");
      if (typeof rowdata !== 'undefined') {
        $('#modal_create').modal({backdrop: 'static'});
        $('input[name=form_type]').val('update');
        $('.modal-title').text('แก้ไขสาเหตุการซ่อม');
        $('input[name=inp_causeid]').show();
        $('#inp_causeid').show();
        $('input[name=inp_causeid]').val(rowdata.ID);
        $('input[name=inp_causeid]').prop('readonly', true);
        $('input[name=inp_causename]').val(rowdata.CAUSE);
        $('input[name=id]').val(rowdata.ID);

        if (rowdata.STATUS == 1){
        $('input[name=inp_status]').prop('checked' , true);
      }else{
        $('input[name=inp_status]').prop('checked' , false);
      }
      }else{
        alert('กรุณาเลือกข้อมูล');
      }     
    });

    $('#delete').on('click', function(e) {
        var rowdata = row_selected("#gridcause");
      if (typeof rowdata !== 'undefined') {
        $("#dialog").dialog({
          buttons : {
            "OK" : function() {

            gojax('post', '/api/v1/cause/delete', {id:rowdata.ID})

            .done(function(data) {
              if (data.status == 200) 
            {
              gotify(data.message,"success");
                $('#dialog').dialog("close");
                    $('#gridcause').jqxGrid('updatebounddata');
                          
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

    $('#detail').on('click',function(e) {
    var rowdata = row_selected("#gridcause");
        if (typeof rowdata !== 'undefined') 
        {
            event.preventDefault();
            $('input[name=inp_sentid]').val(rowdata.ID);
            document.forms["CauseDetail"].submit();
    
    }else{
      alert('กรุณาเลือกข้อมูล');
    }       
  });

  function modal_create_open(){
        $('#form_create').trigger('reset');
        $('.modal-title').text('เพิ่มสาเหตุการซ่อม');
        $('input[name=form_type]').val('create');
        $('#inp_causeid').hide();
        $('input[name=inp_causeid]').hide().val('0');
        $('input[name=inp_status]').prop('checked' , true);

  }

  function submit_create_user() {
        
        $.ajax({
            url : '/api/v1/cause/create',
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
              $('#gridcause').jqxGrid('updatebounddata');
            }
          });
       return false;
  }

  function gridcause(){
  
    var dataAdapter = new $.jqx.dataAdapter({
    datatype: "json",
        datafields: [
            { name: "ID", type: "int" },
            { name: "CAUSE", type: "string" },
            { name: 'STATUS', type: 'int' },
        ],
        url : '/api/v1/Cause/load'
    });

    return $("#gridcause").jqxGrid({
          width: '130%',
          source: dataAdapter,
          autoheight: true,
          columnsresize: true,
          pageable: true,
          filterable: true,
          showfilterrow: true,
          theme : 'themeorange2',
          columns: [
            { text:"รหัสาเหตุการซ่อม", datafield: "ID",width:"15%"},
            { text:"ชื่อสาเหตุการซ่อม", datafield: "CAUSE"},
            { text: 'สถานะ', dataField: 'STATUS', cellsAlign: 'center', align: 'center', width: '10%',
            cellsrenderer: function (index, datafield, value, defaultvalue, column, rowdata){
              var status;
                 if (value ==1) {
                     status =  "<div style='padding: 5px; background:#00BB00 ; color:#ffffff;'>Active</div>";
                 }else if (value ==0) {
                     status =  "<div style='padding: 5px; background:#EE0000 ; color:#ffffff;'>NotActive</div>";
                 }
                 return status;
                 }
            }
              
            ]
    });  
  }


</script>