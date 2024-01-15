<?php
namespace App\Models;
use Wattanar\Sqlsrv;
use App\Controllers\ConnectionController;


class EmailModel
{
    public function __construct()
    {
        $this->conn = new ConnectionController;
        $this->mail = new \PHPMailer;
        $this->maildi = new \PHPMailer;
    }

    public function send_re($inp_RepairID_sent,$manager_v)
    {
        $email_a = Sqlsrv::array(
            $this->conn->connect(),
            "SELECT TOP(1) U.EMAIL
            FROM MASTER_USER U
            WHERE U.ID = '$manager_v'"
        );

        foreach ($email_a as $key) {
            $email = $key->EMAIL;
        }


        $idApproved = $manager_v;


        //$mail = new PHPMailer;
        $this->mail->isSMTP();
        $this->mail->Host = 'smtp-relay.gmail.com';
        $this->mail->SMTPAuth = true;
        $this->mail->SMTPSecure = "ssl";
        $this->mail->Username = 'noreply@deestone.com';
        $this->mail->Password = "tckpwktdnrpahmem";
        $this->mail->CharSet = "utf-8";
        $this->mail->Port = 465 ;
        $this->mail->From = 'carrepair_system@deestone.com';
        $this->mail->FromName = 'carrepair_system@deestone.com';
        $this->mail->addAddress($email);
        $this->mail->isHTML(true);
        $this->mail->SMTPOptions = array(
            'ssl' => array(
                'verify_peer' => false,
                'verify_peer_name' => false,
                'allow_self_signed' => true
            )
        );
        $this->mail->Subject =  "Request for car repair เลขที่ใบขออนุมัติ : " . $inp_RepairID_sent;
        $this->mail->Body    = "เลขที่ใบขออนุมัติ : "."<font color='red'>".$inp_RepairID_sent."</font>"
                               ."<br>"."อนุมัติ : "."<a href='http://lungryn.deestonegrp.com:8812/ApprovalRequest?repairId=$inp_RepairID_sent&idapp=$idApproved'>Link</A> ";


        if($this->mail->send())
        {
            $updateStatus = sqlsrv_query(
                                            $this->conn->connect(),
                                            "UPDATE REPAIR SET STATUSREPAIR=2
                                            WHERE REPAIRID=?",
                                            array(
                                                $inp_RepairID_sent
                                            )
                                );

                if($updateStatus)
                {
                    return  [
                        "result" => true,
                        "message" => "Sent email  successful."
                    ];
                }
                else
                {
                    return  [
                        "result" => false,
                        "message" => "Sent email  Failed."
                    ];
                }
        }
        else
        {
            return  [
                "result" => false,
                "message" => "Sent email  Failed."
            ];
        }
    }

