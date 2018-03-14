//
//  Director.m
//  OGLGame
//
//  Created by Michael Daley on 03/05/2009.
//  Copyright 2009 Michael Daley. All rights reserved.
//

#import "Director.h"
#import "AbstractScene.h"

@implementation Director

@synthesize currentlyBoundTexture;
@synthesize currentScene;
@synthesize _scenes;
@synthesize framesPerSecond;

// Make this class a singleton class
SYNTHESIZE_SINGLETON_FOR_CLASS(Director);


- (id)init {
	_scenes = [[NSMutableArray alloc] init];
	return self;
}

- (void)addScene:(AbstractScene*)aScene {
	[_scenes addObject:aScene];
}

- (void)dealloc {
	[_scenes release];
	[super dealloc];
}

- (void)setCurrentSceneAtIndex:(int)aIndex {
	currentScene = [_scenes objectAtIndex:aIndex];
	currentScene.hidden = NO;
	currentScene.sceneState = kSceneState_TransitionIn;
}

// レンダリングはトランジションのために、すべて描画する
- (void)render {
	[[_scenes objectAtIndex:kSceneMenu] render];
	[[_scenes objectAtIndex:kSceneGame] render];
}


@end
