#import "Score.h"

// 文字列グローバル変数
NSString    *KeyEnableSound = @"KeyEnableSound";
NSString    *KeyScores = @"KeyScores";

@implementation Score

@synthesize enableSound = enableSound_;
@synthesize scores = scores_;

- (id)init {
	
	if(self = [super init]) {

		enableSound_ = [[NSNumber alloc] init];
		scores_ = [[NSMutableArray alloc] init];

		for (int i = 0; i < 3; i++) {
			[scores_ addObject:[NSNumber numberWithInt:0]];
		}		
	}
	
	return self;
}

- (void)dealloc {
	
	[enableSound_ release];		
	[scores_ release];

	[super dealloc];
}

- (void)encodeWithCoder:(NSCoder*)coder {
	[coder encodeObject:self.enableSound forKey:KeyEnableSound];
	[coder encodeObject:self.scores forKey:KeyScores];
}

- (id)initWithCoder:(NSCoder*)coder {
	if ( (self = [super init]) ) {
		self.enableSound = [coder decodeObjectForKey:KeyEnableSound];
		self.scores = [coder decodeObjectForKey:KeyScores];
	}
	return self;
}

- (void)setScoreAtIndex:(int)aIndex withInt:(int)aScore {
	[scores_ replaceObjectAtIndex:aIndex withObject:[NSNumber numberWithInt:aScore]];
}

- (int)getScoreAtIndex:(int)aIndex {
	NSNumber* theNumber = [scores_ objectAtIndex:aIndex];
	int theInt = [theNumber intValue];
	return theInt;
}
	
@end
