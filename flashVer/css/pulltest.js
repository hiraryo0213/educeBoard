var sid;
var cid;

$(document).ready(function(){
	/*var s_flag = false;
	var t_flag = false;
	$(document).click(function(){
		$("ul.session").slideUp();
		$("ul.trial").slideUp();
	});
	$("ul.sim li").click(function(ev){
		var session = $(this).children('ul');
		if($(session).is(':hidden')){
			ev.stopPropagation();
			$("ul.session:visible").slideUp();
			$(session).slideDown();
			$(session).children('li').hover(function(){
				$(this).children('ul').slideDown();
			},function(){
				$(this).children('ul').slideUp();
			});
		}
	});
	$("a").click(function(ev){ ev.preventDefault() });*/
/*	$("ul.sim li").hover(function(){
		$(this).children('ul').slideDown("fast");
	},function(){
		$(this).children('ul').slideUp("fast");
	});
	$("ul.session li").hover(function(){
		$(this).children('ul').slideDown("fast");
	},function(){
		$(this).children('ul').slideUp("fast");
	});*/
	
	
	var xml = simulationLoader();
	var simulation = xml.documentElement.getElementsByTagName("simulation");
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
	
	$("#sim_select").append(str);
	
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
			$(this).css("background-color","#F93");
			},function(){
			$(this).css("background-color","#FFF");
		});
		$(this).unbind("hover");
		$(this).next("ul").slideToggle();
		$(this).css("background-color","#F93");
		sid = $(this).attr("value");
	});
	
	$("p.session_name").hover(function(){
		$(this).css("background-color","#F93");
	},function(){
		$(this).css("background-color","#FFF");
	});
	
	$("p.trial_name").click(function(){
		tid = $(this).attr("value");
		$("#test").append(sid + tid);
	});
});

function simulationLoader(){
	var xmlhttp = new XMLHttpRequest();
	//xmlhttp.open("GET","http://pb.fm.senshu-u.ac.jp/~tmochi/educeboard/showSessionList.php?cid="+ id +"&uid=" + id2,false);
	xmlhttp.open("GET","http://pb.fm.senshu-u.ac.jp/~tmochi/educeboard/simulation.xml",false);
	xmlhttp.send();
	return xmlhttp.responseXML;
}