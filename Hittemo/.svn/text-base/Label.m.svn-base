//
//  Label.m
//  Tutorial1
//
//  Created by zoonzee on 09/09/27.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "Label.h"


@interface Label (Private)
- (void)scaleImage:(GLfloat)delta;
@end

@implementation Label

#define MAX_SCALE 3.0f
#define SCALE_DELTA 1.0f
#define ALPHA_DELTA 1.0f

- (id)initWithString:(NSString*)theString
			location:(Vector2f)theLocation 
			  alignX:(AngelCodeFontAlign)aAlignX 
			  alignY:(AngelCodeFontAlign)aAlignY
			interval:(float)aInterval
			   scale:(float)aScale
{
	
	self = [super init];
	if (self != nil) {
		sharedDirector = [Director sharedDirector];
		
		labelString = [[NSString alloc] initWithString:theString];
		location = theLocation;
		alignX = aAlignX;
		alignY = aAlignY;
		state = kControl_Scaling;
		originalScale = aScale;
		scale = aScale;
		alpha = 1.0f;
		
		expand = 0.0;
		restitutive = 0.0;

		hidden = YES;
		
		// Init font
		font = [[AngelCodeFont alloc] initWithFontImageNamed:@"Casual32Pink.png" controlFile:@"Casual32Pink" scale:aScale filter:GL_LINEAR];
	}
	return self;
}

- (void)dealloc {
	
	[labelString release];	
	[font release];
	
	[super dealloc];
}

- (void)updateWithDelta:(GLfloat)theDelta {

	if (hidden) {
		return;
	}

	theDelta = 1.0 / 60.0;

	if(0.0 != expand) {		

		scale += expand * theDelta;								// 拡張
		expand -= (scale - originalScale) * restitutive * theDelta;		// 拡張率
		scale -= (scale - originalScale) * scaleRedece * theDelta;		// 収束
		duration -= theDelta;

		if (0.0 > duration) {
			expand = 0.0;
			scale = originalScale;
		}
	}
	
	if (0.0 < toAlphaDuration) {
		toAlphaDuration -= theDelta;
		alpha += toAlphaDelta;
		if (alpha < 0.0) {
			alpha = 0.0;
		}
		if (1.0 < alpha) {
			alpha = 1.0;
		}
	}
}

- (void)render {
	
	if (hidden) {
		return;
	}
	
	[font setScale:scale];
	[font setAlpha:alpha];
	[font drawStringAt:CGPointMake(location.x, location.y) text:labelString alignX:alignX alignY:alignY];
}

// 膨張
- (void)setString:(NSString*)aString {
	[labelString release];
	labelString = [[NSString alloc] initWithString:aString];
	alpha = 1.0;
	scale = originalScale;
	expand = 0.0;
	hidden = NO;
}

// 膨張
- (void)startExpand:(float)aExpand 
		scaleReduce:(float)ascaleReduce
		restitutive:(float)aRestitutive
		   duration:(float)aDuration
{
	expand = aExpand;
	scaleRedece = ascaleReduce;
	restitutive = aRestitutive;
	duration = aDuration;
}

- (void)startAnimAlpha:(float)aFinishAlpha
			  duration:(float)aDuration {
	
	toAlphaDelta = (aFinishAlpha - alpha) * kFrameRate * aDuration;
	toAlphaDuration = aDuration;
	
}

@end
