//
//  KDEConsoleLog.m
//  Py80
//
//  Created by Benjamin S Hopkins on 6/5/15.
//  Copyright (c) 2015 kode80. All rights reserved.
//

#import "KDEConsoleLog.h"


@interface KDEConsoleLog ()

@property (nonatomic, readwrite, strong) NSDate *date;
@property (nonatomic, readwrite, strong) NSString *message;

@end


@implementation KDEConsoleLog

+ (instancetype) logWithMessage:(NSString *)message
{
    KDEConsoleLog *log = [KDEConsoleLog new];
    log.date = [NSDate date];
    log.message = [message copy];
    return log;
}

@end
