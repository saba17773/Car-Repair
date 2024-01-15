<?php $this->layout("layouts/main") ?>
<?php 
  if (!isset($_GET["inp_sentid"])) {
    echo "no params";
    exit();
  }
?>  
<style type="text/css">
	input[type=checkbox] {
    	width: 20px;
      	height: 20px;
  	} 
</style>

<h2>รายละเอียด</h2>

  <button class="btn btn-info btn-xs" id="create">เพิ่ม</button>
  <button class="btn btn-warning btn-xs" id="edit">แก้ไข</button>
  <button class="btn btn-danger btn-xs" id="delete">ลบ</button>
  <br><br>

<!-- Filter -->
  <label for="Filter">Filter : 
    <select name="sel_detailtype" id="sel_detailtype">
      <option value="">All</option>
      <option value="INS">ประกันภัย</option>
      <option value="TAX">ภาษี</option>    
      <option value="ACT">พ.ร.บ.</option>
      <option value="IMG">รูปรถ</option>
  </select></label>
<input type="hidden" name="Typeid">
<div id="gridCarDetail"></div>

<!-- Popup create -->
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
          <!-- <form id="form_create" onsubmit="return submit_create_detail()"> -->
          <form id="form_create" method="post" action="/api/v1/Detail/create"  enctype="multipart/form-data">
            <div class="form-group">
              <label for="inp_detailid" id="inp_detailid">Detail No.</label>
              <input type="name" name="inp_detailid" id="inp_detailid" class="form-control" autocomplete="off" required>
            </div>
            <label for="lab_type" id="lab_type">ประเภท</label>
            <select name="sel_type" id="sel_type" class="form-control">
              <option value="INS">ประกันภัย</option>
              <option value="TAX">ภาษี</option>
              <option value="ACT">พรบ.</option>
              <option value="IMG">รูปรถ</option>
            </select>
            <br>
            <label for="lab_insuranceid" id="lab_insuranceid">บริษัทประกันภัย</label>
              <select name="sel_insuranceid" id="sel_insuranceid" class="form-control"></select>
            <br>
            <div class="form-group">
              <label for="lab_createdate" id="lab_createdate">วันที่ต่อ</label>
              <input type="text" name="inp_createdate" id="inp_createdate" class="form-control" autocomplete="off" required>
            </div>
            <div class="form-group">
              <label for="lab_closingdate" id="lab_closingdate">วันที่สิ้นสุด</label>
              <input type="text" name="inp_closingdate" id="inp_closingdate" class="form-control" autocomplete="off" required>
            </div>
             <div class="form-group">
              <label for="inp_status" id="inp_status">Active</label>&nbsp;&nbsp;&nbsp;&nbsp;
              <input type="checkbox" name="inp_status" id="inp_status" value="1">
            </div>
            <div class="form-group">
              <label class="form-group">แนบไฟล์</label>
                  <input name="inp_but_upload" id="inp_but_upload" type="button" class="btn" value="+" ><br>
                  <div class="well">
                    <span id="mySpan"></span>
                  </div>
                  <div id= "show_file"></div>
            </div>
            <input type="hidden" name="id">
            <input type="hidden" name="inp_type">
            <input type="hidden" name="inp_carid">
            <input type="hidden" name="form_type">

            <label>

              <button type="submit" class="btn btn-primary" name="signup" id="signup"><i class="glyphicon glyphicon-floppy-save"></i>&nbsp;Save</button>
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

