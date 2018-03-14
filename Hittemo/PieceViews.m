#import "Pieces.h"

@implementation Pieces
//
//@synthesize delegate;
//@synthesize status;
//@synthesize drugingPiece;

- (id)initWithDelegate:(id) aDelegate {
	
	if (self = [super init]) { 
		
		configurations = [Configurations instance];

		pieces = [[NSMutableArray alloc] init];
		
//		delegate = aDelegate;
	}
	
	return self;
}

- (void)addPieceWithBaseImage:(NSString*)baseImage shadowImage:(NSString*) shadowImage {
	Piece *thePiece;
	thePiece = [[Piece alloc] initWithImage:baseImage 
								shadowImage:shadowImage
								   Location:Vector2fMake(160, 240)];
	[thePiece setSpeed:5.0];
	[thePiece setAngle:(int)(360 * RANDOM_0_TO_1()) % 360];
	
	[pieces addObject:thePiece];
	[thePiece release];
}

- (void)update:(GLfloat)delta {

	for(AbstractEntity *entity in pieces) {
		[entity update:delta];
	}
}

- (void)render {
	
	for(AbstractEntity *entity in pieces) {
		[entity render];
	}
}


// piceViewsクリア
//- (void) reset {
//	[pieceViews removeAllObjects];
//}

