#import <Foundation/Foundation.h>
#import "Configurations.h"
#import "Piece.h"

typedef enum {
	PieceViewsStatusAppeared,
    PieceViewsStatusActivated,
	PieceViewsStatusRomping,
} PieceViewsStatus;

//@protocol PieceViewsDelegate;

@interface Pieces : NSObject {
//	@interface PieceViews : NSObject <PieceViewDelegate> {

//	id <PieceViewsDelegate> delegate;

	Configurations* configurations;

	PieceViewsStatus status;
	
	NSMutableArray* pieces;
	
	UIView* pieceViewsLayer;

	Piece* drugingPiece;
	BOOL didLevelClear;
}

//@property (nonatomic, assign) id <PieceViewsDelegate> delegate;
@property (readonly) PieceViewsStatus status;
@property (readonly) UIView* pieceViewsLayer;
@property (readwrite, assign) Piece* drugingPiece;

- (id)initWithDelegate:(id) aDelegate;
- (void)addPieceWithBaseImage:(NSString*)baseImage shadowImage:(NSString*) shadowImage;
- (void)update:(GLfloat)delta;
- (void)render;
//- (void) reset;
//- (void) setUpPieceView: (PieceType*) pieceType;
//- (void) appear;
//- (void) startMoving;
//- (void) activate;
//- (void) pullingPiece:(CGPoint) location;
//- (void) pickAt:(CGPoint) location;
//- (int) aliveCount;
//- (void) applyAcceralation:(CGPoint) accelVector;
//- (void) setStartButtonOn;
//- (void) setBackButtonOn;
//- (void) stageCleared;

@end

//@protocol PieceViewsDelegate
//
//@end
