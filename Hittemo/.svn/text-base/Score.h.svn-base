@interface Score : NSObject <NSCoding>
{
@private
	NSNumber* enableSound_;
	NSMutableArray* scores_;
}

// 重要 copy しなければならない
@property(nonatomic, copy) NSNumber* enableSound;
@property(nonatomic, copy) NSMutableArray* scores;

- (void)setScoreAtIndex:(int)aIndex withInt:(int)aScore;
- (int)getScoreAtIndex:(int)aIndex;
	
@end
