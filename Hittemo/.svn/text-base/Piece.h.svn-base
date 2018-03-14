#import <UIKit/UIKit.h>
#import "AbstractEntity.h"
#import "Configurations.h"
#import "PieceType.h"
#import "SoundManager.h"

@class GameScene;

typedef enum {
	PieceStatusIdol,
	PieceStatusActivate,
	PieceStatusActivated,
	PieceStatusToGoal,
	PieceStatusGoal,
} PieceStatus;

typedef enum {
	PieceAnimationStatusNormal = 0,
	PieceAnimationStatusArrivedInTarget,
	PieceAnimationStatusAlignedToStageScore,
    PieceAnimationStatusMovedToCropperButton,
} PieceAnimationStatus;

@protocol PieceDelegate;

@interface Piece : AbstractEntity {
	
	id <PieceDelegate> delegate;
	
    Director *_sharedDirector;    
	SoundManager    *_sharedSoundManager;
	Configurations* _configurations;

	PieceType* _pieceType;
	
	int renderOrder;	// 描画順。0は最前面。

	PieceStatus status;

	int margin;				// マージン
	
	// ピースの中心位置が移動できる範囲
	float minX;
	float minY;
	float maxX;
	float maxY;
		
	float speed;			// 速度
	float angle;			// 移動方向	

	float rotateVelocity;	// 回転角度
	Image* shadowImage;
	BOOL haveShadow;	// 影フラグ	
	BOOL isDragging;

	float toAlpha;
	
	NSTimeInterval last1TouchTimestamp;	// 最後のタッチの時間
	NSTimeInterval last2TouchTimestamp;	// 最後のタッチの１つ前の時間
	
	CFAbsoluteTime lastTouchTime;

	// 前回のタッチ位置（前回との平均を計算するため）
	CGFloat last1X;
	CGFloat last1Y;
	CGFloat last2X;
	CGFloat last2Y;
}

@property(nonatomic) int renderOrder;
@property(nonatomic) PieceStatus status;
@property(nonatomic) float speed;
@property(nonatomic) float angle;
@property(nonatomic) float minX;
@property(nonatomic) float minY;
@property(nonatomic) float maxX;
@property(nonatomic) float maxY;
@property(nonatomic) float rotateVelocity;
@property(nonatomic, readwrite) BOOL isDragging;
@property(nonatomic, readwrite) BOOL haveShadow;
@property(nonatomic) NSTimeInterval last1TouchTimestamp;
@property(nonatomic) NSTimeInterval last2TouchTimestamp;
@property(nonatomic) CFAbsoluteTime lastTouchTime;
@property(nonatomic) CGFloat last1X;
@property(nonatomic) CGFloat last1Y;
@property(nonatomic, readonly) PieceType* _pieceType;

- (id)initWithPieceType:(PieceType*)aPieceType delegate:(id) aDelegate;
- (void)updateWithDelta:(GLfloat)aDelta;
- (BOOL)isStillOutside:(CGPoint) location;
- (void)updateWithTouchLocationMoved:(CGPoint)theLocation;
- (void) setFlickMovement:(UITouch*) touch view:(UIView*)aView speed:(float) theSpeed;

@end

@protocol PieceDelegate

//- (void)goal:(Piece*) aPiece;

@end
