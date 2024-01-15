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
<!-- 	<h2>Report Item</h2> -->
	<table width="1000" border="0">
	<?php
		foreach ($data as $value) {
	?>
<!-- Head -->
	<?php
		if ($value->CARID) {
	?>
	<tr>
		<td align="Right" width="1000" COLSPAN=4><?php echo $value->CARID; ?></td>
	</tr>
	 <tr><!-- start_tan_edit_180625 -->
		<td align="center" colspan = "4"><h1>ประวัติการซ่อม (Stock card)</h1></td>
	</tr><!-- end_tan_edit_180625 -->
	<tr>
		<td width="1000" COLSPAN=4>&nbsp;&nbsp;</td>
	</tr>
	<tr>
		<td width="350">รถยี่ห้อ/รุ่น&nbsp;:&nbsp;<?php echo $value->BRANDNAME; ?></td>
		<td width="300">ทะเบียน&nbsp;:&nbsp;<?php echo $value->REGCAR; ?></td>
		<td width="350">ผู้ครอบครอง/ผู้รับผิดชอบ&nbsp;:&nbsp;<?php echo $value->DRIVERNAME; ?></td>

	</tr>
	<tr>
		<td width="350">ตำแหน่ง&nbsp;:&nbsp;<?php echo $value->POSITIONDES; ?></td>
		<td width="300">แผนก&nbsp;:&nbsp;<?php echo $value->DEPARTMENTDES; ?></td>
		<td width="350">ฝ่าย&nbsp;:&nbsp;<?php echo $value->SECTIONDES; ?></td>


	</tr>
	<tr>
		<td width="350">วันจดทะเบียน&nbsp;:&nbsp;<?php echo $value->DATEREG; ?></td>
		<td width="300">วันครบกำหนดเสียภาษี&nbsp;:&nbsp;<?php echo $value->TAX; ?></td>
		<td width="350">วันครบกำหนดประกันภัย&nbsp;:&nbsp;<?php echo $value->INS; ?></td>
	</tr>
	<tr>
		<td width="350">วันครบกำหนด พ.ร.บ.&nbsp;:&nbsp;<?php echo $value->ACT; ?></td>
		<td width="650" COLSPAN=2>ประเภทรถ&nbsp;:&nbsp;<?php echo $value->CARTYPENAME; ?></td>
	</tr>
		<?php
    			}
    		}
    	?>
	</table>
<br>
<h4 align="CENTER">รายการซ่อม</h4>
	<table width="1000" border="1">

		<tr>
			<td align="CENTER" width="15">ลำดับ</td>
			<td align="CENTER" width="115">รหัสการซ่อมรถ</td>
			<td align="CENTER" width="90">วันที่ซ่อม</td>
			<td align="CENTER" width="90">เลขไมล์</td>
			<td align="CENTER" width="225">เหตุผลของการซ่อม</td>
			<td align="CENTER" width="225">รายการที่ซ่อม</td>
			<td align="CENTER" width="120">ราคาที่ซ่อม</td>
			<td align="CENTER" width="120">ลงชื่อผู้ส่งซ่อม</td>
		</tr>
		<?php
    		foreach ($sorted as $value_line) {
    	?>
		<tr>
			<td align="CENTER" width="15"><?php echo $value_line->ROWNUMBER; ?></td>
			<td align="left" width="115"><?php echo $value_line->REPAIRID; ?></td>
			<td align="CENTER" width="90"><?php echo $value_line->REPAIRDATE; ?></td>
			<td align="CENTER" width="90"><?php echo $value_line->MILESNO; ?></td>
			<td align="left" width="225"><?php echo $value_line->CAUSENAME; ?></td>
			<td align="left" width="225"><?php echo $value_line->DETAILNAME; ?></td>
			<td align="Right" width="120">
				<?php
				  if($value_line->PRICE != 0){
					echo number_format($value_line->PRICE, 2, '.', ','); }else{ echo "&nbsp;"; }
				?>
			</td>
			<td align="CENTER" width="120"></td>
		</tr>
		<?php
	    	}
	    ?>
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
