//
//  MenuControl.m
//  OGLGame
//
//  Created by Michael Daley on 21/05/2009.
//  Copyright 2009 Michael Daley. All rights reserved.
//

#import "MenuControl.h"

@interface MenuControl (Private)
- (void)scaleImage:(GLfloat)delta;
@end


@implementation MenuControl

#define MAX_SCALE 3.0f
#define SCALE_DELTA 1.0f
#define ALPHA_DELTA 1.0f

@synthesize isEnable;

- (id)initWithImageNamed:(NSString*)theImageName
				location:(Vector2f)theLocation 
		   centerOfImage:(BOOL)theCenter 
				  target:(id)aTarget 
				selector:(SEL)aSelector 
				interval:(float)aInterval
		   blendAdditive:(BOOL)isBlendAdditive
				  string:(NSString*)theString
{

	self = [super init];
	if (self != nil) {
		sharedDirector = [Director sharedDirector];
		image = [(Image*)[Image alloc] initWithImage:theImageName filter:GL_LINEAR isBlendAdditive:isBlendAdditive];
		location = theLocation;
		centered = theCenter;
		scale = 1.0f;
		alpha = 1.0f;
		blendAdditive = isBlendAdditive;
		
		isPressing = NO;
		isEnable = NO;
		isInside = NO;
		
		// Set the interval and the elapsed time
		interval = aInterval;
		_elapsedTime = 0;
		
		// Create a method signature based on the target and selector which were provided for this 
		// timer.  This will then allow us to invoke that method within the target when this
		// timer fires.
		NSMethodSignature *methodSignature = [[aTarget class] instanceMethodSignatureForSelector:aSelector];
		_invocation = [NSInvocation invocationWithMethodSignature:methodSignature];
		[_invocation setTarget:aTarget];
		[_invocation setSelector:aSelector];
		[_invocation retainArguments];
		[_invocation retain];

		labelString = theString;
		// Init font
		font = [[AngelCodeFont alloc] initWithFontImageNamed:@"Casual32Pink.png" controlFile:@"Casual32Pink" scale:0.75f filter:GL_LINEAR];
	}
	return self;
}

- (void)dealloc {
	
	[font release];
	
	[super dealloc];
}

//- (void)reset {
//	isPressing = NO;
//	isEnable = NO;
//	isInside = NO;
//}

- (void)setIsInside:(NSString*)theTouchLocation {

	CGRect controlBounds = CGRectMake(location.x - (([image imageWidth]*[image scale])/2), location.y - (([image imageHeight]*[image scale])/2), [image imageWidth]*[image scale], [image imageHeight]*[image scale]);
	
	CGPoint touchPoint = CGPointFromString((NSString*)theTouchLocation);
	
	isInside = CGRectContainsPoint(controlBounds, touchPoint);
}

- (void)updateWithTouchLocationBegan:(NSString*)theTouchLocation {

	if (isPressing) {
		return;
	}
	
	[self setIsInside:theTouchLocation];

	if (isInside) {
		isPressing = YES;
	}
}

- (void)updateWithTouchLocationMoved:(NSString*)theTouchLocation {
	
	if (!isPressing) {
		return;
	}

	[self setIsInside:theTouchLocation];
}

- (void)updateWithTouchLocationEnded:(NSString*)theTouchLocation {

	if (!isPressing) {
		return;
	}
	
	[self setIsInside:theTouchLocation];
	
	isPressing = NO;

	if (isInside) {
		// invoke
		[_invocation invoke];
	}
}

- (void)updateWithDelta:(NSNumber*)theDelta {
}

- (void)render {
	
	[image setAlpha:alpha];
	
	BOOL theIsEnalbe;
	
	theIsEnalbe = isEnable;
	
	if (isPressing && isInside) {
		theIsEnalbe = !isEnable;
	}
	
	if (theIsEnalbe) {
		[image renderAtPoint:CGPointMake(location.x, location.y) centerOfImage:centered];
	}
	
	// label
	[font drawStringAt:CGPointMake(location.x, location.y) text:labelString alignX:AngelCodeFontAlignCenter alignY:AngelCodeFontAlignCenter];
}


@end
