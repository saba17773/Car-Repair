<?php $this->layout("layouts/main") ?>
<?php
require '../mpdf/mpdf.php';
?> 

<style type="text/css">
	body {
    	font-family: "Garuda";
	} 
 	table {
	        border-collapse: collapse;
		    width: 1000px;
		    font-family: "Garuda";
		    text-align: left;
	    }
	    td, tr, th {
	        padding: 10px;
	        height: 40px;
	        font-family: "Garuda";
	    }
	    .table, .tr, .td {
	     border-collapse: collapse;
	     padding: 0px;
	     font-family: "Tahoma";
 		}
</style>

<!DOCTYPE html>
<html lang="en">
<head>
	<meta charset="UTF-8">
	<title>Document</title>
</head>
<body>
	<?php
		foreach ($data as $value) 
		{
	?>
	<?php 
	}
	?>
	<table style="font-size: 16px">
		<tr>
			<td width="25%" rowspan="2" align="center">
				<?php
				if ($value->INTERNALCODE == 'DSI'){
					echo "<img width='26%'' height='16%'' src='C:\_SERVER\Apache24\htdocs\web\CarRepair\public\Manual\DSI.jpg'>";
				}
				if($value->INTERNALCODE == 'DRB'){
					echo "<img width='26%'' height='16%'' src='C:\_SERVER\Apache24\htdocs\web\CarRepair\public\Manual\DRB.jpg'>";
				}
				if($value->INTERNALCODE == 'DSC'){
					echo "<img width='26%'' height='16%'' src='C:\_SERVER\Apache24\htdocs\web\CarRepair\public\Manual\DSC.jpg'>";
				}
				if($value->INTERNALCODE == 'DSL'){
					echo "<img width='26%'' height='16%'' src='C:\_SERVER\Apache24\htdocs\web\CarRepair\public\Manual\DSL.jpg'>";
				}
				if($value->INTERNALCODE == 'STR'){
					echo "<img width='26%'' height='16%'' src='C:\_SERVER\Apache24\htdocs\web\CarRepair\public\Manual\STR.jpg'>";
				}
				if($value->INTERNALCODE == 'SVO'){
					echo "<img width='26%'' height='16%'' src='C:\_SERVER\Apache24\htdocs\web\CarRepair\public\Manual\SVO.jpg'>";
				}
				?>
			</td>
			<td width="50%" align="center"><h2><?php echo $value->DESCOMPANY?></h2></td>
			<td width="25%" align="Right">เลขที่&nbsp;<?php echo $value->RUNNINGDSG;?></td>
		</tr>
		<tr>
			<td align="center"><h3>ใบอนุมัติเบิกค่าใช้จ่าย/เงินสำรองจ่าย</h3></td>
			<td align="Right">วันที่&nbsp;<?=date('d/m/Y')?></label></td>
		</tr>
	</table>
	<table style="font-size: 18px">
		<tr>
			<td width="30%">ข้าพเจ้า&nbsp;:&nbsp;<?php echo $value->USERNAME;?></td>
			<td>แผนก&nbsp;:&nbsp;<?php echo $value->DEPARTMENTDES;?></td>
			<td>ฝ่าย&nbsp;:&nbsp;<?php echo $value->SECTIONDES;?></td>
			<!-- <td>บริษัท&nbsp;:&nbsp;<?php echo $value->INTERNALCODE;?></td> -->
		</tr>
		<tr>
			<td>เลขทะเบียน&nbsp;:&nbsp;<?php echo $value->REGCAR; ?></td>
			<td colspan="2">ประเภทรถยนต์&nbsp;:&nbsp;<?php echo $value->RegisterTypeName; ?></td>
			<td>เลขไมล์&nbsp;:&nbsp;<?php echo $value->MILESNO; ?></td>
		</tr>
		<tr>
			<td>ผู้ขับ&nbsp;:&nbsp;<?php echo $value->DRIVERNAME; ?></td>
			<td>แผนก&nbsp;:&nbsp;<?php echo $value->DEPDRIVER; ?></td>
			<td>ฝ่าย&nbsp;:&nbsp;<?php echo $value->SECDRIVER; ?></td>
		</tr>
		<tr>
			<td colspan="2">
				<b>ขออนุมัติเบิกค่าใช้จ่าย ตามรายการข้างล่าง ดังนี้</b>
			</td>
			<td align="Right" colspan="2">รหัสแจ้งซ่อม&nbsp;:&nbsp;<?php echo $value->REPAIRID;?></td>
		</tr>
	</table>
	<table width="1000" border="1" style="font-size: 18px">
			<tr align="CENTER">
				<td width="10%" align="CENTER">ลำดับ</td>	
				<td width="70%" align="CENTER">รายการที่ขอเบิก</td>
				<td width="20%" align="CENTER">จำนวนเงิน</td>
			</tr>
			<?php 
				$TotalPrice = 0;
				// echo '<pre>'. print_r($sorted, true) . '</pre>';
    			foreach ($sorted as $value_line) {
    			$TotalPrice = $TotalPrice + $value_line->PRICE; 
    		?>
			<tr>
				<td align="CENTER"><?php echo $value_line->RowNumber; ?></td>
				<td>&nbsp;<?php echo $value_line->DESCRIPTION; ?></td>
				<td align="Right"><?php
				  if($value_line->PRICE != 0){ 
					echo number_format($value_line->PRICE, 2, '.', ','); 
					}else{ echo "&nbsp;"; 
				  } 
				?></td>
			</tr>
			<?php }
	  		?>
	  	<tr>
	  		<td>&nbsp;</td>
	  		<td>ขอรับ&nbsp;&nbsp;เงินสด&nbsp;/&nbsp;เช็ค&nbsp;/&nbsp;โอน&nbsp;/&nbsp;ภายในวันที่&nbsp;.............../.............../...............<br>จ่าย&nbsp;:&nbsp;<?php echo $value->CRADLE; ?></td>
	  		<td>&nbsp;</td>
	  	</tr>
	    <tr>

	    	
				<td width="700" COLSPAN=2 align="center">ราคาสุทธิ&nbsp;<?PHP 
				function convert($number){ 
					$txtnum1 = array('ศูนย์','หนึ่ง','สอง','สาม','สี่','ห้า','หก','เจ็ด','แปด','เก้า','สิบ'); 
					$txtnum2 = array('','สิบ','ร้อย','พัน','หมื่น','แสน','ล้าน','สิบ','ร้อย','พัน','หมื่น','แสน','ล้าน'); 
					$number = str_replace(",","",$number); 
					$number = str_replace(" ","",$number); 
					$number = str_replace("บาท","",$number); 
					$number = explode(".",$number); 
					if(sizeof($number)>2){ 
						return ''; 
						exit; 
					} 
					$strlen = strlen($number[0]); 
					$convert = ''; 
					for($i=0;$i<$strlen;$i++){ 
						$n = substr($number[0], $i,1); 
						if($n!=0){ 
							if($i==($strlen-1) AND $n==1){ $convert .= 'เอ็ด'; } 
							elseif($i==($strlen-2) AND $n==2){  $convert .= 'ยี่'; } 
							elseif($i==($strlen-2) AND $n==1){ $convert .= ''; } 
							else{ $convert .= $txtnum1[$n]; } 
							$convert .= $txtnum2[$strlen-$i-1]; 
						} 
					} 

					$convert .= 'บาท'; 
					if($number[1]=='0' OR $number[1]=='00' OR 
					$number[1]==''){ 
					$convert .= 'ถ้วน'; 
					}else{ 
					$strlen = strlen($number[1]); 
					for($i=0;$i<$strlen;$i++){ 
					$n = substr($number[1], $i,1); 
						if($n!=0){ 
						if($i==($strlen-1) AND $n==1){$convert 
						.= 'เอ็ด';} 
						elseif($i==($strlen-2) AND 
						$n==2){$convert .= 'ยี่';} 
						elseif($i==($strlen-2) AND 
						$n==1){$convert .= '';} 
						else{ $convert .= $txtnum1[$n];} 
						$convert .= $txtnum2[$strlen-$i-1]; 
						} 
				} 
					$convert .= 'สตางค์'; 
				} 
					return $convert; 
				} 
					echo convert(number_format($TotalPrice, 2, '.', ',') ); 
			?></td>
				<td align="Right"><?php echo number_format($TotalPrice, 2, '.', ','); ?></td>
	    </tr>
	  	
	</table>
	<table style="font-size: 18px" width="100%">
		<tr>
			<td>หมายเหตุ :&nbsp;</td>
			<?php
    			foreach ($data as $value) 
				{
    		?>
    	<?php }?>
			<td width="85%"><?php echo $value->REMARK;?></td>
			<td></td>
			<td></td>
		</tr>
	</table>
	<table width="1000" style="font-size: 18px">
		<tr>
			<td width="33%" align="CENTER" class="td">Prepared by</td>
			<td width="33%" align="CENTER" class="td">Checked by</td>
			<td width="33%" align="CENTER" class="td">Approved by</td>
		</tr>
		<tr>
			<td></td>
			<td></td>
			<td></td>
		</tr>
		<tr>
			<td align="CENTER">(&nbsp;<?php echo $value->USERNAME;?>&nbsp;)</td>
			<td align="CENTER">(&nbsp;<?php echo $value->HRNAME;?>&nbsp;)</td>
			<!-- <td align="CENTER">(&nbsp;วิมลวรรณ สุขประเสริฐ&nbsp;)</td> -->
			<td align="CENTER">(&nbsp;<?php echo $value->DirectorName;?>&nbsp;)</td>
		</tr>
		<tr>
			<td align="center" class="td">Admin</td>
			<td align="center" class="td">HR & Admin Manager</td>
			<td align="center" class="td">HR & Admin Director</td>
		</tr>
	</table>
</body>
</html>
<?php
$html = ob_get_clean();
$mpdf = new mPDF();
$mpdf->WriteHTML($html);
ob_clean();
$mpdf->Output();
ob_end_flush(); 
 

