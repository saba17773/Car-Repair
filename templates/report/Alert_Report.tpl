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

<!-- connect -->
<?php
  use Wattanar\Sqlsrv;
  use App\Controllers\ConnectionController; 
?>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Document</title>
</head>
<body>
<!-- <h2>Alert Report</h2> -->

		<CAPTION>แจ้งเตือนประจำเดือน
    <?php 
      $date = date('m');
      switch($date){
        case 1:
            echo 'มกราคม - กุมภาพันธ์';
            break;
        case 2:
            echo 'กุมภาพันธ์ - มีนาคม';
            break;
        case 3:
            echo 'มีนาคม - เมษายน';
            break;
        case 4:
            echo 'เมษายน - พฤษภาคม';
            break;
        case 5:
            echo 'พฤษภาคม - มิถุนายน';
            break;
        case 6:
            echo 'มิถุนายน - กรกฎาคม';
            break;
        case 7:
            echo 'กรกฎาคม - สิงหาคม';
            break;
        case 8:
            echo 'สิงหาคม - กันยายน';
            break;
        case 9:
            echo 'กันยายน - ตุลาคม';
            break;
        case 10:
            echo 'ตุลาคม - พฤศจิกายน';
            break;
        case 11:
            echo 'พฤศจิกายน - ธันวาคม';
            break;                                      
        default:
            echo 'ธันวาคม - มกราคม';
      }

    ?>

		</CAPTION>
		<br><br>
		<div class="modal-body">
          <form id="form_create">
            <div class="form-group">
              <label for="Insurance" id="Insurance" >&nbsp;&nbsp;&nbsp;&nbsp;ประกันภัย</label>

                <?php  
                    if(ConnectionController::connect() !== false)
                    {
                      $user_id = $_SESSION["userid"];
                      $sql = "SELECT C.REGCAR
                                  ,INS.CLOSINGDATE[Insurance]     
                              FROM MASTER_CAR C
                              LEFT JOIN(
                                    SELECT CD.CARID,IC.INSURANCEDES,CD.CLOSINGDATE,CD.DETAILTYPE
                                    FROM CARDETAIL CD
                                    LEFT JOIN MASTER_INSURANCE IC ON IC.ID = CD.INSURANCE
                                    WHERE CD.DETAILTYPE = 'INS'
                                    AND CD.STATUS = 1
                                    )INS ON INS.CARID = C.CARID
                              where INS.CLOSINGDATE <= DATEADD(d,-1, DATEADD(mm, DATEDIFF(mm,'',GETDATE())+2,''))
                              AND C.COMPANY IN (
                                                SELECT F.COMPANY
                                                FROM FACTORY F
                                                WHERE F.USERID = '$user_id'
                                                )";
                ?>          
                  <table border="1" cellspacing="2" cellpadding="0" align="center">
                        <tr>
                          <td bgcolor="F0F08E" align="center">ทะเบียน</td>
                          <td bgcolor="F0F08E" align="center">วันที่หมด</td>
                        </tr>
                    <?php
                      $sql_car = Sqlsrv::array(ConnectionController::connect(),$sql);
                      foreach($sql_car as $car){
                    ?>  
                        <tr>
                         <td>&nbsp;&nbsp; <?php echo "$car->REGCAR" ?> </td>
                         <td>&nbsp;&nbsp; <?php echo "$car->Insurance" ?> </td>
                        </tr>                   
                    <?php 
                      }
                    ?>
                  </table>
                <?php
                    }
                ?>
              
            </div>
            <div class="form-group">
              <label for="DateAct">&nbsp;&nbsp;&nbsp;&nbsp;พรบ.</label>              
          
                <?php  
                    if(ConnectionController::connect() !== false)
                    {
                      $user_id = $_SESSION["userid"];
                      $sql = "SELECT C.REGCAR
                                   ,ACT.CLOSINGDATE[Act]      
                              FROM MASTER_CAR C
                               LEFT JOIN(
                                    SELECT CDA.CARID,CDA.CLOSINGDATE,CDA.DETAILTYPE
                                    FROM CARDETAIL CDA
                                    WHERE CDA.DETAILTYPE = 'ACT'
                                    AND CDA.STATUS = 1
                                    )ACT ON ACT.CARID = C.CARID
                              where ACT.CLOSINGDATE <= DATEADD(d,-1, DATEADD(mm, DATEDIFF(mm,'',GETDATE())+2,''))
                              AND C.COMPANY IN (
                                                SELECT F.COMPANY
                                                FROM FACTORY F
                                                WHERE F.USERID = '$user_id'
                                                )";
                ?>          
                  <table border="1" cellspacing="2" cellpadding="0" align="center">
                      <tr>
                          <td bgcolor="F0F08E" align="center">ทะเบียน</td>
                          <td bgcolor="F0F08E" align="center">วันที่หมด</td>
                      </tr>
                    <?php
                      $sql_car = Sqlsrv::array(ConnectionController::connect(),$sql);
                      foreach($sql_car as $car){
                    ?>  
                      <tr>
                       <td>&nbsp;&nbsp; <?php echo "$car->REGCAR" ?> </td>
                       <td>&nbsp;&nbsp; <?php echo "$car->Act" ?> </td>
                      </tr>
                     
                    <?php 
                      }
                    ?>
                  </table>
                <?php
                    }
                ?>

            </div>
            <div class="form-group">
              <label for="DateRepair">&nbsp;&nbsp;&nbsp;&nbsp;ภาษี</label>
                
                <?php  
                    if(ConnectionController::connect() !== false)
                    {
                      $user_id = $_SESSION["userid"];
                      $sql = "SELECT C.*
                                  ,TAX.CLOSINGDATE[Tax]       
                              FROM MASTER_CAR C
                              LEFT JOIN(
                                    SELECT CDT.CARID,CDT.CLOSINGDATE,CDT.DETAILTYPE
                                    FROM CARDETAIL CDT
                                    WHERE CDT.DETAILTYPE = 'Tax'
                                    AND CDT.STATUS = 1
                                    )TAX ON TAX.CARID = C.CARID 
                              where TAX.CLOSINGDATE <= DATEADD(d,-1, DATEADD(mm, DATEDIFF(mm,'',GETDATE())+2,''))
                              AND C.COMPANY IN (
                                                SELECT F.COMPANY
                                                FROM FACTORY F
                                                WHERE F.USERID = '$user_id'
                                                )";
                ?>         
                  <table border="1" cellspacing="2" cellpadding="0" align="center">
                      <tr>
                          <td bgcolor="F0F08E" align="center">ทะเบียน</td>
                          <td bgcolor="F0F08E" align="center">วันที่หมด</td>
                      </tr>
                    <?php
                      $sql_car = Sqlsrv::array(ConnectionController::connect(),$sql);
                      foreach($sql_car as $car){
                    ?>  
                      <tr>
                       <td>&nbsp;&nbsp; <?php echo "$car->REGCAR" ?> </td>
                       <td>&nbsp;&nbsp; <?php echo "$car->Tax" ?> </td>
                      </tr>
                     
                    <?php 
                      }
                    ?>
                  </table>
                <?php
                    }
                ?>

            </div>
          </form>

</body>
<?php
$html = ob_get_clean();
$mpdf = new mPDF();
$mpdf->WriteHTML($html);
ob_clean();
$mpdf->Output();
ob_end_flush(); 
