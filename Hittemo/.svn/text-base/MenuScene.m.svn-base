//
//  MenuState.m
//  OGLGame
//
//  Created by Michael Daley on 31/05/2009.
//  Copyright 2009 Michael Daley. All rights reserved.
//

#import "MenuScene.h"

@interface MenuScene (Private)
- (void)initMenuItems;
@end

@implementation MenuScene


- (id)init {
	
	if(self = [super init]) {
		_sharedDirector = [Director sharedDirector];
		_sharedResourceManager = [ResourceManager sharedResourceManager];
//		_sharedSoundManager = [SoundManager sharedSoundManager];
		_configurations = [Configurations instance];
        
        _origin = CGPointMake(0, 0);
			
		menuEntities = [[NSMutableArray alloc] init];
		scores = [[NSMutableArray alloc] init];
		menuBackground = [[Image alloc] initWithImage:@"menu.png"];
		[self setSceneState:kSceneState_TransitionIn];
		[self initMenuItems];
	}
	return self;
}

- (void)startGameEasy {
	_configurations.levelNo = 0;
	[_sharedDirector setCurrentSceneAtIndex:kSceneGame];
	sceneState = kSceneState_TransitionOut;
}

- (void)startGameNormal {
	_configurations.levelNo = 1;
	[_sharedDirector setCurrentSceneAtIndex:kSceneGame];
	sceneState = kSceneState_TransitionOut;
}

- (void)startGameHard {
	_configurations.levelNo = 2;
	[_sharedDirector setCurrentSceneAtIndex:kSceneGame];
	sceneState = kSceneState_TransitionOut;
}

- (void)toggleEnableSound {
	
	MenuControl* enableSoundButton = [menuEntities objectAtIndex:3];
	
	enableSoundButton.isEnable = !enableSoundButton.isEnable;
	
	// Set the master sound FX volume
	[_sharedSoundManager setFXVolume:enableSoundButton.isEnable * 1.0f];
	
	[_configurations setEnableSound:enableSoundButton.isEnable];
	[_configurations saveScoreFile];
}

- (void)openWebSite {
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.n-arts.com/"]];
}

- (void)initMenuItems {
	
	// Init font
	font = [[AngelCodeFont alloc] initWithFontImageNamed:@"Casual32Pink.png" controlFile:@"Casual32Pink" scale:1.0f filter:GL_LINEAR];

	// menu button
	MenuControl *menuEntity;

	menuEntity = [[MenuControl alloc] initWithImageNamed:@"highlightButton.png" 
												location:Vector2fMake(160, 480 - 142) 
										   centerOfImage:YES
												  target:self 
												selector:@selector(startGameEasy) 
												interval:0.0
										   blendAdditive:YES
												  string:@"easy"];
	menuEntity.alpha = 0.5;
	[menuEntities addObject:menuEntity];
	[menuEntity release];
	
	menuEntity = [[MenuControl alloc] initWithImageNamed:@"highlightButton.png" 
												location:Vector2fMake(160, 480 - 215) 
										   centerOfImage:YES
												  target:self 
												selector:@selector(startGameNormal) 
												interval:0.0
										   blendAdditive:YES
												  string:@"normal"];
	menuEntity.alpha = 0.5;
	[menuEntities addObject:menuEntity];
	[menuEntity release];
	
	menuEntity = [[MenuControl alloc] initWithImageNamed:@"highlightButton.png" 
												location:Vector2fMake(160, 480 - 290) 
										   centerOfImage:YES
												  target:self 
												selector:@selector(startGameHard) 
												interval:0.0
										   blendAdditive:YES
												  string:@"hard"];
	menuEntity.alpha = 0.5;
	[menuEntities addObject:menuEntity];
	[menuEntity release];
	
	menuEntity = [[MenuControl alloc] initWithImageNamed:@"highlightButton.png" 
												location:Vector2fMake(160, 480 - 384) 
										   centerOfImage:YES
												  target:self 
												selector:@selector(toggleEnableSound) 
												interval:0.0
										   blendAdditive:YES
												  string:@"sound on"];
	menuEntity.isEnable = [_configurations getEnableSound];
	menuEntity.alpha = 0.5;
	// Set the master sound FX volume
	[_sharedSoundManager setFXVolume:menuEntity.isEnable * 1.0f];
	[menuEntities addObject:menuEntity];
	[menuEntity release];

	menuEntity = [[MenuControl alloc] initWithImageNamed:@"highlightButton.png" 
												location:Vector2fMake(160, 480 - 437) 
										   centerOfImage:YES
												  target:self 
												selector:@selector(openWebSite)  
												interval:0.0
										   blendAdditive:YES
												  string:@"web site"];
	[menuEntities addObject:menuEntity];
	[menuEntity release];
	
	// score
	Label* theLabel;
	
	theLabel = [[Label alloc] initWithString:@"" location:Vector2fMake(285, 480 - 142) alignX:AngelCodeFontAlignRight alignY:AngelCodeFontAlignCenter interval:0.0 scale:0.5];
	[scores addObject:theLabel];
	[theLabel release];	
	
	theLabel = [[Label alloc] initWithString:@"" location:Vector2fMake(285, 480 - 215) alignX:AngelCodeFontAlignRight alignY:AngelCodeFontAlignCenter interval:0.0 scale:0.5];
	[scores addObject:theLabel];
	[theLabel release];	

	theLabel = [[Label alloc] initWithString:@"" location:Vector2fMake(285, 480 - 290) alignX:AngelCodeFontAlignRight alignY:AngelCodeFontAlignCenter interval:0.0 scale:0.5];
	[scores addObject:theLabel];
	[theLabel release];	

}

