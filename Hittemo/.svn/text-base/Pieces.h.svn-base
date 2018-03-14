#import <Foundation/Foundation.h>
#import "Configurations.h"
#import "Piece.h"
#import "PieceType.h"
//#import "Target.h"
#import "TJView.h"

typedef enum {
    PiecesStatusIdol,
    PiecesStatusActivate,
    PiecesStatusActivated,
} PiecesStatus;

@protocol PiecesDelegate;

@interface Pieces : TJView <PieceDelegate> {

	id <PiecesDelegate> delegate;

	SoundManager* _sharedSoundManager;
	Configurations* _configurations;

	PiecesStatus status;
	
	NSMutableArray* pieces;
	
	// ドラッグ中のピース
	NSMutableDictionary* drugingPieces;
	
	BOOL didLevelClear;
}

@property (nonatomic) PiecesStatus status;
@property (nonatomic, assign) NSMutableDictionary* drugingPieces;

- (id)initWithDelegate:(id) aDelegate;
- (void)removeAllObjects;
- (void)updateWithDelta:(GLfloat)aDelta;
- (void)addPieceWithPieceType:(PieceType*)aTarget;
- (void)render;
- (void) pullingPiece:(UITouch*)touch view:(UIView*)aView;
- (void) bringToFront:(Piece*) thePiece;
- (void) setHaveShadow:(BOOL) aHaveShadow;
- (void)updateWithTouchLocationMoved:(NSSet*)touches withEvent:(UIEvent*)event view:(UIView*)aView;
- (void)collisionDetection;

@end

@protocol PiecesDelegate

- (void)explode:(Piece*) aPiece;

@end
