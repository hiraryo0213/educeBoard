<?php  
#  ob_start();
  error_reporting(E_ALL ^ E_DEPRECATED);
  header('Access-Control-Allow-Origin: *');
  if(isset($_GET['xml'])) {
      $xml = $_GET['xml'];
  }

  mb_language("ja");
  mb_internal_encoding("SJIS");
  mb_http_input("auto");
  mb_http_output("SJIS");

  $url= "localhost";
  $user = "root";
  $pass = "hoge1234";
  $db = "educeboard";

  $link = mysql_connect($url,$user,$pass) or die("MySQLへの接続に失敗しました。");

  $sdb = mysql_select_db($db,$link) or die("データベースの選択に失敗しました。");

  $sql = sprintf("SELECT cid, cname From Courses");

  $result = mysql_query($sql, $link) or die("クエリの送信に失敗しました。<br />SQL:".$sql);

if ($xml==1){
   header ("Content-Type: text/xml; charset=UTF-8");
   echo "<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n";
   echo "<data>\n";
    while ($row = mysql_fetch_assoc($result)) {
    echo "<CourseList id='".$row['cid']."'>\n";
	echo "<cid>";
	echo $row['cid'];
	echo "</cid>";
    echo "<cname>";
#    echo mb_convert_encoding($row['cname'], 'UTF-8','Shift_JIS');
    echo $row['cname'];
    echo "</cname>\n";
    echo "</CourseList>\n";
  }
    echo "</data>\n";
}
else{
    header ("Content-Type: text/html; charset=Shift_JIS");
    while ($row = mysql_fetch_assoc($result)) {
    echo $row['cid'];
    echo ",";
    echo mb_convert_encoding($row['cname'], 'Shift_JIS','UTF-8');
    echo ",";
    print "<br />";
  }
}
  mysql_free_result($result);

  mysql_close($link) or die("MySQL切断に失敗しました。");

?>