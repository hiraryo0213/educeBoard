﻿package{
import flash.display.Sprite;
import flash.net.URLLoader;
import flash.net.URLRequest;
import flash.events.Event;
import flash.utils.Timer;
import flash.events.TimerEvent;
import flash.display.MovieClip;
import flash.events.MouseEvent;
import flash.geom.Rectangle;
import flash.display.SimpleButton;
import flash.media.Sound;
import flash.media.SoundLoaderContext;
import flash.media.SoundChannel;
import flash.net.URLVariables;
import flash.net.URLRequestMethod;
import flash.net.sendToURL
import flash.text.TextField;
import flash.text.TextFieldAutoSize;
import flash.text.TextFormat;
import flash.net.URLLoaderDataFormat;
import flash.ui.Mouse;
import flash.display.Loader;
import flash.events.IOErrorEvent;
import flash.events.SecurityErrorEvent;
import flash.display.Bitmap;
import flash.display.LoaderInfo;
import flash.events.ProgressEvent;
import flash.net.navigateToURL;
import flash.display.Shape;
import flash.text.engine.EastAsianJustifier;
import flash.geom.ColorTransform


	public class main extends Sprite
	{
		private var xml_urlLoader:URLLoader = new URLLoader();
		private var xml_urlRequest:URLRequest = new URLRequest();
		private var cmxml_urlLoader:URLLoader = new URLLoader();
		private var cmxml_urlRequest:URLRequest = new URLRequest();
		private var mp3_urlRequest:URLRequest = new URLRequest();
		private var loadTotal = 0;
		private var now_loadTotal = 0;
		private var load_per = 0;
		private var memberXML:XML;
		private var commentXML:XML;
		private var sound:Sound;
		private var channel:SoundChannel;
		private var position:Number;
		private var timer:Timer;
		private var timecount:Number=0;
		private var stage_X = 550;
		private var stage_Y = 400;
		private var n:int = 0;
		private var t:int = 0;
		private var s:Number = 0;
		private var TimeTable:Array = [];
		private var XTable:Array = [];
		private var YTable:Array = [];
		private var midTable:Array = [];
		private var colorTable:Array = [];
		private var angleTable:Array = [];
		private var actTable:Array = [];
		private var cm_uid:Array = [];
		private var cm_time:Array = [];
		private var cm_name:Array = [];
		private var comment:Array = [];
		private var c_baseMC = new MovieClip();
		private var cmMC_Table:Array = [];
		private var cmMC_height:Array = [];
		private var Tcomment_c = 0;
		private var Mcomment_c = 0;
		private var cm_notMoveNum:int = 0;
		private var cBase_y;//全体のコメントMCの最初の場所
		private var base_point = 111;//全体のコメントMCがどこまで動くのかを指定するもの
		private var c_moveFlag = false;
		private var c_moveSum = 0;
		private var cm_whileNum;
		private var now_x:Array = [];//現在のactの場所(%)
		private var now_y:Array = [];
		private var aft_x:Array = [];//actの目標座標(%)
		private var aft_y:Array = [];
		private var per_x:Array = [];//現在の場所から目標の場所までどのくらい離れているかを求める(%の小数化)
		private var per_y:Array = [];
		private var first_x:Array = [];
		private var first_y:Array = [];
		private var first_color:Array = [];
		private var first_angle:Array = [];
		private var now_color:Array = [];
		private var now_angle:Array = [];
		private var midUniqueTable:Array = [];
		private var color_actTable:Array = [];
		private var angle_actTable:Array = [];
		private var mid_c = 3;//midの数 とりあえず3つ
		private var SB_max = 534;//シークバーの最大X座標
		private var SB_x;
		private var SB_y;
		private var SB_backFlag = false;
		private var p_min_x = 8;//ポインターの最初の場所
		private var p_min_y = 4.5;
		private var rect;//ポインターの移動範囲
		private var v_rect;
		private var TS_end;//xmlの最後の秒数
		private var TS_num;//タイムスタンプがいくつあるか。
		private var sound_end;
		private var play_flag:Boolean = true;
		private var drop_flag:Boolean = false;
		private var session_id;
		private var tid;
		private var uid;
		private var uname;
		private var dropMC = new MovieClip();
		private var dropMC_v = new MovieClip();
		private var playerMask = new MovieClip();
		private var playerFlag = true;
		private var contentsMask = new MovieClip();
		private var c_end;
		private var trans;
		private var imgURLLoader:Array = [];
		private var imgLoader:Array = [];
		private var imgURL:Array = [];
		private var completeCount = 0;//最初のムービークリップの画像を読み込みで何個ロードしたかをカウント
		private var completeJudge = 0;//全部で何個画像をロードするべきなのかを保存しておく
		private var loadstatus_text;
		
		
		
		public function main(){
			//JavaScriptから値を取得
			uid = this.loaderInfo.parameters['uid'];
			uname = this.loaderInfo.parameters['uname'];
			session_id = int(this.loaderInfo.parameters['sid']);
			tid = int(this.loaderInfo.parameters['tid']);
			
			//JavaScriptから値を引き受けない場合(テストの場合)のユーザは望月先生とする。
			if(uid == null){
				uid = 1;
				uname = "望月　俊男";
			}
			
			//シークバーの初期値
			player.pointer.x = p_min_x;
			player.sb.width = p_min_x;
			
			//プレイヤーマスクの設定
			playerMask.graphics.beginFill(0xFFFFFF,1);
			playerMask.graphics.drawRect(0,250,550,150);
			playerMask.graphics.endFill;
			player.mask = playerMask;
			veil.infoVar.width = 0;
			load_start();
			/*veil.sessionid_box.background = true;
			veil.sessionid_box.backgroundColor = 0xFFFFFF;
			veil.sessionid_box.border = true;
			veil.sessionid_box.borderColor = 0x000000;
			veil.sessionid_box.restrict = "0-9";
			veil.sessionid_box.text = int(session_id);
			veil.tid_box.background = true;
			veil.tid_box.backgroundColor = 0xFFFFFF;
			veil.tid_box.border = true;
			veil.tid_box.borderColor = 0x000000;
			veil.tid_box.restrict = "0-9";
			veil.tid_box.text = int(tid);
			veil.infoVar.width = 0;
			veil.ok_btn.addEventListener(MouseEvent.CLICK, load_start);*/
		}
		
		//readMarkerLocatorロード開始
		private function load_start(){
			veil.s_text.visible = false;
			veil.t_text.visible = false;
			veil.sessionid_box.visible = false;
			veil.tid_box.visible = false;
			veil.ok_btn.visible = false;
			veil.logout_btn.visible = false;
			veil.infoVar.visible = true;
			veil.loadStatus.text = "人形のデータを取得中...";
			
			loadstatus_text = "人形データ";
			
			//読み込むXMLを吐き出すURLを変数に格納
			var xmlURL:String = "http://pb.fm.senshu-u.ac.jp/~tmochi/educeboard/readMarkersLocator2.php?xml=1&session_id=" + session_id + "&tid=" + tid;
			//var xmlURL:String = "./readMarkersLocator.xml";
			//URLRequestにURLを格納
			xml_urlRequest.url = xmlURL;
			//読み込みが完了したらcomment_Loadを実行するように設定
			xml_urlLoader.addEventListener(Event.COMPLETE, sound_Load);
			//IOエラーを取り除く
			xml_urlLoader.addEventListener(IOErrorEvent.IO_ERROR,IOErrorHandler);
			//ロード開始
			xml_urlLoader.load(xml_urlRequest);
			//ロード状況
			xml_urlLoader.addEventListener(ProgressEvent.PROGRESS,infoFunc);
		}
		
		private function load_start_Error(me:MouseEvent){
			veil.s_text.visible = false;
			veil.t_text.visible = false;
			veil.sessionid_box.visible = false;
			veil.tid_box.visible = false;
			veil.ok_btn.visible = false;
			veil.logout_btn.visible = false;
			veil.infoVar.visible = true;
			veil.loadPerStatus.visible = false;
			veil.loadStatus.text = "人形のデータを取得中...";
			//最初のテキストボックスに入れたIDを変数に格納
			session_id = int(veil.sessionid_box.text);
			tid = int(veil.tid_box.text);
			loadstatus_text = "人形データ";
			
			//読み込むXMLを吐き出すURLを変数に格納
			var xmlURL:String = "http://pb.fm.senshu-u.ac.jp/~tmochi/educeboard/readMarkersLocator.php?session_id=" + session_id + "&tid=" + tid;
			//URLRequestにURLを格納
			xml_urlRequest.url = xmlURL;
			//読み込みが完了したらcomment_Loadを実行するように設定
			xml_urlLoader.addEventListener(Event.COMPLETE, sound_Load);
			//IOエラーを取り除く
			xml_urlLoader.addEventListener(IOErrorEvent.IO_ERROR,IOErrorHandler);
			//ロード開始
			xml_urlLoader.load(xml_urlRequest);
			//ロード状況
			xml_urlLoader.addEventListener(ProgressEvent.PROGRESS,infoFunc);
			
			//コメントのURLを格納
			/*var cm_xmlURL:String = "http://pb.fm.senshu-u.ac.jp/~tmochi/educeboard/showComments.php?session_id=" + session_id + "&tid=" + tid;
			cmxml_urlRequest.url = cm_xmlURL;
			cmxml_urlLoader.addEventListener(Event.COMPLETE,XMLLoadCompleteCounter);
			cmxml_urlLoader.load(cmxml_urlRequest);
			//cmxml_urlLoader.addEventListener(ProgressEvent.PROGRESS,infoFunc);
			cmxml_urlLoader.addEventListener(IOErrorEvent.IO_ERROR,IOErrorHandler);*/
			
			//stage.addEventListener(Event.ENTER_FRAME,XMLinfoFunc);
			/*if(now_loadTotal >= loadTotal){
				completeHandler();
			}*/
		}
		
		//soundロード開始
		private function sound_Load(event:Event){
			veil.infoVar.width = 0;
			veil.loadPerStatus.visible = false;
			veil.loadStatus.text = "音声データを取得中...";
			//commentがロードし終わったのでEventListenerを取り除く。
			xml_urlLoader.removeEventListener(Event.COMPLETE,load_start);
			loadstatus_text = "音声データ";
			
			mp3_urlRequest = new URLRequest("http://pb.fm.senshu-u.ac.jp/~tmochi/educeboard/voice/" + session_id + "_" + tid + ".mp3");
			//mp3_urlRequest = new URLRequest("./289_1.mp3");
			//サウンドを操作するためのオブジェクトを変数に格納。
			sound = new Sound();
			//サウンドの読み込みが完了したらcompleteHandlerを実行するように設定。
			sound.addEventListener(Event.COMPLETE, comment_Load);
			//ロード開始
			sound.load(mp3_urlRequest,new SoundLoaderContext(1000,true));
			sound.addEventListener(ProgressEvent.PROGRESS,infoFunc);
			sound.addEventListener(IOErrorEvent.IO_ERROR,IOErrorHandler);
		}
		
		//commentロード開始
		private function comment_Load(event:Event){
			veil.infoVar.width = 0;
			veil.loadPerStatus.visible = false;
			veil.loadStatus.text = "コメントデータを取得中...";
			sound.removeEventListener(Event.COMPLETE, comment_Load);
			loadstatus_text = "コメントデータ";
			
			//コメントのURLを格納
			var cm_xmlURL:String = "http://pb.fm.senshu-u.ac.jp/~tmochi/educeboard/showComments.php?session_id=" + session_id + "&tid=" + tid;
			//var cm_xmlURL:String = "./comment.xml";
			cmxml_urlRequest.url = cm_xmlURL;
			cmxml_urlLoader.addEventListener(Event.COMPLETE,completeHandler);
			cmxml_urlLoader.load(cmxml_urlRequest);
			//cmxml_urlLoader.addEventListener(ProgressEvent.PROGRESS,infoFunc);
			cmxml_urlLoader.addEventListener(IOErrorEvent.IO_ERROR,IOErrorHandler);
			cmxml_urlLoader.addEventListener(ProgressEvent.PROGRESS,infoFunc);
		}
		
		/*private function XMLLoadCompleteCounter(event:Event){
			//xmlのロードだけを数える
			completeCount += 1;
			if(completeCount >= 2){
				trace("a");
				soundLoader();
			}
		}*/
		
		/*private function soundLoader(){
			trace("b");
			stage.removeEventListener(Event.ENTER_FRAME,XMLinfoFunc);
			xml_urlLoader.removeEventListener(Event.COMPLETE,XMLLoadCompleteCounter);
			cmxml_urlLoader.removeEventListener(Event.COMPLETE,XMLLoadCompleteCounter);
			
			mp3_urlRequest = new URLRequest("http://pb.fm.senshu-u.ac.jp/~tmochi/educeboard/voice/" + session_id + "_" + tid + ".mp3");
			//サウンドを操作するためのオブジェクトを変数に格納。
			sound = new Sound();
			//サウンドの読み込みが完了したらcompleteHandlerを実行するように設定。
			//sound.addEventListener(Event.COMPLETE,completeHandler);
			stage.addEventListener(Event.ENTER_FRAME,SoundInfoFunc);
			//ロード開始
			sound.load(mp3_urlRequest,new SoundLoaderContext(1000,true));
		}*/
		
		private function completeHandler(event:Event){
			cmxml_urlLoader.removeEventListener(Event.COMPLETE,completeHandler);
			//すべてのロードが完了したので、黒い半透明レイヤーを消す
			removeChild(veil);
			//サウンドのロードが完了したのでEventListenerを取り除く。
			/*xml_urlLoader.removeEventListener(Event.COMPLETE,completeCounter);
			cmxml_urlLoader.removeEventListener(Event.COMPLETE,completeCounter);
			sound.removeEventListener(Event.COMPLETE,completeCounter);
			stage.removeEventListener(Event.ENTER_FRAME,infoFunc);*/
			
			//読み込んだデータをXMLオブジェクトにし、変数に格納する
			memberXML = new XML(xml_urlLoader.data);
			commentXML = new XML(cmxml_urlLoader.data);
			//XMLの要素をelementに格納しながらループさせ、各テーブルに追加していく。
			for each(var element:Object in memberXML.MarkerLocator){//readMarkerLocator
				TimeTable.push(element.TS);
				XTable.push(element.x);
				YTable.push(element.y);
				midTable.push(element.mid);
				colorTable.push(element.color);
				angleTable.push(element.direction1);
			}
			for each(var c_element:Object in commentXML.Comments){//コメント
				cm_time.push(c_element.time);
				cm_uid.push(c_element.uid);
				cm_name.push(c_element.username);
				comment.push(c_element.text);
			}
			
			
			//midTableの重複した値を消して、どのmidがあるのかを新たにテーブルに格納する。
			midUniqueTable = arrayUnique(midTable);//関数は自ら定義してある。また、このテーブル自体が添え字になってくる。mid自体を添え字にしてしまうため空の領域も出てくる。わからなければtrace(midUniqueTable);で確認。
			mid_c = midUniqueTable.length;//midの数
			midUniqueTable.sort(16);//midを1から順番にする。

			
			//readMarkersLocator.phpが出力する全てのデータの個数を格納
			var midAllNum = midTable.length;
			//テーブル初期化
			var midCount = [];
			for(var i = 0; i < mid_c; i++){
				midCount[i] = 0;
			}
			//各midのデータ数を計算
			for(i = 0; i < midAllNum; i++){
				var _mid = midTable[i];
				for(var j = 0; j < mid_c; j++){
					if(_mid == midUniqueTable[j]){
						midCount[j]++;
					}
				}
			}
			//データの数が一番小さいものを算出
			var midMax = midCount[0];
			for(i = 0; i < midCount.length; i++){
				if(midMax < midCount[i]){
					midMax = midCount[i];
				}
			}

			var midPer = [];
			for(i = 0; i < midCount.length; i++){
				midPer[i] = Math.round(midCount[i] / midMax * 100);
				midPer[i] = midPer[i] / 100;
			}

			/*
			//各midのデータ数が均等だったらいくつなのかを算出
			var midAverage = midAllNum / mid_c;
			//アクターを表示しないボーダーラインを算出
			var midDeleteBorder = midAverage - midMin;*/
			//表示するならfalse、しないならtrueを入れる
			var midVisible = [];
			for(i = 0; i < midCount.length; i++){
				if(midPer[i] < 0.05){
					midVisible[i] = false;
				}
				else{
					midVisible[i] = true;
				}
			}
			trace(midUniqueTable);
			trace(midCount);
			trace(midPer);
			
			
			//まず最初のLEDの色が何であるのかを、各midごとに線形探索で探し、テーブルに格納する
			for(var l = 0; l < midUniqueTable.length; l++){
				var m = 0;
				while(1){
					if(midTable[m] == midUniqueTable[l]){
						color_actTable[midUniqueTable[l]] = colorTable[m];//アクターごとのLEDの色データを格納しておいて、色に変化があったかどうかを判断するためのもの
						angle_actTable[midUniqueTable[l]] = angleTable[m];//アクターごとの向きの変化。意図は上に同じ。
						//最初の1秒間の間にアクターがあればカラーとアングルを保存する。なければundefinedとなる。
						if(TimeTable[0] > TimeTable[m] - 1){
							first_color[midUniqueTable[l]] = colorTable[m];
							first_angle[midUniqueTable[l]] = angleTable[m];
							completeJudge += 1;//ロードとの時間を調整するために用いる。first_color(及びangle)にいくつデータがあったかを保存しておく。
						}
						break;
					}
					m++;
				}
			}
			
			//コメントのムービークリップを生成していく
			//マスクをかけるためのMCを生成
			var cmMC_y = 0;//コメントMCのy座標をずらさないとコメントが重なってしまうため、それを防ぐための変数
			var c_maskMC = new MovieClip();
			c_maskMC.x = 599;
			c_maskMC.y = cBase_y = base_point = 111;
			c_maskMC.graphics.beginFill(0xFFFFFF,1);
			c_maskMC.graphics.drawRect(0,0,397,519);
			c_maskMC.graphics.endFill();
			//コメントのMCを一つにまとめるためのMCの設定
			c_baseMC.x = 599;
			c_baseMC.y = cBase_y;
			c_baseMC.graphics.beginFill(0xFFFFFF,1);
			c_baseMC.graphics.lineStyle(1,0xCCCCCC,1);
			c_baseMC.graphics.drawRect(0,0,400,cmMC_y);
			c_baseMC.graphics.endFill();
			//c_baseMCに生成したコメントMCを入れ子していく
			for(i = 0; i < cm_time.length; i++){
				var cmMC = cmMC_maker(cm_name[i],comment[i],secound_trans(cm_time[i]));//コメントMC作成Function
				cmMC.y = cmMC_y;//最初のy座標は0、次が70、次が140… というようにコメントのy座標がずれていく
				//cmMC_y += 70;
				//70である理由は、コメントMCのheightを70にしているから
				cmMC_y += cmMC.height;//cmMCの高さを加算し、次のMCのy座標値を決める
				cmMC_Table[i] = cmMC;//コメントのMCをテーブルにも格納していく
				cmMC_height[i] = cmMC.height;//コメントのMCの高さも格納する
				c_baseMC.addChild(cmMC);//作ったコメントMCをc_baseMCに入れ子
			}
			if(cmMC_Table.length > 0){//コメントが一個も無いときは何もせず、あるときは最初のコメントを点滅させる
				cmMC_Table[0].addChildAt(now_cmMCmarker(cmMC_height[0]),0);
			}
			//c_baseMC自体をステージに追加(入れ子)
			stage.addChild(c_baseMC);
			//マスクを設定
			c_baseMC.mask = c_maskMC;
			
			//サウンドを再生し、再生したサウンドオブジェクトを変数に格納(再生中に音量などを変更したり、再生をストップさせたりするため）
			channel = sound.play();
			
			//TimeStampとFlashの時間を合わせるため、0.1秒ごとに処理を実行してくれるTimeObjectを生成
			timer = new Timer(100);
			timer.start();//スタートさせる
			
			//midに対応したアクターを作る
			for(j = 1; j <= midUniqueTable[midUniqueTable.length - 1]; j++){//midの数字はとびとびになるため、jはmidUniqueTableの最後のセルに入った数字まで回す
				for(var k = 0; k < midUniqueTable.length; k++){
					if(j == midUniqueTable[k]){
						actTable[midUniqueTable[k]] = new MovieClip();//ムービークリップを生成
						if(midVisible[k]){
							contents.addChild(actTable[midUniqueTable[k]]);//contentsは.flaにおいてあるMCでありASで生成したものではない。comtentsは変数名ではなくインスタンス名である。
						}
					}
				}
			}
			trace(actTable);
			
			//それぞれのアクターに画像を入れるとともに、アクターの最初のx座標とy座標を決める
			for(var n = 0; n < midUniqueTable.length; n++){//各アクターごとに線形探索を行う
				var o = 0;
				var _act = actTable[midUniqueTable[n]];//アクターを一時保存
				while(1){
					if(midUniqueTable[n] == midTable[o]){
						//firstは最初の場所を保存しておくもの。nowは現在のアクターの場所。aftはアクターを動かす目標値。
						first_x[midUniqueTable[n]] = now_x[midUniqueTable[n]] = aft_x[midUniqueTable[n]] = XTable[o];
						first_y[midUniqueTable[n]] = now_y[midUniqueTable[n]] = aft_y[midUniqueTable[n]] = YTable[o];
						actTable[midUniqueTable[n]].x = stage_X * XTable[o] / 100;
						actTable[midUniqueTable[n]].y = stage_Y * YTable[o] / 100;
						//nowからaftまでの距離を求め、それを百分率にしたものを格納するためのもの。今はnowとaftが同じ数であるため0でよい。
						per_x[midUniqueTable[n]] = 0;
						per_y[midUniqueTable[n]] = 0;
						//imgLoaderとimgURLLoaderは後々使うため、ifの中には入れない。
						imgLoader[midUniqueTable[n]] = new Loader();//
						imgURLLoader[midUniqueTable[n]] = new URLLoader();
						//アクターに入れ子する画像のURLを変数に格納する。しかし、first_colorかfirst_angleのデータがないものは最初の1秒以内にはアクターが存在しないため画像はロードしない。
						//つまり、ローダーをifの中に入れてしまうと、最初の一秒にアクターが存在しないものに対応するローダーオブジェクトが生成されないため、後々困ることになる。
						if(first_color[midUniqueTable[n]] != undefined || first_angle[midUniqueTable[n]] != undefined){
							var imgXMLURL:String = "http://pb.fm.senshu-u.ac.jp/~tmochi/educeboard/showActorImage.php?mid=" + midTable[o] + "&color=" + colorTable[o] + "&angle=" + angleTable[o];
							//var imgXMLURL:String = "./f_hard_F.png";
							var imgURLRequest:URLRequest = new URLRequest();
							imgURLRequest.url = imgXMLURL;
							imgURLLoader[midUniqueTable[n]].load(imgURLRequest);//画像のURLをロードする
							imgURLLoader[midUniqueTable[n]].addEventListener(Event.COMPLETE,ImageURL_addTable(midUniqueTable[n]));//URLをロードしたらImageURL_addTable()を実行するように設定
							imgURLLoader[midUniqueTable[n]].addEventListener(IOErrorEvent.IO_ERROR,IOErrorHandler_image);//IOエラーを取り除く
						}
						break;
					}
					o++;
				}
			}
			
			//URLがロードされるのを待つために、ENTER_FRAMEをする。ImageURL_addTable()の処理を待つ。強引すぎる処理です。
			addEventListener(Event.ENTER_FRAME,function(e:Event){
				//imgURLにURLがロードされ次第格納されていく。格納しているのはImageURL_addTable。ImageURL_addTableにあるcompleteCountの値がcompleteJudgeの値以上になった時にすべての画像を読みに行く。
				if(completeJudge <= completeCount){
					for(var i = 0; i < imgURL.length; i++){
						//midを添え字にしているため、imgURL[midUniqueTable]がundefinedの場合があるため以下のif文を入れる。
						if(imgURL[midUniqueTable[i]] != undefined){
							var urlRequest:URLRequest = new URLRequest();
							urlRequest.url = imgURL[midUniqueTable[i]];
							//imgLoader[i] = new Loader();
							imgLoader[midUniqueTable[i]].addEventListener(IOErrorEvent.IO_ERROR,IOErrorHandler_image);
							imgLoader[midUniqueTable[i]].load(urlRequest);
							actTable[midUniqueTable[i]].addChild(imgLoader[midUniqueTable[i]]);
						}
					}
					//ENTER_FRAMEを止める。arguments.calleeは「この関数自信」という意味である。この関数は無名関数であるため名前を指定できないからこのような形になっている。
					removeEventListener(Event.ENTER_FRAME,arguments.callee);
					//ロードし終えたらplayPrepareを実行する。
					playPrepare();
				}
			});
		}
		
		//URLがロードされ次第、テーブルに格納していく。この関数は上のENTER_FRAMEより先に実行される。ENTER_FRAMEはこの関数が処理を終えるのを待っている。
		//またこの関数は「関数を返す関数」である。addEventListenerに登録できる関数には引数を持たせることができないため、この方法をとっている。
		private function ImageURL_addTable(n:int):Function{
			return function(e:Event):void{//returnの後ろのfunctionを返している。つまりimgURLLoaderのaddEventListenerに入れている関数は、この関数に化けるということである。
				var url = e.target.data;//eはEvent.COMPLETEしたオブジェクトのことであり、つまりimgURLLoader[n]のことである。
				imgURL[n] = url;//nはImageURL_addTable(n)のnである。引数で渡してある。
				e.target.removeEventListener(Event.COMPLETE,arguments.callee);//imgURLLoader[n]のEventListenerを取り除く。
				completeCount += 1;//URLの格納が終わったため、ひとつ加算する。
			}
		}
		
		private function playPrepare(){
			comment_box.text = "";
			
			//アクターが枠からでないようにマスクをかけるため、そのマスクを生成する。
			contentsMask.graphics.beginFill(0xFFFFFF,1);
			contentsMask.graphics.drawRect(0,0,550,400);
			contentsMask.graphics.endFill();
			//マスクをかける。(contentsはアクターを入れ子したものである)
			contents.mask = contentsMask;
			
			
			TS_num = TimeTable.length - 1;
			TS_end = TimeTable[TS_num];//最後の秒数の格納
			trace(imgURL);
			
			//サウンドの終わる時間を格納
			sound_end = sound.length / 1000;
			
			//再生された場合、play_markは見えなくてよいので、見えなくする。(playerは.flaにおいてある)
			player.play_btn.play_mark.visible = false;
			com_play_btn.play_mark.visible = false;
			
			//シークバーの移動範囲場所を格納
			rect = new Rectangle(p_min_x,p_min_y,SB_max,0);
			
			//ボリュームバーの移動範囲
			v_rect = new Rectangle(16.5,7.35,0,70);
			
			//ドラッグしたときにどこでもドロップできるようにするためのMC
			dropMC.graphics.beginFill(0xFFFFFF,1);
			dropMC.graphics.drawRect(0,0,1000,400);
			dropMC.graphics.endFill;
			dropMC.alpha = 0;
			
			//ドラッグしたときにどこでもドロップできるようにするためのMC(ボリューム用)
			dropMC_v.graphics.beginFill(0xFFFFFF,1);
			dropMC_v.graphics.drawRect(0,0,1000,400);
			dropMC_v.graphics.endFill;
			dropMC_v.alpha = 0;
			
			//ボリュームの初期値
			trans = channel.soundTransform;
			trans.volume = 0.5;
			channel.soundTransform = trans;
			player.volumer.v_pointer.y = 42.5;
			player.volumer.v_height.y = 42.5;
			player.volumer.v_height.height = 77.35 - player.volumer.v_pointer.y;
			
			//タイムスタンプとサウンドの秒数をそろえる
			var per = 1 - (TS_end / sound_end);
			for(var i = 0; i < TimeTable.length; i++){
				TimeTable[i] = TimeTable[i] * (1 + per);
			}
			
			
			player.pointer.addEventListener(MouseEvent.MOUSE_DOWN, SBdrag);//シークバーをドラッグしたときの処理を設定
			dropMC.addEventListener(MouseEvent.MOUSE_UP, SBdrop);//シークバーをドロップしたときの処理を設定
			player.volumer.v_pointer.addEventListener(MouseEvent.MOUSE_DOWN,vSBdrag);//ボリュームバーをドラッグしたときの処理を設定
			dropMC_v.addEventListener(MouseEvent.MOUSE_UP,vSBdrop);//ボリュームバーをドロップしたときの処理を設定
			player.play_btn.addEventListener(MouseEvent.CLICK,start_fnc);//再生／一時停止ボタンを押したときの処理を設定
			com_play_btn.addEventListener(MouseEvent.CLICK,start_fnc);//コメント下の再生／一時停止ボタンを押したときの処理を設定
			timer.addEventListener(TimerEvent.TIMER,loop);//0.1秒ごとに実行される処理を設定
			send_btn.addEventListener(MouseEvent.CLICK,send_f);//コメントを投稿したときの処理を設定
			stage.addEventListener(Event.ENTER_FRAME,playerINOUT);//プレイヤーを表示させたり非表示にさせたりするときの処理を設定
			player.volume_btn.addEventListener(MouseEvent.ROLL_OVER,volumerIN);//ボリュームのアイコンをマウスオーバーしたときの処理を設定
			player.volumer.addEventListener(MouseEvent.ROLL_OUT,volumerOUT);//ボリュームを変更するMCからマウスアウトしたときの処理を設定
			stage.addEventListener(MouseEvent.MOUSE_DOWN,volumerOUT);//Flash自体をクリックしたときにボリュームMCを消すための処理を設定
		}
		
		//0.1秒ごとに処理を実行する関数
		private function loop(e:TimerEvent){
			s = channel.position / 1000;//秒数を格納
			var SB_per = s / sound_end;//シークバーの場所を百分率にして格納
			player.show_time.text = secound_trans(s);//秒数を時:分:秒の形にして表示させる
			player.pointer.x = SB_per * SB_max + p_min_x;//百分率をもとにシークバーを動かす
			player.sb.width = player.pointer.x;//シークバーの赤い部分を引き延ばす
			
			//TimeStampが0秒から始まっているとは限らないため、sがTimeStampの最初の秒数を超えるまでアクターを動かす処理は行わないようにする。
			if(s >= TimeTable[0]){
				act_move();//アクトを動かす関数
				while(s > TimeTable[t]){//Flashの時間とずれるためTimeTableを飛ばす。
					for(var l = 0; l < midUniqueTable.length; l++){
						if(midTable[t] == midUniqueTable[l]){
							aft_x[midUniqueTable[l]] = XTable[t];//飛ばしたら飛ばされたままになってしまうので、アクターの目標場所を更新。
							aft_y[midUniqueTable[l]] = YTable[t];
							now_color[midUniqueTable[l]] = colorTable[t];
							now_angle[midUniqueTable[l]] = angleTable[t];
						}
					}
					t++;
				}
				
				for(var m = 0; m < midUniqueTable.length; m++){
					var w_t = t;
					while(1){
						if(midTable[w_t] == midUniqueTable[m]){
							break;
						}
						else if(w_t > midTable.length){
							while(1){
								if(actTable[midUniqueTable[m]].numChildren <= 0){
									now_color[midUniqueTable[m]] = now_angle[midUniqueTable[m]] = undefined;
									break;
								}
								else{
									actTable[midUniqueTable[m]].removeChildAt(0);
								}
							}
							break;
						}
						w_t++;
					}
				}
				
				//LEDのカラーが変わったときに画像をロードして、アクターに入れる
				for(var j = 0; j < midUniqueTable.length; j++){
					//var _act = actTable[midUniqueTable[j]];//アクターを一時保存
					//現在のmidとforのmidが同じであり、さらにカラーが現在のものと、今までのいものが違う色であるときだけ以下を実行
					if(now_color[midUniqueTable[j]] != color_actTable[midUniqueTable[j]] || angleHandler(now_angle[midUniqueTable[j]]) != angleHandler(angle_actTable[midUniqueTable[j]]) || actTable[midUniqueTable[j]].numChildren <= 0){
						//trace(midUniqueTable[j],now_color[midUniqueTable[j]],color_actTable[midUniqueTable[j]],angleHandler(now_angle[midUniqueTable[j]]),angleHandler(angle_actTable[midUniqueTable[j]]),actTable[midUniqueTable[j]].numChildren);
						if(now_color[midUniqueTable[j]] != undefined || now_angle[midUniqueTable[j]] != undefined){
							//URLを格納
							var showIMG_URL:String = "http://pb.fm.senshu-u.ac.jp/~tmochi/educeboard/showActorImage.php?mid=" + midUniqueTable[j] + "&color=" + now_color[midUniqueTable[j]] + "&angle=" + now_angle[midUniqueTable[j]];
							//var showIMG_URL:String = "f_hard_F.png";
							//trace(midTable[t],colorTable[t]);
							var imgURLRequest:URLRequest = new URLRequest();
							imgURLRequest.url = showIMG_URL;
							//Loaderは前に画像をロードするときに格納しているので、またオブジェクトを生成する必要はない
							imgURLLoader[midUniqueTable[j]].load(imgURLRequest);
							imgURLLoader[midUniqueTable[j]].addEventListener(IOErrorEvent.IO_ERROR,IOErrorHandler_image);
							imgURLLoader[midUniqueTable[j]].addEventListener(Event.COMPLETE,imageLoader(midUniqueTable[j],actTable[midUniqueTable[j]]));//ロードし終えたらimageLoaderを実行するように設定
						
							color_actTable[midUniqueTable[j]] = now_color[midUniqueTable[j]];//カラーを更新する
							angle_actTable[midUniqueTable[j]] = now_angle[midUniqueTable[j]];
							//アクターの画像を常に1つにするように保つための処理
							while(1){
								if(actTable[midUniqueTable[j]].numChildren <= 1){
									break;
								}
								else{
									actTable[midUniqueTable[j]].removeChildAt(0);
								}
							}
						}
					}
					//trace(_act.numChildren);
					
					
				}
				if(sound_end <= s || TimeTable[TimeTable.length - 1] <= s){
					timer.stop();
					timer.removeEventListener(TimerEvent.TIMER,loop);
					channel.stop();
					position = 0;
					play_flag = false;
					player.pointer.x = p_min_x;
					player.sb.width = p_min_x;
					t = s = 0;
					player.play_btn.play_mark.visible = true;
					player.play_btn.stop_mark.visible = false;
					com_play_btn.play_mark.visible = true;
					com_play_btn.stop_mark.visible = false;
					for(var i = 0; i < midUniqueTable.length; i++){
						while(actTable[midUniqueTable[i]].numChildren > 0){   
 							actTable[midUniqueTable[i]].removeChildAt(0);   
						}
						var o = 0;
						while(1){
							if(midUniqueTable[i] == midTable[o]){
								now_x[midUniqueTable[i]] = aft_x[midUniqueTable[i]] = XTable[o];
								now_y[midUniqueTable[i]] = aft_y[midUniqueTable[i]] = YTable[o];
								actTable[midUniqueTable[i]].x = stage_X * XTable[o] / 100;
								actTable[midUniqueTable[i]].y = stage_Y * YTable[o] / 100;
								per_x[midUniqueTable[i]] = 0;
								per_y[midUniqueTable[i]] = 0;
								color_actTable[midUniqueTable[i]] = colorTable[o];
								angle_actTable[midUniqueTable[i]] = angleTable[o];
								break;
							}
							o++;
						}
						if(first_color[midUniqueTable[i]] != undefined || first_angle[midUniqueTable[i]] != undefined){
							var showIMG_URL2:String = "http://pb.fm.senshu-u.ac.jp/~tmochi/educeboard/showActorImage.php?mid=" + midUniqueTable[i] + "&color=" + first_color[midUniqueTable[i]] + "&angle=" + first_angle[midUniqueTable[i]];
							//var showIMG_URL2:String = "./f_hard_F.png";
							var imgURLRequest2:URLRequest = new URLRequest();
							imgURLRequest2.url = showIMG_URL2;
							imgURLLoader[midUniqueTable[i]].load(imgURLRequest2);
							imgURLLoader[midUniqueTable[i]].addEventListener(Event.COMPLETE,imageLoader(midUniqueTable[i],actTable[midUniqueTable[i]]));
						}
					}
					cmMC_Table[0].addChildAt(now_cmMCmarker(cmMC_height[0]),0);
					cmMC_Table[cmMC_Table.length - 1].removeChildAt(0);
					base_point = cBase_y;
					c_baseMC.y = base_point;
					Tcomment_c = Mcomment_c = 0;
				}
			}
			
			//※Mcomment_cは一番上に表示されているコメントの添字、Tcomment_cは再生時間に対応したコメントの添字
			comment_move();//コメントを動かす関数
			var cmMC_heightSum = 0;//表示されているコメントの高さの合計を出すための変数
			var _Tcomment_c = Tcomment_c;//コメントの高さを出すための添字を一時格納
			while(1){
				if(Mcomment_c > _Tcomment_c){//表示されている一番上のコメントの添字(Mcomment_c)を下回ったらループを抜ける
					break;
				}
				else if(cmMC_height.length >= _Tcomment_c){
					cmMC_heightSum += cmMC_height[_Tcomment_c];
					_Tcomment_c--;
				}
				else{
					break;
				}
			}
			if(SB_backFlag == true){//シークバーを左側にずらしたときの処理
				if(Tcomment_c <= 0){
					c_baseMC.y = base_point = cBase_y;
				}
				else{
					c_baseMC.y = base_point;//comment_move関数を使わず、値を代入して移動する
				}
				SB_backFlag = false;
				c_moveFlag = false;
			}
			else if(cmMC_heightSum > 519){//コメントの表示領域が519pxで、cmMC_heightSumがその値を超えた時の処理
				Mcomment_c++;
				base_point -= cmMC_height[Mcomment_c];//base_pointの値を変える
				c_moveFlag = true;//コメントを動くのでフラグをたてる
			}
			if(Math.floor(cm_time[Tcomment_c]) <= Math.floor(s)){//再生時間がコメントの時間以上になったら
				if(Tcomment_c >= 0){//さらにコメントがある状態のとき
					if(Tcomment_c > 0){
						var _markerMC = cmMC_Table[Tcomment_c - 1].getChildByName("markerMC");//一つ前の点滅しているMCを取得
						if(_markerMC != null){//データが格納されていたら
							cmMC_Table[Tcomment_c - 1].removeChild(_markerMC);//点滅を削除する
						}
					}
					cmMC_Table[Tcomment_c].addChildAt(now_cmMCmarker(cmMC_height[Tcomment_c]),0);//現在のコメントを点滅させるために点滅MCをadd
				}
				Tcomment_c += 1;//コメントの添字を加算
			}
		}
		
		private function comment_move():void{
			if(c_moveFlag == true){//動かすときにしか作動しないようにする
				if(c_baseMC.y > base_point){
					c_baseMC.y = Math.floor((c_baseMC.y + (base_point - c_baseMC.y) * 0.5) * 10) / 10;//50%ずつ動かす。小数点第1位を切り捨て。
				}
				else{
					c_moveFlag = false;//動かしたら動かないようにフラグをfalseに。
				}
			}
		}
		
		private function act_move():void{
			//アクターの移動予定場所まですべてのアクターを動かす
			for(var k = 0; k < midUniqueTable.length; k++){
				if(drop_flag){//シークバーを動かしたときの処理
					//一気にその時間の場所まで戻す。50%ずつ動かす必要は無いのでnowとaftは同じ値で良い
					now_x[midUniqueTable[k]] = aft_x[midUniqueTable[k]];
					now_y[midUniqueTable[k]] = aft_y[midUniqueTable[k]];
					per_x[midUniqueTable[k]] = 0;//nowとaftは同じ値だから、計算させずに単純に0を代入
					per_y[midUniqueTable[k]] = 0;
					if(k == midUniqueTable.length - 1){//ループが終わったらフラグを戻す
						drop_flag = false;
					}
				}
				else{
					var w_x:Number = now_x[midUniqueTable[k]];//そのままnow_xを使うと文字として判断されるため、
					var w_y:Number = now_y[midUniqueTable[k]];//一度Number型の変数に格納
					//nowとaftの差を出す
					var x_margin = aft_x[midUniqueTable[k]] - now_x[midUniqueTable[k]];
					var y_margin = aft_y[midUniqueTable[k]] - now_y[midUniqueTable[k]];
					
					//貧乏揺すり現象を回避するためのif。nowとaftの差が-0.5〜0.5の時はパーセントを出さない
					if((x_margin > 0.5 || x_margin < -0.5) || (y_margin > 0.5 || y_margin < -0.5)){
						per_x[midUniqueTable[k]] = x_margin / 100;//再びパーセントを出す
						per_y[midUniqueTable[k]] = y_margin / 100;
						now_x[midUniqueTable[k]] = (w_x + per_x[midUniqueTable[k]] * 50);
						now_y[midUniqueTable[k]] = (w_y + per_y[midUniqueTable[k]] * 50);
					}
				}
				actTable[midUniqueTable[k]].x = stage_X * now_x[midUniqueTable[k]] / 100;
				actTable[midUniqueTable[k]].y = stage_Y * now_y[midUniqueTable[k]] / 100;
			}
		}
		

		private function SBdrag(me:MouseEvent):void{
			timer.removeEventListener(TimerEvent.TIMER,loop);
			player.pointer.startDrag(false,rect);
			player.sb.addEventListener(Event.ENTER_FRAME,SBwidth);
			stage.addChild(dropMC);
			channel.stop();
			play_flag = false;
		}
		
		private function SBwidth(e:Event):void{
			e.target.width = player.pointer.x;
		}
		
		private function SBdrop(me:MouseEvent):void{
			timer.addEventListener(TimerEvent.TIMER,loop);
			player.sb.removeEventListener(Event.ENTER_FRAME,SBwidth);
			stage.removeChild(dropMC);
			var _s = s;//再計算する前の時間を保存
			var SB_per2 = (player.pointer.x - p_min_x) / SB_max;
			s = sound_end * SB_per2;
			t = 0;
			while(s >= TimeTable[t]){
				t++;
			}
			if(s < _s){//時間が前に戻っていたときにフラグをtrueにする。コメントで使う。
				SB_backFlag = true;
			}
			//trace(t);
			for(var i = 0; i <= midUniqueTable.length; i++){//tの段階ですべてのアクターがどこにいたのかを調べる
				var w_t = t;
				while(1){
					if(w_t <= 0){//添字が0以下になってしまった場合
						aft_x[midUniqueTable[i]] = first_x[midUniqueTable[i]];
						aft_y[midUniqueTable[i]] = first_y[midUniqueTable[i]];
						now_color[midUniqueTable[i]] = first_color[midUniqueTable[i]];
						now_angle[midUniqueTable[i]] = first_angle[midUniqueTable[i]];
						//color_actTable[midUniqueTable[i]] = undefined;
						//angle_actTable[midUniqueTable[i]] = undefined;
						break;
					}
					else if(midUniqueTable[i] == midTable[w_t]){
						aft_x[midUniqueTable[i]] = XTable[w_t];
						aft_y[midUniqueTable[i]] = YTable[w_t];
						now_color[midUniqueTable[i]] = color_actTable[midUniqueTable[i]] = colorTable[w_t];
						now_angle[midUniqueTable[i]] = angle_actTable[midUniqueTable[i]] = angleTable[w_t];
						break;
					}
					w_t--;
				}
			}
			for(var j = 0; j < midUniqueTable.length; j++){
				if(now_color[midUniqueTable[j]] != undefined || now_angle[midUniqueTable[j]] != undefined){
					//trace(midUniqueTable[j],now_color[midUniqueTable[j]],now_angle[midUniqueTable[j]],"a");
					var showIMG_URL:String = "http://pb.fm.senshu-u.ac.jp/~tmochi/educeboard/showActorImage.php?mid=" + midUniqueTable[j] + "&color=" + now_color[midUniqueTable[j]] + "&angle=" + now_angle[midUniqueTable[j]];
					var imgURLRequest:URLRequest = new URLRequest();
					imgURLRequest.url = showIMG_URL;
					imgURLLoader[midUniqueTable[j]].load(imgURLRequest);
					var act_imageURL;
					imgURLLoader[midUniqueTable[j]].addEventListener(Event.COMPLETE,imageLoader(midUniqueTable[j],actTable[midUniqueTable[j]]));
				}
				while(1){
					if(actTable[midUniqueTable[j]].numChildren <= 1){
						break;
					}
					else{
						actTable[midUniqueTable[j]].removeChildAt(0);
					}
				}
			}
			var cmnt_c = 0;
			while(1){
				if(s <= cm_time[cmnt_c]){//現在の秒数をcm_timeが超えたらbreak
					break;
				}
				if(cmnt_c >= cm_time.length - 1){//cmnt_cがcm_timeの添字数以上になったらbreak
					cmnt_c += 1;//後に-1をする必要があり。これだと後に添字数が一つ足りないことになるためあえてひとつ増やしておく。
					break;
				}
				cmnt_c += 1;
			}
			Tcomment_c = cmnt_c - 1;//while文の上のifで抜けた場合、現在の秒数を超えているためコメントの位置が一つ先になってしまう。そのため-1をする。
			if(Tcomment_c < 0){//cmnt_cがそもそも0だった場合、-1になってしまうため、ifで回避。
				Tcomment_c = 0;
			}
			var _Tcomment_c = Tcomment_c;
			var cmMC_heightSum = 0;
			while(1){
				if(cmMC_heightSum > 519){
					break;
				}
				else if(_Tcomment_c <= 0){
					break;
				}
				else if(cmMC_height.length >= _Tcomment_c){
					cmMC_heightSum += cmMC_height[_Tcomment_c];
					_Tcomment_c--;
				}
				else{
					break;
				}
			}
			Mcomment_c = _Tcomment_c;
			var _Mcomment_c = 0;
			var sum = 0;
			while(1){
				if(_Mcomment_c > Mcomment_c){
					break;
				}
				sum += cmMC_height[_Mcomment_c];
				_Mcomment_c++;
			}
			base_point = cBase_y - sum;
			for(var k = 0; k < cmMC_Table.length; k++){
				var _markerMC = cmMC_Table[k].getChildByName("markerMC");
				if(_markerMC != null){
					cmMC_Table[k].removeChild(_markerMC);
				}
			}
			play_flag = true;
			drop_flag = true;
			player.pointer.stopDrag();
			channel = sound.play(s * 1000);
			player.play_btn.play_mark.visible = false;
			player.play_btn.stop_mark.visible = true;
			com_play_btn.play_mark.visible = false;
			com_play_btn.stop_mark.visible = true;
			timer.start();
			timer.addEventListener(TimerEvent.TIMER,loop);
		}
		
		private function vSBdrag(me:MouseEvent):void{
			stage.removeEventListener(MouseEvent.MOUSE_DOWN,volumerOUT);
			player.volumer.removeEventListener(MouseEvent.ROLL_OUT,volumerOUT);
			player.volumer.v_pointer.startDrag(false,v_rect);
			player.volumer.v_height.addEventListener(Event.ENTER_FRAME,vSBheight);
			stage.addChild(dropMC_v);
		}
		
		private function vSBheight(e:Event):void{
			e.target.height = 77.35 - player.volumer.v_pointer.y;
			e.target.y = player.volumer.v_pointer.y;
			trans.volume = 1 - (player.volumer.v_pointer.y / 77.35);
			channel.soundTransform = trans;
		}
		
		private function vSBdrop(me:MouseEvent):void{
			player.volumer.addEventListener(MouseEvent.ROLL_OUT,volumerOUT);
			stage.addEventListener(MouseEvent.MOUSE_DOWN,volumerOUT);
			stage.removeChild(dropMC_v);
			player.volumer.mouseEnabled = true;
			player.volumer.v_pointer.stopDrag();
		}
		
		private function start_fnc(me:MouseEvent):void{
			if(play_flag){
				play_flag = false;
				timer.stop();
				timer.removeEventListener(TimerEvent.TIMER,loop);
				channel.stop();
				position = channel.position;
				player.play_btn.play_mark.visible = true;
				player.play_btn.stop_mark.visible = false;
				com_play_btn.play_mark.visible = true;
				com_play_btn.stop_mark.visible = false;
			}
			else{
				play_flag = true;
				timer.start();
				timer.addEventListener(TimerEvent.TIMER,loop);
				channel = sound.play(position);
				player.play_btn.play_mark.visible = false;
				player.play_btn.stop_mark.visible = true;
				com_play_btn.play_mark.visible = false;
				com_play_btn.stop_mark.visible = true;
			}
		}
		
		private function imageLoader(n:int,act:Object):Function{
			return function(e:Event):void{
				var urlRequest:URLRequest = new URLRequest(e.target.data);
				e.target.removeEventListener(Event.COMPLETE,arguments.callee);
				if(urlRequest.url != "false"){
					imgLoader[n].load(urlRequest);
					imgLoader[n].addEventListener(IOErrorEvent.IO_ERROR,IOErrorHandler_image);
					act.addChild(imgLoader[n]);
				}
			}
		}
		
		private function send_f(me:MouseEvent){
			if(comment_box.text != ""){
				var variables:URLVariables = new URLVariables();
				variables.uid = uid;
				variables.session_id = session_id;
				variables.tid = tid;
				variables.time = s;
				variables.comments = comment_box.text;
				var urlRequest:URLRequest = new URLRequest();
				urlRequest.url = "http://pb.fm.senshu-u.ac.jp/~tmochi/educeboard/insertComments.php";
				urlRequest.method = URLRequestMethod.POST;
				urlRequest.data = variables;
				var urlLoader:URLLoader = new URLLoader();
				urlLoader.load(urlRequest);
				var i = 0;
				var cmMC_h:int = 0;
				var SignMC = new MovieClip();
				while(1){
					if(cm_time[i] >= s){//現在の時間以上のコメントを検索
						cm_time.splice(i,0,s);
						var cmMC = cmMC_maker(uname,comment_box.text,secound_trans(s));
						for(var j = i; j < cmMC_Table.length; j++){//コメントの数だけy座標をずらす
							cmMC_Table[j].y += cmMC.height;
						}
						cmMC.y = cmMC_h;
						SignMC.graphics.beginFill(0xFF9933,1);
						SignMC.graphics.drawRect(0,0,397,cmMC.height);
						SignMC.graphics.endFill();
						SignMC.x = SignMC.y = 0;
						SignMC.addEventListener(Event.ENTER_FRAME,commentAddSign);
						cmMC.addChild(SignMC);
						cmMC_Table.splice(i,0,cmMC);
						cmMC_height.splice(i,0,cmMC.height);
						c_baseMC.addChild(cmMC);
						Tcomment_c = i;
						cm_notMoveNum = cm_NotMoveNumFunc(cmMC_height,Tcomment_c) - 1;
						break;
					}
					else if(cm_time.length <= 0){//今までのコメントが無い場合(これが先にないと、後のelse ifが適応されてしまう)
						cm_time.push(s);
						cmMC = cmMC_maker(uname,comment_box.text,secound_trans(s));
						cmMC.y = 0;
						SignMC.graphics.beginFill(0xFF9933,1);
						SignMC.graphics.drawRect(0,0,397,cmMC.height);
						SignMC.graphics.endFill();
						SignMC.x = SignMC.y = 0;
						SignMC.addEventListener(Event.ENTER_FRAME,commentAddSign);
						cmMC.addChild(SignMC);
						cmMC.addChildAt(now_cmMCmarker(cmMC.height),0);
						cmMC_Table.push(cmMC);
						cmMC_height.push(cmMC.height);
						c_baseMC.addChild(cmMC);
						Tcomment_c = 0;
						base_point = cBase_y;
						break;
					}
					else if(i > cm_time.length - 1){//最後のコメントのときにコメントを送信した場合
						cm_time.push(s);
						cmMC = cmMC_maker(uname,comment_box.text,secound_trans(s));
						//cmMC.y = 70 * i;
						cmMC.y = cmMC_h;
						SignMC.graphics.beginFill(0xFF9933,1);
						SignMC.graphics.drawRect(0,0,397,cmMC.height);
						SignMC.graphics.endFill();
						SignMC.x = SignMC.y = 0;
						SignMC.addEventListener(Event.ENTER_FRAME,commentAddSign);
						cmMC.addChild(SignMC);
						cmMC_Table.push(cmMC);
						cmMC_height.push(cmMC.height);
						c_baseMC.addChild(cmMC);
						break;
					}
					cmMC_h += cmMC_height[i];
					i++;
				}
				comment_box.text = "";
				for(var m = 0; m < cmMC_Table.length; m++){
					var _markerMC = cmMC_Table[m].getChildByName("markerMC");
					if(_markerMC != null){
						cmMC_Table[m].removeChild(_markerMC);
					}
				}
			}
		}
		
		private function commentAddSign(e:Event){
			if(e.target.alpha < 0){
				e.target.removeEventListener(Event.ENTER_FRAME,commentAddSign);
				e.target.parent.removeChild(e.target);
			}
			else{
				e.target.alpha -= 0.1;
			}
		}
		
		private function playerINOUT(e:Event):void{
			if(mouseX <= 550 && mouseY <= 400){
				if(playerFlag == false){
					player.addEventListener(Event.ENTER_FRAME,fadeIn);
				}
			}
			else{
				if(playerFlag == true){
					player.addEventListener(Event.ENTER_FRAME,fadeOut);
					player.volumer.y = 42;
				}
			}
		}
		
		private function fadeIn(e:Event):void{
			if(e.target.alpha >= 1){
				playerFlag = true;
				e.target.alpha = 1;
				e.target.removeEventListener(Event.ENTER_FRAME,fadeIn);
			}
			else{
				e.target.alpha += 0.1;
				e.target.y -= 1;
			}
		}
		
		private function fadeOut(e:Event):void{
			if(e.target.alpha <= 0){
				playerFlag = false;
				player.y = 370;
				e.target.alpha = 0;
				e.target.removeEventListener(Event.ENTER_FRAME,fadeOut);
			}
			else{
				e.target.alpha -= 0.1;
				e.target.y += 1;
			}
		}
		
		private function volumerIN(me:MouseEvent):void{
			if(playerFlag == true){
				player.volumer.addEventListener(Event.ENTER_FRAME,vUP);
			}
		}
		
		private function volumerOUT(me:MouseEvent):void{
			player.volumer.y = 42;
		}
		
		private function vUP(e:Event):void{
			if(e.target.y <= -85){
				e.target.removeEventListener(Event.ENTER_FRAME,vUP);
			}
			else{
				e.target.y -= 10;
			}
		}
		
		//コメントMC作成関数
		private function cmMC_maker(cm_name,comment,sc){
			//コメント全体のMCを生成
			var cmMC = new MovieClip();
			//コメント、コメント者名、時間のテキストフィールドを生成
			var text_name = new TextField();
			var text_comment = new TextField();
			var secound_comment = new TextField();
			//各々のテキストフィールドを生成（テキストサイズを決めるため）
			var name_format:TextFormat = new TextFormat();
			var comment_format:TextFormat = new TextFormat();
			var secound_format:TextFormat = new TextFormat();
			//テキストサイズの設定
			name_format.size = 11;
			name_format.font = "_ゴシック"
			comment_format.size = 16;
			comment_format.font = "_ゴシック"
			comment_format.leading = 3;
			secound_format.size = 11;
			secound_format.font = "_ゴシック"
			//text_commentにコメントとフォーマットをセットし、座標値と横幅を決める
			text_comment.defaultTextFormat = comment_format;
			text_comment.text = comment;
			text_comment.width = 360;
			text_comment.x = 20;
			text_comment.y = 10;
			text_comment.autoSize =TextFieldAutoSize.LEFT;
			text_comment.wordWrap = true;
			
			//cmMCの高さをtext_commentの高さに応じて可変するための変数
			var cmMC_h = text_comment.height + 50;
			cmMC.graphics.beginFill(0xFFFFFF,1);
			cmMC.graphics.lineStyle(1,0xCCCCCC,1);
			cmMC.graphics.drawRect(0,0,397,cmMC_h);
			cmMC.graphics.endFill();
			cmMC.width = 397;
			
			//text_nameにコメントとフォーマットをセットし、座標値を決める
			text_name.defaultTextFormat = name_format;
			text_name.text = cm_name;
			text_name.x = 20;
			text_name.y = cmMC_h - 30;
			text_name.height = 20;
			
			//var text_commentMC = new MovieClip();
			//text_commentMC.addChild(text_comment);
			//var commentMask = new MovieClip();
			/*text_commentMC.x = 20;
			text_commentMC.y = 10;
			commentMask.graphics.beginFill(0xFFFFFF,1);
			commentMask.graphics.drawRect(0,0,340,20);
			commentMask.graphics.endFill();
			commentMask.x = 20;
			commentMask.y = 10;
			text_commentMC.addChild(text_comment);*/
			
			//second_commentにコメントとフォーマットをセットし、座標値を決める
			secound_comment.defaultTextFormat = secound_format;
			secound_comment.text = sc;
			secound_comment.x = 200;
			secound_comment.y = cmMC_h - 30;
			secound_comment.height = 20;
			
			cmMC.addChild(text_name);
			//c_scrollLeftをクリックしたときにアクセスできるようにするため「0」とする
			//cmMC.addChildAt(text_commentMC,0);
			cmMC.addChild(text_comment);
			//cmMC.addChild(commentMask);
			//text_commentMC.mask = commentMask;
			cmMC.addChild(secound_comment);
			
			/*if(text_comment.width >= 360){
				var c_scrollLeft = new MovieClip();
				c_scrollLeft.graphics.beginFill(0xFFFFFF,0);
				c_scrollLeft.graphics.drawRect(0,0,20,20);
				c_scrollLeft.graphics.endFill();
				var triangle = new Shape();
				var vertices:Vector.<Number> = Vector.<Number>([0,0, 0,18, 15,9]);
				triangle.graphics.beginFill(0xCCCCCC);
				triangle.graphics.drawTriangles(vertices);
				triangle.graphics.endFill();
				triangle.x = 2;
				triangle.y = 1;
				c_scrollLeft.x = 365;
				c_scrollLeft.y = 11;
				c_scrollLeft.addChild(triangle);
				cmMC.addChild(c_scrollLeft);
				c_scrollLeft.addEventListener(MouseEvent.CLICK,ScrollBtnPush);
			}*/
			
			return cmMC;
		}
		
		private function now_cmMCmarker(h:int){
			var markerMC = new MovieClip;
			markerMC.graphics.beginFill(0xFFFFCC,1);
			markerMC.graphics.drawRect(0,0,397,h);
			markerMC.graphics.endFill();
			markerMC.name = "markerMC";
			markerMC.addEventListener(Event.ENTER_FRAME,markerMCswicher);
			return markerMC;
		}
		
		private function markerMCswicher(e:Event){
			if(e.target.alpha < 0){
				e.target.alpha = 1;
			}
			else{
				e.target.alpha -= 0.05;
			}
		}
		
		private function cm_NotMoveNumFunc(cmHeightArr:Array,c:int){
			var sum = 0;
			var i = c;
			while(1){
				sum += cmHeightArr[i];
				if(cmHeightArr.length <= 0){
					break;
				}
				else if(cmHeightArr.length <= i - 1){
					break;
				}
				else if(sum > 519){//519はコメント表示領域(マスクの高さと同じ)
					trace("a" + sum);
					break;
				}
				i++;
			}
			return i - c;
		}
		
		private function ScrollBtnPush(me:MouseEvent){
			//一度親にアクセスして、コメントにアクセスする
			var text_comment = me.target.parent.getChildAt(0);
			text_comment.addEventListener(Event.ENTER_FRAME,commentScroll);
		}
		
		private function commentScroll(e:Event){
			if(e.target.width <= (e.target.x * -1)){
				e.target.x = 20;
				e.target.removeEventListener(Event.ENTER_FRAME,commentScroll);
			}
			else{
				e.target.x -= 3;
				trace(e.target.x);
			}
		}
		
		//秒数を「時：分：秒」にする関数
		private function secound_trans(num){
			var ss = Math.round(num);
			if(ss >= 60){
				var mm = Math.floor(ss / 60);
				ss = ss - 60 * mm;
				if(mm >= 60){
					var hh = Math.floor(mm / 60);
					mm = mm - 60 * hh;
				}
				else{
					hh = 0;
				}
			}
			else{
				mm = 0;
				hh = 0;
			}
			if(ss < 10){
				ss = "0" + ss;
			}
			if(mm < 10){
				mm = "0" + mm;
			}
			if(hh < 10){
				hh = "0" + hh;
			}
			var str = hh + ":" + mm + ":" + ss;
			return str;
		}
		
		//配列の重複を削除
		private function arrayUnique(_array){
			var result_array:Array = new Array();
			var oValues:Object = new Object();
			for (var i:Number = 0; i < _array.length; i++) {
				var myValue:Object = _array[i];
				if (!oValues[myValue]) {
					oValues[myValue] = true;
					result_array.push(myValue);
				}
			}
			return result_array;
		}
		
		private function angleHandler(_angle){
			var turn;
			if (_angle >= -30 && _angle <= 30 ) {
				turn = 0;
			}
    		else if (_angle > 30 && _angle < 60 ){
				turn = 1;
			}
			else if (_angle >= 60 && _angle <= 120 ){
				turn = 2;
			}
			else if (_angle > 120 && _angle < 150){
				turn = 3;
			}
			else if (_angle >= 150 && _angle <= 180){
				turn = 4;
			}
			else if (_angle >= -180 && _angle <=-150){
				turn = 4;
			}
			else if (_angle > -150 && _angle < -120){
				turn = 5;
			}
			else if (_angle >= -120 && _angle <= -60){
				turn = 6;
			}
			else if (_angle > -60 && _angle < -30){
				turn = 7;
			}
			return turn;
		}
		
		private function IOErrorHandler(e:IOErrorEvent){
			veil.sessionid_box.background = true;
			veil.sessionid_box.backgroundColor = 0xFFFFFF;
			veil.sessionid_box.border = true;
			veil.sessionid_box.borderColor = 0x000000;
			veil.sessionid_box.restrict = "0-9";
			veil.sessionid_box.text = int(session_id);
			veil.tid_box.background = true;
			veil.tid_box.backgroundColor = 0xFFFFFF;
			veil.tid_box.border = true;
			veil.tid_box.borderColor = 0x000000;
			veil.tid_box.restrict = "0-9";
			veil.tid_box.text = int(tid);
			veil.infoVar.width = 0;
			veil.ok_btn.addEventListener(MouseEvent.CLICK, load_start_Error);
			xml_urlLoader.removeEventListener(ProgressEvent.PROGRESS,infoFunc);
			sound.removeEventListener(ProgressEvent.PROGRESS,infoFunc);
			cmxml_urlLoader.removeEventListener(ProgressEvent.PROGRESS,infoFunc);
			
			veil.loadStatus.text = loadstatus_text + "エラー";
			veil.s_text.visible = true;
			veil.t_text.visible = true;
			veil.sessionid_box.visible = true;
			veil.tid_box.visible = true;
			veil.ok_btn.visible = true;
			veil.logout_btn.visible = true;
			veil.infoVar.visible = false;
			veil.loadPerStatus.visible = false;
			veil.logout_btn.addEventListener(MouseEvent.CLICK,logout);
		}
		
		private function IOErrorHandler_image(e:IOErrorEvent){
			trace("a");
			/*e.target.close();
			e.target.removeEventListener(IOErrorEvent.IO_ERROR,IOErrorHandler_image);*/
		}
		
		private function SecurityErrorHander(e:SecurityErrorEvent){
			trace("b");
		}
		
		private function logout(me:MouseEvent){
			var goBack:URLRequest = new URLRequest("http://pb.fm.senshu-u.ac.jp/~tmochi/educeboard/educeboard1.html");
			navigateToURL(goBack,"_self");
		}
		
		private function infoFunc(e:ProgressEvent):void{
			if(veil.loadPerStatus.visible == false){
				veil.loadPerStatus.visible = true;
			}
			var nowLoaded = e.bytesLoaded;
			var LoadedTotal = e.bytesTotal;
			var LoadPer = nowLoaded / LoadedTotal;
			veil.infoVar.width = 200 * LoadPer;
			veil.loadPerStatus.text = Math.floor(LoadPer * 100) + "%";
		}
	}
}
