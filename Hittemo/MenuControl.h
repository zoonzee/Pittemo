//
//  MenuControl.h
//  OGLGame
//
//  Created by Michael Daley on 21/05/2009.
//  Copyright 2009 Michael Daley. All rights reserved.
//
// This class controls the appearance and state of menu options.  It takes an image
// which represents the menu option itself and is resposible for both the logic and
// rendering of the item

#import <Foundation/Foundation.h>
#import "AbstractControl.h"
#import "Image.h"
#import "Common.h"
#import "AngelCodeFont.h"


@interface MenuControl : AbstractControl {

@private
    NSInvocation*	_invocation;	
    float			_elapsedTime;
	BOOL			blendAdditive;
	
	BOOL			isPressing;
	BOOL			isEnable;
	BOOL			isInside;
	
	NSString* labelString;

    // フォント
	AngelCodeFont *font;
	
@protected
    float interval;
	
}

@property(nonatomic) BOOL isEnable;

- (id)initWithImageNamed:(NSString*)theImageName
				location:(Vector2f)theLocation 
		   centerOfImage:(BOOL)theCenter 
				  target:(id)aTarget 
				selector:(SEL)aSelector 
				interval:(float)aInterval
		   blendAdditive:(BOOL)isBlendAdditive
				  string:(NSString*)theString;
//- (void)reset;
- (void)setIsInside:(NSString*)theTouchLocation;
- (void)updateWithDelta:(NSNumber*)theDelta;
- (void)render;

@end
