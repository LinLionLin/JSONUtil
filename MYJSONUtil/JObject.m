
#import "JObject.h"

@implementation JObject

-(instancetype)init
{
    if(self = [super init])
    {
        _md = [NSMutableDictionary dictionaryWithCapacity:5];
    }
    return self;
}

-(instancetype)initWithDic:(NSMutableDictionary *) md
{
    if(self = [super init])
    {
        _md = md;
    }
    return self;
}

-(int)getInt:(NSString *)key
{
    return [[_md valueForKey:key] intValue];
}

-(NSString *)getString:(NSString *)key
{
    return [_md valueForKey:key];
}

//-(BOOL)getBool:(NSString *)key
//{
//    //TODO:NSString转BOOl
//}

-(JArray *)getJArray:(NSString *)key
{
    return (JArray *)[_md valueForKey:key];
}

-(NSString *)toString
{
    NSMutableString *ms = [[NSMutableString alloc] init];
    [ms appendString:@"{ "];
    int size = (int) _md.count;
    for (id key in _md) {
        [ms appendString:(NSString *)key];
        [ms appendString:@" : "];
        [ms appendString:[_md valueForKey:key]];
        if (--size != 0) {
            [ms appendString:@", "];
        }
    }
    [ms appendString:@" }"];
    return (NSString *)ms;
}

@end
