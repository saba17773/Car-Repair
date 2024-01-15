<?php $this->layout("layouts/main") ?>

<style type="text/css">
  input[type=checkbox] {
      width: 20px;
        height: 20px;
    } 
</style>

<div class="container">
	<div class="row">
		<div class="col-md-5 col-md-offset-3">
			<div class="panel panel-default">
				<div class="panel-heading"><font size="3px">เปลี่ยนรหัสผ่าน</font></div>
				<div class="panel-body">
					<form id="form_user_auth">
						<div class="form-group">
							<div class="row">
								<div class="col-md-12">
									<label for="username">UserID</label>
									<div class="form-group">
								      <input type="text" name="inp_userid" id="inp_userid" class="form-control" placeholder="Username" required>
								    </div>
								</div>
							</div>
						</div>
						<div class="form-group">
							<div class="row">
								<div class="col-md-12">
									<label for="username">ชื่อผู้ใช้</label>
									<div class="form-group">
								      <input type="text" name="inp_username" id="inp_username" class="form-control" placeholder="Username" required>
								    </div>
								</div>
							</div>
						</div>
						<div class="form-group">
							<div class="row">
								<div class="col-md-12">
									<label for="password">รหัสผ่านใหม่</label>
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
						<div class="form-group">
							<div class="row">
								<div class="col-md-12">
									<label for="password">ยืนยันรหัสผ่าน</label>
								</div>
							</div>
							<div class="row">
								<div class="col-md-12">
									<div class="form-group">
								      <input type="password" name="inp_passwordconfirm" id="inp_passwordconfirm" class="form-control" placeholder="Password" required>
								    </div>
								</div>
							</div>
						</div>
						<input type="hidden" name="userid">
						<button class="btn btn-primary" type="submit">บันทึก</button>
						<button class="btn btn-default" id="btn_clear">Clear</button>
						<!-- <p align="right"><a href="/forgetpassword"><i>forget password</i></a></p> -->
					</form>
				</div>
			</div>
		</div>
	</div>
</div>

<script type="text/javascript">
  var session_userid = '<?php echo $_SESSION["userid"]; ?>';
  var session_username = '<?php echo $_SESSION["username"]; ?>';

jQuery(document).ready(function($){
	document.getElementById("inp_userid").disabled = true;
	document.getElementById("inp_username").disabled = true;
  $('#inp_userid').val(session_userid);
  $('#inp_username').val(session_username);
  $('input[name=userid]').val(session_userid);

	$('#form_user_auth').on('submit', function(event) {
		event.preventDefault();
		gojax_f('post', '/api/v1/user/changepass', '#form_user_auth')
		.done(function(data) {
			if($('#inp_password').val() == $('#inp_passwordconfirm').val()){
				if (data.status = 200) {
					
					swal("เปลี่ยนรหัสผ่านสำเร็จ", " ", "success");
					$('#inp_password').val('');
					$('#inp_passwordconfirm').val('');
					// gotify(data.message,"danger");
				} else {
					swal("เปลี่ยนรหัสผ่านไม่สำเร็จ", "  ", "error");
				}
			}else{
				swal("รหัสผ่านไม่ตรงกัน หรือ รหัสผ่านผิด", "กรุณาตรวจสอบรหัสผ่าน", "error");
			}
		});
	});

  // $userid = session_userid ;
  //   getusername($userid)
  //   .done(function(data) {
  //     $.each(data, function(index, val) {
  //     $('input[name=inp_username]').val(val.USERNAME);
  //     });
  // });
});
	
	$('#btn_clear').on('click', function(e) {
        $('input[name=inp_password]').val('');
        $('input[name=inp_passwordconfirm]').val('');
    });

  // function submit_create_user() {
        
  //   $.ajax({
  //       url : '/api/v1/user/changepass',
  //       type : 'post',
  //       cache : false,
  //       dataType : 'json',
  //       data : $('form#form_user_auth').serialize()
  //     })
  //     .done(function(data) {
  //       if (data.status != 200) {
  //         gotify(data.message,"danger");
  //       }else{
  //         gotify(data.message,"success");
  //       }ss
  //     });
  //  return false;
  // }

	// function getusername($causeid) 
 //  {
 //    return gojax('post', '/api/v1/get/usernamea', {userid:$userid})
 //  }
  


</script>