- (void)dealloc {
	
	[font release];
	[menuEntities release];
	[scores release];
	[menuBackground release];
	
	[super dealloc];
}

- (void)updateWithDelta:(GLfloat)aDelta {

	if (hidden) {
		return;
	}
	
	switch (sceneState) {
		case kSceneState_Running:
			[menuEntities makeObjectsPerformSelector:@selector(updateWithDelta:) withObject:[NSNumber numberWithFloat:aDelta]];
			break;
			
		case kSceneState_TransitionOut:
			break;
			
		case kSceneState_TransitionIn:

//			[menuEntities makeObjectsPerformSelector:@selector(reset)];
		{
			// score
			int theLevelNo = 0;
			for (Label* theScore in scores) {
				theScore.hidden = NO;
				int theScoreNo = [_configurations getScore:theLevelNo];
				if (0 != theScoreNo) {
					[theScore setString:[NSString stringWithFormat:@"%d", theScoreNo]];
				}
				theLevelNo++;
			}

			sceneState = kSceneState_Running;
			break;
		}
		default:
			break;
	}

}


- (void)setSceneState:(uint)theState {
	sceneState = theState;
}

- (void)updateWithTouchLocationBegan:(NSSet*)touches withEvent:(UIEvent*)event view:(UIView*)aView {

	if (hidden) {
		return;
	}
	
    UITouch *touch = [[event touchesForView:aView] anyObject];
	CGPoint location;
	location = [touch locationInView:aView];
    
	// Flip the y location ready to check it against OpenGL coordinates
	location.y = 480-location.y;
	[menuEntities makeObjectsPerformSelector:@selector(updateWithTouchLocationBegan:) withObject:NSStringFromCGPoint(location)];
}


- (void)updateWithTouchLocationMoved:(NSSet*)touches withEvent:(UIEvent*)event view:(UIView*)aView {
	
	if (hidden) {
		return;
	}
	
    UITouch *touch = [[event touchesForView:aView] anyObject];
	CGPoint location;
	location = [touch locationInView:aView];
    
	// Flip the y location ready to check it against OpenGL coordinates
	location.y = 480-location.y;
	[menuEntities makeObjectsPerformSelector:@selector(updateWithTouchLocationMoved:) withObject:NSStringFromCGPoint(location)];	
}

- (void)updateWithTouchLocationEnded:(NSSet*)touches withEvent:(UIEvent*)event view:(UIView*)aView {
	
	if (hidden) {
		return;
	}
	
    UITouch *touch = [[event touchesForView:aView] anyObject];
	CGPoint location;
	location = [touch locationInView:aView];
    
	// Flip the y location ready to check it against OpenGL coordinates
	location.y = 480-location.y;
	[menuEntities makeObjectsPerformSelector:@selector(updateWithTouchLocationEnded:) withObject:NSStringFromCGPoint(location)];	
}

- (void)transitionToSceneWithKey:(NSString*)theKey {
	sceneState = kSceneState_TransitionOut;
}


- (void)render {
	
	if (hidden) {
		return;
	}
	
	[menuBackground renderAtPoint:CGPointMake(160, 240) centerOfImage:YES];
	[menuEntities makeObjectsPerformSelector:@selector(render)];
	[scores makeObjectsPerformSelector:@selector(render)];
}


@end
