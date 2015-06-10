//
//  KDETokenizedString.h
//  Py80
//
//  Created by Benjamin S Hopkins on 6/9/15.
//  Copyright (c) 2015 kode80. All rights reserved.
//

#import <Foundation/Foundation.h>


@class KDETokenizer, KDETheme;

@interface KDETokenizedString : NSObject

@property (nonatomic, readonly, copy) NSString *string;
@property (nonatomic, readonly, strong) KDETokenizer *tokenizer;
@property (nonatomic, readonly, strong) NSArray *tokens;

- (instancetype) initWithString:(NSString *)string
                      tokenizer:(KDETokenizer *)tokenizer;

/**
 Modifies the string and re-tokenizes the appropriate range, returning
 any newly added tokens.
 */
- (NSArray *) replaceCharactersInRange:(NSRange)range
                            withString:(NSString *)string;

- (NSAttributedString *) attributedStringWithTheme:(KDETheme *)theme;

/**
 @brief Returns all tokens that overlap the character range provided.
 */
- (NSArray *) tokensForCharacterRange:(NSRange)range;

/**
 @brief Returns the array range of tokens that overlap the character range provided.
 If no tokens overlap, the returned array range will have a length of 0 and
 the location will be the index of the token to the right of the character range.
 
 @discussion Example: if the character range is beyond the last token then the returned
 array range's location will be KDETokenizedString.tokens.count.
 
 Example: [T:"keyword"] "untokenized parts of string" [T:"keyword"]
 if the character range was { 10, 5 }, the array range would be { 1, 0 }
 */
- (NSRange) tokensSubarrayRangeWithCharacterRange:(NSRange)range;

@end
