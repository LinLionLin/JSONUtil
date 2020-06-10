
#import "Parser.h"

@implementation Parser

-(instancetype)initWithTokenizer:(Tokenizer *)tokenizer
{
    if(self = [super init])
    {
        _tokenizer = tokenizer;
    }
    return self;
}

+(JObject *)parseJSONObject:(NSString *)s
{
    Tokenizer *tokenizer = [[Tokenizer alloc] initWithReader:s];
    [tokenizer tokenize];
    Parser *parser = [[Parser alloc] initWithTokenizer:tokenizer];
    return [parser toObject];
}

+(JArray *)parseJSONArray:(NSString *)s
{
    Tokenizer *tokenizer = [[Tokenizer alloc] initWithReader:s];
    [tokenizer tokenize];
    Parser *parser = [[Parser alloc] initWithTokenizer:tokenizer];
    return [parser toArray];
}

-(JObject *)toObject
{
    [_tokenizer next];      // 消去{
    NSMutableDictionary *md = [NSMutableDictionary dictionaryWithCapacity:5];
    if ([self isToken:END_OBJ]) {
        [_tokenizer next];  // 消去}
        return [[JObject alloc] initWithDic:md];
    } else if ([self isToken:STRING]) {
        md = [self key:md];
    }
    return [[JObject alloc] initWithDic:md];
}

-(JArray *)toArray
{
    [_tokenizer next];  // 消去[
    NSMutableArray *list = [[NSMutableArray alloc] init];
    JArray *array = NULL;
    if ([self isToken:START_ARRAY]) {
        array = [self toArray];
        [list addObject:array];
        if ([self isToken:COMMA]) {
            [_tokenizer next]; // 消去,
            list = [self element:list];
        }
    } else if ([self isPrimary]) {
        list = [self element:list];
    } else if ([self isToken:START_OBJ]) {
        [list addObject:[self toObject]];
        while ([self isToken:COMMA]) {
            [_tokenizer next]; // 消去,
            [list addObject:[self toObject]];
        }
    } else if ([self isToken:END_ARRAY]) {
        [_tokenizer next]; // 消去]
        array = [[JArray alloc] initWithList:list];
        return array;
    }
    [_tokenizer next]; // 消去]
    array = [[JArray alloc] initWithList:list];
    return array;
}

-(NSMutableDictionary *)key:(NSMutableDictionary *)md
{
    NSString *key = [_tokenizer next].value;
    if (![self isToken:COLON]) {
        NSLog(@"Invalid JSON input.");
    } else {
        [_tokenizer next]; // 消去:
        if ([self isPrimary]) {
            Primary *primary = [[Primary alloc] initWithValue:[_tokenizer next].value];
            [md setValue:primary forKey:key];
        } else if ([self isToken:START_ARRAY]) {
            JArray *array = [self toArray];
            [md setValue:array forKey:key];
        }
        if ([self isToken:COMMA]) {
            [_tokenizer next]; // 消去,
            if ([self isToken:STRING]) {
                md = [self key:md];
            }
        } else if ([self isToken:END_OBJ]) {
            [_tokenizer next]; // 消去}
            return md;
        } else {
            NSLog(@"Invalid JSON input.");
        }
    }
    return md;
}

-(NSMutableArray *)element:(NSMutableArray *)list
{
    [list addObject:[[Primary alloc] initWithValue:[_tokenizer next].value]];
    if ([self isToken:COMMA]) {
        [_tokenizer next]; // 消去,
        if ([self isPrimary]) {
            list = [self element:list];
        } else if ([self isToken:START_OBJ]) {
            [list addObject:[self toObject]];
        } else if ([self isToken:START_ARRAY]) {
            [list addObject:[self toArray]];
        } else {
            NSLog(@"Invalid JSON input.");
        }
    } else if ([self isToken:END_ARRAY]) {
        return list;
    } else {
        NSLog(@"Invalid JSON input.");
    }
    return list;
}

-(BOOL)isPrimary
{
    TokenType type = [_tokenizer peek:0].type;
    return type == BOOLEAN || type == NULL_VALUE ||
            type == NUMBER || type == STRING;
}

-(BOOL)isToken:(TokenType)tokenType
{
    Token *t = [_tokenizer peek:0];
    return t.type == tokenType;
}


@end
