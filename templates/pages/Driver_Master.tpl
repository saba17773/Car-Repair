<?php $this->layout("layouts/main") ?>

<style type="text/css">
	input[type=checkbox] {
    	width: 20px;
      	height: 20px;
  	}
</style>

<h2>ผู้ขับรถยนต์</h2>
<button id="btn_create" onclick="return modal_create_open()"  class="btn btn-default" data-backdrop="static" data-toggle="modal" data-target="#modal_create">เพิ่ม</button>
<button class="btn btn-primary" id="edit">แก้ไข</button>
<button class="btn btn-danger" id="delete">ลบ</button>
<hr>

<div id="griddriver"></div>

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
        <form id="form_create" onsubmit="return submit_create_driver()">

          <div class="form-group">
            <label for="inp_deriverid" id="inp_deriverid">รหัส</label>
            <input type="name" name="inp_deriverid" id="inp_deriverid" class="form-control" autocomplete="off" required>
          </div>
          <div class="form-group">
            <label for="inp_drivername">ชื่อผู้ขับ</label>
            <input type="name" name="inp_drivername" id="inp_drivername" class="form-control" autocomplete="off" required>
          </div>

          <label for="lab_com">บริษัท</label>
            <select name="sel_comid" id="sel_comid" class="form-control" required></select>
          <label for="lab_pos">ตำแหน่ง</label>
            <select name="sel_posid" id="sel_posid" class="form-control" required></select>
          <label for="lab_dep">แผนก</label>
            <select name="sel_depid" id="sel_depid" class="form-control" required></select>
          <label for="lab_sec">ฝ่าย</label>
            <select name="sel_secid" id="sel_secid" class="form-control" required></select>


          <input type="hidden" name="id">
        	<input type="hidden" name="form_type">
          <br>
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

	griddriver();

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

  getCom()
        .done(function(data) {
          $('select[name=sel_comid]').html("<option value=''>-- Select --</option>");
          $.each(data, function(index, val) {
            $('select[name=sel_comid]').append('<option value="'+val.ID+'">'+val.DESCRIPTION+'</option>');
          });
  });
  getPos()
        .done(function(data) {
          $('select[name=sel_posid]').html("<option value=''>-- Select --</option>");
          $.each(data, function(index, val) {
            $('select[name=sel_posid]').append('<option value="'+val.ID+'">'+val.POSITIONDES+'</option>');
          });
  });
  getDep()
        .done(function(data) {
          $('select[name=sel_depid]').html("<option value=''>-- Select --</option>");
          $.each(data, function(index, val) {
            $('select[name=sel_depid]').append('<option value="'+val.ID+'">'+val.DEPARTMENTDES+'</option>');
          });
  });
  getSec()
        .done(function(data) {
          $('select[name=sel_secid]').html("<option value=''>-- Select --</option>");
          $.each(data, function(index, val) {
            $('select[name=sel_secid]').append('<option value="'+val.ID+'">'+val.SECTIONDES+'</option>');
          });
  });

});

	$('#edit').on('click', function(e) {
      var rowdata = row_selected("#griddriver");
      if (typeof rowdata !== 'undefined') {

        $('#modal_create').modal({backdrop: 'static'});
        $('input[name=form_type]').val('update');
        $('.modal-title').text('แก้ไขข้อมูลผู้ขับ');
        $('input[name=inp_deriverid]').show();
        $('#inp_deriverid').show();
        $('input[name=inp_deriverid]').val(rowdata.dm_id);
        $('input[name=inp_deriverid]').prop('readonly', true);
        $('input[name=inp_drivername]').val(rowdata.DRIVERNAME);
        $('input[name=id]').val(rowdata.dm_id);

        gojax('get', '/api/v1/comp/load')
          .done(function(data) {
            $('#sel_comid').html('');
            $.each(data, function(index, val) {
               $('#sel_comid').append('<option value="'+val.ID+'">'+val.DESCRIPTION+'</option>');
            });
            $('#sel_comid').val(rowdata.COMPANY);
        });
        gojax('get', '/api/v1/pos/load')
          .done(function(data) {
            $('#sel_posid').html('');
            $.each(data, function(index, val) {
               $('#sel_posid').append('<option value="'+val.ID+'">'+val.POSITIONDES+'</option>');
            });
            $('#sel_posid').val(rowdata.POSITION);
        });
        gojax('get', '/api/v1/depart/load')
          .done(function(data) {
            $('#sel_depid').html('');
            $.each(data, function(index, val) {
               $('#sel_depid').append('<option value="'+val.ID+'">'+val.DEPARTMENTDES+'</option>');
            });
            $('#sel_depid').val(rowdata.DEPARTMENT);
        });
        gojax('get', '/api/v1/sec/load')
          .done(function(data) {
            $('#sel_secid').html('');
            $.each(data, function(index, val) {
               $('#sel_secid').append('<option value="'+val.ID+'">'+val.SECTIONDES+'</option>');
            });
            $('#sel_secid').val(rowdata.SECTION);
        });

      }else{//tan_edit_180625
				alert("กรุณาเลือกรายการ");
			}

  	});

  	$('#delete').on('click', function(e) {
      var rowdata = row_selected("#griddriver");
    	if (typeof rowdata !== 'undefined') {
    		$("#dialog").dialog({
      		buttons : {
        		"OK" : function() {

        		gojax('post', '/api/v1/driver/delete', {id:rowdata.dm_id})

			    	.done(function(data) {
			    		if (data.status == 200)
						{
							gotify(data.message,"success");
			    			$('#dialog').dialog("close");
			          		$('#griddriver').jqxGrid('updatebounddata');

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

      }else{//tan_edit_180625
				alert("กรุณาเลือกรายการ");
			}
  	});

	function modal_create_open(){
  	    $('#form_create').trigger('reset');
  	    $('.modal-title').text('เพิ่มข้อมูลผู้ขับ');
  	    $('input[name=form_type]').val('create');
        $('#inp_deriverid').hide();
        $('input[name=inp_deriverid]').hide().val('0');

	}

	function submit_create_driver() {

		    $.ajax({
		        url : '/api/v1/driver/create',
		        type : 'post',
		        cache : false,
		        dataType : 'json',
		        data : $('form#form_create').serialize()
	        })
	        .done(function(data) {
	        	//alert(data);
		        if (data.status != 200) {
              gotify(data.message,"danger");
		        }else{
              gotify(data.message,"success");
		          $('#modal_create').modal('hide');
		          $('#griddriver').jqxGrid('updatebounddata');
		        }
	        });
    	 return false;
	}

	function griddriver(){

	    var dataAdapter = new $.jqx.dataAdapter({
			datatype: "json",
	        datafields: [
	            { name: "dm_id", type: "int" },
	            { name: "DRIVERNAME", type: "string"},
              { name: "COMPANY", type: "int"},
              { name: "POSITION", type: "int"},
              { name: "DEPARTMENT", type: "int"},
              { name: "SECTION", type: "int"},
              { name: "DESCRIPTION", type: "string"},
              { name: "POSITIONDES", type: "string"},
              { name: "DEPARTMENTDES", type: "string"},
              { name: "SECTIONDES", type: "string"}
	        ],
	        url : '/api/v1/driver/load'
		  });

		  return $("#griddriver").jqxGrid({
	        width: '130%',
	        source: dataAdapter,
	        autoheight: true,
	        columnsresize: true,
	        pageable: true,
	        filterable: true,
	        showfilterrow: true,
	        theme : 'themeorange2',
	        columns: [
	        	{ text:"รหัส", datafield: "dm_id",width:"5%"},
	        	{ text:"ชื่อผู้ขับ", datafield: "DRIVERNAME"},
            { text:"บริษัท", datafield: "DESCRIPTION"},
            { text:"ตำแหน่ง", datafield: "POSITIONDES"},
            { text:"แผนก", datafield: "DEPARTMENTDES"},
            { text:"ฝ่าย", datafield: "SECTIONDES"}

	          ]
	  });
	}
  function getCom() {
      return $.ajax({
        url : '/api/v1/com/load',
        type : 'get',
        dataType : 'json',
        cache : false
      });
  }
  function getPos() {
      return $.ajax({
        url : '/api/v1/pos/load',
        type : 'get',
        dataType : 'json',
        cache : false
      });
  }
  function getDep() {
      return $.ajax({
        url : '/api/v1/depart/load',
        type : 'get',
        dataType : 'json',
        cache : false
      });
  }
  function getSec() {
      return $.ajax({
        url : '/api/v1/sec/load',
        type : 'get',
        dataType : 'json',
        cache : false
      });
  }


</script>
