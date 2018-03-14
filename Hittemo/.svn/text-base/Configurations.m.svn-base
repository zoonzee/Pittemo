#import "Configurations.h"

NSString* kDocumentDirName = @"Documents";
NSString* kPrefsFileName = @"test01.bin";

@implementation Configurations

@synthesize levelNo;
@synthesize stageNo;

static id _instance = nil;

ConfigurationTable configurationTable[kLevelMax] = {

// NORMAL
{
0,		// ステージ制限秒（未使用）
1,		// スタート後にターゲットから離れるまで触れない時間
0,		// 初速（0-約10程度）
0.005,	// 衝突回転率（壁に衝突して回転する角度、最大180度を１とした倍率）
YES,	// 常時、ゴールしても消えない（１種類１ピース、はめこみモード）
NO,		// 加速度センサーオンオフフラグ
30,		// 加速度センサーインターバルの逆数
0.8,	// シェイク最小量（感度・摩擦限界値）(0.0 <0.8> 1.0)
10,		// シェイク時の倍増移動量（滑り量）
30,		// 判定インターバルの逆数
0.02,	// 移動減衰倍率（摩擦）
0.02,	// 衝突による速度倍率（壁）
32.0,	// ピースがゴールするターゲットまでの距離
90.0,	// ピースがゴールできる角度の範囲（30の場合は、-30~30度)
0,		// 引力適応距離のしきい値（0：適用なし）
0,		// 引力適応係数（50以下が妥当。約１００だとターゲット付近であばれる。）
0,		// 半径の拡張（ピクセル）
40,		// 最大移動量
0.05,	// フリック速度比（1.0が等倍）
0.0,	// カバーあたった場合のフリック速度比（1.0が等倍）
3.0,	// 重力（下方向）
{0,0,320,480},		// ピース移動範囲
NO,					// クリアカバーフラグ
{0,0,320,480},	// ドラッグエリア
{
{ 2, 2, 2, 2, 2, 0, 0},
{ 4, 4, 4, 4, 4, 0, 0},
{ 4, 4, 4, 4, 4, 0, 0},
{ 4, 4, 4, 4, 4, 0, 0},
{ 5, 5, 5, 5, 5, 0, 0},
},
},
};

- (ConfigurationTable) config {
	return configurationTable[levelNo];
}

- (id) init {

    self = [super init];
    if(!self) {
		return nil;
	}

	levelNo = 0;				// 開始レベル
	stageNo = 0;				// 開始ステージ
//	enableSound = YES;			// サウンドオンオフフラグ

	// score
    NSString* a_doc_dir = [NSHomeDirectory() stringByAppendingPathComponent:kDocumentDirName];
    
	[[NSFileManager defaultManager] changeCurrentDirectoryPath:a_doc_dir];
	BOOL a_isDir;
	
	score = [[Score alloc] init];
	
	// 削除
//	[[NSFileManager defaultManager] removeItemAtPath:kPrefsFileName error:nil];
	
    // ファイルが存在しなければ作成する
    if( [[NSFileManager defaultManager] fileExistsAtPath:kPrefsFileName isDirectory:&a_isDir] == NO ) {		
		[self createScoreFile];
	// 存在していれば読み込み
    } else {
		[self loadScoreFile];
    }
	
	return self;
}

+ (id) instance
{
    @synchronized(self) {
        if (!_instance) {
            [[self alloc] init];
        }
    }
    return _instance;
}

+ (id) allocWithZone:(NSZone*)zone
{
    @synchronized(self) {
        if (!_instance) {
            _instance = [super allocWithZone:zone];
            return _instance;
        }
    }
    return nil;
}

- (id) copyWithZone:(NSZone*)zone
{
    return self;
}

- (id) retain
{
    return self;
}

- (unsigned)retainCount
{
    return UINT_MAX;
}

- (void) release
{
}

- (id) autorelease
{
    return self;
} 

