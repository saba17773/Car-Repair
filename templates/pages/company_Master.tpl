<?php $this->layout("layouts/main") ?>

<style type="text/css">
	input[type=checkbox] {
    	width: 20px;
      	height: 20px;
  	} 
</style>

<h2>บริษัท</h2>

<button id="btn_create" onclick="return modal_create_open()"  class="btn btn-default" data-backdrop="static" data-toggle="modal" data-target="#modal_create">เพิ่ม</button>
<button class="btn btn-primary" id="edit">แก้ไข</button>
<button class="btn btn-danger" id="delete">ลบ</button>
<hr>

<div id="gridcom"></div>

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
            <label for="inp_companyid"  id="inp_companyid">รหัสบริษัท</label>
            <input type="name" name="inp_companyid" id="inp_companyid" class="form-control" autocomplete="off" required>
          </div>
          <div class="form-group">
            <label for="inp_internalcode">โค้ดบริษัท</label>
            <input type="name" name="inp_internalcode" id="inp_internalcode" maxlength=3 class="form-control" autocomplete="off" required>
          </div>
          <div class="form-group">
            <label for="inp_description">ชื่อบริษัท-EN</label>
            <input type="name" name="inp_description" id="inp_description" maxlength=50 class="form-control" autocomplete="off" required>
          </div>
          <div class="form-group">
            <label for="inp_descriptionth">ชื่อบริษัท-TH</label>
            <input type="name" name="inp_descriptionth" id="inp_descriptionth" maxlength=50 class="form-control" autocomplete="off" required>
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
  var session_useredit = '<?php echo $_SESSION["userEdit"] ; ?>';

jQuery(document).ready(function($){
  
    Getgridcom();
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

	$('#dialog').hide();

	$('#edit').on('click', function(e) {
      var rowdata = row_selected("#gridcom");
      if (typeof rowdata !== 'undefined') {

        $('#modal_create').modal({backdrop: 'static'});
        $('input[name=form_type]').val('update');
        $('.modal-title').text('แก้ไขบริษัท');
        $('input[name=inp_companyid]').show();
        $('#inp_companyid').show();
        $('input[name=id]').val(rowdata.ID);
        $('input[name=inp_companyid]').val(rowdata.ID);
        $('input[name=inp_companyid]').prop('readonly', true);
        $('input[name=inp_internalcode]').val(rowdata.INTERNALCODE);
        $('input[name=inp_description]').val(rowdata.DESCRIPTION);
        $('input[name=inp_descriptionth]').val(rowdata.DESCRIPTIONTH);

      }
      
  	});

function modal_create_open(){

    $('#form_create').trigger('reset');
    $('.modal-title').text('เพิ่มบริษัท');
    $('input[name=form_type]').val('create');
    $('#inp_companyid').hide();
    $('input[name=inp_companyid]').hide().val('0');

}

function submit_create_user() {
    		
		    $.ajax({
		        url : '/api/v1/com/create',
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
		          $('#gridcom').jqxGrid('updatebounddata');
		        }
	        });
    	 return false;
}

$('#delete').on('click', function(e) {
    var rowdata = row_selected("#gridcom");
    if (typeof rowdata !== 'undefined') {
    	$("#dialog").dialog({
      		buttons : {
        		"OK" : function() {

        	gojax('post', '/api/v1/com/delete', {id:rowdata.ID})

			    .done(function(data) {
			    	if (data.status == 200) 
					{
						gotify(data.message,"success");
			    		$('#dialog').dialog("close");
			          	$('#gridcom').jqxGrid('updatebounddata');
						            	
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

function Getgridcom(){

    var dataAdapter = new $.jqx.dataAdapter({
    datatype: "json",
        datafields: [
            { name: "ID", type: "int" },
            { name: "INTERNALCODE", type: "string" },
            { name: "DESCRIPTION", type: "string" },
            { name: "DESCRIPTIONTH", type: "string"}
        ],
        url : '/api/v1/com/load'
    });

    return $("#gridcom").jqxGrid({
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
          { text:"โค้ดบริษัท", datafield: "INTERNALCODE", width: "10%"},
          { text:"บริษัท-EN", datafield: "DESCRIPTION"},
          { text:"บริษัท-TH", datafield: "DESCRIPTIONTH"}
            
          ]
    });

	}

</script>

