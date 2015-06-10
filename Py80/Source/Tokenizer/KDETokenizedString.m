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
        self.string = string;
        self.tokenizer = tokenizer;
        self.tokens = [tokenizer tokenizeString:string];
    }
    return self;
}

- (NSAttributedString *) attributedStringWithTheme:(KDETheme *)theme
{
    NSDictionary *defaultAttributes = [theme textAttributesForItemName:theme.itemNames.firstObject];
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:self.string
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

@end
