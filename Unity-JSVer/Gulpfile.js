/*Gulpfile.js*/

/********************
プラグイン格納
********************/
// gulp本体
var gulp = require('gulp')
// sassコンパイラ
,sass = require('gulp-ruby-sass')
// 変換したものをする前に操作するときに利用するもの
,gulpFilter = require('gulp-filter')
// cssのプロパティ並べ替え
,cssComb = require('gulp-csscomb')
// ベンダープレフィックス付与などができるもの
,pleeease = require('gulp-pleeease')
// ファイル結合
,concat = require('gulp-concat')
// エラーが起きてもそのまま処理を続行するもの
,plumber = require('gulp-plumber')
// ファイル内文字列を置換
,strReplace = require('gulp-replace')
// liveReloadを利用するもの
,browserSync = require('browser-sync')
// reloadメソッド
,reload = browserSync.reload
// ファイル内に文字列追加
,inject = require('gulp-inject-string')
// ユーザに入力を促すもの
,prompt = require('gulp-prompt')
// 画像圧縮
,imageMin = require('gulp-imagemin')
// JS圧縮
,uglify = require('gulp-uglify')
// console.logを消す
,stripDebug = require('gulp-strip-debug')
// 削除するもの
,rimraf = require('rimraf')

/********************
ファイルのパスを格納する変数群
********************/
,sassFilePath = ''
,cssFilePath = ''
,jsFilePath = '';


