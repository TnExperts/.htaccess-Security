<?php
function getrealip()
{
 if (isset($_SERVER)){
if(isset($_SERVER["HTTP_X_FORWARDED_FOR"])){
$ip = $_SERVER["HTTP_X_FORWARDED_FOR"];
if(strpos($ip,",")){
$exp_ip = explode(",",$ip);
$ip = $exp_ip[0];
}
}else if(isset($_SERVER["HTTP_CLIENT_IP"])){
$ip = $_SERVER["HTTP_CLIENT_IP"];
}else{
$ip = $_SERVER["REMOTE_ADDR"];
}
}else{
if(getenv('HTTP_X_FORWARDED_FOR')){
$ip = getenv('HTTP_X_FORWARDED_FOR');
if(strpos($ip,",")){
$exp_ip=explode(",",$ip);
$ip = $exp_ip[0];
}
}else if(getenv('HTTP_CLIENT_IP')){
$ip = getenv('HTTP_CLIENT_IP');
}else {
$ip = getenv('REMOTE_ADDR');
}
}
return $ip; 
}


$VIP = getrealip();
{
?>
<html>
    <body>
        <center> <h1> <bold>Nothing Personal.</bold> </h1> </center>
        <center> <h2> <bold>But you can't get what u'r searching.</bold> </h2> </center>
        <center> <h3> <bold>Your IP  (<?php echo $VIP; ?>), Is Savet On Log File. If we read it more than 3'times, you will be banned from this site! </bold> </h3> </center>
    </body>
</html>
        
<?php
include "iplist.txt"; 
$ip = $_SERVER['REMOTE_ADDR'];
$file = "iplist.txt"; //Select file
$file = fopen($file, "a"); //Appened file
$data = "<center><b>IP</b>: $ip NEW!<br></center>";
fwrite($file, $data); //Write data to file
fclose($file); //Close the file
}
?>
