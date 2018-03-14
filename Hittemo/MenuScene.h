//
//  MenuState.h
//  OGLGame
//
//  Created by Michael Daley on 31/05/2009.
//  Copyright 2009 Michael Daley. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AbstractScene.h"
#import "Label.h"

@interface MenuScene : AbstractScene {
	
	NSMutableArray *menuEntities;
	Image *menuBackground;
    CGPoint _origin;

    // フォント
	AngelCodeFont *font;

	// スコア
	NSMutableArray *scores;
}

- (void)startGameEasy;
- (void)startGameNormal;
- (void)startGameHard;
- (void)toggleEnableSound;
- (void)openWebSite;
	
@end
