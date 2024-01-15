<?php $this->layout("layouts/main") ?>

<style type="text/css">
	input[type=checkbox] {
    	width: 20px;
      	height: 20px;
  	}
</style>

<h2>ยี่ห้อรถยนต์</h2>
<button id="btn_create" onclick="return modal_create_open()"  class="btn btn-default" data-backdrop="static" data-toggle="modal" data-target="#modal_create">เพิ่ม</button>
<button class="btn btn-primary" id="edit">แก้ไข</button>
<button class="btn btn-danger" id="delete">ลบ</button>
<hr>

<div id="gridBrand"></div>

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
            <label for="inp_brandid" id="inp_brandid">รหัสยี่ห้อ</label>
            <input type="name" name="inp_brandid" id="inp_brandid" class="form-control" autocomplete="off" required>
          </div>
          <div class="form-group">
            <label for="inp_brandname">ชื่อยี่ห้อ</label>
            <input type="name" name="inp_brandname" id="inp_brandname" class="form-control" autocomplete="off" required>
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
<div id="dialog" title="ลบ"><label for="Delete">คุณต้องการลบข้อมูล?</label></div>

<script type="text/javascript">
	$('#dialog').hide();
  var session_useredit = '<?php echo $_SESSION["userEdit"] ; ?>';

jQuery(document).ready(function($){

	gridBrand();

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
      var rowdata = row_selected("#gridBrand");
      if (typeof rowdata !== 'undefined') {

        $('#modal_create').modal({backdrop: 'static'});
        $('input[name=form_type]').val('update');
        $('.modal-title').text('แก้ไขยี่ห้อรถยนต์');
        $('input[name=inp_brandid]').show();
        $('#inp_brandid').show();
        $('input[name=inp_brandid]').val(rowdata.ID);
        $('input[name=inp_brandid]').prop('readonly', true);
        $('input[name=inp_brandname]').val(rowdata.BRAND);
        $('input[name=id]').val(rowdata.ID);

      }else{//tan_edit_180625
				alert("กรุณาเลือกรายการ");
			}

  	});

  	$('#delete').on('click', function(e) {
      	var rowdata = row_selected("#gridBrand");
    	if (typeof rowdata !== 'undefined') {
    		$("#dialog").dialog({
      		buttons : {
        		"OK" : function() {

        		gojax('post', '/api/v1/brand/delete', {id:rowdata.ID})

			    	.done(function(data) {
			    		if (data.status == 200)
						{
							gotify(data.message,"success");
			    			$('#dialog').dialog("close");
			          		$('#gridBrand').jqxGrid('updatebounddata');

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
  	    $('.modal-title').text('เพิ่มยี่ห้อรถยนต์');
  	    $('input[name=form_type]').val('create');
        $('#inp_brandid').hide();
        $('input[name=inp_brandid]').hide().val('0');

	}

	function submit_create_user() {

		    $.ajax({
		        url : '/api/v1/brand/create',
		        type : 'post',
		        cache : false,
		        dataType : 'json',
		        data : $('form#form_create').serialize()
	        })
	        .done(function(data) {
	        	// alert(data);
		        if (data.status != 200) {
              gotify(data.message,"Create Failed");
		        }else{
              gotify(data.message,"Create Successful");
		          $('#modal_create').modal('hide');
		          $('#gridBrand').jqxGrid('updatebounddata');
		        }
	        });
    	 return false;
	}

	function gridBrand(){

	    var dataAdapter = new $.jqx.dataAdapter({
			datatype: "json",
	        datafields: [
	            { name: "ID", type: "int" },
	            { name: "BRAND", type: "string" }
	        ],
	        url : '/api/v1/brand/load'
		  });

		  return $("#gridBrand").jqxGrid({
	        width: '1000',
	        source: dataAdapter,
	        autoheight: true,
	        columnsresize: true,
	        pageable: true,
	        filterable: true,
	        showfilterrow: true,
	        theme : 'themeorange2',
	        columns: [
	        	{ text:"รหัสยี่ห้อ", datafield: "ID",width:"10%"},
	        	{ text:"ชื่อยี่ห้อ", datafield: "BRAND"}

	          ]
	  });
	}


</script>
