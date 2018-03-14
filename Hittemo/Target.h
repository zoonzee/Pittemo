#import <Foundation/Foundation.h>
#import "AbstractEntity.h"
#import "PieceType.h"

@interface Target : AbstractEntity {

	PieceType* pieceType;
	int maxCount;			// ゴールができるピースの数
	int goalCount;			// ゴールしたピースの数
	int nuisanceCount;		// おじゃまピースの数

}

@property(nonatomic, assign) PieceType* pieceType;
@property(nonatomic, readonly) int maxCount;
@property(nonatomic, readwrite) int goalCount;
@property(nonatomic, readonly) int nuisanceCount;

- (id)initWithPieceType:(PieceType*)aPieceType pieceMax:(int)aPieceMax targetMax:(int)aTargetMax;

@end
