
#import "Tokenizer.h"

@implementation Tokenizer

-(instancetype)init
{
    if(self = [super init])
    {
        _tokens = [[NSMutableArray alloc] init];
        _isUnread = NO;
        _currentIndex = 0;
        _readerSize = 0;
    }
    return self;
}

-(instancetype)initWithReader:(NSString *)reader
{
    if(self = [super init])
    {
        _reader = reader;
        _readerSize = (int)reader.length;
    }
    return self;
}

-(NSMutableArray *)getTokens
{
    return _tokens;
}

-(void)tokenize
{
    Token *token;
    do{
        token = [self start];
        [_tokens addObject:token];
    } while (token.type != END_DOC);
}

-(Token *)start
{
    _c = '?';
    Token *token = NULL;
    do{
        _c = [self read];
    } while ([self isSpace:_c]);
    if ([self isNull:_c]) {
        return [[Token alloc] initWithType:NULL_VALUE :NULL];
    } else if (_c == ',') {
        return [[Token alloc] initWithType:COMMA :@","];
    } else if (_c == ':') {
        return [[Token alloc] initWithType:COLON :@":"];
    } else if (_c == '{') {
        return [[Token alloc] initWithType:START_OBJ :@"{"];
    } else if (_c == '[') {
        return [[Token alloc] initWithType:START_ARRAY :@"["];
    } else if (_c == ']') {
        return [[Token alloc] initWithType:END_ARRAY :@"]"];
    } else if (_c == '}') {
        return [[Token alloc] initWithType:END_OBJ :@"}"];
    } else if ([self isTrue:_c]) {
        return [[Token alloc] initWithType:BOOLEAN :@"true"];
    } else if ([self isFalse:_c]) {
        return [[Token alloc] initWithType:BOOLEAN :@"false"];
    } else if (_c == '"') {
        return [self readString];
    } else if ([self isNum:_c]) {
        [self unread];
        return [self readNum];
    } else if (_c == -1) {
        return [[Token alloc] initWithType:END_DOC :@"EOF"];
    } else {
        NSLog(@"Invalid JSON input.");
    }
    return token;
}

-(int)read
{
    if(!_isUnread)
    {
        if(_currentIndex < _readerSize)
        {
            NSString *s = [_reader substringWithRange:NSMakeRange(_currentIndex, 1)];   //第i个字符
            const char * myCstring = [s cString];
            int c = (int)myCstring[0];
            _currentIndex++;
            _savedChar = c;
            return c;
        }
        else
        {
            return -1;
        }
    }
    else
    {
        _isUnread = NO;
        return _savedChar;
    }
}


-(BOOL)isSpace:(int)c
{
    return c >= 0 && c <= ' ';
}

-(BOOL)isNull:(int)c
{
    if (c == 'n') {
        c = [self read];
        if (c == 'u') {
            c = [self read];
            if (c == 'l') {
                c = [self read];
                if (c == 'l') {
                    return YES;
                } else {
                    NSLog(@"Invalid JSON input.");
                    return NO;
                }
            } else {
                NSLog(@"Invalid JSON input.");
                return NO;
            }
        } else {
            NSLog(@"Invalid JSON input.");
            return NO;
        }
    } else {
        return NO;
    }
}

-(BOOL)isTrue:(int)c
{
    if (c == 't') {
        c = [self read];
        if (c == 'r') {
            c = [self read];
            if (c == 'u') {
                c = [self read];
                if (c == 'e') {
                    return YES;
                } else {
                    NSLog(@"Invalid JSON input.");
                    return NO;
                }
            } else {
                NSLog(@"Invalid JSON input.");
                return NO;
            }
        } else {
            NSLog(@"Invalid JSON input.");
            return NO;
        }
    } else {
        return NO;
    }
}

-(BOOL)isFalse:(int)c
{
    if (c == 'f') {
        c = [self read];
        if (c == 'a') {
            c = [self read];
            if (c == 'l') {
                c = [self read];
                if (c == 's') {
                    c = [self read];
                    if (c == 'e') {
                        return YES;
                    } else {
                        NSLog(@"Invalid JSON input.");
                        return NO;
                    }
                } else {
                    NSLog(@"Invalid JSON input.");
                    return NO;
                }
            } else {
                NSLog(@"Invalid JSON input.");
                return NO;
            }
        } else {
            NSLog(@"Invalid JSON input.");
            return NO;
        }
    } else {
        return NO;
    }
}

-(BOOL)isNum:(int)c
{
    return [self isDigit:c] || c == '-';
}

-(BOOL)isDigit:(int)c
{
    return c >= '0' && c <= '9';
}

