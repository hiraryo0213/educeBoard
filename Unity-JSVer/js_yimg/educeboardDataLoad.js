!function(t){var a="educeboardDataLoad",e=(t("body"),{initialize:function(n){return this.each(function(){t(this).data(a,t.extend(!0,{unityObject:null,courseURL:"http://pb.fm.senshu-u.ac.jp/~tmochi/educeboard/loginCourseList.php",userURL:"http://pb.fm.senshu-u.ac.jp/~tmochi/educeboard/loginCourseMemberList.php",authURL:"http://pb.fm.senshu-u.ac.jp/~tmochi/educeboard/loginAuth.php",simulationURL:"http://pb.fm.senshu-u.ac.jp/~tmochi/educeboard/showSessionList.php",courseButtonText:null,userButtonText:null,IDobj:{cid:null,uid:null,simid:null,sid:null,tid:null},courseParameter:{xml:1},userParameter:{xml:1,cid:null},authParameter:{xml:1,uid:null,pwd:null},$simulationList:t("[data-listExpand]"),courseButtonID:"pulldownBtn1",userButtonID:"pulldownBtn2",pwdButtonID:"loginButton",pwdObjClass:"elPassword",simulationListClass:"elSimulationList",sessionListClass:"elSessionList",trialListClass:"elTrialList",coursePulldownID:null,userPulldownID:null,$coursePulldownBtn:null,$userPulldownBtn:null,$coursePulldownObj:null,$userPulldownObj:null,$pwdInputObj:null,$loginButtonObj:null,nextMethod:"course",courseLoaded:null,userLoaded:null,beforeAuth:null,authSuccess:null,authFail:null,simulationLoaded:null,idResult:null},n));var i=t(this),d=i.data(a);d.$coursePulldownBtn=i.find("#"+d.courseButtonID),d.courseButtonText=d.$coursePulldownBtn.text(),d.coursePulldownID=d.$coursePulldownBtn.attr("aria-controles"),d.$coursePulldownObj=i.find("#"+d.coursePulldownID),d.$userPulldownBtn=i.find("#"+d.userButtonID),d.userButtonText=d.$userPulldownBtn.text(),d.userPulldownID=d.$userPulldownBtn.attr("aria-controles"),d.$userPulldownObj=i.find("#"+d.userPulldownID),d.$pwdInputObj=i.find("."+d.pwdObjClass).find('input[type="password"]'),d.$loginButton=i.find("#"+d.pwdButtonID),e.courseLoader.apply(i)})},courseLoader:function(){var n=t(this),i=n.data(a);i.$coursePulldownBtn.on("click."+a,function(){i.$userPulldownBtn.text(i.userButtonText).parents("[aria-activedescendant]").attr("aria-activedescendant",""),i.$userPulldownObj.find("li").remove(),i.$userPulldownObj.attr("aria-expanded",!1),i.$pwdInputObj.attr("disabled","disabled").val(""),i.$loginButton.parents("[aria-activedescendant]").attr("aria-activedescendant",""),i.nextMethod="userLoader"}),t.ajax({type:"GET",url:i.courseURL,data:i.courseParameter}).done(function(a){var d={cid:[],cname:[]};t(a).find("CourseList").each(function(a){d.cid[a]=t(this).find("cid").text(),d.cname[a]=t(this).find("cname").text()});var l,u=d.cid.length,o=[];for(l=0;u>l;l++)o[l]=t("<li />").attr("data-cid",d.cid[l]);for(l=0;u>l;l++){var s=t('<a href="#" />').text(d.cname[l]);o[l].append(s)}for(l=0;u>l;l++)i.$coursePulldownObj.append(o[l]);i.$coursePulldownBtn.parents("[aria-activedescendant]").attr("aria-activedescendant",i.courseButtonID),i.nextMethod="userLoader",e.takeID.apply([n,o]),e.applyCallback.apply([n,"courseLoaded"])})},userLoader:function(){var n=t(this),i=n.data(a);i.$userPulldownBtn.on("click."+a,function(){i.$pwdInputObj.attr("disabled","disabled").val(""),i.$loginButton.parents("[aria-activedescendant]").attr("aria-activedescendant",""),i.nextMethod="authLogin"}),i.userParameter.cid=i.IDobj.cid,t.ajax({type:"GET",url:i.userURL,data:i.userParameter}).done(function(a){var d={uid:[],uname:[]};t(a).find("UserList").each(function(a){d.uid[a]=t(this).find("uid").text(),d.uname[a]=t(this).find("username").text()});var l,u=d.uid.length,o=[];for(l=0;u>l;l++)o[l]=t("<li />").attr("data-uid",d.uid[l]);for(l=0;u>l;l++){var s=t('<a href="#" />').text(d.uname[l]);o[l].append(s)}for(l=0;u>l;l++)i.$userPulldownObj.append(o[l]);i.$userPulldownBtn.parents("[aria-activedescendant]").attr("aria-activedescendant",i.userButtonID),i.nextMethod="authLogin",e.takeID.apply([n,o]),e.applyCallback.apply([n,"userLoaded"])})},authLogin:function(){function n(a){a.preventDefault(),d.authParameter.pwd=d.$pwdInputObj.val(),t.ajax({type:"GET",url:d.authURL,data:d.authParameter}).done(function(a){var n=t(a).find("Auth").text();return"false"!=n?(e.applyCallback.apply([i,"authFail"]),!1):(e.simulationLoader.apply(i),void e.applyCallback.apply([i,"authSuccess"]))})}var i=t(this),d=i.data(a);e.applyCallback.apply([i,"beforeAuth"]),d.authParameter.uid=d.IDobj.uid,d.$pwdInputObj.removeAttr("disabled").select(),d.$loginButton.parents("[aria-activedescendant]").attr("aria-activedescendant",d.pwdButtonID),d.$loginButton.off("."+a),d.$pwdInputObj.off("."+a),d.$loginButton.on("click."+a,n),d.$pwdInputObj.on("keypress."+a,function(t){13==t.which&&n(t)})},simulationLoader:function(){var n=t(this),i=n.data(a),d={cid:i.IDobj.cid,uid:i.IDobj.uid};t.ajax({type:"GET",url:i.simulationURL,data:d}).done(function(d){$listDom=i.$simulationList,$listDom.empty(),i.$pwdInputObj.val(""),t(d).find("simulation").each(function(d){var l=t(this),u=l.find("sim_id").text(),o=l.find("sim_name").text(),s=t("<li />").attr("data-listExpand-level",0).append(t("<dl />")),r=t('<dd aria-expanded="false" id="expand'+d+'" />').append(t("<ul />",{"class":i.sessionListClass}));s.find("dl").append(t('<dt><a href="#" role="button" aria-controles="expand'+d+'">'+o+"</a></dt>")).append(r),l.find("session").each(function(l){var o=t(this),s=o.find("session_id").text(),p=o.find("session_name").text(),c=d+"-"+l,f=t("<li />").attr("data-listExpand-level",1).append(t("<dl />")),h=t('<dd aria-expanded="false" id="expand'+c+'" />').append(t("<ul />",{"class":i.trialListClass}));f.find("dl").append(t('<dt><a href="#" role="button" aria-controles="expand'+c+'">'+p+"</a></dt>")).append(h),r.find("."+i.sessionListClass).append(f),o.find("trial").each(function(){var d=t(this),l=d.find("trial_id").text(),o=d.find("timestamp").text(),r=t('<li><p><a href="#" data-unitySendData /></p></li>'),p=r.find("a");p.data("id",{simulationId:u,sessionId:s,trialId:l}).text(o).on("click."+a,function(a){a.preventDefault();var d=t(a.target).data().id;i.unityObject.getUnity().SendMessage("Loader","GetSID",d.sessionId),i.unityObject.getUnity().SendMessage("Loader","GetTID",d.trialId),t("#educeboard").attr("aria-hidden",!1),t("#login").attr("aria-hidden",!0),e.applyCallback.apply([n,"idResult"])}),h.find("."+i.trialListClass).append(r)})}),$listDom.append(s)}),e.applyCallback.apply([n,"simulationLoaded"])})},takeID:function(){var n,i=t(this)[0],d=i.data(a),l=t(this)[1],u=l.length;for(n=0;u>n;n++)l[n].on("click."+a,function(a){a.preventDefault();var n=t(this),l=n.data();t.extend(d.IDobj,l),e[d.nextMethod].apply(i)})},applyCallback:function(){var e=t(this)[0],n=e.data(a),i=t(this)[1];"function"==typeof n[i]&&n[i]()},destroy:function(){}});t.fn[a]=function(t){return e[t]?e[t].apply(this,Array.prototype.slice.call(arguments,1)):"object"!=typeof t&&t?void 0:e.initialize.apply(this,arguments)}}(jQuery);