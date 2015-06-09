//
//  KDETokenizer.m
//  Py80
//
//  Created by Benjamin S Hopkins on 6/7/15.
//  Copyright (c) 2015 kode80. All rights reserved.
//

#import "KDETokenizer.h"
#import "KDEToken.h"
#import "KDETokenizePhase.h"


NSComparisonResult(^KDETokenComparator)( KDEToken *, KDEToken *) = ^NSComparisonResult( KDEToken *tokenA, KDEToken *tokenB){
    if( NSMaxRange( tokenA.range) <= tokenB.range.location)
    {
        return NSOrderedAscending;
    }
    else if( NSEqualRanges( tokenA.range, tokenB.range))
    {
        return NSOrderedSame;
    }
    
    return NSOrderedDescending;
};


@interface KDETokenizer ()

@property (nonatomic, readwrite, strong) NSArray *tokenizePhases;

@end


@implementation KDETokenizer

- (void) addTokenizePhase:(KDETokenizePhase *)phase
{
    self.tokenizePhases = self.tokenizePhases ? [self.tokenizePhases arrayByAddingObject:phase] :
                                                @[ phase];
}

- (NSArray *) tokenizeString:(NSString *)string
{
    NSMutableArray *tokens = [NSMutableArray array];
    NSRange wholeRange = NSMakeRange( 0, string.length);
    NSArray *ranges = @[ [NSValue valueWithRange:wholeRange]];
    NSArray *currentTokens;
    
    for( KDETokenizePhase *phase in self.tokenizePhases)
    {
        currentTokens = [self tokenizeString:string
                       withRegularExpression:phase.regularExpression
                                      ranges:ranges
                            defaultTokenType:phase.defaultTokenType
                                tokenTypeMap:phase.tokenTypeMap];
        [tokens addObjectsFromArray:currentTokens];
        [self sortTokens:tokens];
        
        ranges = [self untokenizedRangesInRange:wholeRange
                                 existingTokens:tokens];
    }
    
    return [NSArray arrayWithArray:tokens];
}

- (NSArray *) tokenizeString:(NSString *)string
       withRegularExpression:(NSRegularExpression *)regex
                      ranges:(NSArray *)ranges
            defaultTokenType:(KDETokenType)defaultTokenType
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
                                 token.type = [tokenTypeMap[ token.value] unsignedIntegerValue] ?: defaultTokenType;
                                 token.range = result.range;
                                 
                                 if( tokenTypeMap)
                                 {
                                     NSNumber *typeNumber = tokenTypeMap[ @(token.type)];
                                     token.type = typeNumber ? [typeNumber unsignedIntegerValue] : defaultTokenType;
                                 }
                                 else
                                 {
                                     token.type = defaultTokenType;
                                 }

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

- (NSArray *) sortedTokens:(NSArray *)tokens
{
    return [tokens sortedArrayWithOptions:0
                          usingComparator:KDETokenComparator];
}

- (void) sortTokens:(NSMutableArray *)tokens
{
    [tokens sortUsingComparator:KDETokenComparator];
}


@end
