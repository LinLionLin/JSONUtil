
#import <Foundation/Foundation.h>
#import "TokenType.h"

NS_ASSUME_NONNULL_BEGIN

@interface Token : NSObject

@property TokenType type;
@property NSString *value;

-(instancetype)initWithType:(TokenType) type :(NSString *)value;

@end

NS_ASSUME_NONNULL_END
