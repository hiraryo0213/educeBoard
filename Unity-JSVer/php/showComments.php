<?php  
  error_reporting(E_ALL ^ E_DEPRECATED);
  header('Access-Control-Allow-Origin: *');
  if(isset($_GET['session_id'])) {
      $session_id = $_GET['session_id'];
  }
  if(isset($_GET['tid'])) {
      $tid = $_GET['tid'];
  }

//選択されたラジオボタンの value の内容を表示する
//   print "送信されたセッションidは、 $sid です。<br/>";
//   print "送信されたセッションの名前は、 $session_name です。<br/>";
//   for( $i = 0; $i < count( $member_id ) ; $i++ ){
//		print "送信されたmember_idは {$member_id[$i]}です。<br/>";
//	}
//   print "送信された背景画像のidは、 $bgimage です。<br/>";

  if($session_id=='' or $tid==''){
    print "Data submission is not sufficient.";
  }
  else{
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

    $sql = sprintf("SELECT Comments.id, Comments.time, Users.uid, Users.name, Comments.text, Comments.disable from Comments, Users WHERE Comments.session_id = $session_id and Comments.tid=$tid and Users.uid= Comments.uid order by Comments.time");

    $result = mysql_query($sql, $link) or die("クエリ1の送信に失敗しました。<br />SQL:".$sql);

   header ("Content-Type: text/xml; charset=UTF-8");
   echo "<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n";
   echo "<data>\n";
   while ($row = mysql_fetch_assoc($result)) {
	      if ($row['disable']==0){
		print ("<Comments id='".$row['id']."'>\n");
#		echo "<id>";
#		echo $row['id'];
#		echo "</id>\n";
		echo "<time>";
		echo $row['time'];
		echo "</time>\n";
		echo "<uid>\n";
		echo $row['uid'];
		echo "</uid>\n";
		echo "<username>";
#		echo mb_convert_encoding($row['name'],'UTF-8','SJIS-win');
		echo $row['name'];
		echo "</username>\n";
		echo "<text>";
#		echo mb_convert_encoding($row['text'],'UTF-8','SJIS-win');
		echo $row['text'];
		echo "</text>\n";
		echo "</Comments>\n";
	      }
	    }
    echo "</data>\n";
    mysql_close($link) or die("MySQL切断に失敗しました。");
  }

?>