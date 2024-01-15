<?php $this->layout("layouts/main") ?>

<style type="text/css">
  input[type=checkbox] {
      width: 20px;
        height: 20px;
    } 
</style>
<div class="container">
	<div class="row">
		<div class="col-md-6 col-md-offset-3">
			<div class="panel-heading">แก้ไข รหัสผ่าน</div>
			<div class="panel-body">
				<form id="forgetpass">
					<div class="form-group">
						<div class="row">
							<div class="col-md-10">
								<label for="username">ชื่อผู้ใช้</label>
							</div>
						</div>
						<div class="row">
							<div class="col-md-10">
								<input type="text" name="username" id="username" class="form-control input-sm">
							</div>
						</div>
						<div class="row">
							<div class="col-md-10">
								<label for="username">รหัสผ่าน</label>
							</div>
						</div>
						<div class="row">
							<div class="col-md-10">
								<input type="text" name="passnew" id="passnew" class="form-control input-sm">
							</div>
						</div>
						<div class="row">
							<div class="col-md-10">
								<label for="username">ยืนยันรหัสผ่าน</label>
							</div>
						</div>
						<div class="row">
							<div class="col-md-10">
								<input type="text" name="passnew" id="passnew" class="form-control input-sm">
							</div>
						</div>
					</div>
				</form>
			</div>
		</div>
	</div>
</div>


