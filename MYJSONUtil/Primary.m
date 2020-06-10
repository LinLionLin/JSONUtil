
#import "Primary.h"

@implementation Primary

-(instancetype)initWithValue:(NSString *)value
{
    if(self = [super init])
    {
        _value = value;
    }
    return self;
}

-(void)setValue:(NSString *)value
{
    _value = value;
}

-(NSString *)getValue
{
    return _value;
}


@end
