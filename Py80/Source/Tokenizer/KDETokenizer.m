//
//  KDETokenizer.m
//  Py80
//
//  Created by Benjamin S Hopkins on 6/7/15.
//  Copyright (c) 2015 kode80. All rights reserved.
//

#import "KDETokenizer.h"
#import "KDEToken.h"


@implementation KDETokenizer

- (NSArray *) tokenizeString:(NSString *)string
{
    return nil;
}

- (NSArray *) tokenizeString:(NSString *)string
       withRegularExpression:(NSRegularExpression *)regex
                      ranges:(NSArray *)ranges
            defaultTokenType:(NSString *)defaultTokenType
                tokenTypeMap:(NSDictionary *)tokenTypeMap
{
    NSMutableArray *tokens = [NSMutableArray array];
    for( NSValue *range in ranges)
    {
        [regex enumerateMatchesInString:string
                                options:NSMatchingWithTransparentBounds
                                  range:[range rangeValue]
                             usingBlock:^(NSTextCheckingResult *result, NSMatchingFlags flags, BOOL *stop){
                                 KDEToken *token = [KDEToken new];
                                 token.value = [string substringWithRange:result.range];
                                 token.type = tokenTypeMap[ token.value] ?: defaultTokenType;
                                 token.range = result.range;
                                 [tokens addObject:token];
                             }];
    }
    return [NSArray arrayWithArray:tokens];
}

- (NSArray *) untokenizedRangesInRange:(NSRange)boundaryRange
                        existingTokens:(NSArray *)tokens
{
    NSMutableArray *ranges = [NSMutableArray array];
    NSRange range = NSMakeRange( boundaryRange.location, 0);
    
    for( KDEToken *token in tokens)
    {
        if( range.location >= token.range.location && range.location < NSMaxRange( token.range))
        {
            range.location = NSMaxRange( token.range);
        }
        
        if( range.location < token.range.location)
        {
            range.length = token.range.location - range.location;
            [ranges addObject:[NSValue valueWithRange:range]];
            
            range.location = NSMaxRange( token.range);
            range.length = 0;
        }
    }
    
    if( range.location < NSMaxRange( boundaryRange))
    {
        range.length = NSMaxRange( boundaryRange) - range.location;
        [ranges addObject:[NSValue valueWithRange:range]];
    }
    
    return [NSArray arrayWithArray:ranges];
}

- (NSArray *) sortTokens:(NSArray *)tokens
{
    return [tokens sortedArrayWithOptions:0
                          usingComparator:^NSComparisonResult( KDEToken *tokenA, KDEToken *tokenB){
                              if( NSMaxRange( tokenA.range) <= tokenB.range.location)
                              {
                                  return NSOrderedAscending;
                              }
                              else if( NSEqualRanges( tokenA.range, tokenB.range))
                              {
                                  return NSOrderedSame;
                              }
                              
                              return NSOrderedDescending;
                          }];
}


@end
