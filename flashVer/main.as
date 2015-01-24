package{
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
import flash.text.TextFormat;
import flash.net.URLLoaderDataFormat;
import flash.ui.Mouse;
import flash.display.Loader;
import flash.events.IOErrorEvent;
import flash.display.Bitmap;

	public class main extends Sprite
	{
		private var a;
		private var xml_urlLoader:URLLoader = new URLLoader();
		private var xml_urlRequest:URLRequest = new URLRequest();
		private var cmxml_urlLoader:URLLoader = new URLLoader();
		private var cmxml_urlRequest:URLRequest = new URLRequest();
		private var memberXML:XML;
		private var commentXML:XML;
		private var sound:Sound;
		private var channel:SoundChannel;
		private var position:Number;
		private var timer:Timer;
		private var timecount:Number=0;
		private var stage_X = 550;
		private var stage_Y = 400;
		private var n:int=0;
		private var t:int=0;
		private var s:Number=0;
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
		private var comment_c = 0;
		private var cBase_y;//全体のコメントMCの最初の場所
		private var base_point = 111;//全体のコメントMCがどこまで動くのかを指定するもの
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
		private var p_min_x = 8;//ポインターの最初の場所
		private var p_min_y = 4.5;
		private var rect;//ポインターの移動範囲
		private var v_rect;
		private var TS_end;//xmlの最後の秒数
		private var TS_num;//タイムスタンプがいくつあるか。
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
		
		
		
		public function main(){
			//JavaScriptから値を取得
			uid = this.loaderInfo.parameters['uid'];
			uname = this.loaderInfo.parameters['uname'];
			
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
			veil.sessionid_box.background = true;
			veil.sessionid_box.backgroundColor = 0xFFFFFF;
			veil.sessionid_box.border = true;
			veil.sessionid_box.borderColor = 0x000000;
			veil.sessionid_box.restrict = "0-9";
			veil.tid_box.background = true;
			veil.tid_box.backgroundColor = 0xFFFFFF;
			veil.tid_box.border = true;
			veil.tid_box.borderColor = 0x000000;
			veil.tid_box.restrict = "0-9";
			veil.ok_btn.addEventListener(MouseEvent.CLICK, load_start);
		}
		
		//readMarkerLocatorロード開始
		public function load_start(me:MouseEvent){
			//最初のテキストボックスに入れたIDを変数に格納
			session_id = int(veil.sessionid_box.text);
			tid = int(veil.tid_box.text);
			
			//読み込むXMLを吐き出すURLを変数に格納
			var xmlURL:String = "http://pb.fm.senshu-u.ac.jp/~tmochi/educeboard/readMarkersLocator.php?session_id=" + session_id + "&tid=" + tid;
			
			//URLRequestにURLを格納
			xml_urlRequest.url = xmlURL;
			//読み込みが完了したらcomment_Loadを実行するように設定
			xml_urlLoader.addEventListener(Event.COMPLETE, comment_Load);
			//IOエラーを取り除く
			xml_urlLoader.addEventListener(IOErrorEvent.IO_ERROR,IOErrorHandler);
			//ロード開始
			xml_urlLoader.load(xml_urlRequest);
		}
		
		//commentロード開始
		private function comment_Load(event:Event){
			//readMarkerLocatorがロードし終わったのでEventListenerを取り除く。
			xml_urlLoader.removeEventListener(Event.COMPLETE, load_start);
			
			//以下処理はload_startと同じ
			//var cm_xmlURL:String = "http://pb.code.ouj.ac.jp/educeboard/showComments.php?session_id=" + session_id + "&tid=" + tid;
			var cm_xmlURL:String = "http://pb.fm.senshu-u.ac.jp/~tmochi/educeboard/showComments.php?session_id=" + session_id + "&tid=" + tid;
			cmxml_urlRequest.url = cm_xmlURL;
			cmxml_urlLoader.addEventListener(Event.COMPLETE, sound_Load);
			cmxml_urlLoader.load(cmxml_urlRequest);
			cmxml_urlLoader.addEventListener(IOErrorEvent.IO_ERROR,IOErrorHandler);
		}
		
		//soundロード開始
		private function sound_Load(event:Event){
			//commentがロードし終わったのでEventListenerを取り除く。
			xml_urlLoader.removeEventListener(Event.COMPLETE,sound_Load);
			
			//サウンドのURLを格納
			var mp3_urlRequest:URLRequest = new URLRequest("http://pb.fm.senshu-u.ac.jp/~tmochi/educeboard/voice/" + session_id + "_" + tid + ".mp3");
			//var mp3_urlRequest:URLRequest = new URLRequest("mirage.mp3");
			
			//サウンドを操作するためのオブジェクトを変数に格納。
			sound = new Sound();
			
			//サウンドの読み込みが完了したらcompleteHandlerを実行するように設定。
			sound.addEventListener(Event.COMPLETE,completeHandler);
			
			//ロード開始
			sound.load(mp3_urlRequest,new SoundLoaderContext(1000,true));
		}
		
		private function completeHandler(event:Event){
			//すべてのロードが完了したので、黒い半透明レイヤーを消す
			removeChild(veil);
			//サウンドのロードが完了したのでEventListenerを取り除く。
			sound.removeEventListener(Event.COMPLETE,completeHandler);
			
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
			midUniqueTable = arrayUnique(midTable);//関数は自ら定義してある。
			mid_c = midUniqueTable.length;//midの数
			midUniqueTable.sort(16);//midを1から順番にする。
			trace(midUniqueTable,mid_c);
			
			//まず最初のLEDの色が何であるのかを、各midごとに線形探索で探し、テーブルに格納する
			for(var l = 0; l < midUniqueTable.length; l++){
				var m = 0;
				while(1){
					if(midTable[m] == midUniqueTable[l]){
						color_actTable.push(colorTable[m]);//アクターごとのLEDの色データを格納
						first_color.push(colorTable[m]);//最初は何色だったのかを別で取っておく。
						now_color.push(colorTable[m]);
						angle_actTable.push(angleTable[m]);
						first_angle.push(angleTable[m]);
						now_angle.push(angleTable[m]);
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
			for(var i = 0; i < cm_time.length; i++){
				var cmMC = cmMC_maker(cm_name[i],comment[i],secound_trans(cm_time[i]));//コメントMC作成Function
				cmMC.y = cmMC_y;//最初のy座標は0、次が70、次が140… というようにコメントのy座標がずれていく
				cmMC_y += 70;//70である理由は、コメントMCのheightを70にしているから
				cmMC_Table[i] = cmMC;//コメントのMCをテーブルにも格納していく。
				c_baseMC.addChild(cmMC);//作ったコメントMCをc_baseMCに入れ子
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
			for(var j = 1; j <= midUniqueTable[midUniqueTable.length - 1]; j++){//midの数字はとびとびになるため、jはmidUniqueTableの最後のセルに入った数字まで回す
				for(var k = 0; k < midUniqueTable.length; k++){
					if(j == midUniqueTable[k]){
						actTable[midUniqueTable[k]] = new MovieClip();//ムービークリップを生成
						contents.addChild(actTable[midUniqueTable[k]]);//contentsは.flaにおいてあるMCである。ASで生成したものではない。
					}
				}
			}
			
			//それぞれのアクターに画像を入れるとともに、アクターの最初のx座標とy座標を決める
			for(var n = 0; n < midUniqueTable.length; n++){//各アクターごとに線形探索を行う
				var o = 0;
				var _act = actTable[midUniqueTable[n]];//アクターを一時保存
				while(1){
					if(midUniqueTable[n] == midTable[o]){
						//firstは最初の場所を保存しておくもの。nowは現在のアクターの場所。aftはアクターを動かす目標値。
						first_x[midUniqueTable[n]] = now_x[midUniqueTable[n]] = aft_x[midUniqueTable[n]] = actTable[midUniqueTable[n]].x = stage_X * XTable[o] / 100;
						first_y[midUniqueTable[n]] = now_y[midUniqueTable[n]] = aft_y[midUniqueTable[n]] = actTable[midUniqueTable[n]].y = stage_Y * YTable[o] / 100;
						//nowからaftまでの距離を求め、それを百分率にしたものを格納するためのもの。今はnowとaftが同じ数であるため0でよい。
						per_x[midUniqueTable[n]] = 0;
						per_y[midUniqueTable[n]] = 0;
						//アクターに入れ子する画像のURLを変数に格納
						var imgXMLURL:String = "http://pb.fm.senshu-u.ac.jp/~tmochi/educeboard/showActorImage.php?mid=" + midTable[o] + "&color=" + colorTable[o] + "&angle=" + angleTable[o];
						trace(imgXMLURL);
						var imgURLRequest:URLRequest = new URLRequest();
						imgURLRequest.url = imgXMLURL;
						imgURLLoader[n] = new URLLoader();
						imgURLLoader[n].load(imgURLRequest);//画像のURLをロードする
						imgURLLoader[n].addEventListener(Event.COMPLETE,ImageURL_addTable(n));//URLをロードしたらImageURL_addTable()を実行するように設定
						imgURLLoader[n].addEventListener(IOErrorEvent.IO_ERROR,IOErrorHandler);//IOエラーを取り除く
						break;
					}

					o++;
				}
			}
			
			//URLがロードされるのを待つために、ENTER_FRAMEをする。
			addEventListener(Event.ENTER_FRAME,function(e:Event){
				//imgURL(これはURLがロードされ次第格納されていく。格納するのはImageURL_addTable)とmidUniqueTableのテーブル数が同じになったらイメージを読みに行く
				if(imgURL.length == midUniqueTable.length){
					for(var i = 0; i < imgURL.length; i++){
						var urlRequest:URLRequest = new URLRequest();
						urlRequest.url = imgURL[i];
						imgLoader[i] = new Loader();
						imgLoader[i].contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,IOErrorHandler);
						imgLoader[i].load(urlRequest);
						actTable[midUniqueTable[i]].addChild(imgLoader[i]);
					}
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
				imgURL[n] = url;//nはImageURL_addTable(n)のnである。
				e.target.removeEventListener(Event.COMPLETE,arguments.callee);//imgURLLoader[n]のEventListenerを取り除く。
				trace(url,n);
			}
		}
		
		private function playPrepare(){
			//アクターが枠からでないようにマスクをかけるため、そのマスクを生成する。
			contentsMask.graphics.beginFill(0xFFFFFF,1);
			contentsMask.graphics.drawRect(0,0,550,400);
			contentsMask.graphics.endFill();
			//マスクをかける。(contentsはアクターを入れ子したものである)
			contents.mask = contentsMask;
			
			
			TS_num = TimeTable.length - 1;
			TS_end = TimeTable[TS_num];//最後の秒数の格納
			
			//サウンドの終わる時間を格納
			//TS_end = sound.length / 1000;
			
			//再生された場合、play_markは見えなくてよいので、見えなくする。(playerは.flaにおいてある)
			player.play_btn.play_mark.visible = false;
			
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
			
			
			player.pointer.addEventListener(MouseEvent.MOUSE_DOWN, SBdrag);//シークバーをドラッグしたときの処理を設定
			dropMC.addEventListener(MouseEvent.MOUSE_UP, SBdrop);//シークバーをドロップしたときの処理を設定
			player.volumer.v_pointer.addEventListener(MouseEvent.MOUSE_DOWN,vSBdrag);//ボリュームバーをドラッグしたときの処理を設定
			dropMC_v.addEventListener(MouseEvent.MOUSE_UP,vSBdrop);//ボリュームバーをドロップしたときの処理を設定
			player.play_btn.addEventListener(MouseEvent.CLICK,start_fnc);//再生／一時停止ボタンを押したときの処理を設定
			timer.addEventListener(TimerEvent.TIMER,loop);//0.1秒ごとに実行される処理を設定
			send_btn.addEventListener(MouseEvent.CLICK,send_f);//コメントを投稿したときの処理を設定
			stage.addEventListener(Event.ENTER_FRAME,playerINOUT);//プレイヤーを表示させたり非表示にさせたりするときの処理を設定
			player.volume_btn.addEventListener(MouseEvent.ROLL_OVER,volumerIN);//ボリュームのアイコンをマウスオーバーしたときの処理を設定
			player.volumer.addEventListener(MouseEvent.ROLL_OUT,volumerOUT);//ボリュームを変更するMCからマウスアウトしたときの処理を設定
			stage.addEventListener(MouseEvent.MOUSE_DOWN,volumerOUT);//Flash自体をクリックしたときにボリュームMCを消すための処理を設定
			//player.volume_btn.addEventListener(MouseEvent.ROLL_OUT,volumerOUT);
		}
		
		//0.1秒ごとに処理を実行する関数
		private function loop(e:TimerEvent){
			//trace(drop_flag,now_x[3],aft_x[3],per_x[3]);
			trace(actTable[5].x,now_x[5],aft_x[5],per_x[5]);
			s = channel.position / 1000;//秒数を格納
			var SB_per = s / TS_end;//シークバーの場所を百分率にして格納
			player.show_time.text = secound_trans(s);//秒数を時:分:秒の形にして表示させる
			player.pointer.x = SB_per * SB_max + p_min_x;//百分率をもとにシークバーを動かす
			player.sb.width = player.pointer.x;//シークバーの赤い部分を引き延ばす
			
			//TimeStampが0秒から始まっているとは限らないため、sがTimeStampの最初の秒数を超えるまでアクターを動かす処理は行わないようにする。
			if(s >= TimeTable[0]){
				//アクトを動かす関数
				act_move();
				//LEDのカラーが変わったときに画像をロードして、アクターに入れる
				for(var j = 0; j < midUniqueTable.length; j++){
					var _act = actTable[midUniqueTable[j]];//アクターを一時保存
					//trace(midTable[t],midUniqueTable[j],colorTable[t],color_actTable[j],angleTable[t],angle_actTable[j]);
					if(now_color[j] != color_actTable[j] || angleHandler(now_angle[j]) != angleHandler(angle_actTable[j])){//現在のmidとforのmidが同じであり、さらにカラーが現在のものと、今までのいものが違う色であるときだけ以下を実行
						//URLを格納
						var showIMG_URL:String = "http://pb.fm.senshu-u.ac.jp/~tmochi/educeboard/showActorImage.php?mid=" + midUniqueTable[j] + "&color=" + now_color[j] + "&angle=" + now_angle[j];
						//trace(midTable[t],colorTable[t]);
						var imgURLRequest:URLRequest = new URLRequest();
						imgURLRequest.url = showIMG_URL;
						//Loaderは前に画像をロードするときに格納しているので、またオブジェクトを生成する必要はない
						imgURLLoader[j].load(imgURLRequest);
						imgURLLoader[j].addEventListener(Event.COMPLETE,imageLoader(j,_act));//ロードし終えたらimageLoaderを実行するように設定
						color_actTable[j] = now_color[j];//カラーを更新する
						angle_actTable[j] = now_angle[j];
					}
					/*else{
						trace("miss");
					}*/
					//trace(_act.numChildren);
					
					//アクターの画像を常に1つにするように保つための処理
					while(1){
						if(_act.numChildren <= 1){
							break;
						}
						else{
							_act.removeChildAt(0);
						}
					}
				}
				//trace(midTable[t],colorTable[t]);
				//trace(color_actTable);
				//trace(a);
				//trace(midTable[t],colorTable[t]);
				if(TS_end <= s){
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
					for(var i = 0; i < midUniqueTable.length; i++){
						/*actTable[midUniqueTable[i]].x = 0;
						actTable[midUniqueTable[i]].y = 0;
						now_x[midUniqueTable[i]] = aft_x[midUniqueTable[i]] = per_x[midUniqueTable[i]] = 0;
						now_y[midUniqueTable[i]] = aft_y[midUniqueTable[i]] = per_y[midUniqueTable[i]] = 0;*/
						while(actTable[midUniqueTable[i]].numChildren > 0){   
 							actTable[midUniqueTable[i]].removeChildAt(0);   
						}
						var o = 0;
						while(1){
							if(midUniqueTable[i] == midTable[o]){
								now_x[midUniqueTable[i]] = aft_x[midUniqueTable[i]] = actTable[midUniqueTable[i]].x = stage_X * XTable[o] / 100;
								now_y[midUniqueTable[i]] = aft_y[midUniqueTable[i]] = actTable[midUniqueTable[i]].y = stage_Y * YTable[o] / 100;
								per_x[midUniqueTable[i]] = 0;
								per_y[midUniqueTable[i]] = 0;
								color_actTable[i] = colorTable[o];
								angle_actTable[i] = angleTable[o];
								break;
							}
							o++;
						}
						var showIMG_URL2:String = "http://pb.fm.senshu-u.ac.jp/~tmochi/educeboard/showActorImage.php?mid=" + midUniqueTable[i] + "&color=" + color_actTable[i] + "&angle=" + angle_actTable[i];
						var imgURLRequest2:URLRequest = new URLRequest();
						imgURLRequest2.url = showIMG_URL2;
						imgURLLoader[i].load(imgURLRequest2);
						imgURLLoader[i].addEventListener(Event.COMPLETE,imageLoader(i,actTable[midUniqueTable[i]]));
						trace(color_actTable);
					}
					base_point = cBase_y;
					c_baseMC.y = base_point;
					comment_c = 0;
				}
				/*while(s >= TimeTable[t]){//Flashの時間とずれるためTimeTableを飛ばす。
					aft_x[midTable[t]] = XTable[t];//飛ばしたら飛ばされたままになってしまうので、アクターの目標場所を更新。
					aft_y[midTable[t]] = YTable[t];
					for(var l = 0; l < midUniqueTable.length; l++){
						if(midTable[t] == midUniqueTable[l]){
							color_actTable[l] = colorTable[t];
							angle_actTable[l] = angleTable[t];
						}
					}
					t++;
				}*/
				while(1){
					if(s <= TimeTable[t] && midTable[t] == midUniqueTable[0]){
						for(var k = t; k < t + mid_c; k++){
							aft_x[midTable[k]] = stage_X * XTable[k] / 100;
							aft_y[midTable[k]] = stage_Y * YTable[k] / 100;
							for(var l = 0; l < midUniqueTable.length; l++){
								if(midTable[k] == midUniqueTable[l]){
									now_color[l] = colorTable[k];
									now_angle[l] = angleTable[k];
								}
								//trace(midTable[k],midUniqueTable[l]);
							}
						}
						//trace("***");
						break;
					}
					t++;
				}
			}
			/*else{
				for(var k = 0; k < midUniqueTable.length; k++){
					actTable[midUniqueTable[k]].x = 0;
					actTable[midUniqueTable[k]].y = 0;
				}
			}*/
			if(c_end == true){//先にコメントが最後かどうかを判断する
				if(c_baseMC.y > base_point){
					c_baseMC.y -= 10;
				}
				else{
					c_end = false;
				}
			}
			else if(cm_time[comment_c] <= s){//コメントの秒数が実際の秒数を超えたら
				if(comment_c < cm_time.length ){//また現在のコメントの添字がテーブル数を超えていなかったら（超えていたらc_endがtrueになっている）
					if(c_baseMC.y > base_point){//base_pointのy座標まで10ずつ動かす（最初に動かないのはc_baseMC.yもbase_pointも111になっているから）
						c_baseMC.y -= 10;
					}
					else{//c_baseMCをbase_pointまで動かしたら
						comment_c += 1;//コメントの添字を動かし
						base_point = -70 * comment_c + cBase_y;//base_pointを次の場所に指定する
					}
				}
			}
			//trace(drop_flag);
			//trace(c_baseMC.y,base_point,comment_c);
			//trace(s,cm_time[comment_c]);
		}
		
		/*private function init():void{
			n++;
			s = n/10;
			//trace(s);
		}*/
		
		private function act_move():void{
			//アクターの移動予定場所が変更されたら更新
			/*for(var j = 0; j < midUniqueTable.length; j++){
				if(midTable[t] == midUniqueTable[j]){
					var tt = t;
					while(1){
						if(midTable[t] == midTable[tt]){
							aft_x[midTable[tt]] = XTable[tt];
							aft_y[midTable[tt]] = YTable[tt];
							tt = 0;
							break;
						}
						tt++;
					}
					per_x[midUniqueTable[j]] = (aft_x[midUniqueTable[j]] - now_x[midUniqueTable[j]]) / 100;
					per_y[midUniqueTable[j]] = (aft_y[midUniqueTable[j]] - now_y[midUniqueTable[j]]) / 100;
				}
			}*/
			//アクターの移動予定場所まですべてのアクターを動かす
			for(var k = 0; k < midUniqueTable.length; k++){
				if(drop_flag){
					now_x[midUniqueTable[k]] = aft_x[midUniqueTable[k]];
					now_y[midUniqueTable[k]] = aft_y[midUniqueTable[k]];
					per_x[midUniqueTable[k]] = 0;
					per_y[midUniqueTable[k]] = 0;
					if(k == midUniqueTable.length - 1){
						drop_flag = false;
					}
				}
				else{
					var w_x:Number = now_x[midUniqueTable[k]];//そのままnow_xを使うと文字として判断されるため、
					var w_y:Number = now_y[midUniqueTable[k]];//一度Number属性の変数に格納
					now_x[midUniqueTable[k]] = (w_x + per_x[midUniqueTable[k]]);
					now_y[midUniqueTable[k]] = (w_y + per_y[midUniqueTable[k]]);
					per_x[midUniqueTable[k]] = (aft_x[midUniqueTable[k]] - now_x[midUniqueTable[k]]) / 2;
					per_y[midUniqueTable[k]] = (aft_y[midUniqueTable[k]] - now_y[midUniqueTable[k]]) / 2;
				}
				actTable[midUniqueTable[k]].x = now_x[midUniqueTable[k]];
				actTable[midUniqueTable[k]].y = now_y[midUniqueTable[k]];
				/*actTable[k].x = now_x[k];
				actTable[k].y = now_y[k];*/
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
			var SB_per2 = (player.pointer.x - p_min_x) / SB_max;
			s = TS_end * SB_per2;
			t = 0;
			while(s >= TimeTable[t]){
				t++;
			}
			for(var i = 0; i <= midUniqueTable.length; i++){//tの段階ですべてのアクターがどこにいたのかを調べる
				var w_t = t;
				while(1){
					if(midUniqueTable[i] == midTable[w_t]){
						aft_x[midUniqueTable[i]] = stage_X * XTable[w_t] / 100;
						aft_y[midUniqueTable[i]] = stage_Y * YTable[w_t] / 100;
						color_actTable[i] = colorTable[w_t];
						angle_actTable[i] = angleTable[w_t];
						break;
					}
					if(w_t < 0){//添字が0以下になってしまった場合
						aft_x[midUniqueTable[i]] = first_x[midUniqueTable[i]];
						aft_y[midUniqueTable[i]] = first_y[midUniqueTable[i]];
						color_actTable[i] = first_color[i];
						angle_actTable[i] = first_angle[i];
						break;
					}
					w_t--;
				}
			}
			for(var j = 0; j < midUniqueTable.length; j++){
				var _act = actTable[midUniqueTable[j]];
				var showIMG_URL:String = "http://pb.fm.senshu-u.ac.jp/~tmochi/educeboard/showActorImage.php?mid=" + midUniqueTable[j] + "&color=" + color_actTable[j] + "&angle=" + angle_actTable[j];
				var imgURLRequest:URLRequest = new URLRequest();
				imgURLRequest.url = showIMG_URL;
				imgURLLoader[j].load(imgURLRequest);
				var act_imageURL;
				imgURLLoader[j].addEventListener(Event.COMPLETE,imageLoader(j,_act));
			}
			var cmnt_c = 0;
			while(1){
				if(s <= cm_time[cmnt_c]){
					break;
				}
				if(cmnt_c >= cm_time.length - 1){
					cmnt_c += 1;
					break;
				}
				cmnt_c += 1;
			}
			comment_c = cmnt_c - 1;
			if(comment_c < 0){
				comment_c = 0;
			}
			base_point = -70 * comment_c + cBase_y;
			c_baseMC.y = base_point;
			play_flag = true;
			drop_flag = true;
			player.pointer.stopDrag();
			channel = sound.play(s * 1000);
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
			}
			else{
				play_flag = true;
				timer.start();
				timer.addEventListener(TimerEvent.TIMER,loop);
				/*var w_s:Number = Math.round(position);
				w_s = w_s / 100;
				Math.round(w_s);
				s = w_s / 10;
				channel = sound.play(s * 1000);*/
				channel = sound.play(position);
				player.play_btn.play_mark.visible = false;
				player.play_btn.stop_mark.visible = true;
			}
		}
		
		private function imageLoader(n:int,act:Object):Function{
			return function(e:Event):void{
				var urlRequest:URLRequest = new URLRequest(e.target.data);
				imgLoader[n].load(urlRequest);
				imgLoader[n].addEventListener(IOErrorEvent.IO_ERROR,IOErrorHandler);
				act.addChild(imgLoader[n]);
			}
		}
		
		/*private function imageLoader(e:Event){
			e.target.removeEventListener(Event.COMPLETE,imageLoader);
			var imageXML:XML = new XML(e.target.data);
			for each(var element in imageXML.ActorImage){
				var imageURL:String = element.url;
			}
			a = imageURL;
			var urlRequest:URLRequest = new URLRequest();
			urlRequest.url = imageURL;
			var loader = new Loader();
			loader.load(urlRequest);
			loader.addEventListener(IOErrorEvent.IO_ERROR,IOErrorHandler);
			if(actTable[midTable[t]].numChildren > 1){
				actTable[midTable[t]].removeChildAt(0);
			}
			actTable[midTable[t]].addChild(loader);
		}
		
		private function imageXMLLoader(){
			//for(var i = 0; i < midUniqueTable.length; i++){
				//if(midTable[t] == midUniqueTable[i]){
					var xmlURL:String = "http://pb.fm.senshu-u.ac.jp/~tmochi/educeboard/showActorImage.php?mid=" + midTable[t] + "&color=" + colorTable[t];
					var urlRequest:URLRequest = new URLRequest();
					urlRequest.url = xmlURL;
					var urlLoader:URLLoader = new URLLoader();
					urlLoader.addEventListener(Event.COMPLETE,imageLoader);
					urlLoader.addEventListener(IOErrorEvent.IO_ERROR,IOErrorHandler);
					urlLoader.load(urlRequest);
				//}
			//}
			return midTable[t] + "," + colorTable[t];
		}*/
		
		private function send_f(me:MouseEvent){
			var variables:URLVariables = new URLVariables();
			variables.uid = uid;//仮に1とする
			variables.session_id = session_id;
			variables.tid = tid;
			variables.time = s;
			variables.comments = comment_box.text;
			var urlRequest:URLRequest = new URLRequest();
			urlRequest.url = "http://pb.fm.senshu-u.ac.jp/~tmochi/educeboard/insertComments.php";
			urlRequest.method = URLRequestMethod.POST;
			urlRequest.data = variables;
			var urlLoader:URLLoader = new URLLoader();
			//urlLoader.dataFormat = URLLoaderDataFormat.TEXT;
			urlLoader.load(urlRequest);
			urlLoader.addEventListener(IOErrorEvent.IO_ERROR,IOErrorHandler);
			sendToURL(urlRequest);
			var i = 0;
			while(1){
				if(cm_time[i] >= s){//現在の時間以上のコメントを検索
					for(var j = i; j < cmMC_Table.length; j++){//コメントの数だけy座標をずらす
						cmMC_Table[j].y += 70;
					}
					cm_time.splice(i,0,s);
					var cmMC = cmMC_maker(uname,comment_box.text,secound_trans(s));
					cmMC.y = 70 * i;
					cmMC_Table.splice(i,0,cmMC);
					c_baseMC.addChild(cmMC);
					comment_c = i;
					base_point = -70 * comment_c + cBase_y;
					c_baseMC.y = base_point;
					break;
				}
				else if(cm_time.length <= 0){//今までのコメントが無い場合(これが先にないと、後のelse ifが適応されてしまう)
					cm_time.push(s);
					cmMC = cmMC_maker(uname,comment_box.text,secound_trans(s));
					cmMC.y = 0;
					cmMC_Table.push(cmMC);
					c_baseMC.addChild(cmMC);
					comment_c = 0;
					base_point = cBase_y;
					break;
				}
				else if(i > cm_time.length - 1){//最後のコメントのときにコメントを送信した場合
					cm_time.push(s);
					cmMC = cmMC_maker(uname,comment_box.text,secound_trans(s));
					cmMC.y = 70 * i;
					cmMC_Table.push(cmMC);
					c_baseMC.addChild(cmMC);
					//comment_c += 1;
					c_end = true;//コメントが最後であることを示すフラグを立てる。
					base_point = -70 * comment_c + cBase_y;
					break;
				}
				i++;
			}
			comment_box.text = "";
		}
		
		function playerINOUT(e:Event):void{
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
		
		function fadeIn(e:Event):void{
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
		
		function fadeOut(e:Event):void{
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
		
		function volumerIN(me:MouseEvent):void{
			if(playerFlag == true){
				player.volumer.addEventListener(Event.ENTER_FRAME,vUP);
			}
		}
		
		function volumerOUT(me:MouseEvent):void{
			player.volumer.y = 42;
		}
		
		function vUP(e:Event):void{
			if(e.target.y <= -85){
				e.target.removeEventListener(Event.ENTER_FRAME,vUP);
			}
			else{
				e.target.y -= 10;
			}
		}
		
		//コメントMC作成関数
		private function cmMC_maker(cm_name,comment,sc){
			var cmMC = new MovieClip();
			cmMC.graphics.beginFill(0xFFFFFF,1);
			cmMC.graphics.lineStyle(1,0xCCCCCC,1);
			cmMC.graphics.drawRect(0,0,397,70);
			cmMC.graphics.endFill();
			cmMC.width = 397;
			cmMC.height = 70;
			var text_name = new TextField();
			var text_comment = new TextField();
			var secound_comment = new TextField();
			var name_format:TextFormat = new TextFormat();
			var comment_format:TextFormat = new TextFormat();
			var secound_format:TextFormat = new TextFormat();
			name_format.size = 11;
			comment_format.size = 18;
			secound_format.size = 11;
			text_name.defaultTextFormat = name_format;
			text_name.text = cm_name;
			text_name.x = 20;
			text_name.y = 40;
			text_comment.defaultTextFormat = comment_format;
			text_comment.text = comment;
			text_comment.width = 370;
			text_comment.x = 20;
			text_comment.y = 10;
			secound_comment.defaultTextFormat = secound_format;
			secound_comment.text = sc;
			secound_comment.x = 200;
			secound_comment.y = 40;
			cmMC.addChild(text_name);
			cmMC.addChild(text_comment);
			cmMC.addChild(secound_comment);
			return cmMC;
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
			
		}
	}
}
