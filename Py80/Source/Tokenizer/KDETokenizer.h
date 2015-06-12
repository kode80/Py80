//
//  KDETokenizer.h
//  Py80
//
//  Created by Benjamin S Hopkins on 6/7/15.
//  Copyright (c) 2015 kode80. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KDETokenizePhase.h"


@interface KDETokenizer : NSObject

@property (nonatomic, readonly, strong) NSArray *tokenizePhases;

+ (NSArray *) sortedTokens:(NSArray *)tokens;
+ (void) sortTokens:(NSMutableArray *)tokens;

- (void) addTokenizePhase:(KDETokenizePhase *)phase;

- (NSArray *) tokenizeString:(NSString *)string;
- (NSString *) stringForTokenType:(KDETokenType)type;

- (BOOL) isOpenToken:(KDEToken *)token;
- (KDETokenType) closedTokenTypeForOpenToken:(KDEToken *)token;
- (NSArray *) filterOpenTokens:(NSArray *)tokens;
- (BOOL) canRightToken:(KDEToken *)rightToken
        closeLeftToken:(KDEToken *)leftToken;

@end
