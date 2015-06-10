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

@end
