//
//  KDETokenizedString.m
//  Py80
//
//  Created by Benjamin S Hopkins on 6/9/15.
//  Copyright (c) 2015 kode80. All rights reserved.
//

#import "KDETokenizedString.h"
#import "KDETokenizer.h"
#import "KDETheme.h"
#import "NSRangeUtils.h"


@interface KDETokenizedString ()

@property (nonatomic, readwrite, copy) NSString *string;
@property (nonatomic, readwrite, strong) NSMutableString *internalString;
@property (nonatomic, readwrite, strong) KDETokenizer *tokenizer;
@property (nonatomic, readwrite, strong) NSArray *tokens;

@end


@implementation KDETokenizedString

- (instancetype) initWithString:(NSString *)string
                      tokenizer:(KDETokenizer *)tokenizer
{
    self = [super init];
    if( self)
    {
        self.internalString = [NSMutableString stringWithString:string ? string : @""];
        self.tokenizer = tokenizer;
        self.tokens = [tokenizer tokenizeString:string];
    }
    return self;
}

#pragma mark - Accessors

- (NSString *) string
{
    if( _string == nil)
    {
        _string = [self.internalString copy];
    }
    return _string;
}

#pragma mark - Public

- (NSArray *) replaceCharactersInRange:(NSRange)range
                            withString:(NSString *)string
{
    if( range.location > self.internalString.length)
    {
        @throw [NSException exceptionWithName:NSRangeException
                                       reason:@"range is out of bounds"
                                     userInfo:nil];
    }
    
    NSRange subarrayRange = [self tokensSubarrayRangeWithCharacterRange:range];
    NSInteger leftIndex = subarrayRange.location ? subarrayRange.location - 1 : -1;
    NSInteger rightIndex = NSMaxRange( subarrayRange) < self.tokens.count ? NSMaxRange( subarrayRange) : -1;
    
    KDEToken *leftToken = leftIndex > -1 ? self.tokens[ leftIndex] : nil;
    KDEToken *rightToken = rightIndex > -1 ? self.tokens[ rightIndex] : nil;
    
    if( leftIndex + 1 < self.tokens.count)
    {
        [self updateTokenRangesFromFirstToken:self.tokens[ leftIndex + 1]
                                       offset:string.length - range.length];
    }
    
    
    [self.internalString replaceCharactersInRange:range
                                       withString:string];
    [self invalidatePublicString];
    
    NSUInteger tokenizeStart = leftToken ? leftToken.range.location : 0;
    NSUInteger tokenizeEnd = rightToken ? NSMaxRange( rightToken.range) : self.internalString.length;
    NSRange tokenizeRange = NSMakeRange( tokenizeStart, tokenizeEnd - tokenizeStart);
    NSArray *newTokens = [self.tokenizer tokenizeString:[self.internalString substringWithRange:tokenizeRange]];
    for( KDEToken *token in newTokens)
    {
        [token offsetRangeLocation:leftToken.range.location];
    }
    
    [self replaceTokensFromFirstToken:leftToken ?: self.tokens.firstObject
              toAndIncludingLastToken:rightToken ?: self.tokens.lastObject
                           withTokens:newTokens];

    return newTokens;
}

- (NSAttributedString *) attributedStringWithTheme:(KDETheme *)theme
{
    NSDictionary *defaultAttributes = [theme textAttributesForItemName:theme.itemNames.firstObject];
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:self.internalString
                                                                                         attributes:defaultAttributes];
    for( KDEToken *token in self.tokens)
    {
        [attributedString setAttributes:[theme textAttributesForItemName:[self.tokenizer stringForTokenType:token.type]]
                                  range:token.range];
    }
    
    return [[NSAttributedString alloc] initWithAttributedString:attributedString];
}

- (NSArray *) tokensForCharacterRange:(NSRange)range
{
    NSRange subarrayRange = [self tokensSubarrayRangeWithCharacterRange:range];
    return subarrayRange.length ? [self.tokens subarrayWithRange:subarrayRange] : nil;
}

