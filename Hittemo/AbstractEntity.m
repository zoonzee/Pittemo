//
//  AbstractEntity.m
//  OGLGame
//
//  Created by Michael Daley on 04/03/2009.
//  Copyright 2009 Michael Daley. All rights reserved.
//

#import "AbstractEntity.h"


@implementation AbstractEntity

@synthesize position;
@synthesize velocity;
@synthesize image;

- (id)init {
	self = [super init];
	if (self != nil) {
		position = Vector2fMake(0, 0);
		velocity = Vector2fMake(0, 0);
	}
	return self;
}


- (void)render {
	
}


@end
