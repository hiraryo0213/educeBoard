/********************
unitySendData
クリックされたらそのデータを送るという仕組みにする
********************/

;(function($){
	var namespace = 'unitySendData';

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
					

				}, method));

				// dataコピー
				var $this = $(this)
				,options = $this.data(namespace);


				methods.eventSet.apply($this);

			});
		}

		/********************
		eventSet
		********************/
		,eventSet:function(){
			var $this = $(this)
			,options = $this.data(namespace);

			$this.on('click.' + namespace,function(){
				methods.sendData.apply($this)
			});
			
		}

		/********************
		eventSet
		********************/
		,sendData:function(){
			var $this = $(this)
			,options = $this.data(namespace);

			console.log('unity hoge');
			
		}

		/********************
		destroy
		********************/
		,destroy:function(){
			

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