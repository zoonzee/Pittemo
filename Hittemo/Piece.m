#import "Piece.h"
#import "GameScene.h"

@implementation Piece

#define kDurationToDesapear 1.0	// ゴールして消える時間

@synthesize renderOrder;
@synthesize status;
@synthesize angle;
@synthesize speed;
@synthesize minX;
@synthesize minY;
@synthesize maxX;
@synthesize maxY;
@synthesize rotateVelocity;
//@synthesize status;
@synthesize isDragging;
@synthesize haveShadow;
@synthesize last1TouchTimestamp;
@synthesize last2TouchTimestamp;
@synthesize lastTouchTime;
@synthesize last1X;
@synthesize last1Y;
@synthesize _pieceType;

- (void)dealloc {
    [super dealloc];
}

- (id)initWithPieceType:(PieceType*)aPieceType delegate:(id) aDelegate{

    self = [super init];
	
	if (self != nil) {
        _sharedDirector = [Director sharedDirector];
//		_sharedSoundManager = [SoundManager sharedSoundManager];
		_configurations = [Configurations instance];
		
		delegate = aDelegate;
		
		_pieceType = aPieceType;
		status = PieceStatusIdol;

		image = [[Image alloc] initWithImage:_pieceType.baseImageName scale:1.0];
		shadowImage = [[Image alloc] initWithImage:_pieceType.shadowImageName scale:1.0];
        
        // Set the actors location to the vector location which was passed in
        position.x = rand() % 320;
        position.y = 450;
		alpha = 1.0;
		scale = 1.0;
        angle = 0.0;
        speed = 0.0;
		rotation = 0.0;
		isDragging = NO;
		haveShadow = NO;
		
		[image setColourFilterRed:_pieceType.color.red 
							green:_pieceType.color.green 
							 blue:_pieceType.color.blue 
							alpha:_pieceType.color.alpha];

		// ピースの中心位置が移動できる範囲
		minX = _configurations.config.bounds.origin.x + 15;
		minY = _configurations.config.bounds.origin.y + 15;
		maxX = _configurations.config.bounds.origin.x + _configurations.config.bounds.size.width - 15;
		maxY = _configurations.config.bounds.origin.x + _configurations.config.bounds.size.height - 15;
    }
    return self;
}

- (void)updateWithDelta:(GLfloat)aDelta {
	
	// ドラッグ中は無処理
	if (isDragging) {
		return;
	};

	float theRotation;
	
	// 移動量計算
	float dx = speed * cos(DEGREES_TO_RADIANS(angle));
	float dy = speed * sin(DEGREES_TO_RADIANS(angle));	

	// 重力による移動量（スピード、角度）変化
	if (status == PieceStatusActivated && _configurations.config.gravity != 0.0) {
		dy -= aDelta * _configurations.config.gravity;
		speed = sqrt(dx * dx + dy * dy);
		angle = 180.0 * atan2f(dy, dx) / M_PI ;
	}	

	// 移動量適応
    position.x += dx;
    position.y += dy;

	// 衝突軸角度
	float reflectionAxis = -1.0f;

	// 衝突判定と、衝突軸角度の設定
	// 0は右方向。
	if (position.x < minX) {
		reflectionAxis = 180.0f;
		position.x = minX;
	}
	else if (maxX < position.x) {
		reflectionAxis = 0.0f;
		position.x = maxX;
	}
	else if (position.y < minY) {
		reflectionAxis = -90.0f;
		position.y = minY;
	}	
	else if (maxY < position.y) {
		reflectionAxis = 90.0f;
		position.y = maxY;
	}
	
	// 衝突した場合
	if (-1.0f != reflectionAxis) {
		
		// 回転角度（衝突軸角度との差分）
		theRotation = reflectionAxis - angle;

		// -180 〜 180 度に修正
		theRotation = NearestAngle(theRotation);
		
		// 回転適用率を設定
		rotateVelocity -= theRotation * _configurations.config.rotationRate * speed;

		// 反射角度設定
		angle = theRotation + reflectionAxis + 180.0f;
		
		// 音量を速度から算出
		float theGain = speed * kSoundSpeedRate;
		if (1.0 < theGain) {
			theGain = 1.0;
		}
		
		// 衝突による速度倍率
		float frameRateRate = aDelta * 60.0;
		speed -= speed * _configurations.config.hitBrakeRate * frameRateRate;
	
		[_sharedSoundManager playSoundWithKey:@"hit2" gain:theGain pitch:1.0f location:Vector2fMake(position.x, 0) shouldLoop:NO sourceID:-1];
	}


	// -180 〜 180 度に修正
	theRotation = NearestAngle(rotation);
	
	theRotation += rotateVelocity;
	
	// 回転適応
	rotation = theRotation;
	
	// ステータスによる更新
	switch (status) {
			
		case PieceStatusIdol:
			break;

		// スタート
		case PieceStatusActivate:
			
			speed = _configurations.config.initialSpeed;
			angle = ((int)(360 * RANDOM_0_TO_1())) % 360;

			status = PieceStatusActivated;
			break;

		// 稼働
		case PieceStatusActivated:

			// 回転減少
			rotateVelocity *= 0.99f;
						
			// 移動減衰
			// todo フレームレートが低い場合でも減衰が変わらないか検証する
			// todo 最大60fpsは、EAGLViewで固定＞defineする
			// フレームレートのレート
			float frameRateRate = aDelta * 60.0;
			speed -= speed * _configurations.config.brakeRate * frameRateRate;
			
			break;
			
		case PieceStatusToGoal:
			[_sharedSoundManager playSoundWithKey:@"itmget" gain:1.0f pitch:1.0f location:Vector2fZero shouldLoop:NO sourceID:-1];
			status = PieceStatusGoal;
//			[delegate goal:self];
			haveShadow = NO;
			
			break;

		case PieceStatusGoal:
			
			alpha = 0;
			// todo リストから削除
			
			break;
	}
	
}

