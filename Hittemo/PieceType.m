#import "PieceType.h"

@implementation PieceType

@synthesize baseImageName;
@synthesize shadowImageName;
@synthesize targetImageName;
@synthesize color;

- (id)initWithBaseImageName:(NSString*)aBaseImageName
			shadowImageName:(NSString*)aShadowImageName
			targetImageName:(NSString*)aTargetImageName
				   position:(Vector2f)aPosition
					 margin:(int)aMargin
					  color:(Color4f)aColor
{
	self = [super init];

	if (self != nil) {

		baseImageName = aBaseImageName;
		shadowImageName = aShadowImageName;
		targetImageName = aTargetImageName;
		position = aPosition;
		margin = aMargin;
		color = aColor;

	}
	return self;
}

@end
