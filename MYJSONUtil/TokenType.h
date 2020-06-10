
#ifndef TokenType_h
#define TokenType_h

typedef enum TokenType{
    START_OBJ,  // {
    END_OBJ,    // }
    START_ARRAY,// [
    END_ARRAY,  // ]
    NULL_VALUE, // null
    NUMBER,     // 数字字面量
    STRING,     // 字符字面量
    BOOLEAN,    // true false
    COLON,      // :
    COMMA,      // ,
    END_DOC     // 表示json数据的结束
} TokenType;

#endif /* TokenType_h */
