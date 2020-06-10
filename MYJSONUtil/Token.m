

#import "Token.h"

@implementation Token

-(instancetype)initWithType:(TokenType)type :(NSString *)value
{
    if(self = [super init])
    {
        _type = type;
        _value = value;
    }
    return self;
}

@end
