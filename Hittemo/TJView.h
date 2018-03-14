//
//  TJView.h
//  Tutorial1
//
//  Created by zoonzee on 09/10/13.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Image.h"
#import "Common.h"


@interface TJView : NSObject {

	float originalScale;
	float rotation;
	float scale;
	float alpha;
	BOOL hidden;
	
}

@property (nonatomic, assign) GLfloat scale;
@property (nonatomic, assign) GLfloat alpha;
@property (nonatomic) BOOL hidden;

@end
