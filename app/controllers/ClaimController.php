<?php 

namespace App\Controllers;

use App\Models\ClaimModel;
use Slim\Http\UploadedFile;

class ClaimController
{
	public function __construct()
	{
		$this->claim = new ClaimModel;
	}

	public function all($request, $response, $args)
	{
		return $response->withJson($this->claim->all());
	}

	public function car($request, $response, $args)
	{
		return $response->withJson($this->claim->car());
	}

	public function ins($request, $response, $args)
	{
		$parsedBody = $request->getParsedBody();
		return $response->withJson($this->claim->ins($parsedBody["carid"]));

	}

	public function insedit($request, $response, $args)
	{
		$parsedBody = $request->getParsedBody();
		return $response->withJson($this->claim->insedit($parsedBody["insid"]));

	}

	public function datafile($request, $response, $args)
	{
		$parsedBody = $request->getQueryParams();
		return $response->withJson($this->claim->datafile($parsedBody["id"]));
	}

	public function deletedatafile($request, $response, $args)
	{
		$parsedBody = $request->getParsedBody();

		$isfile	= $this->claim->deletedatafile($parsedBody["filename"]);
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

	    $gennumber = $this->claim->gennumberseqfile();
	    if($gennumber === false)
	    {
	    	echo "Uploaded Failed";
	    	exit();
	    }
	    // var_dump($gennumber);exit();
	    $type = strrchr($uploadedFile->getClientFilename(),".");
	    $newfilenameDes = $gennumber.$type;

	    $filename = $newfilenameDes;//$uploadedFile->getClientFilename();//sprintf('%s.%0.8s', $basename, $extension);
	    $uploadedFile->moveTo($directory . DIRECTORY_SEPARATOR . $newfilenameDes); 
	   //$uploadedFile->getClientFilename());
	    return $filename;
	}

	public function create($request, $response, $args)
	{
		$parsedBody = $request->getParsedBody();
		$uploadedFiles = $request->getUploadedFiles();
		// var_dump($parsedBody);exit();
		$directory = "./upload/";
		$Date = DATE($parsedBody["inp_claimdate"]);
		$Year = (int)substr($Date,6)-543;
		$Date  =  substr($Date,3,2) .'-'.substr($Date,0,2) .'-'.$Year;
		
		if($parsedBody["inp_insid"] == 0)
		{
			header("Location: /Claim");
			exit();
		}

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

	    if($parsedBody["form_type"] == "create")
		{
			// var_dump($parsedBody["dd_car_id"], $parsedBody["inp_insid"]);exit();
			$arr = $this->claim->createclaim($parsedBody["dd_car_id"],
											 $parsedBody["inp_insid"],
											 $Date,
											 $parsedBody["text_detail"],
											 $filearr);

			//echo "<pre>" . print_r($parsedBody["inp_carid"], true) . "</pre>"; exit;
			if($arr["result"] == 1)
			{
				header("Location: /Claim");
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
			$arr = $this->claim->updateclaim($parsedBody["dd_car_id"],
											 $parsedBody["inp_insid"],
											 $Date,
											 $parsedBody["text_detail"],
											 $parsedBody["inp_claimid"],
											 $filearr);

			if($arr["result"] == 1)
			{
				header("Location: /Claim");
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

		$getfilename = $this->claim->getfiledelete($parsedBody["claimid"]);

		// var_dump($getfilename);
		$checkerror = 1;
		if ($parsedBody) {		
			if($response->withJson($this->claim->delete($parsedBody["claimid"])) === false) 
			{
				echo json_encode(["status" => 404, "message" => "Delete Failed"]);
				exit;
			}
			else
			{
				foreach ($getfilename as $key) 
				{
					// echo "<pre>" . print_r($key, true) . "</pre>";
					$isfile	= $this->claim->deletedatafile($key->FILENAME);

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
			echo json_encode(["status" => 200, "message" => "Delete Successful"]);
		}
		else
		{
			echo json_encode(["status" => 404, "message" => "Delete false"]);
			exit;
		}
	}

	public function loadpicture($request, $response, $args)
	{
  		$parsedBody = $request->getQueryParams();
		return $response->withJson($this->claim->loadpicture($parsedBody["idclaim"]));
	}

}