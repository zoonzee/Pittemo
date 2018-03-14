//
//  SettingsScene.m
//  Tutorial1
//
//  Created by Michael Daley on 07/06/2009.
//  Copyright 2009 Michael Daley. All rights reserved.
//

#import "SettingsScene.h"


@implementation SettingsScene

- (id)init {
	
	if(self = [super init]) {
		_sharedDirector = [Director sharedDirector];
		_sharedResourceManager = [ResourceManager sharedResourceManager];
//		_sharedSoundManager = [SoundManager sharedSoundManager];

        // Init anglecode font and message
		font = [[AngelCodeFont alloc] initWithFontImageNamed:@"Casual32Pink.png" controlFile:@"Casual32Pink" scale:1.0f filter:GL_LINEAR];

	}
	
	return self;
}

- (void)dealloc {
	
	[font release];
	
	[super dealloc];
}	

- (void)updateWithDelta:(GLfloat)aDelta {
    switch (sceneState) {
		case kSceneState_Running:

			break;
			
		case kSceneState_TransitionOut:
            sceneState = kSceneState_TransitionIn;
			break;
			
		case kSceneState_TransitionIn:
			sceneState = kSceneState_Running;
			break;
		default:
			break;
	}
    
}


- (void)updateWithTouchLoctionBegan:(NSString*)aTouchLocation {
}


- (void)updateWithMovedLocation:(NSString*)aTouchLocation {
}


- (void)transitionToSceneWithKey:(NSString*)aKey {
}

- (void)render {
    [font drawStringAt:CGPointMake(20, 450) text:@"Settings" alignX:AngelCodeFontAlignCenter alignY:AngelCodeFontAlignCenter];
}

@end