-(Token *)readString
{
    NSMutableString *ms = [[NSMutableString alloc]init];
    while (true) {
        _c = [self read];
        if ([self isEscape]) {    //判断是否为\", \\, \/, \b, \f, \n, \t, \r.
            if (_c == 'u') {
                [ms appendString:@"\\"];
                [ms appendString:[NSString stringWithFormat:@"%d",_c]];
                for (int i = 0; i < 4; i++) {
                    _c = [self read];
                    if ([self isHex:_c]) {
                        [ms appendString:[NSString stringWithFormat:@"%d",_c]];
                    } else {
                        NSLog(@"Invalid JSON input.");
                    }
                }
            } else {
                [ms appendString:@"\\"];
                [ms appendString:[NSString stringWithFormat:@"%d",_c]];
            }
        } else if (_c == '"') {
            return [[Token alloc] initWithType:STRING:(NSString *) ms];
        } else if (_c == '\r' || _c == '\n'){
            NSLog(@"Invalid JSON input.");
        } else {
            [ms appendString:[NSString stringWithFormat:@"%d",_c]];
        }
    }
}

-(BOOL) isEscape
{
    if (_c == '\\') {
        _c = [self read];
        if (_c == '"' || _c == '\\' || _c == '/' || _c == 'b' ||
                _c == 'f' || _c == 'n' || _c == 't' || _c == 'r' || _c == 'u') {
            return YES;
        } else {
            NSLog(@"Invalid JSON input.");
            return NO;
        }
    } else {
        return NO;
    }
}

-(BOOL) isHex:(int) c
{
    return (c >= '0' && c <= '9') || (c >= 'a' && c <= 'f') ||
    (c >= 'A' && c <= 'F');
}

-(void) unread
{
    _isUnread = YES;
}

-(Token *)readNum
{
    NSMutableString *ms = [[NSMutableString alloc] init];
    int c = [self read];
    if (c == '-') { //-
        [ms appendString:[NSString stringWithFormat:@"%d",c]];
        c = [self read];
        if (c == '0') { //-0
            [ms appendString:[NSString stringWithFormat:@"%d",c]];
            [self numAppend:ms];
        } else if ([self isDigitOne2Nine:c]) { //-digit1-9
            do {
                [ms appendString:[NSString stringWithFormat:@"%d",c]];
                c = [self read];
            } while ([self isDigit:c]);
            [self unread];
            [self numAppend:ms];
        } else {
            NSLog(@"Invalid JSON input.");
        }
    } else if (c == '0') { //0
        [ms appendString:[NSString stringWithFormat:@"%d",c]];
        [self numAppend:ms];
    } else if ([self isDigitOne2Nine:c]) { //digit1-9
        do {
            [ms appendString:[NSString stringWithFormat:@"%d",c]];
            c = [self read];
        } while ([self isDigit:c]);
        [self unread];
        [self numAppend:ms];
    }
    return [[Token alloc] initWithType:NUMBER:(NSString *) ms];
}

-(void) numAppend:(NSMutableString *) ms
{
    _c = [self read];
    if (_c == '.') { //int frac
        [ms appendString:[NSString stringWithFormat:@"%d",_c]]; //.
        [self appendFrac:ms];
        if ([self isExp:_c]) { //int frac exp
            [ms appendString:[NSString stringWithFormat:@"%d",_c]]; // e或者E;
            [self appendExp:ms];
        }

    } else if ([self isExp:_c]) { // int exp
        [ms appendString:[NSString stringWithFormat:@"%d",_c]]; // e或者E;
        [self appendExp:ms];
    } else {
        [self unread];
    }
}

-(BOOL) isDigitOne2Nine:(int) c
{
    return c >= '1' && c <= '9';
}

-(void) appendFrac:(NSMutableString *)ms
{
    _c = [self read];
    while ([self isDigit:_c]) {
       [ms appendString:[NSString stringWithFormat:@"%d",_c]];
        _c = [self read];
    }
}

-(void) appendExp:(NSMutableString *)ms
{
    int c = [self read];
    if (c == '+' || c == '-') {
        [ms appendString:[NSString stringWithFormat:@"%d",c]]; //+或者-;
        c = [self read];
        if (![self isDigit:c]) {
            NSLog(@"e+(-) or E+(-) not followed by digit");
        } else { //e+(-) digit
            do {
                [ms appendString:[NSString stringWithFormat:@"%d",c]];
                c = [self read];
            } while ([self isDigit:c]);
            [self unread];
        }
    } else if (![self isDigit:c]) {
        NSLog(@"e or E not followed by + or - or digit.");
    } else { //e digit
        do {
            [ms appendString:[NSString stringWithFormat:@"%d",c]];
            c = [self read];
        } while ([self isDigit:c]);
        [self unread];
    }
}

-(BOOL) isExp:(int) c
{
    return c == 'e' || c == 'E';
}

-(Token *)next
{
    Token * token = [_tokens objectAtIndex:0];
    [_tokens removeObjectAtIndex:0];
    return token;
}

-(Token *)peek:(int) i
{
    return [_tokens objectAtIndex:i];
}

-(BOOL)hasNext
{
    return ((Token *)[_tokens objectAtIndex:0]).type != END_DOC;
}

@end
