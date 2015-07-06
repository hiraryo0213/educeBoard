/********************
unitySendData
クリックされたらそのデータを送るという仕組みにする
********************/

;(function($){
	var namespace = 'unitySyncData'

	,transitionendEvent = 'webkitTransitionEnd.' + namespace + ' msTransitionEnd.' + namespace + ' transitionend.' + namespace;

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
					,$seekbar:$(this).find('[data-' + namespace + '-parts="seekbar"]')
					,$timeLength:$(this).find('[data-' + namespace + '-parts="timeLength"]')
					,$position:$(this).find('[data-' + namespace + '-parts="position"]')
					,$playButton:$(this).find('[data-' + namespace + '-parts="playButton"]')
					,$timeView:$(this).find('[data-' + namespace + '-parts="timeView"]')
					,$loadingState:$(this).find('[data-' + namespace + '-parts="loadingState"]')
					,$progress:$(this).find('[data-' + namespace + '-parts="progress"]')
					,$errorMessage:$(this).find('[data-' + namespace + '-parts="errorMessage"]')

					,nowTime:0
					,prevTime:0
					,id:null
					,xmlLoadedFlag:0
					,isPlay:0

					,soundLength:null
					,seekbarWidth:0
					,positionWidth:0

					,sendFlag:false

					,voiceLoaded:0
					,xmlLoaded:0
					,beforeProgress:0

					,$loadOverlay:$(this).find('[data-' + namespace + '-parts="loadOverlay"]')

					,noTransitionClass:'elNoAnimation'

					//コールバック
					,afterTimeAppend:null
					,afterRecieveXMLLoadedFlag:null
					,resultTimePosition:null

					// ,soundLength:null
				}, method));

				// dataコピー
				var $this = $(this)
				,options = $this.data(namespace);

				options.seekbarWidth = options.$seekbar.width();
				options.positionWidth = options.$position.width();

				methods.setUnityObject.apply($this);

			});
		}

		/********************
		setUnityObject
		********************/
		,setUnityObject:function(){
			var $this = $(this)
			,options = $this.data(namespace)
			,unityObject = options.unityObject;

			console.log(options);

			unityObject.initPlugin($('#unityPlayer')[0],'../unity/EduceBoard.unity3d');


			//untiyが実行する、unity自体が読み込まれたことを通知する関数をセット
			window.UnityLoadFlag = function(flag){
				if(flag === 1 && options.id === null){
					//unityが読み込まれていて、idが決まっていない時はsendID関数にIDを送信してもらう
					options.sendFlag = true;
				}
				else{
					//unityが読み込まれていて、かつ、すでにIDが決まっていた時は、この関数がIDを送信する
					options.unityObject.getUnity().SendMessage("Loader", "GetSID", options.id.sessionId);
					options.unityObject.getUnity().SendMessage("Loader", "GetTID", options.id.trialId);
				}
			}

			methods.sendID.apply($this);
			methods.setProgress.apply($this);
			methods.recieveTime.apply($this);
			methods.recieveXMLLoadedFlag.apply($this);
			methods.recieveTimeLength.apply($this);
		}



		/********************
		sendID
		********************/
		,sendID:function(){
			var $this = $(this)
			,options = $this.data(namespace);

			// console.log(educeboardBasicInfo);

			// options.unityObject.getUnity().SendMessage("Loader", "GetSID", options.id.sessionId);
			// options.unityObject.getUnity().SendMessage("Loader", "GetTID", options.id.trialId);

			$this.on('click.' + namespace, options.$IDDOM.selector,function(e){
				options.id = $(e.target).data().id;

				var educeboardBasicInfo = $('body').data('educeboardBasicInfo');

				$('body').data('educeboardBasicInfo', $.extend(educeboardBasicInfo,{
					sid:options.id.sessionId
					,tid:options.id.trialId
				}));

				options.$loadOverlay.attr('aria-hidden',false);

				//sendFlagがtrueになっていなかったら、まだunityが読み込まれていないためIDは送信しない
				if(options.sendFlag){
					options.unityObject.getUnity().SendMessage("Loader", "GetSID", options.id.sessionId);
					options.unityObject.getUnity().SendMessage("Loader", "GetTID", options.id.trialId);
				}

				
			});
		}

		/********************
		recieveTime
		********************/
		,recieveTime:function(){
			var $this = $(this)
			,options = $this.data(namespace)
			,prevTime;

			window.soundPosition = function(time){
				// console.log(time);
				options.nowTime = time;
				prevTime = options.prevTime;
				// console.log(time,prevTime);
				if(prevTime != parseInt(time)){
					methods.timeAppend.apply($this);

					if(soundLength !== null){
						methods.movePosition.apply($this);
					}
				}
				//soundLengthがなかったらmovePositionを実行しない
				
			}
		}

		/********************
		movePosition
		********************/
		,movePosition:function(){
			var $this = $(this)
			,options = $this.data(namespace)
			,soundLength = options.soundLength
			,nowTime = options.nowTime
			,$timeLength = options.$timeLength
			,$position = options.$position
			,seekbarWidth = options.seekbarWidth
			,positionWidth = options.positionWidth
			,percent = 0
			,resultNum = 0;


			// soundLengthがなかったら即終了
			if(soundLength === null){
				return;
			}

			// 百分率計算
			percent = nowTime / soundLength;

			// 横から何pxか計算
			resultNum = seekbarWidth * percent + positionWidth * 0.5;

			// console.log(soundPosition);

			if($timeLength.hasClass(options.noTransitionClass)){
				$timeLength.toggleClass(options.noTransitionClass,false);
			}

			if($position.hasClass(options.noTransitionClass)){
				$position.toggleClass(options.noTransitionClass,false);
			}

			$timeLength.css({
				width:resultNum - positionWidth * 0.5 + 'px'
			});

			$position.css({
				left:resultNum + 'px'
			});

		}

		/********************
		resultTimePosition
		シークバーを動かし終えて場所を決めた時
		********************/
		,resultTimePosition:function(){
			var $this = $(this)
			,options = $this.data(namespace)
			,soundLength = options.soundLength
			,$position = options.$position
			,$timeLength = options.$timeLength
			,seekbarWidth = options.seekbarWidth
			,positionWidth = options.positionWidth

			// ,positionLeft = parseFloat($position.attr('left'))
			,positionLeft = parseFloat($position[0].style.left)

			,resultTime = positionLeft / seekbarWidth * soundLength;

			console.log(resultTime);


			options.unityObject.getUnity().SendMessage("XMLLoader", "soundPosition", resultTime);

			methods.applyCallback.apply([$this,'resultTimePosition']);

		}

		/********************
		timeLengthUpdate
		********************/
		,timeLengthUpdate:function(){
			var $this = $(this)
			,options = $this.data(namespace)
			,$position = options.$position
			,$timeLength = options.$timeLength

			,transformNum = 0
			,leftNum = 0

			,prefixTransform = ['transform','msTransform','MozTransform','webkitTransform']
			,prefixLength = prefixTransform.length
			,i;

			for(i = 0; i < prefixLength; i++){

				// console.log(prefixTransform[i],$position[0].style[prefixTransform[i]]);

				if($position[0].style[prefixTransform[i]]){


					transformNum = $position[0].style[prefixTransform[i]];

					transformNum = transformNum.substring(transformNum.indexOf('(') + 1, transformNum.indexOf(','));
					console.log(prefixTransform[i],transformNum);
					break;

				}

			}

			leftNum = $position[0].style.left;

			var resultNum = parseFloat(leftNum) + parseFloat(transformNum);

			$timeLength[0].style.width = resultNum + 'px';

			console.log(resultNum);

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
			,timeArray =[0,0,0];

			// console.log('timeAppend');

			nowTime = parseInt(nowTime);

			if(nowTime == prevTime){
				return;
			}



			timeArray[2] = nowTime;
			timeArray[1] = parseInt(timeArray[2] / 60);
			timeArray[0] = parseInt(timeArray[1] / 60);

			timeArray[1] = timeArray[1] - 60 * timeArray[0];
			timeArray[2] = timeArray[2] - 60 * timeArray[1];

			var str = ''
			,timeArrayLength = timeArray.length;
			for(i = 0; i < timeArrayLength; i++){
				if(timeArray[i] < 10){
					timeArray[i] = '0' + timeArray[i];
				}

				str += timeArray[i];

				if(i != timeArrayLength - 1){
					str += ':';
				}
			}

			$timeView.text(str).attr('data-' + namespace + '-time',nowTime);

			options.prevTime = nowTime;

			//コールバック実行
			methods.applyCallback.apply([$this,'afterTimeAppend']);


			// if(nowTime % 60 >= 1){

			// }

			// $timeView.text(nowTime);
		}

		,recieveTimeLength:function(){
			var $this = $(this)
			,options = $this.data(namespace)
			// ,$timeLength = options.$timeLength;

			// options.soundLength;
			window.soundLength = function(time){
				options.soundLength = time;
			}
		}



		/********************
		recieveXMLLoadedFlag
		********************/
		,recieveXMLLoadedFlag:function(){
			var $this = $(this)
			,options = $this.data(namespace);

			//これが発火されるまで、画面を黒くするのを実装する
			window.xmlLoadFlag = function(flag){
				// console.log(flag);
				options.xmlLoadedFlag = flag;

				if(flag == 1){
					console.log(flag);
					methods.setEvent.apply($this);
					methods.playToggle.apply($this);
					options.$loadOverlay.attr('aria-hidden',true);
					methods.applyCallback.apply([$this,'afterRecieveXMLLoadedFlag']);
				}
				else if(flag == -1){
					options.$loadingState.attr('aria-hidden',true);
					options.$errorMessage.attr('aria-hidden',false);
				}



				// console.log('afterRecieveXMLLoadedFlag');

				
			}
		}

		/********************
		setEvent
		********************/
		,setEvent:function(){
			var $this = $(this)
			,options = $this.data(namespace)
			,$playButton = options.$playButton
			,$position = options.$position
			,$timeLength = options.$timeLength;

			console.log('setEvent!!');

			// 再生ボタン
			$this.on('click.' + namespace , $playButton.selector,function(e){
				e.preventDefault();
				methods.playToggle.apply($this);
			});

			// シークバーを動かし始めた時
			$this.on('mousedown.' + namespace, $position.selector, function(e){
				e.preventDefault();
				options.isPlay = 1;
				methods.playToggle.apply($this);

				$position.toggleClass(options.noTransitionClass,true);

				$timeLength.toggleClass(options.noTransitionClass,true);

				// シークバーを動かし終えた時
				$this.on('mouseup.' + namespace, function(e){

					$this.off('mouseup.' + namespace);


					// $position.on(transitionendEvent, function(){

						// $(this).off(transitionendEvent);

						// $position.toggleClass(options.noTransitionClass,false);

					// });

					// $timeLength.on(transitionendEvent, function(){

						// $(this).off(transitionendEvent);

						// $timeLength.toggleClass(options.noTransitionClass,false);

					// });


					e.preventDefault();
					options.isPlay = 0;
					methods.playToggle.apply($this);

					methods.applyCallback.apply([$this,'resultTimePosition']);
					// methods.resultTimePosition.apply($this);
				});

			});


		}

		/********************
		playToggle
		********************/
		,playToggle:function(){
			var $this = $(this)
			,options = $this.data(namespace)
			,isPlay = options.isPlay
			,$playButton = options.$playButton
			,$play = $playButton.find('[data-' + namespace + '-parts="play"]')
			,$pause = $playButton.find('[data-' + namespace + '-parts="pause"]');

			options.isPlay = (isPlay == 0) ? 1 : 0;

			// console.log(options.isPlay,options.unityObject);

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
		setProgress
		********************/
		,setProgress:function(){
			var $this = $(this)
			,options = $this.data(namespace);
			

			window.voiceProgress = function(percent){
				options.voiceLoaded = percent * 100;
				methods.progressCalc.apply($this);
			};
			window.xmlProgress = function(percent){
				options.xmlLoaded = percent * 100;
				methods.progressCalc.apply($this);
			};


		}

		/********************
		progressCalc
		********************/
		,progressCalc:function(){
			var $this = $(this)
			,options = $this.data(namespace)
			,voiceLoaded = options.voiceLoaded
			,xmlLoaded = options.xmlLoaded
			,percent = parseInt((voiceLoaded + xmlLoaded) * 0.5)
			,$progress = options.$progress
			,beforePercent = options.beforeProgress;


			if(percent !== beforePercent){
				$progress.css({width:percent + '%'});
				$progress.text(percent + '%');
				options.beforeProgress = percent;
			}

			
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

		/********************
		destroy
		********************/
		,destroy:function(){
			

		}
	};

	/********************
	prefixedStyle
	ベンダープレフィックス付きのスタイルを返す関数
	********************/
	function prefixedStyle(style){

		var prefix = ['ms','webkit','moz']
		,result = {}
		,i,j
		,prefixLength = prefix.length;

		for(i in style){

			for(j = 0; j < prefixLength; j++){
				result['-' + prefix[j] + '-' + i] = style[i];
			}

			result[i] = style[i];

		}

		return result;
	}

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