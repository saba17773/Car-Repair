<?php $this->layout("layouts/main") ?>

<style type="text/css">
	input[type=checkbox] {
    	width: 20px;
      	height: 20px;
  	}
</style>
<h2>ข้อมูลรถยนต์</h2>
<!-- html Begin -->

<table><tr>
<td><button id="btn_create" onclick="return modal_create_open()"  class="btn btn-default btn-sm" data-backdrop="static" data-toggle="modal" data-target="#modal_create">เพิ่ม</button></td>
<td>&nbsp;<button class="btn btn-primary btn-sm" id="edit">แก้ไข</button></td>
<td>&nbsp;<button class="btn btn-danger btn-sm" id="delete">ลบ</button></td>
<td>&nbsp;<button class="btn btn-info btn-sm" id="detail">รายละเอียด</button></td>

<form onsubmit="return printsub()" method="post" action="/api/v1/report/all" target="_blank" >
  <!-- <input type="hidden" name="RepairID" value="" /> -->
  <input type="hidden" name="inp_carid_report" value="" />
  <input type="hidden" name="type" id="type">
<!--   <td>&nbsp;<button class="btn btn-info btn-sm" type="submit" id="printApproval" onclick="return Approval()">ใบอนุมัติซ่อม</button></td> -->
  <td>&nbsp;<button class="btn btn-success btn-sm" type="submit" id="printItem" onclick="return Item()">ประวัติการซ่อม</button></td>
   <td>&nbsp;<button class="btn btn-warning btn-sm" type="submit" id="bt_claim">เคลมประกัน</button></td>
</form>
</tr>
</table>

<hr>

	<div id="gridCAR"></div>
	<div id="dialog" title="Delete"><label for="Delete">Are you sure to delete?</label></div>

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
	            <label for="inp_carid" id="inp_carid">รหัสรถ</label>
	            <input type="name" name="inp_carid" id="inp_carid" class="form-control" autocomplete="off" required>
	          </div>
	          <label for="inp_brandid">รุ่น</label>
	            <select name="inp_brandid" id="inp_brandid" class="form-control" required></select>
	          <label for="inp_cartypeid">ประเภทรถยนต์</label>
	          	<select name="inp_cartypeid" id="inp_cartypeid" class="form-control" required></select>
	          <label for="inp_registerid">ประเภทการจดทะเบียน</label>
	          	<select name="inp_registerid" id="inp_registerid" class="form-control" required></select>
	          	<label for="lab_asset" id="lab_asset">รหัสทรัพย์สิน</label>
	            <input type="text" name="inp_asset" id="inp_asset" class="form-control" autocomplete="off" required>
	          <label for="sel_capid">ความจุเครื่องยนต์</label>
	            <select name="sel_capid" id="sel_capid" class="form-control" required></select>
	          <label for="sel_driverid">ผู้ดูแลรถ</label>
	            <select name="sel_driverid" id="sel_driverid" class="form-control" required></select>
	          <div class="form-group">
	            <label for="lab_datereg" id="lab_datereg">วันที่จดทะเบียน</label>
	            <input type="text" name="inp_datereg" id="inp_datereg" class="form-control" autocomplete="off" required>

	          </div>
	         <!--  <div class="form-group">
	            <label for="inp_milesno">เลขไมค์</label>
	            <input type="number" name="inp_milesno" id="inp_milesno" class="form-control" autocomplete="off" required>
	          </div> -->
	          <div class="form-group">
	            <label for="inp_regcar">ทะเบียนรถ</label>
	            <input type="name" name="inp_regcar" id="inp_regcar" class="form-control" autocomplete="off" required>
	          </div>
	          <div class="form-group">
	            <label for="sel_regcardes">จังหวัด</label>
	            <select name="sel_regcardes" id="sel_regcardes" class="form-control" required></select>
	          </div>
	          <label for="sel_comid">บริษัท</label>
	            <select name="sel_comid" id="sel_comid" class="form-control" required></select>
	          <label for="sel_secid">ฝ่าย</label>
	          	<select name="sel_secid" id="sel_secid" class="form-control" required></select><br>
	          <label for="milesac">ไม่มีเลขไมล์</label>&nbsp;&nbsp;&nbsp;
	          	<input type="checkbox" name="milesac" id="milesac" value="0"><br><br>

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
	<form action="/CarDetail" method="get" id='CarDetail' name='CarDetail'>
	  <input type="hidden" name="inp_sentid" value="" />
	</form>

	<form action="/ClaimByCar" method="get" id='Claim' name='Claim'>
   	  <input type="hidden" name="inp_sentcarid" value="" />
   	  <input type="hidden" name="inp_sentinsid" value="" />
	</form>
	
