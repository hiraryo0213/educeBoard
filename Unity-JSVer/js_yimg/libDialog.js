!function(a){var e="libDialog",t={initialize:function(l){return this.each(function(){a(this).data(e,a.extend(!0,{dialogName:null,$closeOverlay:a("<div />"),closeOverlayClass:"elCloseOverlay",$dialogObj:null,setEvent:!0,setEventFlag:!1,closeAfter:null},l));{var i=a(this);i.data(e)}t.prepare.apply(i)})},prepare:function(){var l=a(this),i=l.data(e);i.dialogName=l.attr("aria-controles"),i.$dialogObj=a("#"+i.dialogName),i.$closeOverlay.toggleClass(i.closeOverlayClass,!0),i.$dialogObj.prepend(i.$closeOverlay),i.setEventFlag&&t.setEvent.apply(l)},setEvent:function(){var l=a(this),i=l.data(e);i.setEventFlag=!0,l.on("click."+e,function(a){a.preventDefault(),t.showDialog.apply(l)}),i.$closeOverlay.on("click."+e,function(a){a.preventDefault(),t.closeDialog.apply(l)})},showDialog:function(){var l=a(this),i=l.data(e);i.$dialogObj.attr("aria-hidden",!1),i.setEventFlag||t.setEvent.apply(l)},closeDialog:function(){var l=a(this),i=l.data(e);i.$dialogObj.attr("aria-hidden",!0),i.setEventFlag||t.setEvent.apply(l),t.applyCallback.apply([l,"closeAfter"])},destroy:function(){var t=a(this),l=t.data(e);t.off("."+e),l.$closeOverlay.off("."+e).remove(),l.$dialogObj.attr("aria-hidden",!0),t.removeData(e)},applyCallback:function(){var t=a(this)[0],l=t.data(e),i=a(this)[1];"function"==typeof l[i]&&l[i]()}};a.fn[e]=function(a){return t[a]?t[a].apply(this,Array.prototype.slice.call(arguments,1)):"object"!=typeof a&&a?void 0:t.initialize.apply(this,arguments)}}(jQuery);