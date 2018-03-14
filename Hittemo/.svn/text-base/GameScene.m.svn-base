//
//  GameState.m
//  OGLGame
//
//  Created by Michael Daley on 31/05/2009.
//  Copyright 2009 Michael Daley. All rights reserved.
//

#import "GameScene.h"
#import "Piece.h"
#import "Target.h"

#define FPS 0

#pragma mark -
#pragma mark Private interface

@interface GameScene (Private)
// Initialize the sound needed for this scene
- (void)initSound;
@end

#pragma mark -
#pragma mark Public implementation

@implementation GameScene

- (id)init {
	
	if(self == [super init]) {
		
        // Grab an instance of our singleton classes
		_sharedDirector = [Director sharedDirector];
		_sharedResourceManager = [ResourceManager sharedResourceManager];
//		_sharedSoundManager = [SoundManager sharedSoundManager];
		_configurations = [Configurations instance];
		
		// Init Sound
//		[self initSound];
		
		// Init font
        font = [[AngelCodeFont alloc] initWithFontImageNamed:@"Casual32Pink.png" controlFile:@"Casual32Pink" scale:1.0f filter:GL_LINEAR];
        font16 = [[AngelCodeFont alloc] initWithFontImageNamed:@"Casual32Pink.png" controlFile:@"Casual32Pink" scale:0.5f filter:GL_LINEAR];
		
		levelNoLabel = [[Label alloc] initWithString:@"" location:Vector2fMake(160, 320) alignX:AngelCodeFontAlignCenter alignY:AngelCodeFontAlignCenter interval:0.0 scale:1.0];
		stageNoLabel = [[Label alloc] initWithString:@"" location:Vector2fMake(160, 280) alignX:AngelCodeFontAlignCenter alignY:AngelCodeFontAlignCenter interval:0.0 scale:1.0];
		messageLabel = [[Label alloc] initWithString:@"" location:Vector2fMake(160, 240) alignX:AngelCodeFontAlignCenter alignY:AngelCodeFontAlignCenter interval:0.0 scale:1.0];
        		
		// Init particle emitter
		_explosionEmitter = [[ParticleEmitter alloc] initParticleEmitterWithImageNamed:@"particles1_64.png"
															   position:Vector2fMake(240, 160)
												 sourcePositionVariance:Vector2fMake(5, 5)
																  speed:1.5f
														  speedVariance:0.0f
													   particleLifeSpan:5.0f
											   particleLifespanVariance:0.0f
																  angle:0.0f
														  angleVariance:360
																gravity:Vector2fMake(0.0f, -0.01f)
															 startColor:Color4fMake(1.0f, 1.0f, 1.0f, 1.0f)
													 startColorVariance:Color4fMake(0.0f, 0.0f, 0.0f, 0.0f)
															finishColor:Color4fMake(1.0f, 1.0f, 0.0f, 0.0f)  
													finishColorVariance:Color4fMake(0.0f, 1.0f, 0.0f, 0.0f)
														   maxParticles:1000
														   particleSize:64
												   particleSizeVariance:32
															   duration:0
														  blendAdditive:YES];
		
        
		// pice type
		pieceTypes = [[NSMutableArray alloc] init];
		PieceType* pieceType;
		

		// index:0 R
		pieceType = [[PieceType alloc] initWithBaseImageName:@"star.png"
											 shadowImageName:@"star.png"
											 targetImageName:@"star.png" 
													position:Vector2fMake(160, 10) 
													  margin:10
													   color:Color4fMake(0.8, 0.2, 0.2, 0.8)];
		[pieceTypes addObject:pieceType];
		[pieceType release];
		
		// index:1 G
		pieceType = [[PieceType alloc] initWithBaseImageName:@"star.png"
											 shadowImageName:@"star.png"
											 targetImageName:@"star.png" 
													position:Vector2fMake(160, 240) 
													  margin:10
													   color:Color4fMake(0.2, 0.8, 0.2, 0.8)];
		[pieceTypes addObject:pieceType];
		[pieceType release];
		
		// index:2 B
		pieceType = [[PieceType alloc] initWithBaseImageName:@"star.png"
											 shadowImageName:@"star.png"
											 targetImageName:@"star.png" 
													position:Vector2fMake(160, 240) 
													  margin:10
													   color:Color4fMake(0.2, 0.2, 0.8, 0.8)];
		[pieceTypes addObject:pieceType];
		[pieceType release];
		
		// index:3 C
		pieceType = [[PieceType alloc] initWithBaseImageName:@"star.png"
											 shadowImageName:@"star.png"
											 targetImageName:@"star.png" 
													position:Vector2fMake(160, 240) 
													  margin:10
													   color:Color4fMake(0.2, 0.8, 0.8, 0.8)];
		[pieceTypes addObject:pieceType];
		[pieceType release];
		
		// index:4 M
		pieceType = [[PieceType alloc] initWithBaseImageName:@"star.png"
											 shadowImageName:@"star.png"
											 targetImageName:@"star.png" 
													position:Vector2fMake(160, 240) 
													  margin:10
													   color:Color4fMake(0.8, 0.8, 0.2, 0.8)];
		[pieceTypes addObject:pieceType];
		[pieceType release];
		
		// pices
		pieces = [[Pieces alloc] initWithDelegate:self];
		
		elapsedTime = 0.0;

		hidden = YES;
		
		soundID = -1;
		
		ocmml = [[AppController alloc] init];
	}
	
	return self;
}

