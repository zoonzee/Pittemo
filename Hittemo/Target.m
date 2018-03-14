#import "Target.h"


@implementation Target

@synthesize pieceType;
@synthesize maxCount;
@synthesize goalCount;
@synthesize nuisanceCount;

- (id)initWithPieceType:(PieceType*)aPieceType pieceMax:(int)aPieceMax targetMax:(int)aTargetMax {

    self = [super init];
	
	if (self != nil) {
		
		pieceType = aPieceType;
		goalCount = 0;

		// ターゲットがある場合
		if (aTargetMax) {
			// ターゲット１つに入るピースの数
			maxCount = aPieceMax / aTargetMax;
			nuisanceCount = 0;
		}
		// ターゲットがない（おじゃまピース）場合
		else {
			maxCount = 0;
			nuisanceCount = aPieceMax;
		}		

		NSString* theImageName = aPieceType.targetImageName;
		image = [[Image alloc] initWithImage:theImageName scale:1.0];        

		[image setColourFilterRed:pieceType.color.red 
							green:pieceType.color.green 
							 blue:pieceType.color.blue 
							alpha:pieceType.color.alpha];
				
	}
    return self;
}

- (void)render {
	// おじゃまピースの場合はターゲットを表示しない
	if (maxCount) {
		[image renderAtPoint:CGPointMake(position.x, position.y) centerOfImage:YES];
	}
}

@end
