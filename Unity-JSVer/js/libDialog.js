/********************
libDialog
********************/

;(function($){
	var namespace = 'libDialog';


	/********************
	methods
	********************/

	var methods = {

		/********************
		initialize
		********************/
		initialize:function(method){
			return this.each(function(){

				// オプションをセット
				$(this).data(namespace, $.extend(true, {
					dialogName : null

					,$closeOverlay : $('<div />')

					,closeOverlayClass : 'elCloseOverlay'

					,$dialogObj : null

					,setEvent : true

					,setEventFlag : false

					// callback
					,closeAfter : null

				}, method));

				// dataコピー
				var $this = $(this)
				,options = $this.data(namespace);
				
				methods.prepare.apply($this);

			});
		}

		/********************
		prepare
		********************/
		,prepare:function(){
			var $this = $(this)
			,options = $this.data(namespace);

			options.dialogName = $this.attr('aria-controles');
			options.$dialogObj = $('#' + options.dialogName);

			options.$closeOverlay.toggleClass(options.closeOverlayClass,true);

			options.$dialogObj.prepend(options.$closeOverlay);

			if(options.setEventFlag){
				methods.setEvent.apply($this);
			}

			
		}

		/********************
		setEvent
		********************/
		,setEvent:function(){
			var $this = $(this)
			,options = $this.data(namespace);

			options.setEventFlag = true;


			$this.on('click.' + namespace, function(e){
				e.preventDefault();

				methods.showDialog.apply($this);
			});

			options.$closeOverlay.on('click.' + namespace,function(e){
				e.preventDefault();

				methods.closeDialog.apply($this);
			})
		}

		/********************
		showDialog
		********************/
		,showDialog:function(){
			var $this = $(this)
			,options = $this.data(namespace);

			options.$dialogObj.attr('aria-hidden',false);

			if(!options.setEventFlag){
				methods.setEvent.apply($this);
			}
		}

		/********************
		closeDialog
		********************/
		,closeDialog:function(){
			var $this = $(this)
			,options = $this.data(namespace);

			options.$dialogObj.attr('aria-hidden',true);

			if(!options.setEventFlag){
				methods.setEvent.apply($this);
			}

			methods.applyCallback.apply([$this,'closeAfter']);
		}

		/********************
		destroy
		********************/
		,destroy:function(){
			var $this = $(this)
			,options = $this.data(namespace);

			$this.off('.' + namespace);
			options.$closeOverlay.off('.' + namespace).remove();
			options.$dialogObj.attr('aria-hidden',true);

			$this.removeData(namespace);
		}

		/********************
		applyCallback
		********************/
		,applyCallback:function(){
			var $this = $(this)[0]
			,options = $this.data(namespace)
			,callback = $(this)[1];


			if(typeof options[callback] === 'function'){;
				options[callback]();
			}
		}
	};


	/********************
	全プラグイン共通
	********************/
	$.fn[namespace] = function(method){
		if(methods[method]){
			return methods[method].apply(this, Array.prototype.slice.call(arguments, 1));
		}
		else if(typeof method === 'object' || !method){
			return methods.initialize.apply(this, arguments);
		}
	}

})(jQuery);