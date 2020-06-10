
#import "JArray.h"

@implementation JArray

-(instancetype)init
{
    if(self = [super init])
    {
        _list = [[NSMutableArray alloc] init];
    }
    return self;
}

-(instancetype)initWithList:(NSMutableArray *) list
{
    if(self = [super init])
    {
        _list = list;
    }
    return self;
}

-(int)length
{
    return (int)_list.count;
}

-(void)add:(NSString *) json
{
    [_list addObject:json];
}

-(NSString *)get:(int) i
{
    return [_list objectAtIndex:i];
}

-(NSString *)toString
{
    NSMutableString *ms = [[NSMutableString alloc] init];
    [ms appendString:@"[ "];
    for (int i =0; i < _list.count; i++) {
        [ms appendString:[_list objectAtIndex:i]];
        if (i != _list.count - 1) {
            [ms appendString:@", "];
        }
    }
    [ms appendString:@" ]"];
    return (NSString *)ms;
}

@end