- (void)render {
	
	[image setAlpha:alpha];
	[image setScale:scale];
	[image setRotation:rotation];
	[image renderAtPoint:CGPointMake(position.x, position.y) centerOfImage:YES];
}

// ポイントがピースの外側の場合は真
- (BOOL) isStillOutside:(CGPoint) location {
	
	// ピース半径
	float radius = (image.imageWidth - margin * 2) / 2;
	float dx = location.x - position.x;
	float dy = location.y - position.y;
	float distanceToCenter = sqrt((dx * dx) + (dy * dy));
	
	// ピースの半径の外の場合は真
	if ((radius + _configurations.config.radiusExtention) < distanceToCenter) {
		return YES;
	}
	return NO;
}

- (void)updateWithTouchLocationMoved:(CGPoint)theLocation {

	// エッジ回転
	
	// 前回のタッチ位置の中心からの角度
	float lastXToCenter = last1X - position.x;
	float lastYToCenter = last1Y - position.y;
	float lastAngle = 180.0 * atan2f(lastYToCenter, lastXToCenter) / M_PI ;
	// todo 同じ処理がある。最適化
	float distanceToCenter = sqrt((lastXToCenter * lastXToCenter) + (lastYToCenter * lastYToCenter));
	
#define edgeMinRadius 25.0
	
	// エッジ最小値チェック
	if (edgeMinRadius < distanceToCenter) {
		
		// 今回のタッチ位置の中心からの角度
		float newXToCenter = theLocation.x - position.x;
		float newYToCenter = theLocation.y - position.y;
		float newAngle = 180.0 * atan2f(newYToCenter, newXToCenter) / M_PI ;
		
		float newRotate = lastAngle - newAngle;
		rotation += newRotate;
		rotation = NearestAngle(rotation);
		
		last2X = last1X;
		last2Y = last1Y;
		last1X = theLocation.x;
		last1Y = theLocation.y;
		
		// 移動直線上に中心を移動
		theLocation.x = theLocation.x - (distanceToCenter * cos(DEGREES_TO_RADIANS(newAngle)));
		theLocation.y = theLocation.y - (distanceToCenter * sin(DEGREES_TO_RADIANS(newAngle)));
		
		position = Vector2fMake(theLocation.x, theLocation.y);
	}
	else {
		// 通常のドラッグ
		position.x = theLocation.x - (last1X - position.x);
		position.y = theLocation.y - (last1Y - position.y);

		last2X = last1X;
		last2Y = last1Y;
		last1X = theLocation.x;
		last1Y = theLocation.y;
	}		
}

// フリック移動の計算
- (void) setFlickMovement:(UITouch*) touch view:(UIView*)aView speed:(float) theSpeed{
	
	isDragging = NO;
	
//	NSTimeInterval touchDelta0 = touch.timestamp - last1TouchTimestamp;
//	NSLog(@"%f", touchDelta0);
	
//	NSLog(@"delta-%f", CFAbsoluteTimeGetCurrent() - lastTouchTime);

	
	NSTimeInterval touchDelta = last1TouchTimestamp - last2TouchTimestamp;
	
	float dx = last1X - last2X;
	float dy = last1Y - last2Y;	

	// 瞬時でない、かつ、時間が短い場合のみ移動する
	// todo config
//	if (0.0 != touchDelta && 0.5 > touchDelta) {
	if (0.0 != touchDelta && 0.2 > (CFAbsoluteTimeGetCurrent() - lastTouchTime)) {
		speed = (sqrt(dx * dx + dy * dy) * theSpeed) / touchDelta;
	}
	else {
		speed = 0.0;
	}
	
	// 最大速度を制限
	if (_configurations.config.maxSpeed < speed) {
		speed = _configurations.config.maxSpeed;
	}
	angle = 180.0 * atan2f(dy, dx) / M_PI ;
	
	float theGain = speed / 40.0f;
	if (0.05 < theGain) {
		theGain = 0.05;
	}	
	
	[_sharedSoundManager playSoundWithKey:@"poi" gain:theGain pitch:1.0f location:Vector2fMake(last1X, 0) shouldLoop:NO sourceID:-1];
}

@end

