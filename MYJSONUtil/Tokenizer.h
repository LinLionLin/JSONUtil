
#import <Foundation/Foundation.h>
#import "Token.h"

NS_ASSUME_NONNULL_BEGIN

@interface Tokenizer : NSObject
{
    NSMutableArray *_tokens;
    NSString *_reader;
    BOOL _isUnread;
    int _savedChar;
    int _c; // 最近读取的字符
    int _currentIndex;
    int _readerSize;
}

-(instancetype)initWithReader:(NSString *) reader;
-(NSMutableArray *)getTokens;
-(void)tokenize;
-(Token *)next;
-(Token *)peek:(int) i;
-(BOOL)hasNext;

@end

NS_ASSUME_NONNULL_END
