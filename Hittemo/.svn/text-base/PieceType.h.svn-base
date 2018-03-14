#import <Foundation/Foundation.h>
#import "Image.h"


@interface PieceType : NSObject {
	
	NSString* baseImageName;
	NSString* shadowImageName;
	NSString* targetImageName;
	int margin;				// マージン
	Vector2f position;		// ターゲット（穴）の中心位置
	Color4f	color;
}

@property(nonatomic, readonly) NSString* baseImageName;
@property(nonatomic, readonly) NSString* shadowImageName;
@property(nonatomic, readonly) NSString* targetImageName;
@property(nonatomic, readonly) Color4f color;

- (id)initWithBaseImageName:(NSString*)aBaseImageName
			shadowImageName:(NSString*)aShadowImageName
			targetImageName:(NSString*)aTargetImageName
				   position:(Vector2f)aPosition
					 margin:(int)aMargin
					  color:(Color4f)aColor;

@end
