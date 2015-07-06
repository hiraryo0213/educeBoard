<?php  
  error_reporting(E_ALL ^ E_DEPRECATED);
  header('Access-Control-Allow-Origin: *');

  if(isset($_GET['uid'])) {
      $uid = $_GET['uid'];
  }
  if(isset($_GET['cid'])) {
      $cid = $_GET['cid'];
  }

  $cid=$_GET["cid"];

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

  $sql = sprintf("SELECT Simulations.sim_id, Simulations.sim_name, Simulations_Sessions.session_id, Simulations_Sessions.session_name, Sessions_Trials.tid, Sessions_Trials.TS_END, Sessions_Trials.disable FROM Simulations, Simulations_Sessions, Sessions_Users, Sessions_Trials WHERE Simulations.cid = $cid AND Sessions_Users.uid = $uid AND Simulations.sim_id = Simulations_Sessions.sim_id AND Simulations_Sessions.session_id = Sessions_Users.session_id AND Sessions_Trials.session_id = Sessions_Users.session_id ORDER BY Simulations.sim_id, Simulations_Sessions.session_id, Sessions_Trials.tid");

  $result = mysql_query($sql, $link) or die("クエリの送信に失敗しました。<br />SQL:".$sql);

   header ("Content-Type: text/xml; charset=UTF-8");
   echo "<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n";
   echo "<data>\n";

$_session_id = 0;
$_sim_id = 0;


while ($row = mysql_fetch_assoc($result)) {
  if ( $row['disable'] ==0){
    if ($_sim_id != $row['sim_id'] ){
      if ($_sim_id != 0){
      echo "</session>\n";
      echo "</simulation>\n";
	  $_session_id = 0;
      }
      echo "<simulation>\n";
      echo " <sim_id>";
      echo $row['sim_id'];
      echo "</sim_id>\n";
      echo "<sim_name>";
      echo $row['sim_name'];
      echo "</sim_name>\n";
      $_sim_id = $row['sim_id'];
      }
    if ($_session_id != $row['session_id']){
		if ($_session_id != 0){
       	 echo "</session>\n";
      }
      echo "<session>";
      echo "<session_id>";
      echo $row['session_id'];
      echo "</session_id>\n";
      echo "<session_name>";
      echo $row['session_name'];
      echo "</session_name>\n";
      $_session_id = $row['session_id'];
      }
	 echo "<trial>\n";
     echo "<trial_id>";
     echo $row['tid'];
     echo "</trial_id>\n";
     echo "<timestamp>";
     echo $row['TS_END'];
     echo "</timestamp>\n";
     echo "</trial>\n";
  }
}


/*
while ($row = mysql_fetch_assoc($result)) {
	if ( $row['disable'] ==0){
		$_simid = $row['sim_id'];
		echo "<SimulationList>\n";
		echo " <sim_id>";
		echo $row['sim_id'];
		echo "</sim_id>\n";
		echo " <sim_name>";
		echo $row['sim_name'];
		echo "</sim_name>\n";
		while ($row2 = mysql_fetch_assoc($result)){
			if ($row2['sim_id'] == $_simid){
				$_sid = $row2['session_id'];
				echo " <SessionList>\n";
				echo "  <session_id>";
				echo $row2['session_id'];
				echo "</session_id>\n";
				echo "  <session_name>";
				echo $row2['session_name'];
				echo "</session_name>\n";
				while ($row3 = mysql_fetch_assoc($result)){
					if($row3['session_id'] == $_sid){
						echo "  <trialList>\n";
						echo "   <trial_id>\n";
						echo $row3['tid'];
						echo "</trial_id>\n";
						echo " <timestamp>";
						echo $row3['TS_END'];
						echo "</timestamp>\n";
						echo "  </trialList>\n";
					}
				}
				echo " </SessionList>";
			}
		}
		echo "</SimulationList>\n";
	}
}
*/
   echo "</session>\n";
   echo "</simulation>\n";
   echo "</data>\n";

  mysql_free_result($result);

  mysql_close($link) or die("MySQL切断に失敗しました。");


?>
