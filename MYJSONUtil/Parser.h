
#import <Foundation/Foundation.h>
#import "Tokenizer.h"
#import "JObject.h"
#import "JArray.h"
#import "Primary.h"

NS_ASSUME_NONNULL_BEGIN

@interface Parser : NSObject
{
    Tokenizer *_tokenizer;
}

-(instancetype)initWithTokenizer:(Tokenizer *)tokenizer;
+(JObject *)parseJSONObject:(NSString *)s;
+(JArray *)parseJSONArray:(NSString *)s;
@end

NS_ASSUME_NONNULL_END