var carid = '<?php echo urlencode($_GET["inp_sentid"]); ?>';
jQuery(document).ready(function($) {
  loadgrid(carid);

  if(session_useredit != 1)
  { 
    document.getElementById("create").disabled = true;  
    document.getElementById("edit").disabled = true;
    document.getElementById("delete").disabled = true;  
  }
  else
  {
    document.getElementById("create").disabled = false;  
    document.getElementById("edit").disabled = false;
    document.getElementById("delete").disabled = false;  
  }
      
});
  $( function() {
    $( "#inp_createdate" ).datepicker_thai({
    dateFormat: 'dd-mm-yy',
    altField:"#h_dateinput",
    altFormat: "yy-mm-dd",
    langTh:true,
    yearTh:true,
    changeYear: true,
  });
    $( "#inp_closingdate" ).datepicker_thai({
    dateFormat: 'dd-mm-yy',
    altField:"#h_dateinput",
    altFormat: "yy-mm-dd",
    langTh:true,
    yearTh:true,
    changeYear: true,
  });
  });

  $('#sel_detailtype').change(function() {
    filtertype($('#sel_detailtype').val());  
  });

  $('#create').on('click',function(e) {

      $('#sel_type').prop('disabled', false);
      $('#modal_create').modal({backdrop: 'static'});
      $('input[name=form_type]').val('create');
      $('#modal_create').trigger('reset');
      $('.modal-title').text('เพิ่มรายละเอียด');
      $('#inp_detailid').hide();
      $('input[name=inp_detailid]').hide().val('0');
      getInsCompany()
        .done(function(data) {
          $('select[name=sel_insuranceid]').html("<option value=''>-- Select --</option>");
          $.each(data, function(index, val) {
            $('select[name=sel_insuranceid]').append('<option value="'+val.ID+'">'+val.INSURANCEDES+'</option>');
          });
      });  
      $('#show_file').html('');
      $('input[name=inp_createdate]').val('');
      $('input[name=inp_closingdate]').val('');
      $('input[name=inp_carid]').val(carid);
      $('input[name=inp_status]').prop('checked' , true);
 
  }); 

  $('#edit').on('click',function(e) {
    var rowdata = row_selected("#gridCarDetail");
    CREATEDATE = new Date(rowdata.CREATEDATE);
    CLOSINGDATE = new Date(rowdata.CLOSINGDATE);
    var montha = CREATEDATE.getMonth();
    var monthb = CLOSINGDATE.getMonth();
    var datea = CREATEDATE.getDate();
    var dateb = CLOSINGDATE.getDate();
    montha = montha+1;
    monthb = monthb+1;
    if(montha.toString().length==1){
        montha = ("0"+montha);
    }if(montha.toString().length==2){
        montha = montha;
    }if(monthb.toString().length==1){
        monthb = ("0"+monthb);
    }if(monthb.toString().length==2){
        monthb = monthb;
    }
    if(datea.toString().length==1){
        datea = ("0"+datea);
      }
    if(dateb.toString().length==1){
        dateb = ("0"+dateb);
      }
    if (typeof rowdata !== 'undefined') {

      $('#sel_type').prop('disabled', true);
      
      $('#modal_create').modal({backdrop: 'static'});
      $('input[name=form_type]').val('update');
      $('.modal-title').text('แก้ไขรายละเอียด');
      $('input[name=inp_detailid]').prop('readonly', true);
      $('input[name=inp_carid]').val(carid);
      $('input[name=id]').val(rowdata.ID);   
      $('input[name=inp_detailid]').val(rowdata.CARDETAILID);    
      $('#sel_type').val(rowdata.DETAILTYPE);
      $('input[name=inp_type]').val(rowdata.DETAILTYPE);    

      if(rowdata.DETAILTYPE == "TAX" || rowdata.DETAILTYPE == "ACT")
      {
        $('input[name=inp_createdate]').val(datea + "-" + montha + "-" + CREATEDATE.getFullYear());
        $('input[name=inp_closingdate]').val(dateb + "-" + monthb + "-" + CLOSINGDATE.getFullYear());
        // $('input[name=inp_createdate]').val(rowdata.CREATEDATE);
        // $('input[name=inp_closingdate]').val(rowdata.CLOSINGDATE);
        $('input[name=inp_createdate]').show();
        $('input[name=inp_closingdate]').show();
        $('#lab_insuranceid').hide();
        $('#sel_insuranceid').hide();
      }
      else if(rowdata.DETAILTYPE == "IMG")
      {
        $('#lab_insuranceid').hide();
        $('#sel_insuranceid').hide();
        $('#lab_createdate').hide();
        $('input[name=inp_createdate]').hide().val("1990-01-01");
        $('#lab_closingdate').hide();
        $('input[name=inp_closingdate]').hide().val("1990-01-01");
      }
      else
      {
        $('#lab_insuranceid').show();
        $('#sel_insuranceid').show();   
        gojax('get', '/api/v1/Ins/load')
            .done(function(data) {
              $('#sel_insuranceid').html('');
              $.each(data, function(index, val) {
                 $('#sel_insuranceid').append('<option value="'+val.ID+'">'+val.INSURANCEDES+'</option>');
              });
              $('#sel_insuranceid').val(rowdata.INSURANCE);
        });   
        $('#lab_createdate').show();
        $('input[name=inp_createdate]').show();
        // $('input[name=inp_createdate]').val(rowdata.CREATEDATE);
        $('input[name=inp_createdate]').val(datea + "-" + montha + "-" + CREATEDATE.getFullYear());
        $('#lab_closingdate').show();
        $('input[name=inp_closingdate]').show();
        // $('input[name=inp_closingdate]').val(rowdata.CLOSINGDATE);
        $('input[name=inp_closingdate]').val(dateb + "-" + monthb + "-" + CLOSINGDATE.getFullYear());
      }

      if (rowdata.STATUS == 1){
        $('input[name=inp_status]').prop('checked' , true);
      }else{
        $('input[name=inp_status]').prop('checked' , false);
      }

      $('#show_file').html('');
      loadfile(rowdata.CARDETAILID);

    }
    else
    {
      alert('Please  select data');
    } 
  });

  $('#delete').on('click',function(e) {
    // alert('delete');
    var rowdata = row_selected("#gridCarDetail");
      if (typeof rowdata !== 'undefined') {
        $("#dialog").dialog({
          buttons : {
            "OK" : function() {

            gojax('post', '/api/v1/Detail/delete', {detailid:rowdata.CARDETAILID})

            .done(function(data) {
              if (data.status == 200) 
            {
              gotify(data.message,"success");
                $('#dialog').dialog("close");
                    $('#gridCarDetail').jqxGrid('updatebounddata');
                          
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
      alert('Please  select data');
    }    
  });

  $('#sel_type').on('change', function (event){
      $('#sel_type').prop('disabled', false);
      $dtype = $('#sel_type').val();
  
      if($dtype === 'IMG')
      {
        $('#lab_insuranceid').hide();
        $('#sel_insuranceid').hide();
        $('select[name=sel_insuranceid]').val(0);
        $('#lab_createdate').hide();
        $('input[name=inp_createdate]').hide().val("1990-01-01");
        $('#lab_closingdate').hide();
        $('input[name=inp_closingdate]').hide().val("1990-01-01");
        $('#inp_status').hide();
        $('input[name=inp_status]').hide().val("1");
      }
      else if($dtype === 'TAX' || $dtype === 'ACT')
      {
        $('#lab_insuranceid').hide();
        $('#sel_insuranceid').hide();
        $('select[name=sel_insuranceid]').val(0);
        $('#lab_createdate').show();
        $('input[name=inp_createdate]').show().val("");
        $('#lab_closingdate').show();
        $('input[name=inp_closingdate]').show().val("");
      }
      else
      {
        $('#lab_insuranceid').show(); 
        $('#sel_insuranceid').show();
        $('select[name=sel_insuranceid]').val(1);
        $('#lab_createdate').show();
        $('input[name=inp_createdate]').show();
        $('#lab_closingdate').show();
        $('input[name=inp_closingdate]').show();
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

// function
  function removeEle(divid,_divid)
  {
      $(divid).remove(); 
      $(_divid).remove();
  }
  function loadfile(detailid)
  {

    $('#show_file').html('');
        gojax('get', '/api/v1/datafile/load',{id:detailid})
          .done(function(data) {
            $.each(data, function(index, val) {
              var  id = data[index].ID;
              var  filename = data[index].FILENAME;
                $('#show_file').append("<button type='button' class='btn btn-info btn-xs'  onclick=deletefile('"+filename+"','" + detailid +"')>-</button><a target='_blank' href='upload/" + data[index].FILENAME + "'>" + data[index].FILENAMEORIGINAL + "</a><br>");
            });
    });

  }

  function deletefile(filename,detailid)
  {
      $.ajax({
              url : '/api/v1/datafile/delete',
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
                loadfile(detailid);
              }
            }).fail(function(data){
            });

  }

  function filtertype (detailtype) {
        datafield = "DETAILTYPE";
        $("#gridCarDetail").jqxGrid('clearfilters');
        var filtertype = 'stringfilter';
        var filtergroup = new $.jqx.filter();
        if(detailtype != "")
        {
          var filter_or_operator = 1;
          var filtervalue = detailtype;
          var filtercondition = 'equal';
          var filter = filtergroup.createfilter(filtertype, filtervalue, filtercondition);
          filtergroup.addfilter(filter_or_operator, filter);
        }
        // add the filters.
        $("#gridCarDetail").jqxGrid('addfilter', datafield, filtergroup);
        // apply the filters.
        $("#gridCarDetail").jqxGrid('applyfilters');
  }

  function loadgrid(carid){

  var source =
    {
        dataType: "json",
        dataFields: [
            { name: 'ID', type: 'int' }
            ,{ name: 'CARDETAILID', type: 'string'}
            ,{ name: 'CARID', type: 'string' }
            ,{ name: 'INSURANCE', type: 'string' }
            ,{ name: 'CREATEDATE', type: 'date', cellsformat: "dd-MM-yyyy" }
            ,{ name: 'CLOSINGDATE', type: 'date', cellsformat: "dd-MM-yyyy" }
            ,{ name: 'DETAILTYPE', type: 'string' }
            ,{ name: 'STATUS', type: 'int' }
            ,{ name: 'INSURANCEDES', type: 'string' }
            ,{ name: 'REGCAR', type: 'string' }
        ], 
        cache: false,
        url : '/api/v1/Detail/load?carid='+carid,
        sortcolumn: 'ID',
        sortdirection: 'desc'
    };

    var dataAdapter = new $.jqx.dataAdapter(source);

    $("#gridCarDetail").jqxGrid(
    {
        source: dataAdapter,
        pageable: true,
        altRows: true,
        width: '100%',
        autoheight: true,
        columnsresize: true,
        theme : 'office',
        showfilterrow: true,
        filterable: true,
        //selectedrowindex:1,
        //autoshowfiltericon: false,
        columns: 
        [ 
          { text: 'ทะเบียนรถ', 
            cellsAlign: 'left', 
            align: 'center', 
            dataField: 'REGCAR', 
            width: '10%' 
          }
          
          ,{ text: 'ประเภท', 
            cellsAlign: 'center', 
            align: 'center', 
            dataField: 'DETAILTYPE', 
            width: '10%' 
          }

          ,{ text: 'วันที่ต่อ', 
            dataField: 'CREATEDATE', 
            cellsAlign: 'center', 
            align: 'center', 
            width: '15%',
            cellsformat: "dd-MM-yyyy" 
          }

          ,{ text: 'วันที่สิ้นสุด', 
            dataField: 'CLOSINGDATE', 
            cellsAlign: 'center', 
            align: 'center', 
            width: '15%',
            cellsformat: "dd-MM-yyyy" 
          }
          
          ,{ text: 'บริษัทประกัน', 
            dataField: 'INSURANCEDES', 
            cellsAlign: 'left', 
            align: 'center', 
            width: '40%' 
          }

          ,{ text: 'สถานะ', 
            dataField: 'STATUS', 
            cellsAlign: 'center', 
            align: 'center', 
            width: '10%' ,
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
 
  function getInsCompany() {
      return $.ajax({
        url : '/api/v1/Ins/load',
        type : 'get',
        dataType : 'json',
        cache : false
      });
  }

</script>



