
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface JArray : NSObject
{
     NSMutableArray *_list;
}

-(instancetype)initWithList:(NSMutableArray *) list;
-(int)length;
-(void)add:(NSString *) json;
-(NSString *)get:(int) i;
-(NSString *)toString;

@end

NS_ASSUME_NONNULL_END
