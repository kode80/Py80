//
//  KDEPyTokenizer.m
//  Py80
//
//  Created by Benjamin S Hopkins on 6/8/15.
//  Copyright (c) 2015 kode80. All rights reserved.
//

#import "KDEPyTokenizer.h"
#import "KDETokenizePhase.h"

@implementation KDEPyTokenizer

- (instancetype) init
{
    self = [super init];
    if( self)
    {
        [self addTokenizePhase:[KDETokenizePhase tokenizePhaseWithRegexPattern:@"#[^\r\n]*"
                                                              defaultTokenType:@"COMMENT"
                                                                  tokenTypeMap:nil]];
        
        [self addTokenizePhase:[KDETokenizePhase tokenizePhaseWithRegexPattern:@"(?s)\"\"\".*\"\"\"|'''.*'''"
                                                              defaultTokenType:@"DOCSTRING"
                                                                  tokenTypeMap:nil]];
        
        [self addTokenizePhase:[KDETokenizePhase tokenizePhaseWithRegexPattern:@"(?s)\".*?\"|'.*?'"
                                                              defaultTokenType:@"STRING"
                                                                  tokenTypeMap:nil]];
        
        [self addTokenizePhase:[KDETokenizePhase tokenizePhaseWithRegexPattern:@"[a-zA-Z_]\\w*"
                                                              defaultTokenType:@"NAME"
                                                                  tokenTypeMap:nil]];
    }
    
    return self;
}

@end
