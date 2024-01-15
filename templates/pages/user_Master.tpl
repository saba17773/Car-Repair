<?php $this->layout("layouts/main") ?> 
<!-- style -->
	<style type="text/css">
		input[type=checkbox] {
	    	width: 20px;
	      	height: 20px;
	  	} 
	</style>
<!-- Menu Button -->
	<h3>ผู้เข้าใช้งานระบบ</h3>
	<button onclick="return modal_create_open()"  class="btn btn-default btn-sm" data-backdrop="static" data-toggle="modal" data-target="#modal_create">เพิ่ม</button>
	<button class="btn btn-primary btn-sm" id="btn_edit">แก้ไข</button>
	<button class="btn btn-danger btn-sm" id="btn_delete">ลบ</button>
	<hr>
<!-- Html -->
	<div id="griduser"></div>
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
	        <form id="form_create" method="post" action="/api/v1/user/create"  enctype="multipart/form-data">     
		        <div class="form-group">
			        <label for="lab_userid" id="lab_userid">รหัสผู้เข้าใช้งาน</label>
			        <input type="name" name="inp_userid" id="inp_userid" class="form-control" autocomplete="off">
		        </div>
		        <div class="form-group">
		        	<label for="lab_username">Username</label>
		            <input type="name" name="inp_username" id="inp_username" class="form-control" placeholder="Username" autocomplete="off" required>
		        </div>
		        <div class="form-group">
		            <label for="lab_password" id="lab_password">Password</label>
		            <input type="password" name="inp_password" id="inp_password" class="form-control"  placeholder="Password" autocomplete="off" required>
		        </div>
		        <div class="form-group">
		            <label for="lab_employeeid">รหัสพนักงาน</label>
        				<div name="db_employeeid" id="db_employeeid" required>
            				<div id="grid"></div>
        				</div>
		        </div>
		        <div class="form-group">
		            <label for="lab_fullname">ชื่อ-นามสกุล</label>
		            <input type="name" name="inp_fullname" id="inp_fullname" class="form-control" placeholder="ชื่อ-นามสกุล" autocomplete="off" required>
		        </div>
		        <div class="row">
					<div class="col-md-12">
						<label for="lab_email">อีเมลล์</label>
						<div class="input-group">
							<input type="text" name="inp_email" id="inp_email" class="form-control" placeholder="ชื่ออีเมลล์" required>
							<span class="input-group-btn">
								<input type="button" class="btn btn-info" value="@deestone.com">
							</span>
						</div>
					</div>
				</div>			
		      	<label for="lab_secid">ฝ่าย</label>
		        <select name="sel_secid" id="sel_secid" class="form-control" required></select>	     
				<label for="lab_depid">แผนก</label>
		        <select name="sel_depid" id="sel_depid" class="form-control" required></select>	     
		        <label for="lab_posid">ตำแหน่ง</label>
		        <select name="sel_posid" id="sel_posid" class="form-control" required></select>
				<table>
					<tr>
						<td><label for="lab_companyid">บริษัท</label></td>
						<td>&nbsp;&nbsp;&nbsp;</td>
						<td><label for="lab_managerid">หัวหน้า</label></td>
					</tr>
					<tr>
						<td><div id="companyid" type="checked" name="companyid"></div></td>
						<td>&nbsp;&nbsp;&nbsp;</td>
						<td><div id="managerid" type="checked" name="managerid"></div></td>					
					</tr>
				</table>
	         	<div class="form-group">
		            <label for="Active" id="Active">Active</label>&nbsp;&nbsp;&nbsp;&nbsp;
		            <input type="checkbox" name="Active" id="Active" value="1">&nbsp;&nbsp;&nbsp;&nbsp;
		            <label for="lab_UserEdit" id="lab_UserEdit">แก้ไขได้</label>&nbsp;&nbsp;&nbsp;&nbsp;
		            <input type="checkbox" name="inp_UserEdit" id="inp_UserEdit" value="1">
	          	</div>	
	
		        <input type="hidden" name="form_type">
		        <input type="hidden" name="inp_empid">
		        <label>
	              	<button type="submit" class="btn btn-primary" name="signup" id="signup"><i class="glyphicon glyphicon-floppy-save"></i>&nbsp;บันทึก</button>
		        </label>
	        </form>
	      </div>
	    </div>
	  </div>
	</div>
	<div id="dialog" title="ลบข้อมูล"><label for="Delete">ต้องการลบข้อมูลหรือไม่?</label></div>


