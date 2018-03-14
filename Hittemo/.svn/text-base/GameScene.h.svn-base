#import <Foundation/Foundation.h>
#import "AbstractScene.h"
#import "PieceType.h"
#import "Pieces.h"
#import "Label.h"
#import "AppController.h"

@class Piece;

@interface GameScene : AbstractScene <PiecesDelegate> {

  @private    

    // フォント
	AngelCodeFont *font;

	AngelCodeFont *font16;
	
	// パーティクル
	ParticleEmitter *_explosionEmitter;
	
	// pice types
	NSMutableArray* pieceTypes;
	
	// pieces
	Pieces* pieces;
	
    // 加速度
    UIAccelerationValue _accelerometer[3];

	// ディレイ（開始前のポーズなど）
	float delay;
	
	// 繰り返し
	int repeat;

	CFTimeInterval elapsedTime;

	Label* levelNoLabel;
	Label* stageNoLabel;
	Label* messageLabel;
	
	NSUInteger soundID;
	NSUInteger soundIDA;
	NSUInteger soundIDS;
	NSUInteger soundIDR;
	
	AppController* ocmml;
}

- (void)setStage;
// Returns the current accelerometer value for the given axis.  The axis is the location
// within an array in which the value is stored.  0 = x, 1 = y, 2 = z
- (float)accelerometerValueForAxis:(uint)aAxis;
//- (void) setFlickMovement:(UITouch*) touch withPieceView:(Piece*) thePieceView view:(UIView*)aView speed:(float) theSpeed;

@end
