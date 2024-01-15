<!DOCTYPE html>
<html>
<head>
	<meta charset="utf-8">
	<meta http-equiv="x-ua-compatible" content="ie=edge">
	<meta name="viewport" content="width=device-width, initial-scale=1">
	<link rel="shortcut icon" type="image/png" href="/resources/logo.png"/>
	<title>Car Repair</title>
	<link rel="stylesheet" href="/resources/css/bootstrap.min.css">
	<link rel="stylesheet" href="/resources/css/app.css" />
	<link rel="stylesheet" href="/resources/css/sandstone.min.css" />
	<link rel="stylesheet" href="/resources/sweetalert-master/dist/sweetalert.css">
	<!-- <link rel="stylesheet" href="/resources/ztreev3/css/zTreeStyle/zTreeStyle.css"> -->
  <script src="/resources/sweetalert-master/dist/sweetalert.min.js"></script> 
  <script src="/resources/js/jquery-1.12.0.min.js"></script>
  <script src="/resources/js/bootstrap.min.js"></script>
<!--    <script src="/resources/ztreev3/js/jquery.ztree.core.min.js"></script> -->
  <script src="/resources/js/gojax.min.js"></script>
  <script src="/resources/js/app.js"></script>
  <script src="/resources/js/gotify.min.js"></script>
	<!--[if lt IE 9]>
		<script src="resources/js/html5shiv.js"></script>
		<script src="resources/js/respond.js"></script>
	<![endif]-->
</head>
<body>
	<!-- NOTE -->
	<!-- GOTIFY -->
	  	<div class="gotify-overlay"></div>

	  	<div class="gotify">
	      <div class="gotify-wrap">
	          <div class="close-gotify" onclick="return close_gotify()"></div>
	          <div class="gotify-content"></div>
	      </div>
	  	</div>

	<nav class="navbar navbar-default nvabar-static-top">
	  <div class="container">
	    <div class="navbar-header">
	      <?php if (isset($_SESSION["logged"]) && $_SESSION["status"]==0){ ?>
	      <a class="navbar-brand" href="#"><img  src="/resources/DN2.png" style="padding-left:0px;height:15px; width:auto;" />
	      </a>
	      <a class="navbar-brand" href="#">
	        Car Repair
	      </a>
	    <?php }else{ ?> 
	      <a class="navbar-brand" href="/"><img  src="/resources/DN2.png" style="padding-left:0px;height:15px; width:auto;" />
	      </a>
	      <a class="navbar-brand" href="/">
	        Car Repair
	      </a>
	      <a class="navbar-brand" href="../Manual/Manual_CarRepair Update 25-9-2018.pdf" target="blank"><font size ="2px">คู่มือการใช้งาน</font></a>
        
	    <?php }?> 
	    </div>
	    <ul class="nav navbar-nav navbar-right">
	    	<?php if (isset($_SESSION["logged"])): ?>
	    		<li><a href="/user/logout"><span class="glyphicon glyphicon-log-out"></span> Logout</a></li>
	    	<?php endif ?>
	    </ul>
	  </div>
	</nav>
	
	<div class="container">
		<?= $this->section('content'); ?>
	</div>

</body>
</html>

