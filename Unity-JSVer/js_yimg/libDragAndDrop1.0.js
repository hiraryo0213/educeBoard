!function(t){{var e="libDragAndDrop";t("body")}$window=t(window);var o={initialize:function(a){return this.each(function(){t(this).data(e,t.extend(!0,{$dragObject:t(this).find("[data-"+e+'-parts="dragObject"]'),dragObjectAttr:"data-"+e+'-parts="dragObject"',dragFeild:{width:t(this).innerWidth(),height:t(this).innerHeight()},moveThisOffset:null,startX:null,startY:null,moveX:0,moveY:0,endX:null,endY:null,Xmode:!1,Ymode:!1},a));{var n=t(this);n.data(e)}o.eventSet.apply(n)})},eventSet:function(){{var a=t(this),n=a.data(e);n.$dragObject}a.on("mousedown."+e,"["+n.dragObjectAttr+"]",function(t){t.preventDefault(),o.dragStart.apply(a)})},dragStart:function(){var a=t(this),n=a.data(e),r=n.$dragObject;n.startX=r.offset().left,n.startY=r.offset().top,o.dragging.apply(a)},dragging:function(){var a=t(this),n=a.data(e),r=n.$dragObject,d=n.startX,i=n.startY,s=d,f=i,l=a.offset(),p=r.outerWidth(),u=r.outerHeight(),g=n.dragFeild.width-p,c=n.dragFeild.height-u,h=i-l.top,m=d-l.left;n.moveThisOffset=l,$window.on("mousemove."+e,function(t){s=t.pageX-d-.5*p,f=t.pageY-i-.5*u,m+s>=g?s=g-m:0>m+s&&(s=-m),h+f>=c?f=c-h:0>h+f&&(f=-h),n.Xmode&&(f=0),n.Ymode&&(s=0),r.css({transform:"translate("+s+"px,"+f+"px"})}),o.dragEnd.apply(a)},dragEnd:function(){var o=t(this),a=o.data(e),n=a.$dragObject,r=null,d=0,i=0,s=n.outerWidth(),f=n.outerHeight(),l=a.moveThisOffset;$window.off("mouseup."+e),$window.on("mouseup."+e,function(){return $window.off("mousemove."+e),r=o.offset(),r.top!=l.top||r.left!=l.left?void n.css({transform:""}):(a.endX=n.offset().left,a.endY=n.offset().top,d=a.endY-r.top+.5*f,i=a.endX-r.left+.5*s,void(a.Xmode||a.Ymode?!a.Xmode&&a.Ymode?n.css({transform:"",top:d+"px"}):a.Xmode&&!a.Ymode&&n.css({transform:"",left:i+"px"}):n.css({transform:"",top:d+"px",left:i+"px"})))})},destroy:function(){{var o=t(this);o.data(e)}}};t.fn[e]=function(t){return o[t]?o[t].apply(this,Array.prototype.slice.call(arguments,1)):"object"!=typeof t&&t?void 0:o.initialize.apply(this,arguments)}}(jQuery);