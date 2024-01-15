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
</style>
<h2>เคลมประกัน</h2>

<!-- menu -->
	<button id="btn_create" onclick="return modal_create_open()"  class="btn btn-default btn-sm" data-backdrop="static" data-toggle="modal" data-target="#modal_create">เพิ่ม</button>
	<button class="btn btn-primary btn-sm" id="btn_edit">แก้ไข</button>
	<button class="btn btn-danger btn-sm" id="btn_delete">ลบ</button>
	<hr>

<!-- grid -->
	<div id="gridClaim"></div><br>

<!-- popup create -->
	<div class="modal" id="dialogpic">
	  	<div id="claimpic"></div>
	  </div>
	</div>

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
	        <form id="form_create" method="post" action="/api/v1/claimbycar/create"  enctype="multipart/form-data">
	          
	          	<div class="form-group">
	            	<label for="lab_claimid" id="lab_claimid">เลขที่เคลม</label>
	            	<input type="name" name="inp_claimid" id="inp_claimid" class="form-control" autocomplete="off" required>
	          	</div>
	          	<div class="form-group">
            	<label for="lab_insid" id="lab_insid">บริษัทประกันภัย</label>
            		<input type="name" name="inp_insname" id="inp_insname" class="form-control" autocomplete="off" required>
				</div>
            	<div class="form-group">
	            	<label for="lab_claimdate" id="lab_claimdate">วันที่เคลม</label>
	            	<input type="text" name="inp_claimdate" id="inp_claimdate" class="form-control" autocomplete="off" required>
	          	</div>
	          	<div class="form-group">
	          		<label for="lab_detail" id="lab_detail">รายละเอียดการเคลม</label>
		            <textarea class="form-control input-sm" rows="5" name="text_detail" id="text_detail" required></textarea>
		        </div>
				<div class="form-group">
	              <label class="form-group">แนบไฟล์</label>
	                  <input name="inp_but_upload" id="inp_but_upload" type="button" class="btn" value="+" ><br>
	                  <div class="well">
	                    <span id="mySpan"></span>
	                  </div>
	                  <div id= "show_file"></div>
	            </div>

				<input type="hidden" name="inp_insid">
	        	<input type="hidden" name="form_type">
	        	<input type="hidden" name="inp_carid">

	          <label>
	            <button class="btn btn-primary" id="Save"><i class="glyphicon glyphicon-floppy-save"></i>&nbsp;บันทึก</button>
	          </label>

	        </form>
	      </div>
	    </div>
	  </div>
	</div>
	<div id="dialog" title="ลบข้อมูลการเครม"><label for="Delete">ต้องการลบข้อมูลหรือไม่?</label></div>


<div id="dataTable"></div>
<script type="text/javascript">
  var session_useredit = '<?php echo $_SESSION["userEdit"] ; ?>';
  var carid = '<?php echo urlencode($_GET["inp_sentcarid"]); ?>';
  var insid = '<?php echo urlencode($_GET["inp_sentinsid"]); ?>';
  
jQuery(document).ready(function($){
	gridClaim(carid);

	if(session_useredit != 1)
    { 
      document.getElementById("btn_create").disabled = true;  
      document.getElementById("btn_edit").disabled = true;
      document.getElementById("btn_delete").disabled = true;  
    }
    else
    {
      document.getElementById("btn_create").disabled = false;  
      document.getElementById("btn_edit").disabled = false;
      document.getElementById("btn_delete").disabled = false;  
    }

});

