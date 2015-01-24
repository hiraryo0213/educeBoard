var CourseList = CourseLoader();
var UserList;
var cid;
var uid;
var uname;

/*---ログイン画面部分---*/

$(document).ready(function(){
	
	//コース選択のプルダウンをセット
	$("#login_table").append('<tr id="login_course"><td class="left"><p>コース</p></td><td><a href="#"><p id="course_select">コース選択</p></a></td></tr>');
	//プルダウンの効果を付与
	$("#course_select").click(function(){
		if($("#login_name").length){
			if($("#login_pass").length){
				$("#login_pass").remove();
				$("#login_button").remove();
			}
			$("#login_name").remove();
			CoursePull();
		}
		else{
			CoursePull();
		}
	});
	
	//名前選択のプルダウンをセット
	
	
});

//コースプルダウン部分を生成
function CoursePull(){
	$("#login").append(addCourse(CourseList));
	$("li.pull").click(function(){
		var _cname = $(this).text();
		cid = $(this).attr("value");
		$("#course_select").text(_cname);
		$("#pulldown").remove();
		addLoginName();
	});
	$("#pulldown").hover(function(){},function(){
		$(this).remove();
	});
}

//ユーザプルダウンボタンを生成
function addLoginName(){
	$("#login_table").append('<tr id="login_name"><td class="left"><p>名前</p></td><td><a href="#"><p id="name_select">名前を選択</p></a></td></tr>');
	UserList = MemberLoader(cid);
	$("#name_select").click(function(){
		if($("#login_pass").length){
			$("#login_pass").remove();
			$("#login_button").remove();
			NamePull();
		}
		else{
			NamePull();
		}
	});
}

//ユーザプルダウンを生成
function NamePull(){
	$("#login").append(addMember(UserList));
	$("li.pull").click(function(){
		var _uname = $(this).text();
		uid = $(this).attr("value");
		uname = $(this).children("span").text();
		$("#name_select").text(_uname);
		$("#pulldown").remove();
		addPass_button();
	});
	$("#pulldown").hover(function(){},function(){
		$(this).remove();
	});
}

//パスワード入力部分とログインボタンを生成
function addPass_button(){
	$("#login_table").append('<tr id="login_pass"><td class="left"><p>パスワード</p></td><td><input type="password" id="pass"/></td></tr><tr id="login_button"><td></td><td><a href="#"><p id="bottom">ログイン</p></a></td></tr>');
	$("#bottom").click(loginHandler);
}

function loginHandler(){
	var pass = $("#pass").val();
	var loginJadge = loginAuth(uid,pass);
	if(loginJadge == "true"){
		alert('パスワードが違います。');
	}
	else{
		sessionSelectHandler();
	}
}

/*---ログイン画面部分終了---*/

/*---セッション選択画面部分---*/
function sessionSelectHandler(){
	/*var str = '<article id="session_select"></article>'
	$("section").append(str);
	sessionListMaker(sessionLoader(cid,uid));*/
	$("#main").children("div").remove();
	flashLoader();
}

function flashLoader(){
	$("header").append('<p id="nowlogin">ようこそ ' + uname +' さん</p>');
	$("#main").append('<div id="mainflash"><div id="flashdummy"></div></div>');
	var flashvars = {uid:uid,uname:uname};
	var params = {menu:false};
	var attributes = {id:'swfPlayer',name:'swfPlayer'};
	swfobject.embedSWF("./educeboard1.swf","flashdummy","1000","640","9.0.0","./expressInstall.swf",flashvars, params, attributes);
}

function sessionListMaker(xml){
	var _SessionList = xml.documentElement.getElementsByTagName("SessionList");
	var _simid;
	var _simname;
	var _sid;
	var _sname;
	var _tid;
	var _timestamp;
	var str = '<menu id="sim_select"><h1>セッション一覧</h1><ul class="sim">';
	for(var element in _SessionList){
		_simid.push(_SessionList.sim_id);
		_simname.push(_SessionList.sim_name);
		_sid.push(_SessionList.session_id);
		_sname.push(_SessionList.session_name);
		_tid.push(_SessionList.trial_id);
		_timestamp.push(_SessionList.timestamp);
	}
	_simid = unique(_simid);
	_simname = unique(_simname);
	_sid = unique(_sid);
	_sname = unique(_sname);
	_tid = unique(_tid);
	_timestamp = unique(timestamp);
	
}


/*---XML_Loader---*/

function CourseLoader(){
	var xmlhttp = new XMLHttpRequest();
	xmlhttp.open("GET","http://pb.fm.senshu-u.ac.jp/~tmochi/educeboard/loginCourseList.php?xml=1",false);
	xmlhttp.send();
	return xmlhttp.responseXML;
}

function addCourse(xml){
	var _CourseList = xml.documentElement.getElementsByTagName("CourseList");
	var str = '<div id="pulldown"><ul>';
	for(var i = 0; i < _CourseList.length; i++){
		var _cid = _CourseList[i].getElementsByTagName("cid")[0].childNodes[0].nodeValue;
		var _cname = _CourseList[i].getElementsByTagName("cname")[0].childNodes[0].nodeValue;
		str += '<a href="#"><li class="pull" value="' + _cid + '"><span>' + _cname +'</span></li></a>';
	}
	str += '</ul></div>';
	return str;
}

function MemberLoader(id){
	var xmlhttp = new XMLHttpRequest();
	xmlhttp.open("GET","http://pb.fm.senshu-u.ac.jp/~tmochi/educeboard/loginCourseMemberList.php?xml=1&cid="+ id,false);
	xmlhttp.send();
	return xmlhttp.responseXML;
}

function addMember(xml){
	var _UserList = xml.documentElement.getElementsByTagName("UserList");
	var str = '<div id="pulldown"><ul>';
	for(var i = 0; i < _UserList.length; i++){
		var _uid = _UserList[i].getElementsByTagName("uid")[0].childNodes[0].nodeValue;
		var _uname = _UserList[i].getElementsByTagName("username")[0].childNodes[0].nodeValue;
		str += '<a href="#"><li class="pull" value="' + _uid + '"><span>' + _uname +'</span></li></a>';
	}
	str += '</ul></div>';
	return str;
}

function loginAuth(id,pass){
	var xmlhttp = new XMLHttpRequest();
	xmlhttp.open("GET",'http://pb.fm.senshu-u.ac.jp/~tmochi/educeboard/loginAuth.php?uid=' + id + '&pwd=' + pass,false);
	xmlhttp.send();
	return xmlhttp.responseText;
}

function sessionLoader(id,id2){
	var xmlhttp = new XMLHttpRequest();
	xmlhttp.open("GET","http://pb.fm.senshu-u.ac.jp/~tmochi/educeboard/showSessionList.php?cid="+ id +"&uid=" + id2,false);
	xmlhttp.send();
	return xmlhttp.responseXML;
}

/*---XML_Loader 終了---*/

/*---重複した配列要素を削除する関数---*/
function unique(array) {
　var storage = {};
　var uniqueArray = [];
　var i,value;
　for ( i=0; i<array.length; i++) {
   　value = array[i];
      if (!(value in storage)) {
      　storage[value] = true;
         uniqueArray.push(value);
       }
   }
   return uniqueArray;
}

/*---重複した配列要素を削除する関数 終了---*/