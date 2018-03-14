#import <Foundation/Foundation.h>
#import "AbstractControl.h"
#import "AngelCodeFont.h"


@interface Label : AbstractControl {

@private
	NSString* labelString;
	
    // フォント
	AngelCodeFont *font;
	
	// 拡張（スプリング）
	float expand;
	float scaleRedece;		
	float restitutive; 		// 復元力
	float duration;			// 継続時間

	// アルファ
	float toAlphaDelta;
	float toAlphaDuration;
	
	AngelCodeFontAlign alignX;
	AngelCodeFontAlign alignY;
}

- (id)initWithString:(NSString*)theString
			location:(Vector2f)theLocation 
			  alignX:(AngelCodeFontAlign)aAlignX 
			  alignY:(AngelCodeFontAlign)aAlignY
			interval:(float)aInterval
			   scale:(float)aScale;
- (void)updateWithDelta:(GLfloat)theDelta;
- (void)render;
- (void)setString:(NSString*)aString;
- (void)startExpand:(float)aExpand 
		scaleReduce:(float)ascaleReduce
		restitutive:(float)aRestitutive
		   duration:(float)aDuration;
- (void)startAnimAlpha:(float)aFinishAlpha
			  duration:(float)aDuration;

@end
