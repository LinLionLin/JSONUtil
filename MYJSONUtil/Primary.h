
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Primary : NSObject
{
    NSString *_value;
}

-(instancetype)initWithValue:(NSString *)value;
-(void)setValue:(NSString *)value;
-(NSString *)getValue;

@end

NS_ASSUME_NONNULL_END
