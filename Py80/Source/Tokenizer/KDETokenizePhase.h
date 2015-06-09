//
//  KDETokenizePhase.h
//  Py80
//
//  Created by Benjamin S Hopkins on 6/8/15.
//  Copyright (c) 2015 kode80. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KDEToken.h"


@interface KDETokenizePhase : NSObject

@property (nonatomic, readonly, strong) NSRegularExpression *regularExpression;
@property (nonatomic, readonly, assign) KDETokenType defaultTokenType;
@property (nonatomic, readonly, strong) NSDictionary *tokenTypeMap;

+ (instancetype) tokenizePhaseWithRegexPattern:(NSString *)regexPattern
                              defaultTokenType:(KDETokenType)defaultTokenType
                                  tokenTypeMap:(NSDictionary *)tokenTypeMapOrNil;

@end
