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


#import "KDEPyTokenizer.h"


@interface KDETokenizedString ()

@property (nonatomic, readwrite, copy) NSString *string;
@property (nonatomic, readwrite, strong) NSMutableString *internalString;
@property (nonatomic, readwrite, strong) KDETokenizer *tokenizer;
@property (nonatomic, readwrite, strong) NSMutableArray *tokens;
@property (nonatomic, readwrite, strong) NSMutableArray *openTokens;

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
        self.tokens = [[tokenizer tokenizeString:string] mutableCopy];
        self.openTokens = [[tokenizer filterOpenTokens:self.tokens] mutableCopy];
        
        NSMutableArray *openTokens = [NSMutableArray array];
        KDEToken *leftToken, *rightToken;
        NSArray *newTokens;
        if( self.openTokens.count > 1)
        {
            NSInteger i=0;
            
            while( i < self.openTokens.count)
            {
                leftToken = self.openTokens[ i];
                rightToken = [self firstOpenTokenRightOfToken:leftToken];
                if( rightToken == nil)
                {
                    break;
                }
                
                NSRange range = NSMakeRange( leftToken.range.location, NSMaxRange( rightToken.range) - leftToken.range.location);
                newTokens = @[ [KDEToken tokenWithType:KDEPyTokenTypeDocString
                                                 value:[string substringWithRange:range]
                                                 range:range]];
                
                [self replaceTokensFromFirstToken:leftToken
                          toAndIncludingLastToken:rightToken
                                       withTokens:newTokens];
                [openTokens addObjectsFromArray:[self.tokenizer filterOpenTokens:newTokens]];
                
                i = [self.openTokens indexOfObject:rightToken] + 1;
            }
            
            [self addNewOpenTokens:openTokens];
        }
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
    
    leftToken = [self firstOpenTokenLeftOfToken:leftToken] ?: leftToken;
    rightToken = [self firstOpenTokenRightOfToken:rightToken] ?: rightToken;
    
    NSArray *newTokens = [self tokenizeFromToken:leftToken
                             toAndIncludingToken:rightToken];
     
    [self replaceTokensFromFirstToken:leftToken ?: self.tokens.firstObject
              toAndIncludingLastToken:rightToken ?: self.tokens.lastObject
                           withTokens:newTokens];
    
    [self addNewOpenTokens:[self.tokenizer filterOpenTokens:newTokens]];
    
    NSMutableArray *openTokens = [NSMutableArray array];
    if( self.openTokens.count > 1)
    {
        NSInteger i=0;
        
        while( i < openTokens.count)
        {
            leftToken = self.openTokens[ i];
            rightToken = [self firstOpenTokenRightOfToken:leftToken];
            if( rightToken == nil)
            {
                break;
            }
            
            newTokens = [self tokenizeFromToken:leftToken
                            toAndIncludingToken:rightToken];
            
            [self replaceTokensFromFirstToken:leftToken
                      toAndIncludingLastToken:rightToken
                                   withTokens:newTokens];
            [openTokens addObjectsFromArray:[self.tokenizer filterOpenTokens:newTokens]];
            
            i = [self.openTokens indexOfObject:rightToken] + 1;
        }

        [self addNewOpenTokens:openTokens];
    }

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

- (NSArray *) tokenizeFromToken:(KDEToken *)leftToken
            toAndIncludingToken:(KDEToken *)rightToken
{
    NSUInteger tokenizeStart = leftToken ? leftToken.range.location : 0;
    NSUInteger tokenizeEnd = rightToken ? NSMaxRange( rightToken.range) : self.internalString.length;
    NSRange tokenizeRange = NSMakeRange( tokenizeStart, tokenizeEnd - tokenizeStart);
    NSArray *newTokens = [self.tokenizer tokenizeString:[self.internalString substringWithRange:tokenizeRange]];
    for( KDEToken *token in newTokens)
    {
        [token offsetRangeLocation:leftToken.range.location];
    }
    return newTokens;
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
    
    [self.tokens replaceObjectsInRange:NSMakeRange( firstIndex, lastIndex - firstIndex + 1)
                  withObjectsFromArray:tokens];

    [self removeOpenTokensNoLongerInTokens];
}

- (KDEToken *) firstOpenTokenLeftOfToken:(KDEToken *)token
{
    KDEToken *leftToken = nil;
    if( token)
    {
        BOOL tokenIsOpen = [self.tokenizer isOpenToken:token];
        
        for( KDEToken *openToken in self.openTokens)
        {
            if( NSMaxRange( openToken.range) <= token.range.location)
            {
                if( tokenIsOpen)
                {
                    if( token.type == openToken.type)
                    {
                        leftToken = openToken;
                    }
                }
                else
                {
                    leftToken = openToken;
                }
            }
            else
            {
                break;
            }
        }
    }
    
    return leftToken;
}

- (KDEToken *) firstOpenTokenRightOfToken:(KDEToken *)token
{
    KDEToken *rightToken = nil;
    if( token)
    {
        BOOL tokenIsOpen = [self.tokenizer isOpenToken:token];
        NSUInteger maxRange = NSMaxRange( token.range);
        
        for( KDEToken *openToken in self.openTokens.reverseObjectEnumerator)
        {
            if( openToken.range.location >= maxRange)
            {
                if( tokenIsOpen)
                {
                    if( token.type == openToken.type)
                    {
                        rightToken = openToken;
                    }
                }
                else
                {
                    rightToken = openToken;
                }
            }
            else
            {
                break;
            }
        }
    }
    
    return rightToken;
}

- (void) addNewOpenTokens:(NSArray *)newOpenTokens
{
    if( newOpenTokens.count)
    {
        [self.openTokens addObjectsFromArray:newOpenTokens];
        [self.openTokens filterUsingPredicate:[NSPredicate predicateWithBlock:^BOOL( KDEToken *token, NSDictionary *bindings){
            return [self.tokens containsObject:token];
        }]];
        [KDETokenizer sortTokens:self.openTokens];
    }
}

- (void) removeOpenTokensNoLongerInTokens
{
    if( self.openTokens.count)
    {
        [self.openTokens filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL( KDEToken *token, NSDictionary *bindings){
            return [self.tokens containsObject:token];
        }]];
    }
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
