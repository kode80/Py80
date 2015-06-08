//
//  KDEToken.m
//  Py80
//
//  Created by Benjamin S Hopkins on 6/7/15.
//  Copyright (c) 2015 kode80. All rights reserved.
//

#import "KDEToken.h"

@implementation KDEToken

+ (instancetype) tokenWithType:(NSString *)type
                         value:(NSString *)value
                         range:(NSRange)range
{
    KDEToken *token = [KDEToken new];
    token.type = [type copy];
    token.value = [value copy];
    token.range = range;
    return token;
}

@end