<script type="text/javascript">
var checkre = '<?php echo urlencode($_GET["check"]); ?>';
// document ready
	jQuery(document).ready(function($){
		griduser();

		if(checkre == 0)
		{
			alert('Usernameซ้ำ กรุณาทำรายการใหม่');
		}
	});
// event begin
	$('#dialog').hide();
	$('#btn_edit').on('click', function(e) {
      var rowdata = row_selected("#griduser");
      if (typeof rowdata !== 'undefined') {
        $('#modal_create').modal({backdrop: 'static'});
        $('input[name=form_type]').val('update');
        $('.modal-title').text('แก้ไขข้อมูลผู้เข้าใช้งานระบบ');
        $('input[name=inp_userid]').show();
        $('#lab_userid').show();
        $('input[name=inp_userid]').val(rowdata.ID);
        $('input[name=inp_userid]').prop('readonly', true);
        $('input[name=inp_username]').val(rowdata.USERNAME);
        $('input[name=inp_password]').hide();
        $('#lab_password').hide();
        $('input[name=inp_password]').val(rowdata.PASSWORD);
        $('input[name=inp_fullname]').val(rowdata.NAME);
 		$('input[name=inp_email]').val(rowdata.EMAIL.slice(0,-13));

        gojax('get', '/api/v1/sec/load')
        	.done(function(data) {
          	$('#sel_secid').html('');
	          	$.each(data, function(index, val) {
	            	$('#sel_secid').append('<option value="'+val.ID+'">'+val.SECTIONDES+'</option>');
	          	});
          	$('#sel_secid').val(rowdata.SECTION);
      	});
        gojax('get', '/api/v1/depart/load')
        	.done(function(data) {
          	$('#sel_depid').html('');
	          	$.each(data, function(index, val) {
	            	$('#sel_depid').append('<option value="'+val.ID+'">'+val.DEPARTMENTDES+'</option>');
	          	});
          	$('#sel_depid').val(rowdata.DEPARTMENT);
      	});        	
        gojax('get', '/api/v1/pos/load')
          	.done(function(data) {
            $('#sel_posid').html('');
	            $.each(data, function(index, val) {
	               $('#sel_posid').append('<option value="'+val.ID+'">'+val.POSITIONDES+'</option>');
	            });
            $('#sel_posid').val(rowdata.POSITION);
        });
// Nattapon_edit_20180710
		$("#grid").on('rowselect', function (event) {
			    var args = event.args;
			    var datarow = $("#grid").jqxGrid('getrowdata', args.rowindex);
			    var dropDownContent = '<div style="position: relative; margin-left: 3px; margin-top: 5px;">' + datarow.CODEMPID+'</div>';

			    	$('input[name=inp_empid]').val(datarow.CODEMPID);
			    	$('input[name=inp_fullname]').val(datarow.EMPNAME+"  "+datarow.EMPLASTNAME);
			    	$('input[name=inp_email]').val(datarow.EMAIL.slice(0,-13));
        $("#db_employeeid").jqxDropDownButton('setContent', dropDownContent);
        $("#db_employeeid").jqxDropDownButton('close');
				});
   			$('#db_employeeid').val(rowdata.EMPLOYEEID);
   			$('input[name=inp_empid]').val(rowdata.EMPLOYEEID);
// End_Nattapon_Edit_20180710
        if (rowdata.STATUS==1){
            $('input[name=Active]').prop('checked' , true);
        }else if(rowdata.STATUS==0){
            $('input[name=Active]').prop('checked' , false);
        }

        if (rowdata.EDIT==1){
            $('input[name=inp_UserEdit]').prop('checked' , true);
        }else if(rowdata.EDIT==0){
            $('input[name=inp_UserEdit]').prop('checked' , false);
        }

        $("#companyid").jqxListBox({width: 250, checkboxes: true, height: 200});
	 	gojax('post', '/api/v1/compedit/load', {userid:rowdata.ID})	
		       	.done(function(data) {
		       	$('#companyid').jqxListBox('refresh');
		        $.each(data, function(index, val) {
		          	$("#companyid").jqxListBox('addItem',{
			           	label: val.INTERNALCODE,
			          	value: val.ID,
		          	}); 
		        if(val.check === 1){
		        	$("#companyid").jqxListBox('checkIndex',index);      
		        }  	           
	        }); 
	 	});

		$("#managerid").jqxListBox({width: 250, checkboxes: true, height: 200});
	 	gojax('post', '/api/v1/manager/load', {userid:rowdata.ID})	
		       	.done(function(data) {
		       	$('#managerid').jqxListBox('refresh');
		        $.each(data, function(index, val) {
		          	$("#managerid").jqxListBox('addItem',{
			           	label: val.NAME,
			          	value: val.ID,
		          	}); 
		        if(val.check === 1){
		        	$("#managerid").jqxListBox('checkIndex',index);      
		        }  	           
	        }); 
	 	});
      }     
  	});

	$('#btn_delete').on('click', function(e) {
      	var rowdata = row_selected("#griduser");
    	if (typeof rowdata !== 'undefined') {
    		$("#dialog").dialog({
      		buttons : {
        		"OK" : function() {
        		gojax('post', '/api/v1/user/delete', {id:rowdata.ID})
			    	.done(function(data) {
			    		if (data.status == 200) 
						{
							gotify(data.message,"success");
			    			$('#dialog').dialog("close");
			          		$('#griduser').jqxGrid('updatebounddata');						            	
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
// event end		
// function Begin
	function modal_create_open(){
  	    $('#form_create').trigger('reset');
  	    $('.modal-title').text('เพิ่มข้อมูลผู้เข้าใช้งานระบบ');
  	    $('input[name=form_type]').val('create');
        $('#lab_password').show();
        $('input[name=inp_password]').show(); 
        $('#lab_userid').hide();
        $('input[name=inp_userid]').hide();
        getSec()
		    .done(function(data) {
		    $('select[name=sel_secid]').html("<option value=''>-- ฝ่าย --</option>");
		      	$.each(data, function(index, val) {
		        $('select[name=sel_secid]').append('<option value="'+val.ID+'">'+val.SECTIONDES+'</option>');
		    });
		});
        getDepart()
		    .done(function(data) {
		    $('select[name=sel_depid]').html("<option value=''>-- แผนก --</option>");
		      	$.each(data, function(index, val) {
		        $('select[name=sel_depid]').append('<option value="'+val.ID+'">'+val.DEPARTMENTDES+'</option>');
		    });
		});
        getPos()
		    .done(function(data) {
		    $('select[name=sel_posid]').html("<option value=''>-- ตำแหน่ง --</option>");
		      	$.each(data, function(index, val) {
		        $('select[name=sel_posid]').append('<option value="'+val.ID+'">'+val.POSITIONDES+'</option>');
		    });
		});
// Nattapon_Edit_20180710
		$("#grid").on('rowselect', function (event) {
		    var args = event.args;
		    var datarow = $("#grid").jqxGrid('getrowdata', args.rowindex);
		    var dropDownContent = '<div style="position: relative; margin-left: 3px; margin-top: 5px;">' + datarow.CODEMPID+'</div>';

		    	$('input[name=inp_empid]').val(datarow.CODEMPID);
		    	$('input[name=inp_fullname]').val(datarow.EMPNAME+'  '+datarow.EMPLASTNAME);
		    	// $('input[name=inp_email]').val(datarow.EMAIL.slice(0,-13));
		    	$("#db_employeeid").jqxDropDownButton('setContent', dropDownContent);
				$("#db_employeeid").jqxDropDownButton('close');
		});
//End_Nattapon_Edit_20180710
	    $("#managerid").jqxListBox({width: 250, checkboxes: true, height: 200});   		
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
		$("#companyid").jqxListBox({width: 250, checkboxes: true, height: 200});   
	 	getCompany()
	       	.done(function(data) {
	       	$('#companyid').jqxListBox('refresh');
	        $.each(data, function(index, val) {
	          	$("#companyid").jqxListBox('addItem',{
		           	label: val.INTERNALCODE,
		          	value: val.ID,
	          	});           
       	 	}); 
	 	}); 
    }
    function getUserManager(){
          	return $.ajax({
	        url : '/api/v1/user/load',
	        type : 'get',
	        dataType : 'json',
	        cache : false
      	});
   	}
   	function getCompany(){
          	return $.ajax({
	        url : '/api/v1/com/load',
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
    function getDepart() {
      	return $.ajax({
	        url : '/api/v1/depart/load',
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
    function griduser(){
	    var dataAdapter = new $.jqx.dataAdapter({
			datatype: "json",
	        datafields: [
	            { 
	            	name: "ID",
	            	type: "int" 
	            },
	            { 
	            	name: "USERNAME", 
	            	type: "string" 
	            },
	            { 
	            	name: "PASSWORD", 
	            	type: "string" 
	            },
	            { 
	            	name: "NAME", 
	            	type: "string" 
	        	},
	            { 
	            	name: "EMAIL", 
	            	type: "string" 
	            },
	            { 
	            	name: "SECTION", 
	            	type: "int" 
	            },
	            { 
	            	name: "SECTIONDES", 
	            	type: "string"
	            },
	            { 
	            	name: "DEPARTMENT", 
	            	type: "int" 
	            },
	            { 
	            	name: "DEPARTMENTDES", 
	            	type: "string"
	            },
	            { 
	            	name: "POSITION", 
	            	type: "int" 
	            },
	            { 
	            	name: "POSITIONDES", 
	            	type: "string"
	            },
	            { 
	            	name: "STATUS", 
	            	type: "int"
	            },
	            { 
	            	name: "EDIT", 
	            	type: "int"
	            },
	            { name: "EMPLOYEEID", type: "int"}
	        ],
	        	url : '/api/v1/user/load'
		 	});

		return $("#griduser").jqxGrid({
	        width: '130%',
	        source: dataAdapter,
	        autoheight: true,
	        columnsresize: true,
	        pageable: true,
	        filterable: true,
	        showfilterrow: true,
	        theme : 'themeorange2',
	        columns: [
	        	{ 
	        		text:"รหัสผู้เข้าใช้งาน", 
	        		datafield: "ID",
	        		width:"5%"
	        	},
	        	{ 
	        		text:"Username", 
	        		datafield: "USERNAME"
	        	},
	        	// { 
	        	// 	text:"Password", 
	        	// 	datafield: "PASSWORD"
	        	// },
	        	{ text: "รหัสพนักงาน", datafield: "EMPLOYEEID"},
	          	{ 
	          		text:"ชื่อ-นามสกุล", 
	          		datafield: "NAME", 
	          		width:"20%"
	          	},
	          	{ 
	          		text:"อีเมลล์", 
	          		datafield: "EMAIL", 
	          		width:"20%"
	          	},
	          	{ 
	          		text:"ฝ่าย", 
	          		datafield: "SECTIONDES", 
	          		width:"10%"
	          	},
	          	{ 
	          		text:"แผนก", 
	          		datafield: "DEPARTMENTDES", 
	          		width:"10%"
	          	},
	          	{ 
	          		text:"ตำแหน่ง", 
	          		datafield: "POSITIONDES", 
	          		width:"10%"
	          	},
	          	{ 
	          		text: 'สถานะ',
	          		datafield: 'STATUS', 
	          		width:"5%", 
	          		filterable: false,
	                cellsrenderer: function (index, datafield, value, defaultvalue, column, rowdata){
	                    var status;
	                       if (value ==1) {
	                           status =  "<div style='padding: 5px; background:#00BB00 ; color:#ffffff;'>Active</div>";
	                       }else{
	                           status =  "<div style='padding: 5px; background:#EE0000 ; color:#ffffff;'>NotActive</div>";
	                       }                    
	                       return status;
	                }
	            },
	          	{ 
	          		text: 'แก้ไขได้',
	          		datafield: 'EDIT', 
	          		width:"6%", 
	          		filterable: false,
	                cellsrenderer: function (index, datafield, value, defaultvalue, column, rowdata){
	                    var status;
	                       if (value ==1) {
	                           status =  "<div style='padding: 5px; background:#00BB00 ; color:#ffffff;'>แก้ไขได้</div>";
	                       }else{
	                           status =  "<div style='padding: 5px; background:#EE0000 ; color:#ffffff;'>ดูอย่างเดียว</div>";
	                       }                    
	                       return status;
	                }
	            }
	        ]
	  });
	}

//Nattapon_Edit_20180710
	$(document).ready(function () {
            var source =
            {
                datatype: "json",
                datafields:
                [
                    { name: "CODEMPID", type: "string"},
                    { name: "EMPNAME", type: "string"},
                    { name: "EMPLASTNAME", type: "string"},
                    { name: "EMAIL", type: "string"}
                ],
                url : '/api/v1/employee/load'
            };
            var dataAdapter = new $.jqx.dataAdapter(source);
            $("#grid").jqxGrid(
             {
                // width: getWidth('Grid'),
               width: '550',
				        source: dataAdapter,
				        autoheight: true,
				        columnsresize: true,
				        pageable: true,
				        filterable: true,
				        showfilterrow: true,
				        theme : 'themeorange2',
				        columns: [
                  { text:"ID", datafield: "CODEMPID",align: 'center'},
                  { text:"Name", datafield: "EMPNAME",align: 'center'},
                  { text:"LastName", datafield: "EMPLASTNAME",align: 'center'},
                  { text:"Email", datafield: "EMAIL",align: 'center'},
                ]
            });
             $("#db_employeeid").jqxDropDownButton({
                width: 562, height: 40
            });
             $("#grid").jqxGrid('selectrow');
        });
// End_Nattapon_Edit_20180710 
// function End
</script>