- (int) getTypeIdAt:(int) no {

	srand(time(NULL));

	int compNo = 0;
	for (int type = 0; type < 7; type++) {
		compNo += configurationTable[levelNo].pieceMax[stageNo][type];
		if (no < compNo) {
			return type;
		}
	}
	
	// 範囲外の場合
	return -1;
}

- (BOOL) isFirstLevel {
	return (0 >= levelNo);
}

- (BOOL) isLastLevel {
	return ((kLevelMax - 1) <= levelNo);
}

- (BOOL) isFirstStage {
	return (0 == stageNo);
}

- (BOOL) isLastStage {
	return (kStageMax == (stageNo + 1));
}

- (void) setNextLevel {
	if (![self isLastLevel]) {
		levelNo++;
		stageNo = 0;
	}
}

- (void) setPrevLevel {
	if (![self isFirstLevel]) {
		levelNo--;
		stageNo = 0;
	}
}

- (void) setNextStage {
	if (![self isLastStage]) {
		stageNo++;
	}
}

- (void) setPrevStage {
	if (![self isFirstStage]) {
		stageNo--;
	}
}

- (void)setScore:(float)aScore {
	
	[score setScoreAtIndex:levelNo withInt:aScore];
	
	[self saveScoreFile];
}

- (void)clearScore {
	
	for (int i = 0; i < 3; i++) {
		[score setScoreAtIndex:i withInt:0];
	}
	
	[self saveScoreFile];
}

- (int)getScore:(int)aLevelNo {
	return [score getScoreAtIndex:aLevelNo];
}

- (void)setEnableSound:(BOOL)isEnable {
	score.enableSound = [NSNumber numberWithBool:isEnable];
}

- (BOOL)getEnableSound {
	return ([score.enableSound boolValue]);
}

- (void)createScoreFile {
	
	NSData* a_data;
	
	// 新規データ
	// サウンド音
	score.enableSound = [NSNumber numberWithInt:1];
	
	// スコア、未クリア
	[score setScoreAtIndex:0 withInt:0];
	[score setScoreAtIndex:1 withInt:0];
	[score setScoreAtIndex:2 withInt:0];
	
	// NSDataへ変換
	a_data = [NSKeyedArchiver archivedDataWithRootObject:score];
	
	// 新規作成
	[[NSFileManager defaultManager] createFileAtPath:kPrefsFileName contents:a_data attributes:nil];
}

- (void)loadScoreFile {

    NSString* a_doc_dir = [NSHomeDirectory() stringByAppendingPathComponent:kDocumentDirName];
	NSString* a_file_path = [a_doc_dir stringByAppendingPathComponent:kPrefsFileName];
		
	// ファイルハンドル取得
	NSFileHandle* a_file = [NSFileHandle fileHandleForWritingAtPath:a_file_path];
	
	// あり得ないエラー
	if(nil == a_file) {
		NSLog(@"error");
	}
	
	NSData* data = [[[NSData alloc] initWithContentsOfFile:a_file_path] autorelease];
	
	// カスタムクラスへ変換
	Score* theScore = [NSKeyedUnarchiver unarchiveObjectWithData:data];

	// メンバー編集へ設定
	score.enableSound = theScore.enableSound;
	for (int i = 0; i < 3; i++) {
		[score setScoreAtIndex:i withInt:[theScore getScoreAtIndex:i]];
	}
}

- (void)saveScoreFile {
	
	NSData* a_data;

    @synchronized(self) {
		// NSDataへ変換
		a_data = [NSKeyedArchiver archivedDataWithRootObject:score];	
		
		NSString* a_doc_dir = [NSHomeDirectory() stringByAppendingPathComponent:kDocumentDirName];
		NSString* a_file_path = [a_doc_dir stringByAppendingPathComponent:kPrefsFileName];
		
		// 書き込み
		[a_data writeToFile:a_file_path atomically:YES];
    }
}

@end