//// ピース出現
//- (void) appear {
//
//	status = PieceViewsStatusAppeared;
//	
//	for (PieceView* pieceView in pieceViews){
//		[pieceView appear];
//	}
//}
//
//// ピース稼働
//- (void) startMoving {
//	for (PieceView* pieceView in pieceViews) {
//		if (PieceViewStatusStartedMoving != pieceView.status) {
//			[pieceView startMoving];
//		}
//	}
//}
//
//- (void) activate {
//	
//	status = PieceViewsStatusActivated;
//
//	for (PieceView* pieceView in pieceViews) {
//		if (PieceViewStatusStartedMoving == pieceView.status) {
//			[pieceView activate];
//		}
//	}
//}
//
//- (void) setUpPieceView: (PieceType*) pieceType {
//	
//	PieceView *pieceView;
//	UIImage* baseImage = pieceType.baseImage;
//	CGRect frame = CGRectMake(0, 0, baseImage.size.width, baseImage.size.height);
//	pieceView = [[PieceView alloc] initWithFrame:frame];
//	
//	pieceView.delegate = self;
//	UIView* mainView = (UIView*) delegate;
//	
//	pieceType.referenceCount++;
//	
//	
//	pieceView.pieceType = pieceType;
//
//	pieceView.outerBounds = CGRectMake(mainView.bounds.origin.x + baseImage.size.width / 2 - pieceType.margin,
//									   mainView.bounds.origin.y + baseImage.size.height / 2 - pieceType.margin,
//									   mainView.bounds.size.width - ((baseImage.size.width / 2 - pieceType.margin) * 2),
//									   mainView.bounds.size.height - ((baseImage.size.height / 2 - pieceType.margin) * 2));
//	pieceView.pieceBaseImage = baseImage;
//	pieceView.pieceShadowImage = pieceType.shadowImage;
//	
//	[pieceView initViews];
//	
//	[pieceViewsLayer addSubview:pieceView];
//	[pieceViews addObject:pieceView];
//	[pieceView release];
//}
//
//// ひっつく
//// ピース以外からドラッグした場合に、ピースに触れたらドラッグを開始する
//- (void) pullingPiece:(CGPoint) location {
//	
//	for (PieceView* pieceView in pieceViews){
//		if (PieceViewStatusActivated == pieceView.status) {
//			
//			// ピースの半径の外の場合は無処理
//			if ([pieceView isStillOutside:location]) {
//				continue;
//			}
//
//			// todo いらない？
//			pieceView.isDragging = YES;
//			
//			// reset
//			pieceView.movement = CGPointMake(0.0f, 0.0f);
//			
//			drugingPiece = pieceView;
//			[drugingPiece setLastLocation:location];
//			[pieceViewsLayer bringSubviewToFront:drugingPiece];
//			return;
//		}
//	}
//	
//	drugingPiece = nil;
//	return;
//}
//
//- (void) pickAt:(CGPoint) location {
//
//	for (PieceView* pieceView in pieceViews){
//		if (PieceViewStatusActivated == pieceView.status) {
//			// ピース半径
//			float radius = (pieceView.bounds.size.width - pieceView.pieceType.margin * 2) / 2;
//			CGFloat dx = location.x - pieceView.center.x;
//			CGFloat dy = location.y - pieceView.center.y;
//			float distanceToCenter = sqrt((dx * dx) + (dy * dy));
//			float distanceToMove = radius - distanceToCenter;
//			if (0.0f > distanceToMove) {
//				continue;
//			}
//			
//			// todo ドラッグとピースの速度を使って衝突判定する
//			
//			CGFloat acosResult = acos(dx / distanceToCenter);
//			CGFloat asinResult = asin(dy / distanceToCenter);
//			CGFloat mx = dx * cos(acosResult) * ((dx > 0)? -1 : 1);
//			CGFloat my = dy * sin(asinResult) * ((dy > 0)? -1 : 1);
//			
//			pieceView.movement = CGPointMake(5 * mx / configurations.config.timeIntervalInverse , 5 * my / configurations.config.timeIntervalInverse );
//		}
//	}
//}
//
//- (int) aliveCount {
//	int pieceCount = 0;
//	for (PieceView* pieceView in pieceViews){
//		if (PieceViewStatusActivated == pieceView.status) {
//			pieceCount++;
//		}
//	}
//	return pieceCount;
//}
//
//// 加速度センサー対応
//- (void) applyAcceralation:(CGPoint) accelVector {
//	
//	for (PieceView* pieceView in pieceViews){
//
//		// 移動
//		if (PieceViewStatusStartedMoving == pieceView.status ||
//			PieceViewStatusRomping == pieceView.status ||
//			PieceViewStatusActivated == pieceView.status) {
//			
//			[pieceView applyAcceralation:accelVector];
////			BOOL isCatchAttraction = [pieceView applyAcceralation:accelVector];
////			if (isCatchAttraction && pieceView == drugingPiece) {
////				drugingPiece = nil;
////			}
//		}
//
//		// ゴールチェック
//		if (PieceViewStatusActivated == pieceView.status) {
//			
//			// ドラッグ中は必ずチェック
//			if (pieceView.isDragging) {
//				if ([pieceView checkDrugGoal]) {
//
//					[pieceView moveToTarget];
//				}
//			}
//			else {
//			// 低速時にゴール判定を行う
////			else if (0.1f < configurations.config.speedToTargetMin) {
//				// 止まっている時のみゴールチェック
////				if (configurations.config.speedToTargetMin > (pieceView.movement.x * pieceView.movement.x + pieceView.movement.y * pieceView.movement.y)) {
//					if ([pieceView checkMovingGoal]) {
//						
//						[pieceView moveToTarget];
//					}
////				}
////			}
//			}
//		}
//	}
//}
//
//- (void) dealloc {
//
//	for (PieceView* pieceView in pieceViews){
//		[pieceView release];
//	}	
//
//	[pieceViewsLayer release];
//	[pieceViews release];
//	
//	[super dealloc];
//}
//
//- (void) stageClear {
//	
//	// 一つでもターゲットに到達していない場合は無処理
//	for (PieceView* pieceView in pieceViews) {
//		if (PieceViewStatusGoal != pieceView.status) {
//			return;
//		}
//	}
//
//	// ネクストステージ、レベル
//	if ([configurations isLastStage]) {
//		[configurations setNextLevel];
//		didLevelClear = YES;
//	}
//	// ネクストステージ、レベル
//	else {
//		[configurations setNextStage];
//	}
//		
//	// すべて到達した
//	// 最終ステージをクリア
//	if (didLevelClear) {
//		
//		// レベルクリア		
//		[delegate startlevelClearAnimation];
//		
//		// todo afterDelayを入れるとRompoingが止まる
//		[self performSelector:@selector(setBackButtonOn) withObject:self];
//				
//		// アイコンパレード
//		int no = 0;
//		for (PieceView* pieceView in pieceViews) {
//			[pieceView startRompingAt:no];
//			no++;
//		}
//		status = PieceViewsStatusRomping;
//		didLevelClear = NO;
//
//		return;
//	}
//	
//	[self performSelector:@selector(stageCleared) withObject:self afterDelay:1.0];
//}
//
//- (void) stageCleared {
//	[delegate stageAppear];
//}
//
//- (void) setStartButtonOn {
//	[delegate setStartButtonOn];
//}
//
//- (void) setBackButtonOn {
//	[delegate setBackButtonOn];
//}
//
//- (void) playBangSound:(float) volume  {
//	[delegate playBangSound:volume];
//}
//
//- (void) playHitSound:(float) volume  {
//	[delegate playHitSound:volume];
//}
//
//- (void) playGoalSound:(float) volume  {
//	[delegate playGoalSound:volume];
//}
//
@end
