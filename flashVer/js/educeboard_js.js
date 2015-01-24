var CourseList = CourseLoader();
var UserList;
var cid;
var uid;
var uname;
var sid;
var tid;

/*---ログイン画面部分---*/

$(document).ready(function(){
	
	$("#logout").click(function(){
		location.reload(true);
	});
	
	//コース選択のプルダウンをセット
	$("#login_table").append('<tr id="login_course"><td class="left"><p>コース</p></td><td><p id="course_select">コース選択</p></td></tr>');
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
	$("#pulldown").animate({height:"200px"},300);
	$("li.pull").click(function(){
		var _cname = $(this).text();
		cid = $(this).attr("value");
		$("#course_select").text(_cname);
		$("#pulldown").animate({opacity:"0"},{duration:100,complete:function(){$("#pulldown").remove();addLoginName();}});
		//$("#pulldown").delay(200).remove();
	});
	$("#pulldown").hover(function(){},function(){
		$(this).animate({opacity:"0"},{duration:100,complete:function(){$("#pulldown").remove();}});
		//$(this).remove();
	});
}

//ユーザプルダウンボタンを生成
function addLoginName(){
	$("#login_table").append('<tr id="login_name"><td class="left"><p>名前</p></td><td><p id="name_select">名前を選択</p></td></tr>');
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
	$("#pulldown").animate({height:"200px"},300);
	$("li.pull").click(function(){
		var _uname = $(this).text();
		uid = $(this).attr("value");
		uname = $(this).children("span").text();
		$("#name_select").text(_uname);
		$("#pulldown").animate({opacity:"0"},{duration:100,complete:function(){$("#pulldown").remove();addPass_button();}});
	});
	$("#pulldown").hover(function(){},function(){
		$(this).animate({opacity:"0"},{duration:100,complete:function(){$("#pulldown").remove();}});
	});
}

//パスワード入力部分とログインボタンを生成
function addPass_button(){
	$("#login_table").append('<tr id="login_pass"><td class="left"><p>パスワード</p></td><td><input type="password" id="pass"/></td></tr><tr id="login_button"><td></td><td><p id="bottom"><span>ログイン</span></p></td></tr>');
	$("#bottom").click(loginHandler);
	$("#pass").select();
	$("#pass").keypress(function(e){
		if(e.which == 13){
			loginHandler();
		}
	});
}

function loginHandler(){
	console.log(cid,uid);
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
	//$("#main").children("div").remove();
	//flashLoader();
	var simulation = simulationLoader(cid,uid).documentElement.getElementsByTagName("simulation");
	var str = '<section id="id_select"><nav id="sim_select"><h1>シミュレーション一覧</h1><ul class="sim">';
	for(var i = 0; i < simulation.length; i++){
		str += '<li><p class="sim_name">';
		str += simulation[i].getElementsByTagName("sim_name")[0].childNodes[0].nodeValue;
		str += '</p><ul class="session">';
		var session = simulation[i].getElementsByTagName("session");
		for(var j = 0; j < session.length; j++){
			str += '<li><p class="session_name" value="';
			str += session[j].getElementsByTagName("session_id")[0].childNodes[0].nodeValue;;
			str += '">';
			str += session[j].getElementsByTagName("session_name")[0].childNodes[0].nodeValue;
			str += '</p><ul class="trial">';
			var trial = session[j].getElementsByTagName("trial");
			for(var k = 0; k < trial.length; k++){
				var trial_id = trial[k].getElementsByTagName("trial_id")[0].childNodes[0].nodeValue;
				str += '<li><p class="trial_name" value="';
				str += trial_id;
				str += '"><span>';
				str += trial_id;
				str += '回</span><span>';
				str += trial[k].getElementsByTagName("timestamp")[0].childNodes[0].nodeValue;
				str += '</span></p></li>';
			}
			str += '</ul></li>';
		}
		str += '</ul></li>';
	}
	str += '</ul></nav></section>';
	
	$("body").append(str);
	
	//表示アニメーション
	$("#id_select").animate({opacity:"1"},{duration:400,complete:function(){$("#pass").val('');}});
	$("#sim_select").delay(200).animate({top:"10%",opacity:"1"},500);
	
	//一覧枠の外をクリックすると消える動作
	var isListHover = false;
	$("#sim_select").hover(
		function(){isListHover = true;},
		function(){isListHover = false;}
	);
	$("#id_select").click(function(){
		if(!isListHover){
			$(this).delay(200).animate({opacity:"0"},{duration:400,complete:function(){$(this).remove();}});
			$("#sim_select").animate({top:"20%",opacity:"0"},500);
			$("#pass").select();
		}
	});
	
	//リストの動作
	$("p.sim_name").click(function(){
		$("p.sim_name").next("ul").slideUp();
		$("p.sim_name").css("background-color","#FFF");
		$("p.sim_name").hover(function(){
			$(this).css("background-color","#CFC");
			},function(){
			$(this).css("background-color","#FFF");
		});
		$(this).unbind("hover");
		$(this).next("ul").slideToggle();
		$(this).css("background-color","#CFC");
		$("p.session_name").next().slideUp();
		$("p.session_name").css("background-color","#FFF");
	});
	
	$("p.sim_name").hover(function(){
		$(this).css("background-color","#CFC");
	},function(){
		$(this).css("background-color","#FFF");
	});
	
	$("p.session_name").click(function(){
		$("p.session_name").next("ul").slideUp();
		$("p.session_name").css("background-color","#FFF");
		$("p.session_name").hover(function(){
			$(this).css("background-color","#FC6");
			},function(){
			$(this).css("background-color","#FFF");
		});
		$(this).unbind("hover");
		$(this).next("ul").slideToggle();
		$(this).css("background-color","#FC6");
		sid = $(this).attr("value");
	});
	
	$("p.session_name").hover(function(){
		$(this).css("background-color","#FC6");
	},function(){
		$(this).css("background-color","#FFF");
	});
	
	$("p.trial_name").click(function(){
		tid = $(this).attr("value");
		$("#login").remove();
		$("#id_select").delay(200).animate({opacity:"0"},{duration:400,complete:function(){$(this).remove();flashLoader();}});
		$("#sim_select").animate({top:"280px",opacity:"0"},500);
	});
}

function flashLoader(){
	console.log('sid',sid);
	console.log('tid',tid);
	$("header").append('<p id="nowlogin">ようこそ ' + uname +' さん</p>');
	$("#main").append('<div id="mainflash"><div id="flashdummy"></div></div>');
	var flashvars = {uid:uid,uname:uname,sid:sid,tid:tid};
	var params = {menu:false};
	var attributes = {id:'swfPlayer',name:'swfPlayer'};
	swfobject.embedSWF("./educeboard1.swf","flashdummy","1000","640","9.0.0","./expressInstall.swf",flashvars, params, attributes);
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
		str += '<li class="pull" value="' + _cid + '"><span>' + _cname +'</span></li>';
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
		str += '<li class="pull" value="' + _uid + '"><span>' + _uname +'</span></li>';
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

/*function sessionLoader(id,id2){
	var xmlhttp = new XMLHttpRequest();
	xmlhttp.open("GET","http://pb.fm.senshu-u.ac.jp/~tmochi/educeboard/showSessionList.php?cid="+ id +"&uid=" + id2,false);
	xmlhttp.send();
	return xmlhttp.responseXML;
}*/

function simulationLoader(id,id2){
	var xmlhttp = new XMLHttpRequest();
	xmlhttp.open("GET","http://pb.fm.senshu-u.ac.jp/~tmochi/educeboard/showSessionList.php?cid="+ id +"&uid=" + id2,false);
	//xmlhttp.open("GET","http://pb.fm.senshu-u.ac.jp/~tmochi/educeboard/simulation.xml",false);
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