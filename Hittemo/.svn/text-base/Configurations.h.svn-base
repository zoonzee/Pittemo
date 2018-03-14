#import <Foundation/Foundation.h>
#import "Score.h"

#define kLevelMax 1		// 全レベル数（0~9の場合は10)
#define kStageMax 5		// 各ステージ数（0~9の場合は10)
#define kTypeMax 7		// ピースタイプ数
#define kSoundSpeedRate 0.5	// 音量/速度比率
#define kSoundZSpeedRate 0.5	// 音量/落下速度比率
#define kToGoalRotate 5.0		// ゴール判定後の回転率
#define kTogoalSpeed 4.0		// ゴール判定後の速度

typedef struct {
	int timeLimit;				// ステージ制限秒
	int timeToAwayFromTarget;	// スタート後にターゲットから離れるまで触れない時間
	int initialSpeed;			// 初速（0-約10程度）
	float rotationRate;			// 衝突回転率（壁に衝突して回転する角度、最大180度を１とした倍率）（スピードで倍増するのでそれも考慮する）
	BOOL isNeverDisappear;		// 常時、ゴールしても消えない（１種類１ピース、はめこみモード）
	BOOL enableAccelermeter;	// 加速度センサーオンオフフラグ
	int accelIntervalInverse;	// 加速度センサーインターバルの逆数
	float threshold;			// シェイク最小量（感度・摩擦限界値）(0.0 <0.8> 1.0)
	float shakeAccelRate;		// シェイク時の倍増移動量（滑り量）
	int timeIntervalInverse;	// 判定インターバルの逆数
	float brakeRate;			// 移動減衰倍率（摩擦）
	float hitBrakeRate;			// 衝突による速度倍率
	float distanceToGoal;		// ピースがゴールするターゲットまでの距離
	float rotationToGoal;		// ピースがゴールできる角度の範囲（30の場合は、-30~30度)
	float distanceToAttraction;	// 引力適応距離のしきい値
	float attractionCoeff;		// 引力適応係数（50以下が妥当。約１００だとターゲット付近であばれる。）
	float radiusExtention;		// 半径の拡張（ピクセル）
	float maxSpeed;				// 最大移動量
	float flickSpeed;			// フリック速度比（1.0が等倍）
	float flickReleaseSpeed;	// カバーあたった場合のフリック速度比（1.0が等倍）
	float gravity;				// 重力（下方向）
	CGRect bounds;				// ピース移動範囲
	BOOL isClearCover;			// クリアカバーフラグ todo delete
	CGRect dragArea;			// ドラッグエリア
	int pieceMax[kStageMax][kTypeMax];	// [STAGE(0-4)][TYPE(0-6)]
} ConfigurationTable;

@interface Configurations : NSObject {

	int levelNo;				// 現在レベル番号　(0~)
	int stageNo;				// 現在ステージ番号　(0~)

	ConfigurationTable config;

	Score* score;
}

@property (nonatomic, readwrite) int levelNo;
@property (nonatomic, readwrite) int stageNo;
@property (nonatomic, readonly) ConfigurationTable config;

+ (id) instance;
+ (id) allocWithZone:(NSZone*)zone;
- (int) getTypeIdAt:(int) no;
- (BOOL) isFirstLevel;
- (BOOL) isLastLevel;
- (BOOL) isFirstStage;
- (BOOL) isLastStage;
- (void) setNextLevel;
- (void) setPrevLevel;
- (void) setNextStage;
- (void) setPrevStage;
- (void)setScore:(float)aScore;
- (void)clearScore;
- (int)getScore:(int)aLevelNo;
- (void)setEnableSound:(BOOL)isEnable;
- (BOOL)getEnableSound;
	
- (void)createScoreFile;
- (void)loadScoreFile;
- (void)saveScoreFile;
	
@end
