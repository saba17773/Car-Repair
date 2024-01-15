<?php $this->layout("layouts/main") ?>
<?php
require '../vendor/autoload.php';
?> 
<!DOCTYPE html>
<html lang="en">
<head>
	<meta charset="UTF-8">
	<title>Document</title>
</head>
<body>
	<Table>
		<tr>
			<td>aaaa</td>
			<td>aaaaa</td>
			<td>sssss</td>
		</tr>
		<tr>
			<td>ddddddd</td>
			<td>fffffff</td>
			<td>fffffff</td>
		</tr>
		<tr>
			<td>gggggg</td>
			<td>hhhhh</td>
			<td>jjjjjjjj</td>
		</tr>
	</Table>
</body>
</html>

<?php
$html = ob_get_clean();
$mpdf = new mPDF();
$mpdf->WriteHTML($html);
ob_clean();
$mpdf->Output();
ob_end_flush(); 