// ステージの設定
- (void)setStage {
	
	// ピース配列クリア
	[pieces removeAllObjects];
	pieces.status = PiecesStatusIdol;
	
	// ピース配列にピース追加
	for (int typeId = 0; typeId < kTypeMax; typeId++) {
		
		int pieceMax = _configurations.config.pieceMax[_configurations.stageNo][typeId];
		if (!pieceMax) {
			continue;
		}
		for(int i=0; i < pieceMax; i++) {
			[pieces addPieceWithPieceType:[pieceTypes objectAtIndex:typeId]];
		}
	}
}

- (void)dealloc {
	[font release];
	[font16 release];
	[_explosionEmitter release];
	[pieceTypes release];
	[pieces release];
	[levelNoLabel release];
	[stageNoLabel release];
	[messageLabel release];
	
	[super dealloc];
}

#pragma mark -
#pragma mark Update scene logic

- (void)updateWithDelta:(GLfloat)theDelta {

//	[levelNoLabel updateWithDelta:theDelta];
//	[stageNoLabel updateWithDelta:theDelta];
//	[messageLabel updateWithDelta:theDelta];
	[pieces updateWithDelta:theDelta];
	[_explosionEmitter update:theDelta];
	[_sharedSoundManager updateWithDelta:theDelta];

	// delay
	if (0.0 < (delay -= theDelta)) {
		return;
	}	
	
	switch (sceneState) {

#define kTransitionDuration 0.3 // トランジション（ディゾルブ）時間（秒）
		case kSceneState_TransitionIn:
			
			delay = kFrameRate;							// 1/60
			repeat = kTransitionDuration / kFrameRate;	// 0.5/ 1/60 = 30
			sceneState = kSceneState_TransitionIn2;
			
			break;
			
		case kSceneState_TransitionIn2:
			
			delay = kFrameRate;

			if (0 == repeat--) {
				((AbstractScene*)[_sharedDirector._scenes objectAtIndex:kSceneMenu]).hidden = YES;
				sceneState = kGameState_StartingReady;
			}
			break;
					
		case kGameState_StartingReady:
			
			[self setStage];
			 [messageLabel setString:@"ready"];
			[stageNoLabel startAnimAlpha:0.0 duration:2.0];
			delay = 1.0;
			sceneState = kGameState_Starting0;
			break;
			
		case kGameState_Starting0:
			
			levelNoLabel.hidden = YES;
			stageNoLabel.hidden = YES;
			messageLabel.hidden = YES;
			[pieces setHaveShadow:YES];
            			
			sceneState = kSceneState_Running;
			pieces.status = PiecesStatusActivate;
						
			[ocmml play:self];
			break;
			
		case kSceneState_Running:
						
			// 衝突判定
//			[pieces collisionDetection];
			
//			if (soundID != -1) {
//				soundID = [_sharedSoundManager sustainSoundWithID:soundID harmonics:-1];
//			}	
			
			elapsedTime += theDelta;

			[ocmml update];
			
			break;
			
		case kGameState_StageCleared:
			
			delay = 1.0;
			sceneState = kGameState_StageClearedShowMessage;
			break;
			
		case kGameState_StageClearedShowMessage:

			[messageLabel setString:@"STAGE CLEAR"];
			
			delay = 2.0;
			sceneState = kGameState_StageClearedShowMessageDone;
			break;
			
		
		case kGameState_StageClearedShowMessageDone:

			messageLabel.hidden = YES;
			[_configurations setNextStage];			

			[self setStage];
			delay = 1.0;
			sceneState = kGameState_StartingReady;
			break;
			
		case kGameState_LevelCleared:

			[messageLabel setString:@"LEVEL CLEAR"];
			
			// スコア表示
			int newScore = elapsedTime;
			[levelNoLabel setString:[NSString stringWithFormat:@"TIME %d sec.", newScore]];
		
			// 新記録
			int oldScore = [_configurations getScore:_configurations.levelNo];
			if (0 == oldScore || newScore < oldScore) {

				[stageNoLabel setString:@"NEW RECORD"];
				// タイムを保存
				[_configurations setScore:newScore];
			}
			
			delay = 0.2;
			repeat = 10;
			sceneState = kGameState_LevelClearedStartAnimation;
			break;
			
		case kGameState_LevelClearedStartAnimation:
		{

			// パーティクル
			float x = rand() % 320;
			float y = rand() % 480;
			
			[_explosionEmitter setSourcePosition:Vector2fMake(x, y)];
			[_explosionEmitter setDuration:0.125f];
			[_explosionEmitter setActive:YES];
			[_explosionEmitter emit:12];
			
			delay = 0.2;
			if (0 == repeat--) {
				delay = 1.0;
				sceneState = kGameState_LevelClearedShowMessageDone;
			}
			break;
		}
		case kGameState_LevelClearedShowMessageDone:
			
			levelNoLabel.hidden = YES;
			stageNoLabel.hidden = YES;
			messageLabel.hidden = YES;
			
			_configurations.stageNo = 0;
			elapsedTime = 0.0;
			
			sceneState = kGameState_TransitionOutStart;
			break;

		case kGameState_TransitionOutStart:
			
			sceneState = kGameState_TransitionOutDone;
			break;
			
		case kGameState_TransitionOutDone:
			hidden = YES;
			[_sharedDirector setCurrentSceneAtIndex:kSceneMenu];
			break;
	}

}

