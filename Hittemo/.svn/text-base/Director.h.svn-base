//
//  Director.h
//  OGLGame
//
//  Created by Michael Daley on 03/05/2009.
//  Copyright 2009 Michael Daley. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <OpenGLES/ES1/gl.h>
#import "SynthesizeSingleton.h"
#import "Common.h"

#define kSceneMenu 0
#define kSceneGame 1

@class AbstractScene;

@interface Director : NSObject {
	
	// Currently bound texture name
	GLuint currentlyBoundTexture;
	
	// 現在のシーン
	AbstractScene* currentScene;

	// シーン
	NSMutableArray* _scenes;

    // Frames Per Second
    float framesPerSecond;	
}

@property (nonatomic, assign) GLuint currentlyBoundTexture;
@property (nonatomic, readonly) AbstractScene* currentScene;
@property (nonatomic, assign) NSMutableArray *_scenes;
@property (nonatomic, assign) float framesPerSecond;

+ (Director*)sharedDirector;
- (void)addScene:(AbstractScene*)aScene;
- (void)setCurrentSceneAtIndex:(int)aIndex;
- (void)render;

@end
