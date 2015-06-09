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


NSString *NSStringFromPyTokenType( KDEPyTokenType type)
{
    switch( type)
    {
        case KDETokenTypeComment:       return @"Comment";
        case KDETokenTypeDocString:     return @"DocString";
        case KDETokenTypeString:        return @"String";
        case KDETokenTypeName:          return @"Name";
        case KDETokenTypeNumber:        return @"Number";
        case KDETokenTypeOperator:      return @"Operator";
        case KDETokenTypeBracket:       return @"Bracket";
        case KDETokenTypeSpecial:       return @"Special";
        default: return @"Unknown";
    }
}


@implementation KDEPyTokenizer

- (instancetype) init
{
    self = [super init];
    if( self)
    {
        // Time was 7ms
        [self addTokenizePhase:[KDETokenizePhase tokenizePhaseWithRegexPattern:@"#[^\r\n]*"
                                                              defaultTokenType:KDETokenTypeComment
                                                                  tokenTypeMap:nil]];
        
        [self addTokenizePhase:[KDETokenizePhase tokenizePhaseWithRegexPattern:[KDEPyTokenizer pythonDocStringPattern]
                                                              defaultTokenType:KDETokenTypeDocString
                                                                  tokenTypeMap:nil]];

        [self addTokenizePhase:[KDETokenizePhase tokenizePhaseWithRegexPattern:@"(?i)((ur|br|r|b|u)*\"[^\"]*\"|(ur|br|r|b|u)*\'[^\']*\')"
                                                              defaultTokenType:KDETokenTypeString
                                                                  tokenTypeMap:nil]];
        
        [self addTokenizePhase:[KDETokenizePhase tokenizePhaseWithRegexPattern:[KDEPyTokenizer pythonNumberPattern]
                                                              defaultTokenType:KDETokenTypeNumber
                                                                  tokenTypeMap:nil]];
        
        [self addTokenizePhase:[KDETokenizePhase tokenizePhaseWithRegexPattern:@"[a-zA-Z_]\\w*"
                                                              defaultTokenType:KDETokenTypeName
                                                                  tokenTypeMap:nil]];
        
        [self addTokenizePhase:[KDETokenizePhase tokenizePhaseWithRegexPattern:@"\\*\\*=?|>>=?|<<=?|<>|!=|//=?|[+\\-*/%&|^=<>]=?|~"
                                                              defaultTokenType:KDETokenTypeOperator
                                                                  tokenTypeMap:nil]];
        
        [self addTokenizePhase:[KDETokenizePhase tokenizePhaseWithRegexPattern:@"[\\]\\[\\(\\)\\{\\}]"
                                                              defaultTokenType:KDETokenTypeBracket
                                                                  tokenTypeMap:nil]];
        
        [self addTokenizePhase:[KDETokenizePhase tokenizePhaseWithRegexPattern:@"[:;.,`@]"
                                                              defaultTokenType:KDETokenTypeSpecial
                                                                  tokenTypeMap:nil]];
        
    }
    
    return self;
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

@end
