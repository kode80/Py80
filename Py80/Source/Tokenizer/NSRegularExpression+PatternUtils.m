//
//  NSRegularExpression+PatternUtils.m
//  Py80
//
//  Created by Benjamin S Hopkins on 6/8/15.
//  Copyright (c) 2015 kode80. All rights reserved.
//

#import "NSRegularExpression+PatternUtils.h"

@implementation NSRegularExpression (PatternUtils)

+ (NSString *) groupPatternWithPatterns:(NSArray *)patterns
{
    return [NSString stringWithFormat:@"(%@)", [patterns componentsJoinedByString:@"|"]];
}

+ (NSString *) maybePatternWithPatterns:(NSArray *)patterns
{
    return [[NSRegularExpression groupPatternWithPatterns:patterns] stringByAppendingString:@"?"];
}


@end
