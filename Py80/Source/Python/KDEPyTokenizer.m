//
//  KDEPyTokenizer.m
//  Py80
//
//  Created by Benjamin S Hopkins on 6/8/15.
//  Copyright (c) 2015 kode80. All rights reserved.
//

#import "KDEPyTokenizer.h"
#import "KDETokenizePhase.h"
#import "NSRegularExpression+PatternUtils.h"


@implementation KDEPyTokenizer

- (instancetype) init
{
    self = [super init];
    if( self)
    {
        [self addTokenizePhase:[KDETokenizePhase tokenizePhaseWithRegexPattern:@"#[^\r\n]*"
                                                              defaultTokenType:KDEPyTokenTypeComment
                                                                  tokenTypeMap:nil]];
        
        
        [self addTokenizePhase:[KDETokenizePhase tokenizePhaseWithRegexPattern:[KDEPyTokenizer pythonDocStringPattern]
                                                              defaultTokenType:KDEPyTokenTypeDocString
                                                                  tokenTypeMap:nil]];
        
        [self addTokenizePhase:[KDETokenizePhase tokenizePhaseWithRegexPattern:@"(?i)((ur|br|r|b|u)*'''|(ur|br|r|b|u)*\"\"\")"
                                                              defaultTokenType:KDEPyTokenTypeOpenDocString
                                                                  tokenTypeMap:nil]];
        
        [self addTokenizePhase:[KDETokenizePhase tokenizePhaseWithRegexPattern:@"(?i)((ur|br|r|b|u)*\"[^\"]*\"|(ur|br|r|b|u)*\'[^\']*\')"
                                                              defaultTokenType:KDEPyTokenTypeString
                                                                  tokenTypeMap:nil]];
        
        [self addTokenizePhase:[KDETokenizePhase tokenizePhaseWithRegexPattern:@"(?i)((ur|br|r|b|u)*\"|(ur|br|r|b|u)*\')"
                                                              defaultTokenType:KDEPyTokenTypeOpenString
                                                                  tokenTypeMap:nil]];
        
        
        [self addTokenizePhase:[KDETokenizePhase tokenizePhaseWithRegexPattern:[KDEPyTokenizer pythonNumberPattern]
                                                              defaultTokenType:KDEPyTokenTypeNumber
                                                                  tokenTypeMap:nil]];
        
        [self addTokenizePhase:[KDETokenizePhase tokenizePhaseWithRegexPattern:@"[a-zA-Z_]\\w*"
                                                              defaultTokenType:KDEPyTokenTypeName
                                                                  tokenTypeMap:[KDEPyTokenizer pythonNameTypeMap]]];
        
        [self addTokenizePhase:[KDETokenizePhase tokenizePhaseWithRegexPattern:@"\\*\\*=?|>>=?|<<=?|<>|!=|//=?|[+\\-*/%&|^=<>]=?|~"
                                                              defaultTokenType:KDEPyTokenTypeOperator
                                                                  tokenTypeMap:nil]];
        
        [self addTokenizePhase:[KDETokenizePhase tokenizePhaseWithRegexPattern:@"[\\]\\[\\(\\)\\{\\}]"
                                                              defaultTokenType:KDEPyTokenTypeBracket
                                                                  tokenTypeMap:nil]];
        
        [self addTokenizePhase:[KDETokenizePhase tokenizePhaseWithRegexPattern:@"[:;.,`@]"
                                                              defaultTokenType:KDEPyTokenTypeSpecial
                                                                  tokenTypeMap:nil]];
        
    }
    
    return self;
}

- (NSString *) stringForTokenType:(KDETokenType)type
{
    switch( type)
    {
        case KDEPyTokenTypeComment:       return @"Comment";
        case KDEPyTokenTypeDocString:     return @"DocString";
        case KDEPyTokenTypeString:        return @"String";
        case KDEPyTokenTypeOpenDocString: return @"OpenDocString";
        case KDEPyTokenTypeOpenString:    return @"OpenString";
        case KDEPyTokenTypeName:          return @"Name";
        case KDEPyTokenTypeKeyword:       return @"Keyword";
        case KDEPyTokenTypeNumber:        return @"Number";
        case KDEPyTokenTypeOperator:      return @"Operator";
        case KDEPyTokenTypeBracket:       return @"Bracket";
        case KDEPyTokenTypeSpecial:       return @"Special";
        default: return @"Unknown";
    }
}

- (NSArray *) filterOpenTokens:(NSArray *)tokens
{
    return [tokens filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL( KDEToken *token, NSDictionary *bindings){
        return token.type == KDEPyTokenTypeOpenDocString || token.type == KDEPyTokenTypeOpenString;
    }]];
}

+ (NSString *) pythonDocStringPattern
{
    NSString *singlePattern = @"(ur|br|r|b|u)*'''[^'\\\\]*(?:(?:\\\\.|'(?!''))[^'\\\\]*)*'''";
    NSString *doublePattern = @"(ur|br|r|b|u)*\"\"\"[^\"\\\\]*(?:(?:\\\\.|\"(?!\"\"))[^\"\\\\]*)*\"\"\"";
    
    return [NSString stringWithFormat:@"(?i)(%@|%@)", singlePattern, doublePattern];
}

+ (NSString *) pythonNumberPattern
{
    NSString *hexPattern = @"\\b0[xX][\\da-fA-F]+[lL]?\\b";
    NSString *octPattern = [NSRegularExpression groupPatternWithPatterns:@[ @"\\b(0[oO][0-7]+)\\b", @"\\b(0[0-7]*)[lL]?\\b"]];
    NSString *binPattern = @"\\b0[bB][01]+[lL]?\\b";
    NSString *decPattern = @"\\b[1-9]\\d*[lL]?\\b";
    NSString *intPattern = [NSRegularExpression groupPatternWithPatterns:@[ hexPattern, binPattern, octPattern, decPattern]];
    
    NSString *exponent = @"[eE][-+]?\\d+";
    NSString *pointFloatPattern = [NSString stringWithFormat:@"\\b(\\d+\\.\\d*(%@)?)|(\\.\\d+(%@)?)", exponent, exponent];
    NSString *expFloatPattern = [@"\\b\\d+" stringByAppendingString:exponent];
    NSString *floatPattern = [NSRegularExpression groupPatternWithPatterns:@[ pointFloatPattern, expFloatPattern]];
    
    NSString *imagPattern = [NSRegularExpression groupPatternWithPatterns:@[ @"\\d+[jJ]",
                                                                            [floatPattern stringByAppendingString:@"[jJ]"]]];

    return [NSRegularExpression groupPatternWithPatterns:@[ imagPattern, floatPattern, intPattern]];
}

+ (NSDictionary *) pythonNameTypeMap
{
    NSArray *keywords = @[ @"and", @"del", @"from", @"not", @"while", @"as", @"elif", @"global", @"or", @"with",
                           @"assert", @"else", @"if", @"pass", @"yield", @"break", @"except", @"import", @"print",
                           @"class", @"exec", @"in", @"raise", @"continue", @"finally", @"is", @"return", @"def",
                           @"for", @"lambda", @"try"];
    NSMutableDictionary *typeMap = [NSMutableDictionary dictionary];
    for( NSString *keyword in keywords)
    {
        typeMap[ keyword] = @(KDEPyTokenTypeKeyword);
    }
    
    return [typeMap copy];
}

@end