    public function send_hr($inp_RepairID_sent,$manager_v)
    {

        $email_a = Sqlsrv::array(
            $this->conn->connect(),
            "SELECT TOP(1) U.EMAIL
            FROM MASTER_USER U
            WHERE U.ID = '$manager_v'"
        );

        $userid = $_SESSION["userid"];

        $updateHRAdmin = Sqlsrv::array(
            $this->conn->connect(),
            "UPDATE P
            SET P.HRADMIN = 'userid'
            FROM REPAIR P
            WHERE P.REPAIRID = '$inp_RepairID_sent'"
        );

        foreach ($email_a as $key) {
            $email = $key->EMAIL;
        }
        // var_dump($email);exit();

        // $email = 'surapon_o@deestone.com';
        $idApproved = $manager_v;

        //$mail = new PHPMailer;
        $this->mail->isSMTP();
        $this->mail->Host = 'smtp-relay.gmail.com';
        $this->mail->SMTPAuth = true;
        $this->mail->SMTPSecure = "ssl";
        $this->mail->Username = 'noreply@deestone.com';
        $this->mail->Password = "tckpwktdnrpahmem";
        $this->mail->CharSet = "utf-8";
        $this->mail->Port = 465 ;

        $this->mail->From = 'carrepair_system@deestone.com';
        $this->mail->FromName = 'carrepair_system@deestone.com';
        $this->mail->addAddress($email);
        $this->mail->isHTML(true);
        $this->mail->SMTPOptions = array(
            'ssl' => array(
                'verify_peer' => false,
                'verify_peer_name' => false,
                'allow_self_signed' => true
            )
        );
        $this->mail->Subject =  "Request for car repair";

        $this->mail->Body    = "เลขที่ใบขออนุมัติ : "."<font color='red'>".$inp_RepairID_sent."</font>"
                               ."<br>"."อนุมัติ : "."<a href='http://lungryn.deestonegrp.com:8812/ApprovalRepair?repairId=$inp_RepairID_sent&idapp=$idApproved'>Link</A> ";
        if($this->mail->send())
        {
            $updateStatus = sqlsrv_query(
                                            $this->conn->connect(),
                                            "UPDATE REPAIR SET STATUSREPAIR=5
                                            WHERE REPAIRID=?",
                                            array(
                                                $inp_RepairID_sent
                                            )
                                );

                if($updateStatus)
                {
                    return  [
                        "result" => true,
                        "message" => "Sent email  successful."
                    ];
                }
                else
                {
                    return  [
                        "result" => false,
                        "message" => "Sent email  Failed."
                    ];
                }
        }
        else
        {
            return  [
                "result" => false,
                "message" => "Sent email  Failed."
            ];
        }
    }
    public function send($from_type,$repairid,$manager_id=[])//tan_edit_20180704
    {
        $check = true;

        if($from_type=="mail_re")
        {
            $statusid = 2;

        }
        else if($from_type=="mail_hr")
        {
            $statusid = 5;
            $userid = $_SESSION["userid"];
            $updateHRAdmin = Sqlsrv::array(
                $this->conn->connect(),
                "UPDATE P
                SET P.HRADMIN = ?
                FROM REPAIR P
                WHERE P.REPAIRID = ?",
                [$userid,$repairid]
            );
        }
        // else if($from_type=="mail_directer")
        // {
        //     $statusid = 7;

        // }
       
            $from = $_SESSION['EMAIL'];

        foreach ($manager_id as $m) {

           $idApproved = $m; 
           $email_a = Sqlsrv::array(
           $this->conn->connect(),
                                "SELECT TOP(1) U.EMAIL
                                FROM MASTER_USER U 
                                WHERE U.ID = ?",[$m]);

           foreach ($email_a as $key) {
                $email[] = $key->EMAIL;
           }

            $subject =  "Request for car repair เลขที่ใบขออนุมัติ : " . $repairid;
            $body = self::body_approve($idApproved,$repairid,$from_type);
            $sendemail =  self::sendemailall($subject,$body,$from,$email);
            if(!$sendemail)
            {
                $check = false;
            }

        }//end for $m

        if($check)
        {
            $updateStatus = sqlsrv_query($this->conn->connect(),
                                        "UPDATE REPAIR SET STATUSREPAIR= ?
                                        WHERE REPAIRID= ?",
                                        array($statusid,$repairid));
                  
            if($updateStatus)
            {
                return  [
                    "status" => 200,
                    "message" => "Sent email  successful."
                ];
            }
            else
            {
                return  [
                    "status" => 404,
                    "message" => "Sent email  Failed."
                ];
            }
        }
        else
        {
            return  [
                    "status" => 404,
                    "message" => "Sent email  Failed."
                ];
        }
        
    
    }

    public function body_approve($idApproved,$id,$fromapprove)
    {
        
        $body = "มีคำร้องขออนุมัติรายการซ่อมรถ  มีรายละเอียด ดังนี้ <br><br>";
        $body .= "<table border =1 >";
        $body .= "<tr align='center' bgcolor='#66CCFF'><td>รหัสแจ้งซ่อม</td>";
        $body .= "<td>วันที่</td>";
        $body .= "<td>บริษัท</td>";
        $body .= "<td>ชื่อผู้ขับขี่</td>";
        $body .= "<td>รุ่น</td>";
        $body .= "<td>ประเภทรถ</td>";
        $body .= "<td>ทะเบียนรถ</td>";
        $body .= "<td>เลขไมล์</td>";
        $body .= "<td>สาเหตุ</td>";
        $body .= "</tr>";
        $sql = Sqlsrv::array($this->conn->connect(),
                            "SELECT R.ID
                                        ,R.REPAIRID
                                        ,R.CREATEDATE
                                        ,R.COMPANY [COMPANYID]
                                        ,CM.INTERNALCODE
                                        ,R.DRIVER [DRIVERID]
                                        ,DM.DRIVERNAME
                                        ,C.BRAND [BRANDID]
                                        ,BM.BRAND
                                        ,C.REGISTERTYPE [REGISTERTYPEID]
                                        ,RTM.REGISTERTYPE
                                        ,C.REGCAR
                                        ,R.MILESNO
                                        ,R.REMARK
                                        ,R.STATUSREPAIR
                                FROM REPAIR R
                                LEFT JOIN MASTER_COMPANY CM ON CM.ID = R.COMPANY
                                LEFT JOIN MASTER_DRIVER DM ON DM.ID = R.DRIVER
                                LEFT JOIN MASTER_CAR C ON C.CarID = R.CarID
                                LEFT JOIN MASTER_BRAND BM ON BM.ID=C.BRAND
                                LEFT JOIN MASTER_REGISTERTYPE RTM ON RTM.ID=C.REGISTERTYPE
                                LEFT JOIN MASTER_STATUS SM ON SM.ID=R.STATUSREPAIR
                                LEFT JOIN MASTER_USER U ON U.ID = R.CREATEBY
                            WHERE R.REPAIRID = ?",
                            [$id]);

        foreach ($sql as $s) {
            $body .= "<tr><td>" . $s->REPAIRID . "</td>";
            $body .= "<td>" . $s->CREATEDATE . "</td>";
            $body .= "<td>" . $s->INTERNALCODE . "</td>";
            $body .= "<td>" . $s->DRIVERNAME . "</td>";
            $body .= "<td>" . $s->BRAND . "</td>";
            $body .= "<td>" . $s->REGISTERTYPE ."</td>";
            $body .= "<td>" . $s->REGCAR. "</td>";
            $body .= "<td>" . $s->MILESNO. "</td>";
            $body .= "<td>" . $s->REMARK . "</td>";
            $body .= "</tr>";
        }
        $body .= "</table>";
        $body .= "<br>จึงเรียนมาเพื่อทราบและอนุมัติ<br>ถ้าคุณต้องการอนุมัติคำร้องนี้ โปรดคลิ๊กที่ ";
        if($fromapprove == 'mail_re')
        {   
            $body .= "<a href='http://lungryn.deestonegrp.com:8812/ApprovalRequest?repairId=$id&idapp=$idApproved'>อนุมัติ</A>";
        }
        else if($fromapprove == 'mail_hr')
        {
            $body .= "<a href='http://lungryn.deestonegrp.com:8812/ApprovalRepair?repairId=$id&idapp=$idApproved'>อนุมัติ</A>";   
        }
        else if($fromapprove == 'mail_directer')
        {
             $body .= "<a href='http://lungryn.deestonegrp.com:8812/ApprovalDirecter?repairId=$id&idapp=$idApproved'>อนุมัติ</A> " ;
        }
        
        return $body;
    }

    public function email($subject,$body,$from,$to=[])
    {
        foreach ($to as $t) {
            // var_dump($to); exit();

            $this->mail->addAddress($t);
        }
      
        $this->mail->isSMTP();
        $this->mail->Host = 'smtp-relay.gmail.com';
        $this->mail->SMTPAuth = true;
        $this->mail->Username = 'noreply@deestone.com';
        $this->mail->Password = "tckpwktdnrpahmem";
        $this->mail->SMTPSecure = "ssl";
        $this->mail->SMTPOptions = array(
            'ssl' => array(
                'verify_peer' => false,
                'verify_peer_name' => false,
                'allow_self_signed' => true
            )
        );
        $this->mail->Port = 465 ;
        $this->mail->isHTML(true);
        $this->mail->CharSet = "utf-8";
        // $this->mail->setFrom('ea_devteam@deestone.com', $from);
        // $this->mail->addReplyTo($from);
        // $this->mail->From = $from;
        $this->mail->From = 'carrepair_system@deestone.com';
        $this->mail->FromName = $from; 
        $this->mail->Sender = 'noreply@deestone.com';
        $this->mail->Subject = $subject;
        $this->mail->Body = $body;
        if($this->mail->send()){
            return true;
        }
        else{
            return false;
        }
    }

    public function sendemailall($subject,$body,$from,$to =[])
    {
        foreach ($to as $t) {

            $this->maildi->addAddress($t);
        }
      
        $this->maildi->isSMTP();
        $this->maildi->Host = 'smtp-relay.gmail.com';
        $this->maildi->SMTPAuth = true;
        $this->maildi->SMTPSecure = "ssl";
        $this->maildi->Username = 'noreply@deestone.com';
        $this->maildi->Password = "tckpwktdnrpahmem";
        $this->maildi->CharSet = "utf-8";
        $this->maildi->Port = 465 ;
        // $this->maildi->setFrom('ea_devteam@deestone.com', $from);
        // $this->maildi->addReplyTo($from);
        // $this->maildi->From = $from;
        $this->maildi->From = 'carrepair_system@deestone.com';
        $this->maildi->FromName = $from;
        $this->maildi->Sender = 'noreply@deestone.com';
        $this->maildi->isHTML(true);
        $this->maildi->SMTPOptions = array(
            'ssl' => array(
                'verify_peer' => false,
                'verify_peer_name' => false,
                'allow_self_signed' => true
            )
        );
        $this->maildi->Subject = $subject;
        $this->maildi->Body = $body;
        if($this->maildi->send()){
            return true;
        }
        else{
            return false;
        }
    }

    public function reply($status,$id,$from,$director = false)//tan_edit_20180704
    {

        $sql = Sqlsrv::array($this->conn->connect(),
                            "SELECT P.STATUSREPAIR
                              ,P.REPAIRID
                              ,MC.REGCAR
                              ,B.BRAND
                              ,p.CREATEDATE
                              ,P.REMARK
                              ,C.INTERNALCODE
                              ,UC.EMAIL [E_CREATE]
                              ,UCM.EMAIL [E_USERMANAGER]
                              ,U_HR.EMAIL [E_HR]
                              ,MU.EMAIL [ADMIN]
                          from REPAIR P
                          LEFT JOIN MASTER_CAR MC
                          ON MC.CARID = P.CARID
                          LEFT JOIN MASTER_BRAND B
                          ON B.ID = MC.BRAND
                          LEFT JOIN MASTER_SECTION S
                          ON S.ID = P.SECTION
                          LEFT JOIN MASTER_USER UC
                          ON UC.ID = P.CREATEBY
                          LEFT JOIN MASTER_USER UCM
                          ON UCM.ID = P.APPROVEDBY
                          LEFT JOIN MASTER_USER U_HR
                          ON U_HR.ID = P.HRADMIN
                          LEFT JOIN MASTER_COMPANY C
                          ON C.ID = P.COMPANY
                          LEFT JOIN FACTORY F
                          ON F.COMPANY = P.COMPANY
                          LEFT JOIN MASTER_USER MU
                          ON MU.ID = F.USERID
                          AND MU.SECTION = '2'
                          AND MU.POSITION = '2'
                          AND MU.DEPARTMENT = '3'
                          WHERE P.REPAIRID = ?",
                          [$id]);

        $check = false;
        foreach ($sql as $s) {
            $check = true;
            if($status==4)
            {   
                $email[] = $s->E_CREATE;
                $email[] = $s->ADMIN;
                $approve = "อนุมัติ";

            }
            elseif($status==3)
            {
                $email[] = $s->E_CREATE;
                $approve = "ไม่อนุมัติ";
            }
            elseif($status ==6 and $director == false)
            {
                $email[] = $s->E_CREATE;
                $email[] = $s->E_HR;
                $email[] = $s->E_USERMANAGER;
                $approve = "ไม่อนุมัติ";
            }
            // elseif($status ==7)
            // {   
            //     $email[] = $s->E_HR;
            //     $approve = "อนุมัติ";
            // }
            // elseif($status ==10 and $director == true)
            // {
            //     $email[] = $s->E_CREATE;
            //     $email[] = $s->E_HR;
            //     $email[] = $s->E_USERMANAGER;
            //     $approve = "ไม่อนุมัติ";
            // }
            else if($status ==8)
            {
                $email[] = $s->E_CREATE;
                $email[] = $s->E_HR;
                $email[] = $s->E_USERMANAGER;
                $approve = "อนุมัติ";
            }

        }

        $q_from = Sqlsrv::array($this->conn->connect(),
                               "SELECT *
                               FROM MASTER_USER
                               WHERE  ID = ?",
                               [$from]);
        foreach ($q_from as $f) { 
            $user_from = $f->EMAIL;
        }

        if($check)
        {
            $from = $user_from;
            $subject = "แจ้งสถานะคำร้องขออนุมัติรายการซ่อมรถเลขที่:" . $s->REPAIRID;
            $body = "รหัสแจ้งซ่อม:  " .  $s->REPAIRID . "<br>";
            $body .="วันที่:  " . $s->CREATEDATE . "<br>";
            $body .="บริษัท:  " . $s->INTERNALCODE . "<br>";
            $body .="ทะเบียนรถ:  " . $s->REGCAR . "<br>";
            $body .="สาเหตุ:  " . $s->REMARK . "<br>";
            $body .= "<font color='red'>ผลการอนุมัติ:  " . $approve . "</font><br>";
            $body .= "ถ้าคุณต้องการเข้าสู่หน้าเว็บ โปรด";
            $body .= "<a href='http://lungryn.deestonegrp.com:8812/user/auth'>คลิ๊กที่นี่</A>";
            $sendemail =  self::email($subject,$body,$from,$email);
            // var_dump($subject); exit();
            if($sendemail){
                return true;
            }else{
                return false;
            }
            
        }
        return  false;

    }

    public function sendpass($inp_mailpass)
    {
        // $from = "ea_devteam@deestone.com";
        $pullpass = self::pullpass($inp_mailpass);
        if(!$pullpass){
            echo json_encode(["status" => 404, "message" => "เมลล์นี้ไม่มีในระบบ กรุณาติดต่อ Admin"]);
            exit;
        }
       
          foreach ($pullpass as $s ) {
            $subject = "Car Repair แจ้งลืมรหัสผ่าน ";
            $body = "แจ้งรหัสผ่านสำหรับใช้งานระบบซ่อมรถออนไลน์ <b> Car Reair : </b>".$s->ID."<br><table><tr><td>Username : </td><td>".$s->USERNAME."</td></tr><tr><td>Password : </td><td>".$s->PASSWORD."</td></tr></table><br>กรุณาจดบันทึกเพื่อใช้ในครั้งถัดไป<br>";
          }  
        
            $this->maildi->isSMTP();
            $this->maildi->Host = 'smtp-relay.gmail.com';
            $this->maildi->SMTPAuth = true;
            $this->maildi->SMTPSecure = "ssl";
            $this->maildi->Username = 'noreply@deestone.com';
            $this->maildi->Password = "tckpwktdnrpahmem";
            $this->maildi->CharSet = "utf-8";
            $this->maildi->Port = 465 ;
            // $this->maildi->setFrom('carrepair_system@deestone.com', $from);
            // $this->maildi->addReplyTo($from);
            $this->maildi->From = 'carrepair_system@deestone.com';
            $this->maildi->FromName = 'carrepair_system@deestone.com';
            $this->maildi->Sender = 'noreply@deestone.com';
            $this->maildi->isHTML(true);
            $this->maildi->SMTPOptions = array(
                'ssl' => array(
                    'verify_peer' => false,
                    'verify_peer_name' => false,
                    'allow_self_signed' => true
                )
            );
            $this->maildi->Subject = $subject;
            $this->maildi->Body = $body;
            $this->maildi->addAddress($inp_mailpass);
        if($this->maildi->send()){
           return true;
        }
        else{
            return false;
        }
    }

    public function pullpass($inp_mailpass)
    {
        return Sqlsrv::array($this->conn->connect(),
                          "SELECT *
                          FROM MASTER_USER WHERE  EMAIL = ?",
                          [
                            $inp_mailpass
                          ]);

    }

    public function sendtest($from_type,$repairid,$manager_id=[])//tan_edit_20180704
    {
        $subject = 'subject_carrepair';
        $body = 'body_carrepair';
        $from = 'ekasit_a_carrepair';
        $email = 'ekasit_a@deestone.com';
        $sendemail =  self::sendemailtest($subject,$body,$from,$email);
        if($sendemail == true)
        {
            return  [
                "status" => 200,
                "message" => "Sent email  successful."
            ];
        } 
        else
        {
            return  [
                "status" => 404,
                "message" => "Sent email  Failed."
            ];
        }
    
    }

    public function sendemailtest($subject,$body,$from,$email)
    {
        // foreach ($to as $t) {

            $this->maildi->addAddress('ekasit_a@deestone.com');
        // }
      
        $this->maildi->isSMTP();
        $this->maildi->Host = 'smtp-relay.gmail.com';
        $this->maildi->SMTPAuth = true;
        $this->maildi->SMTPSecure = "ssl";
        $this->maildi->Username = 'noreply@deestone.com';
        $this->maildi->Password = "tckpwktdnrpahmem";
        $this->maildi->CharSet = "utf-8";
        $this->maildi->Port = 465 ;
        // $this->maildi->setFrom('ea_devteam@deestone.com', $from);
        // $this->maildi->addReplyTo($from);
        // $this->maildi->From = $from;
        $this->maildi->From = 'carrepair_system@deestone.com';
        $this->maildi->FromName = $from;
        $this->maildi->Sender = 'noreply@deestone.com';
        $this->maildi->isHTML(true);
        $this->maildi->SMTPOptions = array(
            'ssl' => array(
                'verify_peer' => false,
                'verify_peer_name' => false,
                'allow_self_signed' => true
            )
        );
        $this->maildi->Subject = $subject;
        $this->maildi->Body = $body;
        if($this->maildi->send()){
            return true;
        }
        else{
            return false;
        }
    }

}
