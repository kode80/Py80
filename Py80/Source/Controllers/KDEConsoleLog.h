//
//  KDEConsoleLog.h
//  Py80
//
//  Created by Benjamin S Hopkins on 6/5/15.
//  Copyright (c) 2015 kode80. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KDEConsoleLog : NSObject

@property (nonatomic, readonly, strong) NSDate *date;
@property (nonatomic, readonly, strong) NSString *message;

+ (instancetype) logWithMessage:(NSString *)message;

@end
