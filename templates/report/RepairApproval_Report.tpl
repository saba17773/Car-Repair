<?php $this->layout("layouts/main") ?>
<?php
require '../vendor/autoload.php';
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
	        font-family: "Garuda";
	    }
	    .table, .tr, .td {
	     border: 1px solid black;
	     padding: 0px;
 		}
</style>


<!DOCTYPE html>
<html lang="en">
<head>
	<meta charset="UTF-8">
	<title>Document</title>
</head>
<body>
</style>
	<table width="1000" border="0">
		<?php 
    		foreach ($data as $value) {  
    		if ($value->REPAIRID) {
    	?>
		<tr>
			<td align="Right" width="1000">เลขที่&nbsp;<?php echo substr($value->REPAIRID,13); ?>&nbsp;/&nbsp;<?php echo $value->Year; ?>&nbsp;ปี</td>
		</tr>
	</table>
<H4 align="CENTER">ใบอนุมัติซ่อม</H4>
	<table width="1000" border="0">
<!-- 		<tr>
			<td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
			<td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
			<td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
			<td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
			<td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
			<td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
		</tr> -->
		<tr>
			<td align="Right" COLSPAN=6>
				วันที่...
				<?php echo $value->DAY; ?>
				...เดือน...
				<?php

				switch($value->MONTH) {
                            case 1:
                                echo 'มกราคม';
                                break;
                            case 2:
                                echo 'กุมภาพันธ์';
                                break;
                            case 3:
                                echo 'มีนาคม';
                                break;
                            case 4:
                                echo 'เมษายน';
                                break;
                            case 5:
                                echo 'พฤษภาคม';
                                break;
                            case 6:
                                echo 'มิถุนายน';
                                break;
                            case 7:
                                echo 'กรกฎาคม';
                                break;
                            case 8:
                                echo 'สิงหาคม';
                                break;
                            case 9:
                                echo 'กันยายน';
                                break;
                            case 10:
                                echo 'ตุลาคม';
                                break;
                            case 11:
                                echo 'พฤศจิกายน';
                                break;                                      
                            default:
                                echo 'ธันวาคม';
                        }

				?>
				...ปี...
				<?php echo $value->Year; ?>
				&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
		</tr>
		<tr>
			<td COLSPAN=6>&nbsp;</td>
		</tr>		
		<tr>
			<td align="Right">หน่วยงาน :&nbsp;</td>
			<td><?php echo $value->INTERNALCODE; ?></td>
			<td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
			<td></td>
			<td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
			<td></td>

		</tr>
		<tr>
			<td align="Right">ชื่อผู้ขับขี่ :&nbsp; </td>
			<td><?php echo $value->DRIVERNAME; ?></td>
			<td align="Right">รุ่น :&nbsp;</td>
			<td><?php echo $value->BrandName; ?></td>
			<td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
			<td></td>

		</tr>
		<tr>
			<td align="Right">ประเภทรถ :&nbsp;</td>
			<td><?php echo $value->RegisterTypeName; ?></td>
			<td align="Right">เลขทะเบียน :&nbsp;</td>
			<td><?php echo $value->REGCAR; ?></td>
			<td align="Right">เลขไมล์ :&nbsp;</td>
			<td><?php echo $value->MILESNO; ?></td>

		</tr>
		<?php  }	    	
	    ?>
	</table>
	<h5>รายละเอียด</h5>
	<table width="1000" border="1">
			<tr align="CENTER">
				<td width="50" align="CENTER">ลำดับ</td>	
				<td width="450" align="CENTER">รายการ</td>
				<td width="200" align="CENTER">เหตุผลของการซ่อมรถ</td>
				<td width="200" align="CENTER">ราคาที่ซ่อม</td>
				<td width="100" align="CENTER">หมายเหตุ</td>
			</tr>
		<?php 
			$TotalPrice = 0;
    		foreach ($sorted as $value_line) { 
    		$TotalPrice = $TotalPrice + $value_line->PRICE; 
    	?>
			<tr>
				<td align="CENTER"><?php echo $value_line->RowNumber; ?></td>
				<td><?php echo $value_line->CAUSE; ?></td>
				<td><?php echo $value_line->DESCRIPTION; ?></td>
				<td align="Right">
				<?php
				  if($value_line->PRICE != 0){ 
					echo number_format($value_line->PRICE, 2, '.', ','); 
					}else{ echo "&nbsp;"; 
				  } 
				?>
				</td>
				<!-- <td><?php echo $value_line->NOTE; ?></td> -->
				<td>&nbsp;</td>
			</tr>
		<?php  
	    	} 
	    ?>
	    <tr>
			<td width="700" COLSPAN=3>ราคาสุทธิ</td>
			<td align="Right"><?php echo number_format($TotalPrice, 2, '.', ','); ?></td>
			<td></td>
	    </tr>
	</table>
<table width="1000" border="0" ><tr><td width="1000" COLSPAN=4></td>&nbsp;</tr></table>
	<table width="1000" border="0" >
		<tr>
			<td width="100" COLSPAN=2>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;ความเห็นของฝ่ายคลังสินค้า</td>
			<td width="900" COLSPAN=2>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;ความเห็นของฝ่ายทรัพยากรบุคคลและธุรการ</td>
		</tr>

		<tr>
			<td width="100" COLSPAN=2>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;....................................................................................................................................................</td>
			<td width="800" COLSPAN=2>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;....................................................................................................................................................</td>
		</tr>

		<tr>
			<td width="100" COLSPAN=2>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;....................................................................................................................................................</td>
			<td width="900" COLSPAN=2>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;....................................................................................................................................................</td>
		</tr>

		<tr><td width="1000" COLSPAN=4>&nbsp;</td></tr>

		<tr>
			<td width="100" COLSPAN=2 align="CENTER">ลงชื่อ........................................................</td>
			<td width="900" COLSPAN=2 align="CENTER">ลงชื่อ........................................................</td>
		</tr>
		
		<tr>
			<td width="100" COLSPAN=2 align="CENTER">(&nbsp;<?php echo $value->RENAME; ?>&nbsp;)</td>
			<td width="900" COLSPAN=2 align="CENTER">(...................................................)</td>
		</tr>

		<tr>
			<td width="100" COLSPAN=2 align="CENTER">ผู้จัดการคลัง</td>
			<td width="900" COLSPAN=2 align="CENTER">หัวหน้าส่วนผู้ช่วยผู้จัดการ</td>
		</tr>

		<tr>
			<td width="100" COLSPAN=2 align="CENTER">วันที่....................................................</td>
			<td width="900" COLSPAN=2 align="CENTER">วันที่....................................................</td>
		</tr>

		<tr><td width="1000" COLSPAN=4>&nbsp;</td></tr>

		<tr>
			<td width="100" COLSPAN=2></td>
			<td width="900" COLSPAN=2 align="CENTER">ลงชื่อ........................................................</td>
		</tr>

		<tr>
			<td width="100" COLSPAN=2></td>
			<td width="900" COLSPAN=2 align="CENTER">&nbsp;&nbsp;ผู้จัดการฝ่ายทรัพยากรบุคคลและธุรการ</td>
		</tr>
		
		<tr>
			<td width="100" COLSPAN=2>&nbsp;</td>
			<td width="900" COLSPAN=2 align="CENTER">(&nbsp;<?php echo $value->HRNAME; ?>&nbsp;)</td>
		</tr>

		<tr>
			<td width="100" COLSPAN=2>&nbsp;</td>
			<td width="900" COLSPAN=2 align="CENTER">วันที่........................................</td>
		</tr>

		<tr><td width="1000" COLSPAN=4>&nbsp;</td></tr>

		<tr>
			<td align="Right" COLSPAN=1>
				<?php 
				if($value->STATUSREPAIR == "8"){
				 ?>			
				<img  src="/resources/check.png" style="padding-left:30px;height:30px; width:auto;" />&nbsp;&nbsp;&nbsp;อนุมัติ&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
				<?php 
				}else{
				?>
				 <img  src="/resources/uncheck.png" style="padding-left:30px;height:30px; width:auto;" />&nbsp;&nbsp;&nbsp;อนุมัติ&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
				<?php 
					}
				?>
			</td>
			<td align="Left" COLSPAN=1>
				<?php if($value->STATUSREPAIR == "9"){ ?>			
				<img  src="/resources/check.png" style="padding-left:30px;height:30px; width:auto;" />&nbsp;&nbsp;&nbsp;ไม่อนุมัติ
				<?php }else{ ?>
				<img  src="/resources/uncheck.png" style="padding-left:30px;height:30px; width:auto;" />&nbsp;&nbsp;&nbsp;ไม่อนุมัติ
				<?php } ?>
			</td>
			<td width="900" COLSPAN=2 align="CENTER">ลงชื่อ........................................................</td>
		</tr>
		
		<tr>
			<td width="100" COLSPAN=2>&nbsp;</td>
			<td width="900" COLSPAN=2 align="CENTER">(&nbsp;<?php echo $value->DTNAME; ?>&nbsp;)</td>
		</tr>

		<tr>
			<td width="100" COLSPAN=2>&nbsp;</td>
			<td width="900" COLSPAN=2 align="CENTER">ผุ้อำนวยการฝ่ายทรัพยากรบุคคลและธุรการ</td>
		</tr>

		<tr>
			<td width="100" COLSPAN=2>&nbsp;</td>
			<td width="900" COLSPAN=2 align="CENTER">วันที่........................................</td>
		</tr>

	</table>
	<?php } ?>
</body>
</html>
<?php
$html = ob_get_clean();
$mpdf = new mPDF();
$mpdf->WriteHTML($html);
ob_clean();
$mpdf->Output();
ob_end_flush(); 


