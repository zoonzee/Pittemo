//
//  AbstractControl.h
//  OGLGame
//
//  Created by Michael Daley on 29/05/2009.
//  Copyright 2009 Michael Daley. All rights reserved.
//

#import "TJView.h"

enum {
	kControl_Idle,
	kControl_Scaling,
	kControl_Selected,
};

@interface AbstractControl : TJView {

	// Shared game state
	Director *sharedDirector;
	
	// Image for the control
	Image *image;
	
	// Location at which the control item should be rendered
	Vector2f location;
	
	// Should the image be rendered based on its center
	BOOL centered;
	
	// State of the control entity
	GLuint state;

}

@property (nonatomic, retain) Image *image;
@property (nonatomic, assign) Vector2f location;
@property (nonatomic, assign) BOOL centered;

- (void)updateWithTouchLocationBegan:(NSString*)theTouchLocation;
- (void)updateWithTouchLocationMoved:(NSString*)theTouchLocation;
- (void)updateWithTouchLocationEnded:(NSString*)theTouchLocation;
- (void)updateWithDelta:(NSNumber*)theDelta;
- (void)render;

@end