- (NSRange) tokensSubarrayRangeWithCharacterRange:(NSRange)range
{
    NSRange subarrayRange = NSMakeRange( NSNotFound, 0);
    NSUInteger i=0;
    
    if( self.tokens.lastObject &&
        NSMaxRange( [self.tokens.lastObject range]) <= range.location)
    {
        // Early out test if range is beyond the tokenized range.
        // If so, set location to tokens.length - i.e. the right most
        // token is nil and the left most token is tokens.lastObject
        
        subarrayRange.location = self.tokens.count;
        return subarrayRange;
    }
    
    for( KDEToken *token in self.tokens)
    {
        if( subarrayRange.location == NSNotFound)
        {
            if( NSRangeOverlapsRange( token.range, range))
            {
                subarrayRange.location = i;
                subarrayRange.length = 1;
            }
            else if( token.range.location >= NSMaxRange( range))
            {
                // Range doesn't overlap any tokens but *is* still
                // within the string's range, so return a subarray
                // range of 0 length, with location pointing to
                // the token to the right.
                //
                // This allows a caller to retrieve tokens on either
                // side of a range even if that range doesn't overlap
                // any tokens.
                
                subarrayRange.location = i;
                return subarrayRange;
            }
        }
        else
        {
            if( NSRangeOverlapsRange( token.range, range))
            {
                subarrayRange.length++;
            }
            else
            {
                return subarrayRange;
            }
        }
        
        i++;
    }
    
    return subarrayRange;
}

#pragma mark - Private

- (void) updateTokenRangesFromFirstToken:(KDEToken *)firstToken
                                  offset:(NSInteger)offset
{
    NSUInteger firstTokenIndex = [self.tokens indexOfObject:firstToken];
    if( firstTokenIndex == NSNotFound)
    {
        @throw [NSException exceptionWithName:NSRangeException
                                       reason:@"firstToken doesn't exist in tokens"
                                     userInfo:nil];
    }
    
    NSUInteger count = self.tokens.count;
    
    for( NSInteger i=firstTokenIndex; i<count; i++)
    {
        [self.tokens[ i] offsetRangeLocation:offset];
    }
}

- (void) replaceTokensFromFirstToken:(KDEToken *)firstToken
             toAndIncludingLastToken:(KDEToken *)lastToken
                          withTokens:(NSArray *)tokens
{
    NSUInteger firstIndex = [self.tokens indexOfObject:firstToken];
    NSUInteger lastIndex = [self.tokens indexOfObject:lastToken];
    
    if( firstIndex == NSNotFound || lastIndex == NSNotFound)
    {
        @throw [NSException exceptionWithName:NSRangeException
                                       reason:@"invalid first/last tokens"
                                     userInfo:nil];
    }
    
    if( firstIndex > lastIndex)
    {
        NSUInteger tmp = lastIndex; lastIndex = firstIndex; firstIndex = tmp;
    }
    
    NSMutableArray *updatedTokens = [NSMutableArray arrayWithArray:self.tokens];
    [updatedTokens replaceObjectsInRange:NSMakeRange( firstIndex, lastIndex - firstIndex + 1)
                    withObjectsFromArray:tokens];
    self.tokens = [NSArray arrayWithArray:updatedTokens];
}

- (void) invalidatePublicString
{
    // Internally we use the mutable self.internalString.
    // Externally the string is accessed via readonly, immutable .string.
    //
    // To avoid [self.internalString copy] everytime  an external
    // caller modifys the string via public methods or accesses .string,
    // we do a lazy copy in the .string accessor.
    //
    // Therefore, any method that modifys self.internalString must call
    // invalidatePublicString so that the next time .string is accessed
    // externally it will be updated via [self.internalString copy]
    
    self.string = nil;
}

@end
