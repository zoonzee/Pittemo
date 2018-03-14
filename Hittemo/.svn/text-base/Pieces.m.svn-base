#import "Pieces.h"

@implementation Pieces

@synthesize status;
@synthesize drugingPieces;

- (id)initWithDelegate:(id) aDelegate {
	
	if (self = [super init]) { 
		
//		_sharedSoundManager = [SoundManager sharedSoundManager];
		_configurations = [Configurations instance];

		pieces = [[NSMutableArray alloc] init];
		
		drugingPieces = [[NSMutableDictionary alloc] init];
		
		delegate = aDelegate;
	}
	
	return self;
}

- (void)dealloc {
	
	[pieces release];
	[drugingPieces release];
	
	[super dealloc];
}

- (void)removeAllObjects {
	[pieces removeAllObjects];
}

- (void)addPieceWithPieceType:(PieceType*)aPieceType {

	Piece *thePiece;
	
	thePiece = [[Piece alloc] initWithPieceType:aPieceType delegate:self];

	thePiece.renderOrder = [pieces count];
	
	[pieces addObject:thePiece];
	[thePiece release];
}

// update
- (void)updateWithDelta:(GLfloat)aDelta {
	
	if (hidden) {
		return;
	}

	for (Piece* thePiece in pieces) {
		[thePiece updateWithDelta:aDelta];
	}
	
	switch (status) {
		case PiecesStatusActivate:
			
			for (Piece* thePiece in pieces) {
				thePiece.status = PieceStatusActivate;
			}
			
			status = PiecesStatusActivated;
			break;
			
		case PiecesStatusActivated:
			break;
	}
	
}

// コンパレータ
// context：ソート順（0が最前面）
// NSOrderedAscending	昇順	タッチ検索順序
// NSOrderedDescending	降順	描画時
NSInteger comparator(id aId1, id aId2, void *context)
{
	NSComparisonResult* sortOrder = context;
	
	int val1 = ((Piece*) aId1).renderOrder;
	int val2 = ((Piece*) aId2).renderOrder;
	
	if  (val1 < val2)
		return  NSOrderedDescending * (*sortOrder);
	else  if  (val1 > val2)
		return  NSOrderedAscending * (*sortOrder);
	else 
		return  NSOrderedSame;
}

- (void)render {
	
	if (hidden) {
		return;
	}
	
	// 下から順に描く
	NSComparisonResult sortOrder = NSOrderedDescending;
	NSArray *sortedPieces = [pieces sortedArrayUsingFunction:comparator context:&sortOrder];

	// ゴールしたピース
	for(Piece* thePiece in sortedPieces) {
		if (PieceStatusGoal == thePiece.status) {
			[thePiece render];
		}
	}

	// ゴールしていないピース
	for(Piece* thePiece in sortedPieces) {
		if (PieceStatusGoal != thePiece.status) {
			[thePiece render];
		}
	}
}

- (void) bringToFront:(Piece*) thePiece {

	// 最前面の場合は無処理
	if (0 == thePiece.renderOrder) {
		return;
	}
	
	for (Piece* piece in pieces) {
		if (piece.renderOrder < thePiece.renderOrder) {
			piece.renderOrder++;
		}
	}
	thePiece.renderOrder = 0;
}

- (void) setHaveShadow:(BOOL) aHaveShadow {
	
	for (Piece* piece in pieces) {
		piece.haveShadow = aHaveShadow;
	}
}

// クリックまたはひっつく
// ピース以外からドラッグした場合に、ピースに触れたらドラッグを開始する
- (void) pullingPiece:(UITouch*)touch view:(UIView*)aView {
	
	CGPoint location = [touch locationInView:aView];
	location.y = 480 - location.y;

	// 上から順にチェックする
	NSComparisonResult sortOrder = NSOrderedAscending;
	NSArray *sortedPieces = [pieces sortedArrayUsingFunction:comparator context:&sortOrder];
	for(Piece* piece in sortedPieces) {

		// アクティブ以外は無処理
		if (PieceStatusActivated != piece.status) {
			continue;
		}
		
		// ピースの半径の外の場合は無処理
		if ([piece isStillOutside:location]) {
			continue;
		}

		// タッチできたらその瞬間に最前面
		[self bringToFront:piece];

		piece.isDragging = YES;

		// タイムスタンプ保存
		piece.last1TouchTimestamp = touch.timestamp;
		piece.lastTouchTime = CFAbsoluteTimeGetCurrent();
		
		// reset
		piece.last1X = location.x;
		piece.last1Y = location.y;
		piece.speed = 0.0;
		piece.rotateVelocity = 0.0;
		
		// ドラッグピースを設定
		[drugingPieces setObject:piece forKey:[NSValue valueWithPointer:touch]];  

//		[_sharedSoundManager playSoundWithKey:@"poi" gain:0.01 pitch:1.5f location:Vector2fMake(piece.position.x, 0) shouldLoop:NO sourceID:-1];
		
		return;
	}
}

- (void)collisionDetection {
	int max = [pieces count];
	for (int i = 0; i < max; i++) {
		for (int j = i+1; j < max; j++) {
			
			Piece* ii = [pieces objectAtIndex:i];
			Piece* jj = [pieces objectAtIndex:j];
			
			if(ii._pieceType != jj._pieceType) {
				continue;
			}
			
			float dx = ii.position.x - jj.position.x;
			float dy = ii.position.y - jj.position.y;
			float theDistance = sqrt(dx * dx + dy * dy);
			
			if (theDistance < 16) {
				[delegate explode:ii];
			}
		}
	}
}

- (void)updateWithTouchLocationMoved:(NSSet*)touches withEvent:(UIEvent*)event view:(UIView*)aView {

	for(UITouch* touch in touches) {  
		
		CGPoint theLocation = [touch locationInView:aView];
		
		// Flip the y location ready to check it against OpenGL coordinates
		theLocation.y = 480 - theLocation.y;
		
		// ドラッグピースがある場合
		Piece* thePiece = [drugingPieces objectForKey:[NSValue valueWithPointer:touch]];
		if (thePiece) {

			if (_configurations.config.isClearCover) {
				
				// ドラッグエリア外は無処理
				if (!CGRectContainsPoint(_configurations.config.dragArea, theLocation)) {
					
					[thePiece setFlickMovement:touch view:aView speed:_configurations.config.flickReleaseSpeed];
					
					thePiece.isDragging = NO;
				}
			}
			
			// 衝突ではなれた場合はひっつき終了
			// （指が外に出た場合、touchesEndedとなり、フリック移動する）
			if (NO == thePiece.isDragging) {
				
				NSValue* value = [NSValue valueWithPointer:touch];
				[drugingPieces removeObjectForKey:value]; 
				
				return;
			}

			thePiece.last2TouchTimestamp = thePiece.last1TouchTimestamp;
			thePiece.last1TouchTimestamp = touch.timestamp;

			thePiece.lastTouchTime = CFAbsoluteTimeGetCurrent();

			[thePiece updateWithTouchLocationMoved:theLocation];
			
		}
		else {
			// ひっつき（外からドラッグ）
			[self pullingPiece:touch view:aView];
		}
	}
}

@end