/********************
sassのコンパイル
********************/
gulp.task('sass',function(){
	console.log('Sassビルド開始！');

	if(!sassFilePath){
		console.log('Pathが取得できなかったッス');
		return;
	}

	// cssFilterオブジェクトセット
	var cssFilter = gulpFilter('**/*.css')
	mapFilter = gulpFilter('**/*.map');

	gulp.src(sassFilePath)
	// エラーが発生してもwatchを動かしたままにするためのもの
	.pipe(plumber())
	// プロパティの順序並び替え
	.pipe(cssComb())
	// sassをコンパイル
	.pipe(sass({
	style:'expanded'
	,compass:true
	}))
	// コンパイルされたcssにオブジェクトを切り替える
	.pipe(cssFilter)
		// @charset 'UTF-8';があれば削除
	.pipe(strReplace(/@charset ["|']utf-8["|'];\n/gi,''))
	.pipe(pleeease({
		autoprefixer: {browsers: ['> 1%', 'Android 2.3', 'ie 10', 'ie 9' ,'ie 8' ,'ie 7']} //全体のシェア1%以上とandroid2.3とie全部
		,minifier:false
		,rem:false
		,import:false
	}))
	// css出力
	.pipe(gulp.dest('./css_mod/'))
	.pipe(cssFilter.restore());
	});

	/********************
	scssが削除されたときに、同時にcssも削除
	********************/
	gulp.task('cssDelete',function(cb){
	rimraf(cssFilePath,cb);
});

/********************
browserSync（serverも立ち上げる場合）
********************/
gulp.task('browserSync', function(){
	browserSync({
		server:{
		baseDir:'../'
		,directory:true
		}
	});
});

/********************
browserSync（mampなどを利用している場合）
********************/
gulp.task('browserSyncProxy', function(){
	browserSync({
		proxy:'localhost'
	});
});

/********************
yimg用css作成（css_compressに格納する。ファイル名指定なし）
********************/
/*gulp.task('concat', function(){
	gulp.src('css_mod/*.css')
	.pipe(concat('yimg.css'))
	// @charset 'utf-8';があれば全てのパターンを削除
	.pipe(strReplace(/@charset ["|']utf-8["|'];\n/gi,''))
	// @charset "utf-8"を先頭に挿入
	.pipe(inject.prepend("@charset 'utf-8';\n"))
	// css_yimgに出力
	.pipe(gulp.dest('./css_compress/'))
	.pipe(reload({stream:true}));
})*/

/********************
JS圧縮（watchしている時）
********************/
gulp.task('jsmin', function(){
	if(!jsFilePath){
		console.log('Pathが取得できなかったッス');
		return;
	}

	// 空文字を足す（理由不明）
	jsFilePath += '';
	// Pathを'js'で切る
	jsFilePath = jsFilePath.split('js/');
	// jsFilterを作成
	var jsFilter = gulpFilter('**/*.js');

	// jsフォルダ直下なのか、さらにフォルダがあるのかを調べる（creフォルダなど）
	var index = jsFilePath[1].indexOf('/')
	// フォルダの名前を格納する変数作成
	,dir = '';

	// 空文字のフォルダはありえないため、indexが1より大きい時
	if(index > 1){
		// フォルダ名格納
		dir = jsFilePath[1].substring(0,index);
	}

	gulp.src(jsFilePath[0] + 'js/' + jsFilePath[1])
	// console.logを削除
	.pipe(stripDebug())
	// minify化
	.pipe(uglify())
	// minify化されたファイルを選択
	// .pipe(jsFilter)
	// console.logを削除
	// .pipe(strReplace(/console\.log\(.+?\)\,?/gi,''))
	// 書き出し
	.pipe(gulp.dest('js_yimg/' + dir + '/'));
});




/********************
yimg用css作成（ファイル名を指定する場合）
********************/
gulp.task('css_yimg', function(){
	// 一つだけ選択したかったのでsrcの引数は一つなら何でも大丈夫です
	gulp.src('css_mod/')
	// ファイル名を入力
	.pipe(prompt.prompt({
		type:'input'
		,name:'fileName'
		,message:'Please enter a filename. ex)front1.1'
	},function(res){
		// 入力された時の処理
		if(res.fileName != ''){
			gulp.src('css_mod/*.css')
			// 入力されたファイル名でcssを結合
			.pipe(concat(res.fileName + '.css'))
			// @charset 'utf-8';があれば全てのパターンを削除
			.pipe(strReplace(/@charset ["|']utf-8["|'];\n/gi,''))
			// @charset "utf-8"を先頭に挿入
			.pipe(inject.prepend("@charset 'utf-8';\n"))
			// css_yimgに出力
			.pipe(gulp.dest('./css_yimg/'));
		}
		else{
			// エラーメッセージを出して強制終了
			console.log('ファイル名入力して！');
			return;
		}

	}));
});

/********************
JS圧縮（フォルダ内一括）
********************/
gulp.task('jsmin_all', function(){
	var jsFilter = gulpFilter('**/*.js');
	gulp.src('js/**')
	// console.logを削除
	.pipe(stripDebug())
	.pipe(uglify())
	.pipe(gulp.dest('./js_yimg/'));
});

/********************
画像圧縮
********************/
gulp.task('imagemin',function(){
	gulp.src('images/**')
	.pipe(imageMin({
		progressivwe:true
		,interlaced:true
		,optimizationLevel:5
	}))
	.pipe(gulp.dest('images_yimg/'));
});







/********************
ファイル監視
********************/
gulp.task('watch',function(){
	// sassのファイルが更新された時
	gulp.watch('scss_mod/*.scss',function(e){

		// Path初期化
		sassFilePath = '';

		// Path取得
		sassFilePath = e.path;

		console.log(e.type);

		// scssが削除されたらcssも削除
		if(e.type == 'deleted'){
			cssFilePath = sassFilePath.replace(/scss/g,'css');
			gulp.start('cssDelete');
		}
		// sassコンパイル
		else if(sassFilePath){
			gulp.start('sass');
		}
		else{
			console.log('sassエラー');
		}
	});

	gulp.watch('js/**/*.js',function(e){

		// Path取得
		jsFilePath = e.path;

		// JSをminify化
		if(jsFilePath){
			gulp.start('jsmin');
		}
		// Pathが無かったら実行しない
		else{
			console.log('jsのPathが取得できなかったッス');
		}

		// 画面リロード
		reload();
	});

		gulp.watch('html_mod/*.html',function(){
			reload();
		});

	gulp.watch('css_mod/*.css',function(e){
		// cssが更新されたらreload（sassからのコンパイルでもcss直でも大丈夫なようにここで実行）
		gulp.src(e.path)
		.pipe(reload({stream:true}));

		// cssを一つにまとめる
		// gulp.start('concat');
	});
});

/********************
watchを初期実行
********************/

gulp.task('default',['watch'],function(){
	console.log('/******** 関数一覧 ********/');
	console.log('gulp css_yimg -> yimg用cssを作成（ファイル名指定機能有り）');
	console.log('gulp jsmin_all -> jsをminify化（jsフォルダ内全て）');
	console.log('gulp imagemin -> 画像minify化');
	console.log('gulp liveReload -> liveReloadを有効にします（html_wrapは見られません）');
	console.log('gulp proxy -> liveReloadを有効にします（mampなどのサーバを使っている場合）');
});

gulp.task('liveReload',['watch','browserSync'],function(){
	console.log('liveReloadモード');
})

gulp.task('proxy',['watch','browserSyncProxy'],function(){
	console.log('proxyモード');
});