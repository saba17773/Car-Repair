<?php $this->layout("layouts/main") ?>

<style type="text/css">
	input[type=checkbox] {
    	width: 20px;
      	height: 20px;
  	}
</style>

<h2>ขนาดความจุของเครื่องยนต์</h2>
<button id="btn_create" onclick="return modal_create_open()"  class="btn btn-default" data-backdrop="static" data-toggle="modal" data-target="#modal_create">เพิ่ม</button>
<button class="btn btn-primary" id="edit">แก้ไข</button>
<button class="btn btn-danger" id="delete">ลบ</button>
<hr>

<div id="gridcap"></div>

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
            <label for="inp_capacityid" id="inp_capacityid">รหัส</label>
            <input type="name" name="inp_capacityid" id="inp_capacityid" class="form-control" autocomplete="off" required>
          </div>
          <div class="form-group">
            <label for="inp_capacityname">ขนาดความจุของเครื่องยนต์</label>
            <input type="name" name="inp_capacityname" id="inp_capacityname" class="form-control" autocomplete="off" required>
          </div>

          	<input type="hidden" name="id">
        	<input type="hidden" name="form_type">

          <label>
            <button class="btn btn-primary" id="Save"><i class="glyphicon glyphicon-floppy-save"></i>&nbsp;Save</button>
          </label>
        </form>
      </div>
    </div>
  </div>
</div>
<div id="dialog" title="Delete"><label for="Delete">Are you sure to delete?</label></div>

<script type="text/javascript">
	$('#dialog').hide();
  var session_useredit = '<?php echo $_SESSION["userEdit"] ; ?>';

jQuery(document).ready(function($){

	gridcap();

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
      var rowdata = row_selected("#gridcap");
      if (typeof rowdata !== 'undefined') {

        $('#modal_create').modal({backdrop: 'static'});
        $('input[name=form_type]').val('update');
        $('.modal-title').text('แก้ไขขนาดความจุ');
        $('input[name=inp_capacityid]').show();
        $('#inp_capacityid').show();
        $('input[name=inp_capacityid]').val(rowdata.ID);
        $('input[name=inp_capacityid]').prop('readonly', true);
        $('input[name=inp_capacityname]').val(rowdata.CAPACITY);
        $('input[name=id]').val(rowdata.ID);

      }else{//tan_edit_180625
				alert("กรุณาเลือกรายการ");
			}

  	});

  	$('#delete').on('click', function(e) {
      var rowdata = row_selected("#gridcap");
    	if (typeof rowdata !== 'undefined') {
    		$("#dialog").dialog({
      		buttons : {
        		"OK" : function() {

        		gojax('post', '/api/v1/cap/delete', {id:rowdata.ID})

			    	.done(function(data) {
			    		if (data.status == 200)
						{
							gotify(data.message,"success");
			    			$('#dialog').dialog("close");
			          		$('#gridcap').jqxGrid('updatebounddata');

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
  	    $('.modal-title').text('เพิ่มขนาดความจุ');
  	    $('input[name=form_type]').val('create');
        $('#inp_capacityid').hide();
        $('input[name=inp_capacityid]').hide().val('0');

	}

	function submit_create_user() {

		    $.ajax({
		        url : '/api/v1/cap/create',
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
		          $('#gridcap').jqxGrid('updatebounddata');
		        }
	        });
    	 return false;
	}

	function gridcap(){

	    var dataAdapter = new $.jqx.dataAdapter({
			datatype: "json",
	        datafields: [
	            { name: "ID", type: "int" },
	            { name: "CAPACITY", type: "string" }
	        ],
	        url : '/api/v1/cap/load'
		  });

		  return $("#gridcap").jqxGrid({
	        width: '1000',
	        source: dataAdapter,
	        autoheight: true,
	        columnsresize: true,
	        pageable: true,
	        filterable: true,
	        showfilterrow: true,
	        theme : 'themeorange2',
	        columns: [
	        	{ text:"รหัส", datafield: "ID",width:"10%"},
	        	{ text:"ขนาดความจุของเครื่องยนต์", datafield: "CAPACITY"}

	          ]
	  });
	}


</script>
