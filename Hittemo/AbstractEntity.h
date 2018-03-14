//
//  AbstractEntity.h
//  OGLGame
//
//  Created by Michael Daley on 04/03/2009.
//  Copyright 2009 Michael Daley. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Image.h"
#import "Animation.h"
#import "TJView.h"

@interface AbstractEntity : TJView {

	// Entity image
	Image *image;

	// Entity position
	Vector2f position;
	
	// Velocity
	Vector2f velocity;
}

@property (nonatomic, readwrite) Vector2f position;
@property (nonatomic, readwrite) Vector2f velocity;
@property (nonatomic, readonly) Image *image;

// Selector that renders the entity
- (void)render;

@end
