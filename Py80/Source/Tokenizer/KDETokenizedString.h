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

- (NSAttributedString *) attributedStringWithTheme:(KDETheme *)theme;

@end
