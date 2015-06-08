//
//  KDETokenizer.h
//  Py80
//
//  Created by Benjamin S Hopkins on 6/7/15.
//  Copyright (c) 2015 kode80. All rights reserved.
//

#import <Foundation/Foundation.h>


@class KDETokenizePhase;


@interface KDETokenizer : NSObject

@property (nonatomic, readonly, strong) NSArray *tokenizePhases;

- (void) addTokenizePhase:(KDETokenizePhase *)phase;

- (NSArray *) tokenizeString:(NSString *)string;

@end
