<?php 

namespace App\Controllers;
use App\Models\CAR_DetailModel;
use Slim\Http\UploadedFile;

class CAR_DetailController
{
	public function __construct()
	{
		$this->Detail = new CAR_DetailModel;
	}

	public function all($request, $response, $args)
	{
		$parsedBody = $request->getQueryParams();
		return $response->withJson($this->Detail->all($parsedBody["carid"]));
	}

	public function datafile($request, $response, $args)
	{
		$parsedBody = $request->getQueryParams();
		return $response->withJson($this->Detail->datafile($parsedBody["id"]));
	}

	public function deletedatafile($request, $response, $args)
	{
		$parsedBody = $request->getParsedBody();

		$isfile	= $this->Detail->deletedatafile($parsedBody["filename"]);
		if($isfile["result"] == 1)
		{
			echo json_encode(["status" => 200, "message" => "Delete Successful"]);
			exit();
		}
		else
		{
			echo json_encode(["status" => 404, "message" => "Delete Failed"]);exit;
		}
		
	}

	public function moveUploadedFile($directory, UploadedFile $uploadedFile)
	{
	    $extension = pathinfo($uploadedFile->getClientFilename(), PATHINFO_EXTENSION);
	    $basename = bin2hex(random_bytes(8)); 

	    $gennumber = $this->Detail->gennumberseqfile();
	    if($gennumber === false)
	    {
	    	echo "Uploaded Failed";
	    	exit();
	    }
	    // var_dump($gennumber);
	    $type = strrchr($uploadedFile->getClientFilename(),".");
	    $newfilenameDes = $gennumber.$type;

	    $filename = $newfilenameDes;//$uploadedFile->getClientFilename();//sprintf('%s.%0.8s', $basename, $extension);
	    $uploadedFile->moveTo($directory . DIRECTORY_SEPARATOR . $newfilenameDes); 
	   //$uploadedFile->getClientFilename());
	    return $filename;
	}

	public function createdetail($request, $response, $args)
	{
		$parsedBody = $request->getParsedBody();
		$uploadedFiles = $request->getUploadedFiles();
		// var_dump($uploadedFiles);exit();
		$directory = "./upload/";
		$Date = DATE($parsedBody["inp_createdate"]);
		$Year = (int)substr($Date,6)-543;
		$Date  =  substr($Date,3,2) .'-'.substr($Date,0,2) .'-'.$Year;
		$Datec = DATE($parsedBody["inp_closingdate"]);
		$Yearc = (int)substr($Datec,6)-543;
		$Datec  =  substr($Datec,3,2) .'-'.substr($Datec,0,2) .'-'.$Yearc;

		if(count($uploadedFiles) > 0)
		{
			foreach ($uploadedFiles['inp_but_upload'] as $uploadedFile) 
			{

		        if ($uploadedFile->getError() === UPLOAD_ERR_OK) 
		        {
		            $filename = self::moveUploadedFile($directory,$uploadedFile);
		            $filenameoriginal = $uploadedFile->getClientFilename();
		            $filearr[] = array('old' => $filename,'new' => $filenameoriginal);
		        }
	    	}
	    }
	    if(!isset($filearr))
	    {
	    	$filearr[] = "";
	    }
		if (!isset($parsedBody["inp_status"])) {
			$status = 0;
		}else{
			$status = 1;
		}
		$id = $parsedBody["inp_carid"];

		if($parsedBody["form_type"] == "create")
		{
			// var_dump($parsedBody);exit();
			$arr = $this->Detail->createdetail($parsedBody["inp_carid"],
											   $parsedBody["sel_insuranceid"],
											   $Date,
											   $Datec,
											   $parsedBody["sel_type"],
											   $status,
											   $filearr);

			//echo "<pre>" . print_r($parsedBody["inp_carid"], true) . "</pre>"; exit;
			if($arr["result"] == 1)
			{
				header("Location: /CarDetail?inp_sentid=".$id);
				exit();
			}
			else
			{
				echo "Create Failed";
				exit();
			}
			
		}
		else
		{
			// var_dump($parsedBody);exit();
			$arr = $this->Detail->updatedetail($parsedBody["inp_detailid"],
											   $parsedBody["sel_insuranceid"],
											   $Date,
											   $Datec,
											   $parsedBody["inp_type"],
											   $status,
											   $parsedBody["id"],
											   $parsedBody["inp_carid"],
											   $filearr);

			if($arr["result"] == 1)
			{
				header("Location: /CarDetail?inp_sentid=".$id);
				exit();
			}
			else
			{
				echo "Update Failed";
				exit();
			}	

			
		}
		
	}


	public function delete($request, $response, $args)
	{
		$parsedBody = $request->getParsedBody();

		$getfilename = $this->Detail->getfiledelete($parsedBody["detailid"]);

		// var_dump($getfilename);
		$checkerror = 0;
		if ($parsedBody) {		
			if($response->withJson($this->Detail->delete($parsedBody["detailid"])) === false) 
			{
				echo json_encode(["status" => 404, "message" => "Delete Failed"]);
				exit;
			}
			else
			{
				foreach ($getfilename as $key) 
				{
					// echo "<pre>" . print_r($key, true) . "</pre>";
					$isfile	= $this->Detail->deletedatafile($key->FILENAME);

					if($isfile["result"] == 1)
					{
						$checkerror = 1;
					}
					else
					{
						$checkerror = 0;
					}

			    }

			}
		}

		if($checkerror == 1)
		{
			echo json_encode(["status" => 404, "message" => "Delete Failed"]);
		}
		else
		{
			echo json_encode(["status" => 200, "message" => "Delete Successful"]);
			exit;
		}
	}
}		