// event begin
    $( function() {
    $( "#inp_claimdate" ).datepicker_thai({
    dateFormat: 'dd-mm-yy',
    altField:"#h_dateinput",
    altFormat: "yy-mm-dd",
    langTh:true,
    yearTh:true,
  });
  });

	$('#dialog').hide();

  	$('#btn_edit').on('click',function(e) {
	    var rowdata = row_selected("#gridClaim");
	    if (typeof rowdata !== 'undefined') 
	    {
	    	$('#modal_create').modal({backdrop: 'static'});
		    $('input[name=form_type]').val('update');
		    $('.modal-title').text('แก้ไขรายละเอียด');
		    $('input[name=inp_claimid]').prop('readonly', true);
		    $('input[name=inp_claimid]').val(rowdata.CLAIMID);
		    $('#lab_claimid').show();
        	$('input[name=inp_claimid]').show();
        	$('input[name=inp_insname]').prop('readonly', true);
        	$('input[name=inp_carid]').val(carid);
        	gojax('post', '/api/v1/claim/insedit', {insid:rowdata.INSURANCE})
		      .done(function(data) {
		        $.each(data, function(index, val) {
		        	$('input[name=inp_insid]').val(val.ID);
		          	$('input[name=inp_insname]').val(val.INSURANCEDES);
		        });
		    });  
   			

		    CLAIMDATE = new Date(rowdata.CLAIMDATE);
		    // alert(REPAIRDATE);
		    var month = CLAIMDATE.getMonth();
		    var date = CLAIMDATE.getDate();
		    if(date.toString().length==1){
		    	date = ("0"+date);
		    }
		    if(month.toString().length==1){
		    	month = ("0"+(month+1));
		    }
		    	month = month;
		    $('input[name=inp_claimdate]').val(date + "-" + month + "-" + CLAIMDATE.getFullYear());
		    // $('input[name=inp_claimdate]').val(rowdata.CLAIMDATE);
		    $('textarea[name=text_detail]').val(rowdata.CLAIMDETAIL);  

	        $('#show_file').html('');
	        loadfile(rowdata.CLAIMID);

	    }
	    else
	    {
	      alert('Please  select data');
	    } 
	});

	$('#btn_delete').on('click', function(e) {
    var rowdata = row_selected("#gridClaim");
      if (typeof rowdata !== 'undefined') {
        $("#dialog").dialog({
          buttons : {
            "OK" : function() {

            gojax('post', '/api/v1/claim/delete', {claimid:rowdata.CLAIMID})

            .done(function(data) {
              if (data.status == 200) 
            {
              gotify(data.message,"success");
                $('#dialog').dialog("close");
                    $('#gridClaim').jqxGrid('updatebounddata');
                          
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

	var num =1;
	$('#inp_but_upload').bind('click',function(){
	      var add ="add"+num;
	      var add1 ="add1"+num;
	      var br1 = "br1"+num;
	      $('#mySpan').append("<button id='"+add+"' onclick='removeEle("+add+','+add1+','+br1+ ")' type='button' class='btn'>-</button><input type='file' name='inp_but_upload[]' id='"+add1+"'><br id='"+br1+"'>");
	      num++;

	});  		
// event end


// function begin
  function removeEle(divid,_divid)
  {
      $(divid).remove(); 
      $(_divid).remove();
  }
	function loadfile(claimid)
	{

		$('#show_file').html('');
	    gojax('get', '/api/v1/claimfile/load',{id:claimid})
	      .done(function(data) {
	        $.each(data, function(index, val) {
	          var  id = data[index].ID;
	          var  filename = data[index].FILENAME;
	            $('#show_file').append("<button type='button' class='btn btn-info btn-xs'  onclick=deletefile('"+filename+"','" + claimid +"')>-</button><a target='_blank' href='upload/" + data[index].FILENAME + "'>" + data[index].FILENAMEORIGINAL + "</a><br>");
	        });
		});
	}
  function deletefile(filename,claimid)
  {
      $.ajax({
              url : '/api/v1/claimfile/delete',
              type : 'post',
              cache : false,
              dataType : 'json',
              data : {
                  filename : filename
              }
            })
            .done(function(data) {

              if (data.status != 200) {
                gotify(data.message,"danger");
              }else{
                loadfile(claimid);
              }
            }).fail(function(data){
        });

  }

	function gridClaim(carid){
		
	    var dataAdapter = new $.jqx.dataAdapter({
			datatype: "json",
	        datafields: [
	       	 	{ name: "ID", type: "int" },
	            { name: "CLAIMID", type: "string" },
	            { name: "CARID", type: "string" },
	            { name: "REGCAR", type: "string" },
	            { name: "INSURANCE", type: "int" },
	            { name: "INSURANCEDES", type: "string" }, 
	            { name: "CLAIMDATE", type: "date", cellsformat: "dd-MM-yyyy" },
	            { name: "CLAIMDETAIL", type: "string" }
	        ],
	        url : '/api/v1/claimbycar/load?carid='+carid,
		});

		var setPicture = function (row, column, value) {
				if (value !== "") {
			     return "<div style='padding:4px;'>" + value + "</div>";
			 	}else {
			     return "<div align='center' style='font-size: 0.9em; padding:-2px 1px 1px 40px;'><button onclick='return setPictureModal("+row+")' ><span class='glyphicon glyphicon-search' style='font-size:15px;'></span></button></div>";
			    }
			}

		return $("#gridClaim").jqxGrid({
	        width: '130%',
	        source: dataAdapter,
	        autoheight: true,
	        columnsresize: true,
	        pageable: true,
	        filterable: true,
	        showfilterrow: true,
	        theme : 'themeorange2',
	        columns: [
	        	{ text:"เลขที่เคลม",datafield: "CLAIMID",width:"10%"},
	        	{ text:"ทะเบียนรถ",datafield: "REGCAR"},
	        	{ text:"บริษัทประกันภัย", datafield: "INSURANCEDES"},
	        	{ text:"วันที่เคลม", datafield: "CLAIMDATE",cellsformat: "dd-MM-yyyy"},
	        	{ text:"รายละเอียดการเคลม", datafield: "CLAIMDETAIL"},
	        	{ text:"รูปการเคลม", cellsrenderer : setPicture, width:"6%" }          	
	        ]
	  	});
	}

	function modal_create_open(){
	    $('#form_create').trigger('reset');
	    $('.modal-title').text('สร้างรายการเคลม');
	    $('input[name=form_type]').val('create');
	    $('#lab_claimid').hide();
        $('input[name=inp_claimid]').hide().val('0');
 		$('#show_file').html('');
        $('input[name=inp_insname]').prop('readonly', true);
        $('#inp_carid').hide();
        $('input[name=inp_carid]').val(carid);
        $('#lab_insid').hide();
        $('#inp_insname').hide();
        $('input[name=inp_insid]').val(insid);
	}

	function setPictureModal(row) {
	 	var selectedrowindex = $("#gridClaim").jqxGrid('getselectedrowindex');
	 	var datarow = $("#gridClaim").jqxGrid('getrowdata', row);
		var idclaim = datarow.CLAIMID;
		if (!!idclaim) {
		    // $("#dialogpic").dialog({width: "340px"});

		      $.ajax({
		        url : '/api/v1/load/picture',
		        type : 'get',
		        cache : false,
		        dataType : 'json',
		        data : {
		          idclaim  : idclaim
		        },
		        success: function (data) {
		        	$("#dialogpic").dialog({width: "640px"}); // ขนาด dialog
		        	 $(".ui-dialog-title").text("รูปภาพการเคลม");
		        	 $('#claimpic').html('');
						$("#dialogpic").dialog({
							width: "640px",
					        buttons : {
					            "Close" : function() {
					                $(this).dialog("close");
					          	}
					        }
					    });

			        for (var i = 0; i <= data.length-1; i++) {
		              	var parent    = document.getElementById('claimpic'),
		              	imagePath = "/upload/"+data[i].FILENAME,
		              	img;
		              	img = new Image();
		              	img.src = imagePath;
		              	img.width = 300; // ขนาดภาพ
		              	img.height = 200; // ขนาดภาพ
		              	parent.appendChild(img);
			        }

			    },	
	            error: function (data) {
	            	alert("ไม่พบข้อมูล");
	            }
		      });
		}
	}





// function end	
</script>