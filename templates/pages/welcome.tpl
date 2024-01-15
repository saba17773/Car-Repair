<?php $this->layout('layouts/main') ?>

<h1>Hello</h1>


<?php
        $server = "192.168.90.30\develop";


        $settings = [
			"Database" => "Test", 
			"UID" => "sa", 
			"PWD" => "c,]'4^j" ,
			"CharacterSet" => "UTF-8",
			"ReturnDatesAsStrings" => true,
			"MultipleActiveResultSets" => true
		];

		try {
			$connect = sqlsrv_connect($server, $settings);
		} catch (Exception $e) {
			return false;
		}

		if($connect)
        {
            echo "test";
        }
        else
        {
            echo "f";
        }


?> 