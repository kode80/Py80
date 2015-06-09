//
//  KDETokenizePhase.m
//  Py80
//
//  Created by Benjamin S Hopkins on 6/8/15.
//  Copyright (c) 2015 kode80. All rights reserved.
//

#import "KDETokenizePhase.h"


@interface KDETokenizePhase ()

@property (nonatomic, readwrite, strong) NSRegularExpression *regularExpression;
@property (nonatomic, readwrite, assign) KDETokenType defaultTokenType;
@property (nonatomic, readwrite, strong) NSDictionary *tokenTypeMap;

@end


@implementation KDETokenizePhase

+ (instancetype) tokenizePhaseWithRegexPattern:(NSString *)regexPattern
                              defaultTokenType:(KDETokenType)defaultTokenType
                                  tokenTypeMap:(NSDictionary *)tokenTypeMapOrNil
{
    KDETokenizePhase *phase = [KDETokenizePhase new];
    phase.regularExpression = [NSRegularExpression regularExpressionWithPattern:regexPattern
                                                                        options:0
                                                                          error:NULL];
    phase.defaultTokenType = defaultTokenType;
    phase.tokenTypeMap = [tokenTypeMapOrNil copy];
    return phase;
}

@end
