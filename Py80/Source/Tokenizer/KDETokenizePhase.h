//
//  KDETokenizePhase.h
//  Py80
//
//  Created by Benjamin S Hopkins on 6/8/15.
//  Copyright (c) 2015 kode80. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KDETokenizePhase : NSObject

@property (nonatomic, readonly, strong) NSRegularExpression *regularExpression;
@property (nonatomic, readonly, strong) NSString *defaultTokenType;
@property (nonatomic, readonly, strong) NSDictionary *tokenTypeMap;

+ (instancetype) tokenizePhaseWithRegexPattern:(NSString *)regexPattern
                              defaultTokenType:(NSString *)defaultTokenType
                                  tokenTypeMap:(NSDictionary *)tokenTypeMapOrNil;

@end
