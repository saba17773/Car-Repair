<?php $this->layout('layouts/auth') ?>

<div class="container">
	<div class="row">
		<div class="col-md-6 col-md-offset-3">
			<div class="panel panel-default">
				<div class="panel-heading">Login</div>
				<div class="panel-body">
					<form id="form_user_auth">
						<div class="form-group">
							<div class="row">
								<div class="col-md-12">
									<label for="username">Username</label>
									<div class="form-group">
								      <input type="text" name="inp_username" id="inp_username" class="form-control" placeholder="Username" required>
									  <input type="hidden" id= "txt_project" name = "txt_project" value = "CarRepair" />
									  <input type="hidden" id= "txt_userId" name = "txt_userId" value = "" />
								    </div>
								</div>
							</div>
						</div>
						<div class="form-group">
							<div class="row">
								<div class="col-md-10">
									<label for="password">Password</label>
								</div>
							</div>
							<div class="row">
								<div class="col-md-12">
									<div class="form-group">
								      <input type="password" name="inp_password" id="inp_password" class="form-control" placeholder="Password" required>
								    </div>
								</div>
							</div>
						</div>
						<button class="btn btn-primary" type="submit">Login</button>
						<button class="btn btn-default" type="reset">Clear</button>
						<a href="#" onclick="modal_forget_password()">ลืมรหัสผ่าน</a> <i class="glyphicon glyphicon-lock"></i> <br><br>
						<!-- <p align="right"><a href="/forgetpassword"><i>forget password</i></a></p> -->
					</form>
				</div>
			</div>
		</div>
	</div>
</div>
<div class="modal" id="modal_password" tabindex="-1" role="dialog">
  <div class="modal-dialog" role="document">
    <div class="modal-content">
      <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
          <span aria-hidden="true" class="glyphicon glyphicon-remove-circle"></span>
        </button>
          <h4 class="modal-title">ลืมรหัสผ่าน</h4>
        </div>
			<div class="modal-body">
				<form id="forget_password" onsubmit="submit_forget_password()">   
					<div class="form-group">
						<label for="mailpass">Email Address</label>
						<input type="email" name="inp_mailpass" id="inp_mailpass" class="form-control input-sm"placeholder="Email Address" required>
						
					</div>
					<button class="btn btn-primary" id="btn_send"><i class="glyphicon glyphicon-send"></i>&nbsp;ส่งเมลล์</button>
				  <!-- <p align="right"><a href="/forgetpassword"><i>forget password</i></a></p> -->
				</form>
			</div>	
		</div>
	</div>
</div>

<script>

	jQuery(document).ready(function($) {
		$('#inp_username').val('').focus();
		$('#form_user_auth').on('submit', function(event) {
			
			event.preventDefault();
			var link_path = "http://papaya:7777/api/auth";
			$.ajax({
		    url : link_path,
		    type : 'post',
		    cache : false,
		    dataType : 'json',
		    data : {
				username : $('#inp_username').val(),
				password : $('#inp_password').val(),
				appname :	$('#txt_project').val()
			}
		})
		.done(function(data) {
			
		  if(data.result == 1){
			$('#txt_userId').val(data.username)
			gojax_f('post', '/api/v1/user/auths', '#form_user_auth')
			.done(function(data) {
				// console.log(data); return false;
				if (data.result === false) {
					swal("ชื่อผู้ใช้ หรือ รหัสผ่านผิด", "กรุณาเช็คชื่อผู้ใช้ และรหัสผ่าน", "error");
					// gotify(data.message,"danger");
					
				} else {
					if (data.message==0) {
						swal("User นี้ไม่มีสิทธิ์ใช้งาน", "กรุณาติดต่อ Admin", "info");
						// window.location = '/profile';
					}else{
						window.location = '/';
					}
					
				}
			});
		  }else{
			 swal("เกิดข้อผิดพลาด", data.message, "info");
			 
			
		  }
		});
			
		});
	});

  function modal_forget_password(){
	$('#modal_password').modal({backdrop: 'static'});
    $('#forget_password').trigger('reset');
		return false;
  }

  function submit_forget_password(){
		$('#btn_send').text('กำลังส่ง...');
		 var form_capex = $("#form_capex").serialize();

    $('#btn_send').attr('disabled', true);
		$.ajax({
		    url : '/api/v1/email/sendpass',
		    type : 'post',
		    cache : false,
		    dataType : 'json',
		    data : $('form#forget_password').serialize()
		})
		.done(function(data) {
		    if (data.status == 200) {
		    	$('#modal_password').modal('hide');
		        alert('ส่งเมลล์สำเร็จ')
		    }else{
		    	alert('ส่งเมลล์ไม่สำเร็จ กรุณาดำเนินการใหม่อีกครั้ง')
		    }
		    $('#btn_send').text('ส่งเมลล์');
      	$('#btn_send').attr('disabled', false);
		    // console.log(data);
		});
	  	return false;
	}
	function Encrypt($request)
		
    {
        return openssl_encrypt($request, 'AES-256-CBC', config('app.key'), false, config('app.iv'));
    }
	

</script>