
#import <Foundation/Foundation.h>
#import "JArray.h"

NS_ASSUME_NONNULL_BEGIN

@interface JObject : NSObject
{
    NSMutableDictionary *_md;
}

-(instancetype)initWithDic:(NSMutableDictionary *) md;
-(int)getInt:(NSString *)key;
-(NSString *)getString:(NSString *)key;
-(BOOL)getBool:(NSString *)key;
-(JArray *)getJArray:(NSString *)key;
-(NSString *)toString;

@end

NS_ASSUME_NONNULL_END