#pragma mark -
#pragma mark Touch events

- (void)updateWithTouchLocationBegan:(NSSet*)touches withEvent:(UIEvent*)event view:(UIView*)aView {

	for(UITouch* touch in touches) {  
		
		CGPoint theLocation = [touch locationInView:aView];

		// Flip the y location ready to check it against OpenGL coordinates
		theLocation.y = 480 - theLocation.y;

		soundID = [_sharedSoundManager playSoundWithSourceID:-1 
												   harmonics:(theLocation.x / 320 * kMaxHarmonics)
														gain:1.0 pitch:((theLocation.y / 480)*2) 
													location:Vector2fMake(theLocation.x, theLocation.y) 
												  shouldLoop:NO];
			
		switch (sceneState) {
			case kSceneState_Running:
				
				// ドラッグエリア外は無処理
				if (!CGRectContainsPoint(_configurations.config.dragArea, theLocation)) {
					return;
				}

				[pieces pullingPiece:touch view:aView];
				
				break;
			default:
				break;
		}
	}
}

- (void)updateWithTouchLocationMoved:(NSSet*)touches withEvent:(UIEvent*)event view:(UIView*)aView {

	// 稼働中以外は無処理
	switch (sceneState) {
		case kSceneState_Running:
			break;
		default:
			return;
	}

	for(UITouch* touch in touches) {  
		
		CGPoint theLocation = [touch locationInView:aView];
		
		// Flip the y location ready to check it against OpenGL coordinates
		theLocation.y = 480 - theLocation.y;
		
		if (soundID != -1) {
			soundID = [_sharedSoundManager modSoundWithID:soundID 
												harmonics:(theLocation.x / 320 * kMaxHarmonics)
													pitch:((theLocation.y / 480)*2) location:Vector2fMake(theLocation.x, theLocation.y)];

		}	
	}
	
	
	[pieces updateWithTouchLocationMoved:touches withEvent:event view:aView];	
}

// タッチ終了
- (void)updateWithTouchLocationEnded:(NSSet*)touches withEvent:(UIEvent*)event view:(UIView*)aView {
	
	// 稼働中以外は無処理
	switch (sceneState) {
		case kSceneState_Running:
			break;
		default:
			return;
	}
	
//	NSLog(@"Ended");
	
	for(UITouch* touch in touches) {  		

		if (soundID != -1) {
			soundID = [_sharedSoundManager stopSoundWithID:soundID];
			soundID = -1;
		}	
		
		// ドラッグ、ひっつきピースがある場合
		Piece* thePiece = [pieces.drugingPieces objectForKey:[NSValue valueWithPointer:touch]];
		if (thePiece) {

			[thePiece setFlickMovement:touch view:aView speed:_configurations.config.flickSpeed];
			NSValue* value = [NSValue valueWithPointer:touch];
			[pieces.drugingPieces removeObjectForKey:value]; 

		}
	}
}

#pragma mark -
#pragma mark Accelerometer

- (void)updateWithAccelerometer:(UIAcceleration*)aAcceleration {
    // Populate the accelerometer array with the filtered accelerometer info
	_accelerometer[0] = aAcceleration.x * 0.1f + _accelerometer[0] * (1.0 - 0.1f);
	_accelerometer[1] = aAcceleration.y * 0.1f + _accelerometer[1] * (1.0 - 0.1f);
	_accelerometer[2] = aAcceleration.z * 0.1f + _accelerometer[2] * (1.0 - 0.1f);
}

