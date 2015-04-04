/********************
unitySendData
クリックされたらそのデータを送るという仕組みにする
********************/

;(function($){
	var namespace = 'unitySyncData';

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
					unityObject:null
					,$IDDOM:$(this).find('[data-' + namespace + '-parts="sendID"]')
					,$timeLength:$(this).find('[data-' + namespace + '-parts="timeLength"]')
					,$playButton:$(this).find('[data-' + namespace + '-parts="playButton"]')
					,$timeView:$(this).find('[data-' + namespace + '-parts="timeView"]')
					,nowTime:0
					,prevTime:0
					,id:null
					,xmlLoadedFlag:0
					,isPlay:0

					// ,soundLength:null
				}, method));

				// dataコピー
				var $this = $(this)
				,options = $this.data(namespace);


				// methods.sendID.apply($this);
				methods.recieveTime.apply($this);
				methods.recieveXMLLoadedFlag.apply($this);
				methods.recieveTimeLength.apply($this);

			});
		}

		/********************
		unitySendID
		********************/
		,sendID:function(){
			var $this = $(this)
			,options = $this.data(namespace);

			console.log('sendID');

			$this.on('click.' + namespace, options.$IDDOM.selector,function(e){
				options.id = $(e.target).data().id;

				options.unityObject.getUnity().SendMessage("Loader", "GetSID", options.id.sessionId);
				options.unityObject.getUnity().SendMessage("Loader", "GetTID", options.id.trialId);
			});
		}

		/********************
		recieveTime
		********************/
		,recieveTime:function(){
			var $this = $(this)
			,options = $this.data(namespace)
			,prevTime = options.prevTime;

			window.soundPosition = function(time){
				// console.log(time);
				options.nowTime = time;
				if(prevTime != time){
					methods.timeAppend.apply($this);
				}
			}
		}

		/********************
		timeAppend
		********************/
		,timeAppend:function(){
			var $this = $(this)
			,options = $this.data(namespace)
			,prevTime = options.prevTime
			,nowTime = options.nowTime
			,$timeView = options.$timeView
			,timeObject ={
				hour:0
				,minute:0
				,second:0
			};

			nowTime = parseInt(nowTime);

			if(nowTime == prevTime){
				return;
			}

			timeObject.second = nowTime;
			timeObject.minute = parseInt(timeObject.second / 60);
			timeObject.hour = parseInt(timeObject.minute / 60);

			timeObject.minute = timeObject.minute - 60 * timeObject.hour;
			timeObject.second = timeObject.second - 60 * timeObject.minute;

			var str = '';
			for(var i in timeObject){
				if(timeObject[i] < 10){
					timeObject[i] = '0' + timeObject[i];
				}

				str += timeObject[i];

				if(i != 'second'){
					str += ':';
				}
			}

			$timeView.text(str);

			options.prevTime = nowTime;

			// if(nowTime % 60 >= 1){

			// }

			// $timeView.text(nowTime);
		}

		,recieveTimeLength:function(){
			var $this = $(this)
			,options = $this.data(namespace)
			,$timeLength = options.$timeLength;

			// options.soundLength;
			window.soundLength = function(time){
				console.log(time,'length');
			}
		}



		/********************
		recieveXMLLoadedFlag
		********************/
		,recieveXMLLoadedFlag:function(){
			var $this = $(this)
			,options = $this.data(namespace);

			window.xmlLoadFlag = function(flag){
				console.log(flag);
				options.xmlLoadedFlag = flag;

				methods.setEvent.apply($this);
				methods.playToggle.apply($this);
			}
		}

		/********************
		setEvent
		********************/
		,setEvent:function(){
			var $this = $(this)
			,options = $this.data(namespace)
			,$playButton = options.$playButton;

			console.log('setEvent!!');

			$this.on('click.' + namespace , $playButton.selector,function(e){
				e.preventDefault();
				methods.playToggle.apply($this);
			});


		}

		/********************
		sendPlayToggle
		********************/
		,playToggle:function(){
			var $this = $(this)
			,options = $this.data(namespace)
			,isPlay = options.isPlay
			,$playButton = options.$playButton
			,$play = $playButton.find('[data-' + namespace + '-parts="play"]')
			,$pause = $playButton.find('[data-' + namespace + '-parts="pause"]');

			options.isPlay = (isPlay == 0) ? 1 : 0;

			console.log(options.isPlay,options.unityObject);

			if(options.isPlay == 1){
				$play.attr('aria-hidden',true);
				$pause.attr('aria-hidden',false);
			}
			else{
				$play.attr('aria-hidden',false);
				$pause.attr('aria-hidden',true);
			}


			options.unityObject.getUnity().SendMessage("XMLLoader","playFlag",options.isPlay);
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