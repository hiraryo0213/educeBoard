!function(t){var a="libDialog",e={initialize:function(l){return this.each(function(){t(this).data(a,t.extend(!0,{$closeOverlay:t("<div />"),closeOverlayClass:"elCloseOverlay",overlayAnotherAttr:null,$show:null,$close:null,dialogID:t(this).attr("id").substring(0),setEvent:!0,setEventFlag:!1,closeAfter:null},l));{var o=t(this);o.data(a)}e.prepare.apply(o)})},prepare:function(){var l=t(this),o=l.data(a),r=[];void 0!==o.dialogID&&(null!==o.overlayAnotherAttr&&"string"==typeof o.overlayAnotherAttr&&(r=o.overlayAnotherAttr.replace(/\"/g,"").split("="),o.$closeOverlay.attr(r[0],r[1])),o.$closeOverlay.toggleClass(o.closeOverlayClass,!0).attr("data-"+a+"-parts","close").attr("aria-controles",o.dialogID),l.prepend(o.$closeOverlay),o.$show=t("[data-"+a+'-parts="show"][aria-controles="'+o.dialogID+'"]'),o.$close=t("[data-"+a+'-parts="close"][aria-controles="'+o.dialogID+'"]'),o.setEventFlag&&e.setEvent.apply(l))},setEvent:function(){var l=t(this),o=l.data(a);o.setEventFlag=!0,o.$show.on("click."+a,function(t){t.preventDefault(),e.showDialog.apply(l)}),o.$close.on("click."+a,function(t){t.preventDefault(),e.closeDialog.apply(l)})},showDialog:function(){var l=t(this),o=l.data(a);l.attr("aria-hidden",!1),o.setEventFlag||e.setEvent.apply(l)},closeDialog:function(){var l=t(this),o=l.data(a);l.attr("aria-hidden",!0),o.setEventFlag||e.setEvent.apply(l),e.applyCallback.apply([l,"closeAfter"])},destroy:function(){var e=t(this),l=e.data(a);l.$show.off("."+a),l.$close.off("."+a),l.$closeOverlay.remove(),e.attr("aria-hidden",!0),e.removeData(a)},applyCallback:function(){var e=t(this)[0],l=e.data(a),o=t(this)[1];"function"==typeof l[o]&&l[o]()}};t.fn[a]=function(t){return e[t]?e[t].apply(this,Array.prototype.slice.call(arguments,1)):"object"!=typeof t&&t?void 0:e.initialize.apply(this,arguments)}}(jQuery);