- (float)accelerometerValueForAxis:(uint)aAxis {
    return _accelerometer[aAxis];
}

#pragma mark -
#pragma mark Transition

- (void)transitionToSceneWithKey:(NSString*)theKey {
	sceneState = kSceneState_TransitionOut;
}

#pragma mark -
#pragma mark Render scene

- (void)render {
	
	if (hidden) {
		return;
	}
	
	// パーティクル
	[_explosionEmitter renderParticles];
	
    // ピース
	[pieces render];
	
//    if(FPS)
//        [font drawStringAt:CGPointMake(5, 450) text:[NSString stringWithFormat:@"FPS: %1.0f", [_sharedDirector framesPerSecond]] alignX:AngelCodeFontAlignCenter alignY:AngelCodeFontAlignCenter];
//
//	[font16 drawStringAt:CGPointMake(160, 465) text:[NSString stringWithFormat:@"LEVEL %d  STAGE %d  TIME %d", _configurations.levelNo + 1, _configurations.stageNo + 1, (int)elapsedTime] alignX:AngelCodeFontAlignCenter alignY:AngelCodeFontAlignCenter];
//	
//	[levelNoLabel render];
//	[stageNoLabel render];
//	[messageLabel render];
}

- (BOOL)isStageClear {
	
	// todo check clear
	
	return YES;
}

- (void)explode:(Piece*) aPiece {
	[_explosionEmitter setStartColor:aPiece._pieceType.color];
	[_explosionEmitter setStartColorVariance:Color4fMake(0.3f, 0.3f, 0.3f, 0.0f)];
	[_explosionEmitter setFinishColor:aPiece._pieceType.color];
	[_explosionEmitter setFinishColorVariance:Color4fMake(0.7f, 0.7f, 0.7f, 0.0f)];
	
	[_explosionEmitter setSourcePosition:aPiece.position];
	[_explosionEmitter setDuration:5.0f];
	[_explosionEmitter setActive:YES];
	[_explosionEmitter emit:12];

// todo
//	// ステージクリア
//	if ([self isStageClear]) {	
//
//		if ([_configurations isLastStage]) {
//			sceneState = kGameState_LevelCleared;
//		}
//		else {
//			sceneState = kGameState_StageCleared;
//		}
//	}
}

@end


@implementation GameScene (Private)

#pragma mark -
#pragma mark Initialize sound

- (void)initSound {
	
    [_sharedSoundManager setListenerPosition:Vector2fMake(160, 0)];
	
    // Initialize the sound effects
//	[_sharedSoundManager loadSoundWithKey:@"bang" fileName:@"bang" fileExt:@"aif"];
//	[_sharedSoundManager loadSoundWithKey:@"click" fileName:@"click" fileExt:@"aif"];
//	[_sharedSoundManager loadSoundWithKey:@"hit2" fileName:@"hit2" fileExt:@"aif"];
//	[_sharedSoundManager loadSoundWithKey:@"itmget" fileName:@"itmget" fileExt:@"wav"];
//	[_sharedSoundManager loadSoundWithKey:@"poi" fileName:@"poi" fileExt:@"wav"];
	[_sharedSoundManager loadSoundWithKey:@"Ride" fileName:@"Ride" fileExt:@"m4a"];
	[_sharedSoundManager loadSoundWithKey:@"MTom" fileName:@"MTom" fileExt:@"m4a"];
	[_sharedSoundManager loadSoundWithKey:@"HTom" fileName:@"HTom" fileExt:@"m4a"];
	[_sharedSoundManager loadSoundWithKey:@"HH" fileName:@"HH" fileExt:@"m4a"];
	[_sharedSoundManager loadSoundWithKey:@"FTom" fileName:@"FTom" fileExt:@"m4a"];
	[_sharedSoundManager loadSoundWithKey:@"CCym" fileName:@"CCym" fileExt:@"m4a"];
	[_sharedSoundManager loadSoundWithKey:@"BD" fileName:@"BD" fileExt:@"m4a"];
	[_sharedSoundManager loadSoundWithKey:@"SD" fileName:@"SD" fileExt:@"m4a"];
	[_sharedSoundManager makeSoundWithType:0];
	
	// Initialize the background music
	//[_sharedSoundManager loadBackgroundMusicWithKey:@"music" fileName:@"music" fileExt:@"caf"];
	[_sharedSoundManager setMusicVolume:0.75f];
	//[sharedSoundManager playMusicWithKey:@"music"  timesToRepeat:-1];
	
}

@end

