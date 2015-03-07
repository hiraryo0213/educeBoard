/********************
libDragAndDrop
********************/

;(function($){
	var namespace = 'libDragAndDrop';

	var $body = $('body')
	$window = $(window);

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
					$dragObject : $(this).find('[data-' + namespace + '-parts="dragObject"]')
					,dragObjectAttr : 'data-' + namespace + '-parts="dragObject"'
					,dragFeild:{width:$(this).innerWidth(),height:$(this).innerHeight()}
					,moveThisOffset : null
					,startX : null
					,startY : null
					,moveX : 0
					,moveY : 0
					,endX : null
					,endY : null
					,Xmode : false
					,Ymode : false
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
			,options = $this.data(namespace)
			,$dragObject = options.$dragObject;

			console.log($dragObject);
			
			$this.on('mousedown.' + namespace, '[' + options.dragObjectAttr + ']', function(e){
				e.preventDefault();
				methods.dragStart.apply($this);
			});

			// $this.on('mosemove.' + namespace, '[' + options.dragObjectAttr + ']', function(e){
				// meghods.dragging.apply($this);
			// });
		}

		,dragStart:function(){
			var $this = $(this)
			,options = $this.data(namespace)
			,$dragObject = options.$dragObject;

			console.log('dragStart');

			console.log($dragObject.offset());

			options.startX = $dragObject.offset().left;
			options.startY = $dragObject.offset().top;

			methods.dragging.apply($this);
		}

		,dragging:function(){
			var $this = $(this)
			,options = $this.data(namespace)
			,$dragObject = options.$dragObject
			,startX = options.startX
			,startY = options.startY
			,moveX = startX
			,moveY = startY
			,thisOffset = $this.offset()
			,dragObjectWidth = $dragObject.outerWidth()
			,dragObjectHeight = $dragObject.outerHeight()
			,dragFeildWidth = options.dragFeild.width - dragObjectWidth
			,dragFeildHeight = options.dragFeild.height - dragObjectHeight
			,dragObjectRelativeTop = startY - thisOffset.top
			,dragObjectRelativeLeft = startX - thisOffset.left;

			options.moveThisOffset = thisOffset;

			console.log('dragging');

			console.log(dragFeildHeight);

			// $this.off('mouseleave.' + namespace, $dragObject.selector);


			$window.on('mousemove.' + namespace, function(e){
				moveX = e.pageX - startX - dragObjectWidth * 0.5;
				moveY = e.pageY - startY - dragObjectHeight * 0.5;

				console.log(dragObjectRelativeTop);

				// console.log(dragFeildWidth,startX + );
				if(dragObjectRelativeLeft + moveX >= dragFeildWidth){
					moveX = dragFeildWidth - dragObjectRelativeLeft;
				}
				else if(dragObjectRelativeLeft + moveX < 0){
					moveX = -(dragObjectRelativeLeft);
				}

				if(dragObjectRelativeTop + moveY >= dragFeildHeight){
					moveY = dragFeildHeight - dragObjectRelativeTop;
					// console.log('max');
				}
				else if(dragObjectRelativeTop + moveY < 0){
					moveY = -(dragObjectRelativeTop);
					// console.log('min');
				}

				if(options.Xmode){
					moveY = 0;
				}

				if(options.Ymode){
					moveX = 0;
				}

				// console.log(moveY);

				// console.log(moveX);
				// console.log(dragFeildWidth - startX - dragObjectWidth * 0.5);
				// console.log(dragFeildWidth);

				$dragObject.css({transform:'translate(' + moveX + 'px,' + moveY +'px'});
			});

			methods.dragEnd.apply($this);
		}

		,dragEnd:function(){
			var $this = $(this)
			,options = $this.data(namespace)
			,$dragObject = options.$dragObject
			,thisOffset = null
			,resultTop = 0
			,resultLeft = 0
			,dragObjectWidth = $dragObject.outerWidth()
			,dragObjectHeight = $dragObject.outerHeight()
			,moveThisOffset = options.moveThisOffset;;

			$window.off('mouseup.' + namespace);

			$window.on('mouseup.' + namespace, function(e){
				$window.off('mousemove.' + namespace);

				// イベントが発火した瞬間に取得する
				thisOffset = $this.offset()

				console.log(thisOffset,moveThisOffset);

				if(thisOffset.top != moveThisOffset.top || thisOffset.left != moveThisOffset.left){
					$dragObject.css({transform:''});
					return;
				}

				options.endX = $dragObject.offset().left;
				options.endY = $dragObject.offset().top;

				resultTop = options.endY - thisOffset.top + dragObjectHeight * 0.5;
				resultLeft = options.endX - thisOffset.left + dragObjectWidth * 0.5;

				console.log(options.endY, thisOffset.top,dragObjectHeight * 0.5);

				if(!options.Xmode && !options.Ymode){
					$dragObject.css({
						transform:''
						,top:resultTop + 'px'
						,left:resultLeft + 'px'
					});
				}
				else if(!options.Xmode && options.Ymode){
					$dragObject.css({
						transform:''
						,top:resultTop + 'px'
					});
				}
				else if(options.Xmode && !options.Ymode){
					$dragObject.css({
						transform:''
						,left:resultLeft + 'px'
					});
				}


			});

			
		}

		/********************
		destroy
		********************/
		,destroy:function(){
			var $this = $(this)
			,options = $this.data(namespace);
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