<!-- html End -->
<script type="text/javascript">
	var session_useredit = '<?php echo $_SESSION["userEdit"] ; ?>';
// document Begin
	jQuery(document).ready(function($){
		gridCAR();

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
// document End
// event Begin
  $( function() {
	    $( "#inp_datereg" ).datepicker_thai({
	    dateFormat: 'dd-mm-yy',
	    altField:"#h_dateinput",
	    altFormat: "yy-mm-dd",
	    langTh:true,
	    yearTh:true,
	    changeYear: true,
  });
  });
	$('#dialog').hide();

	$('#detail').on('click',function(e) {
		var rowdata = row_selected("#gridCAR");
      	if (typeof rowdata !== 'undefined')
      	{
            event.preventDefault();
            $('input[name=inp_sentid]').val(rowdata.CARID);
            document.forms["CarDetail"].submit();

		}else{
        alert('Please  select data');
    }  
	});

	$('#bt_claim').on('click',function(e) {
		var rowdata = row_selected("#gridCAR");
      	if (typeof rowdata !== 'undefined') 
      	{
            event.preventDefault();
            $('input[name=inp_sentcarid]').val(rowdata.CARID);
            $('input[name=inp_sentinsid]').val(rowdata.INSURANCE);
            document.forms["Claim"].submit();
				}else{
					alert('กรุณาเลือกข้อมูล');
				}

	});

	$('#edit').on('click', function(e) {
      	var rowdata = row_selected("#gridCAR");
      	if (typeof rowdata !== 'undefined') {

	        $('#modal_create').modal({backdrop: 'static'});
	        $('input[name=form_type]').val('update');
	        $('.modal-title').text('แก้ไขข้อมูลรถ');
	        $('input[name=inp_carid]').show();
	        $('#inp_carid').show();
	        $('input[name=inp_carid]').val(rowdata.CARID);
	        $('input[name=id]').val(rowdata.ID);
	        $('input[name=inp_carid]').prop('readonly', true);

	        gojax('get', '/api/v1/brand/load')
	          .done(function(data) {
	            $('#inp_brandid').html('');
	            $.each(data, function(index, val) {
	               $('#inp_brandid').append('<option value="'+val.ID+'">'+val.BRAND+'</option>');
	            });
	            $('#inp_brandid').val(rowdata.BRAND);
	        });
	        gojax('get', '/api/v1/carType/load')
	          .done(function(data) {
	            $('#inp_cartypeid').html('');
	            $.each(data, function(index, val) {
	               $('#inp_cartypeid').append('<option value="'+val.ID+'">'+val.CARTYPE+'</option>');
	            });
	            $('#inp_cartypeid').val(rowdata.CARTYPE);
	        });
	        gojax('get', '/api/v1/regi/load')
	          .done(function(data) {
	            $('#inp_registerid').html('');
	            $.each(data, function(index, val) {
	               $('#inp_registerid').append('<option value="'+val.ID+'">'+val.REGISTERTYPE+'</option>');
	            });
	            $('#inp_registerid').val(rowdata.REGISTERTYPE);
	        });
	        gojax('get', '/api/v1/driver/load')
	          .done(function(data) {
	            $('#sel_driverid').html('');
	            $.each(data, function(index, val) {
	               $('#sel_driverid').append('<option value="'+val.dm_id+'">'+val.DRIVERNAME+'</option>');
	            });
	            $('#sel_driverid').val(rowdata.DRIVER);
	        });
	        gojax('get', '/api/v1/sec/load')
	          .done(function(data) {
	            $('#sel_secid').html('');
	            $.each(data, function(index, val) {
	               $('#sel_secid').append('<option value="'+val.ID+'">'+val.SECTIONDES+'</option>');
	            });
	            $('#sel_secid').val(rowdata.SECTION);
	        });
	        gojax('get', '/api/v1/com/load')
	          .done(function(data) {
	            $('#sel_comid').html('');
	            $.each(data, function(index, val) {
	               $('#sel_comid').append('<option value="'+val.ID+'">'+val.DESCRIPTION+'</option>');
	            });
	            $('#sel_comid').val(rowdata.COMPANY);
	        });
	        gojax('get', '/api/v1/cap/load')
	          .done(function(data) {
	            $('#sel_capid').html('');
	            $.each(data, function(index, val) {
	               $('#sel_capid').append('<option value="'+val.ID+'">'+val.CAPACITY+'</option>');
	            });
	            $('#sel_capid').val(rowdata.CAPACITY);
	        });
	        gojax('get', '/api/v1/province/load')
	          .done(function(data) {
	            $('#sel_regcardes').html('');
	            $.each(data, function(index, val) {
	               $('#sel_regcardes').append('<option value="'+val.ID+'">'+val.PRVTH+'</option>');
	            });
	            $('#sel_regcardes').val(rowdata.REGCARDES);
	        });
	        DATEREG = new Date(rowdata.DATEREG);
			var month = DATEREG.getMonth();
			var date = DATEREG.getDate();
			month = month+1;
			if(month.toString().length==1){
				month = ("0"+month);
			}if(month.toString().length==2){
				month = month;
			}
			if(date.toString().length==1){
				date = ("0"+date);
			}
			$('input[name=inp_datereg]').val(date + "-" + month + "-" + DATEREG.getFullYear());
	        // $('input[name=inp_datereg]').val(rowdata.DATEREG);
	        $('input[name=inp_regcar]').val(rowdata.REGCAR);
	        $('input[name=inp_asset]').val(rowdata.ASSET);
	        // $('input[name=inp_milesno]').val(rowdata.MILESNO);
	        if (rowdata.MILESCHECK==1){
            	$('input[name=milesac]').prop('checked' , true);
		    }else if(rowdata.MILESCHECK==0){
		        $('input[name=milesac]').prop('checked' , false);
		    }

    	} else{
        alert('Please  select data');
    }  

  	});

  	$('#delete').on('click', function(e) {
      	var rowdata = row_selected("#gridCAR");
    	if (typeof rowdata !== 'undefined') {
    		$("#dialog").dialog({
      		buttons : {
        		"OK" : function() {

        		gojax('post', '/api/v1/car/delete', {id:rowdata.ID})

			    	.done(function(data) {
			    		if (data.status == 200)
						{
							gotify(data.message,"success");
			    			$('#dialog').dialog("close");
			          		$('#gridCAR').jqxGrid('updatebounddata');

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

      	} else{
        alert('Please  select data');
    }  
  	});
// event End
// function Begin
	function printsub(){
      var rowdata = row_selected('#gridCAR');
      if(!!rowdata){
          $('input[name=inp_carid_report]').val(rowdata.CARID);
          return true;
      }else{
          alert('Please  select data');
          return false;
      }
   	}
	function Item() {
    	$('#type').val(2);
  	}
  	function getCompany() {
	    return $.ajax({
	      url : '/api/v1/com/load',
	      type : 'get',
	      dataType : 'json',
	      cache : false
	    });
	}
	function getSection() {
	    return $.ajax({
	      url : '/api/v1/sec/load',
	      type : 'get',
	      dataType : 'json',
	      cache : false
	    });
	}
	function getBrand() {
	    return $.ajax({
	      url : '/api/v1/brand/load',
	      type : 'get',
	      dataType : 'json',
	      cache : false
	    });
	}
	function getcarType() {
	    return $.ajax({
	      url : '/api/v1/carType/load',
	      type : 'get',
	      dataType : 'json',
	      cache : false
	    });
	}
	function getRegisterType() {
	    return $.ajax({
	      url : '/api/v1/regi/load',
	      type : 'get',
	      dataType : 'json',
	      cache : false
	    });
	}
	function getCapacity() {
	    return $.ajax({
	      url : '/api/v1/cap/load',
	      type : 'get',
	      dataType : 'json',
	      cache : false
	    });
	}
	function getDriver() {
	    return $.ajax({
	      url : '/api/v1/driver/load',
	      type : 'get',
	      dataType : 'json',
	      cache : false
	    });
	}
	function getProvince() {
	    return $.ajax({
	      url : '/api/v1/province/load',
	      type : 'get',
	      dataType : 'json',
	      cache : false
	    });
	}
	function modal_create_open(){
  	    $('#form_create').trigger('reset');
  	    $('.modal-title').text('เพิ่มข้อมูลรถยนต์');
  	    $('input[name=form_type]').val('create');
        $('#inp_carid').hide();
        $('input[name=inp_carid]').hide().val('0');
        $('input[name=inp_carid]').prop('readonly', true);
        $('#inp_brandid').val('');
        $('#inp_cartypeid').val('');
        $('#inp_registerid').val('');
        $('#sel_capid').val('');

	    getBrand()
		      .done(function(data) {
		        $('select[name=inp_brandid]').html("<option value=''>-- Select --</option>");
		        $.each(data, function(index, val) {
		          $('select[name=inp_brandid]').append('<option value="'+val.ID+'">'+val.BRAND+'</option>');
		        });
		});
		getcarType()
		      .done(function(data) {
		        $('select[name=inp_cartypeid]').html("<option value=''>-- Select --</option>");
		        $.each(data, function(index, val) {
		          $('select[name=inp_cartypeid]').append('<option value="'+val.ID+'">'+val.CARTYPE+'</option>');
		        });
		});
		getRegisterType()
		      .done(function(data) {
		        $('select[name=inp_registerid]').html("<option value=''>-- Select --</option>");
		        $.each(data, function(index, val) {
		          $('select[name=inp_registerid]').append('<option value="'+val.ID+'">'+val.REGISTERTYPE+'</option>');
		        });
		});
		getCapacity()
		      .done(function(data) {
		        $('select[name=sel_capid]').html("<option value=''>-- Select --</option>");
		        $.each(data, function(index, val) {
		          $('select[name=sel_capid]').append('<option value="'+val.ID+'">'+val.CAPACITY+'</option>');
		        });
		});
		getCompany()
			.done(function(data) {
		        $('select[name=sel_comid]').html("<option value=''>-- Select --</option>");
		        $.each(data, function(index, val) {
		          $('select[name=sel_comid]').append('<option value="'+val.ID+'">'+val.DESCRIPTION+'</option>');
		    });
		});
		getSection()
		      .done(function(data) {
		        $('select[name=sel_secid]').html("<option value=''>-- Select --</option>");
		        $.each(data, function(index, val) {
		          $('select[name=sel_secid]').append('<option value="'+val.ID+'">'+val.SECTIONDES+'</option>');
		        });
		});
		getDriver()
		      .done(function(data) {
		        $('select[name=sel_driverid]').html("<option value=''>-- Select --</option>");
		        $.each(data, function(index, val) {
		          $('select[name=sel_driverid]').append('<option value="'+val.dm_id+'">'+val.DRIVERNAME+'</option>');
		        });
		});
		getProvince()
		      .done(function(data) {
		        $('select[name=sel_regcardes]').html("<option value=''>-- Select --</option>");
		        $.each(data, function(index, val) {
		          $('select[name=sel_regcardes]').append('<option value="'+val.ID+'">'+val.PRVTH+'</option>');
		        });
		});


	}

	function submit_create_user() {

		    $.ajax({
		        url : '/api/v1/car/create',
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
		          $('#gridCAR').jqxGrid('updatebounddata');
		        }
	        });
    	 return false;
	}

	function gridCAR(){

	    var dataAdapter = new $.jqx.dataAdapter({
			datatype: "json",
	        datafields: [
	            { name: "ID", type: "int" },
	            { name: "CARID", type: "string" },
	            { name: "BRAND", type: "int" },
	            { name: "CARTYPE", type: "int" },
	            { name: "REGISTERTYPE", type: "int" },
	            { name: "CAPACITY", type: "int" },
	            { name: "DRIVER", type: "int" },
	            { name: "DATEREG", type: "date", cellsformat: "dd-MM-yyyy" },
	            // { name: "MILESNO", type: "string" },
	            { name: "MILESCHECK", type: "int"},
	            { name: "ASSET", type: "string"},
	            { name: "REGCAR", type: "string" },
	            { name: "REGCARDES", type: "string" },
	            { name: "PRVTH", type: "string" },
	            { name: "COMPANY", type: "int" },
	            { name: "SECTION", type: "int" },
	            { name: "BRANDNAME", type: "string" },
	            { name: "CARTYPENAME", type: "string" },
	            { name: "REGISTERTYPENAME", type: "string" },
	            { name: "CAPACITYNAME", type: "string" },
	            { name: "COMPANYNAME", type: "string" },
	            { name: "SECTIONDES", type: "string" },
	            { name: "DRIVERNAME", type: "string" },
	            { name: "INSURANCEDES", type: "string" },
	            { name: "INSURANCE", type: "string" },
	            { name: "INS", type: "date", cellsformat: "dd-MM-yyyy" },
	            { name: "STATUS_INS", type: "string" },
	            { name: "TAX", type: "datetime" },
				{ name: "STATUS_TAX", type: "int" },
	            { name: "ACT", type: "datetime" },
				{ name: "STATUS_ACT", type: "int" }

	        ],
	        url : '/api/v1/car/load'
		  });

		  return $("#gridCAR").jqxGrid({
	        width: '190%',
	        source: dataAdapter,
	        autoheight: true,
	        columnsresize: true,
	        pageable: true,
	        filterable: true,
	        showfilterrow: true,
	        theme : 'themeorange2',
	        columns: [
	        	{ text:"รหัสรถ", datafield: "CARID",width:"3%"},
	        	{ text:"รหัสทรัพย์สิน", datafield: "ASSET",width:"4%"},
	        	{ text:"รุ่น", datafield: "BRANDNAME",width:"7%"},
	        	{ text:"ประเภทรถยนต์", datafield: "CARTYPENAME",width:"7%"},
	        	{ text:"ประเภทการจดทะเบียน", datafield: "REGISTERTYPENAME",width:"10%"},
	        	{ text:"ทะเบียนรถ", datafield: "REGCAR",width:"8%"},
	        	{ text:"จังหวัด", datafield: "PRVTH",width:"5%"},
	        	// { text:"เลขไมล์", datafield: "MILESNO",width:"5%"},
	        	{ text:"ผู้ดูแลรถ", datafield: "DRIVERNAME",width:"10%"},
	        	{ text:"ไม่มีเลขไมล์", datafield: "MILESCHECK", columntype: 'checkbox', cellsalign: 'center', align: 'center'},
	        	{ text:"ฝ่าย", datafield: "SECTIONDES",width:"5%"},
	        	{ text:"บริษัท", datafield: "COMPANYNAME",width:"10%"},
	        	{ text:"วันที่จดทะเบียน", datafield: "DATEREG",width:"5%", cellsformat: "dd-MM-yyyy"},
	        	{ text:"บริษัทประกันภัย", datafield: "INSURANCEDES",width:"15%"},
	        	{ text:"ประกันภัย", datafield: "INS", width:"5%", filterable: false, align: 'center', cellsformat: "dd-MM-yyyy"},
	        	{ text: 'สถานะ',datafield:  'STATUS_INS' , width:"3%", filterable: false, align: 'center',
	                cellsrenderer: function (index, datafield, value, defaultvalue, column, rowdata){
	                    var status;
	                       if (value ==1) {
	                           status =  "<div style='padding: 5px; background:#00BB00 ; color:#ffffff;'>TURE</div>";
	                       }else if (value ==0){
	                           status =  "<div style='padding: 5px; background:#EE0000 ; color:#ffffff;'>FALSE</div>";
	                       }else{
	                           status =  "";
	                       }
	                       return status;
	                }
	            },
	            { text:"ภาษี", datafield: "TAX", width:"5%", filterable: false, align: 'center'},
	        	{ text: 'สถานะ',datafield:  'STATUS_TAX' , width:"3%", filterable: false, align: 'center',
	                cellsrenderer: function (index, datafield, value, defaultvalue, column, rowdata){
	                    var status;
	                       if (value ==1) {
	                           status =  "<div style='padding: 5px; background:#00BB00 ; color:#ffffff;'>TURE</div>";
	                       }else if (value ==0){
	                           status =  "<div style='padding: 5px; background:#EE0000 ; color:#ffffff;'>FALSE</div>";
	                       }else{
	                           status =  "";
	                       }
	                       return status;
	                }
	            },
	            { text:"พ.ร.บ.", datafield: "ACT", width:"5%", filterable: false, align: 'center' },
	        	{ text: 'สถานะ',datafield:  'STATUS_ACT' , width:"3%", filterable: false, align: 'center',
	                cellsrenderer: function (index, datafield, value, defaultvalue, column, rowdata){
	                    var status;
	                       if (value ==1) {
	                           status =  "<div style='padding: 5px; background:#00BB00 ; color:#ffffff;'>TURE</div>";
	                       }else if (value ==0){
	                           status =  "<div style='padding: 5px; background:#EE0000 ; color:#ffffff;'>FALSE</div>";
	                       }else{
	                           status =  "";
	                       }
	                       return status;
	                }
	            }
	          ]
	  });
	}
// function End

</script>
