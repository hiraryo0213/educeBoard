!function(t){var e="unitySyncData",i={initialize:function(a){return this.each(function(){t(this).data(e,t.extend(!0,{unityObject:null,$IDDOM:t(this).find("[data-"+e+'-parts="sendID"]'),$timeLength:t(this).find("[data-"+e+'-parts="timeLength"]'),$playButton:t(this).find("[data-"+e+'-parts="playButton"]'),$timeView:t(this).find("[data-"+e+'-parts="timeView"]'),nowTime:0,prevTime:0,id:null,xmlLoadedFlag:0,isPlay:0},a));{var n=t(this);n.data(e)}i.recieveTime.apply(n),i.recieveXMLLoadedFlag.apply(n),i.recieveTimeLength.apply(n)})},sendID:function(){var i=t(this),a=i.data(e);i.on("click."+e,a.$IDDOM.selector,function(e){a.id=t(e.target).data().id,a.unityObject.getUnity().SendMessage("Loader","GetSID",a.id.sessionId),a.unityObject.getUnity().SendMessage("Loader","GetTID",a.id.trialId)})},recieveTime:function(){var a=t(this),n=a.data(e),d=n.prevTime;window.soundPosition=function(t){n.nowTime=t,d!=t&&i.timeAppend.apply(a)}},timeAppend:function(){var i=t(this),a=i.data(e),n=a.prevTime,d=a.nowTime,o=a.$timeView,r={hour:0,minute:0,second:0};if(d=parseInt(d),d!=n){r.second=d,r.minute=parseInt(r.second/60),r.hour=parseInt(r.minute/60),r.minute=r.minute-60*r.hour,r.second=r.second-60*r.minute;var s="";for(var l in r)r[l]<10&&(r[l]="0"+r[l]),s+=r[l],"second"!=l&&(s+=":");o.text(s),a.prevTime=d}},recieveTimeLength:function(){{var i=t(this),a=i.data(e);a.$timeLength}window.soundLength=function(){}},recieveXMLLoadedFlag:function(){var a=t(this),n=a.data(e);window.xmlLoadFlag=function(t){n.xmlLoadedFlag=t,i.setEvent.apply(a),i.playToggle.apply(a)}},setEvent:function(){var a=t(this),n=a.data(e),d=n.$playButton;a.on("click."+e,d.selector,function(t){t.preventDefault(),i.playToggle.apply(a)})},playToggle:function(){var i=t(this),a=i.data(e),n=a.isPlay,d=a.$playButton,o=d.find("[data-"+e+'-parts="play"]'),r=d.find("[data-"+e+'-parts="pause"]');a.isPlay=0==n?1:0,1==a.isPlay?(o.attr("aria-hidden",!0),r.attr("aria-hidden",!1)):(o.attr("aria-hidden",!1),r.attr("aria-hidden",!0)),a.unityObject.getUnity().SendMessage("XMLLoader","playFlag",a.isPlay)},destroy:function(){}};t.fn[e]=function(t){return i[t]?i[t].apply(this,Array.prototype.slice.call(arguments,1)):"object"!=typeof t&&t?void 0:i.initialize.apply(this,arguments)}}(jQuery);