<?php  
  header('Access-Control-Allow-Origin: *');
  error_reporting(E_ALL ^ E_DEPRECATED);
  if(isset($_GET['xml'])) {
      $xml = $_GET['xml'];
  }
  else{
	$xml = 0;
  }
  if(isset($_GET['cid'])) {
      $cid = $_GET['cid'];
  }

  mb_language("uni");
  mb_internal_encoding("utf8"); 
  mb_http_input("auto");
  mb_http_output("utf8");
  $url = "localhost";
  $user = "root";
  $pass = "hoge1234";
  $db = "educeboard";

  $link = mysql_connect($url,$user,$pass) or die("MySQLへの接続に失敗しました。");

  $sdb = mysql_select_db($db,$link) or die("データベースの選択に失敗しました。");

  $sql = sprintf("SELECT Users.uid, Users.name From Users, Users_Courses where Users_Courses.cid = $cid and Users.uid = Users_Courses.uid");

  $result = mysql_query($sql, $link) or die("クエリの送信に失敗しました。<br />SQL:".$sql);

if ($xml==1){
   header ("Content-Type: text/xml; charset=UTF-8");
   echo "<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n";
   echo "<data>\n";
  while ($row = mysql_fetch_assoc($result)) {
    echo "<UserList id='".$row['uid']."'>\n";
    echo " <uid>";
    echo $row['uid'];
    echo "</uid>";
    echo "<username>";
#    echo mb_convert_encoding($row['name'], 'UTF-8','Shift_JIS');
    echo $row['name'];
    echo "</username>\n";
    echo "</UserList>\n";
  }
  echo "</data>\n";
}

else{
  header ("Content-Type: text/html; charset=Shift_JIS");
  while ($row = mysql_fetch_assoc($result)) {
    echo $row['uid'];
    echo ",";
    echo mb_convert_encoding($row['name'], 'Shift_JIS','UTF-8');
    echo ",";
    echo "<br/>";
  }
}

  mysql_free_result($result);

  mysql_close($link) or die("MySQL切断に失敗しました。");


?>