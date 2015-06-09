//
//  KDEToken.m
//  Py80
//
//  Created by Benjamin S Hopkins on 6/7/15.
//  Copyright (c) 2015 kode80. All rights reserved.
//

#import "KDEToken.h"

@implementation KDEToken

+ (instancetype) tokenWithType:(KDETokenType)type
                         value:(NSString *)value
                         range:(NSRange)range
{
    KDEToken *token = [KDEToken new];
    token.type = type;
    token.value = [value copy];
    token.range = range;
    return token;
}

@end
