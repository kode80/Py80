//
//  KDEPy80Context.m
//  Py80
//
//  Created by Benjamin S Hopkins on 5/18/15.
//  Copyright (c) 2015 kode80. All rights reserved.
//

#import "KDEPy80Context.h"

@implementation KDEPy80Context

+ (KDEPy80Context *) sharedContext
{
    static dispatch_once_t onceToken;
    static KDEPy80Context *context = nil;
    dispatch_once(&onceToken, ^{
        context = [KDEPy80Context new];
    });
    return context;
}

- (void) log:(NSString *)message
{
    if( [self.delegate respondsToSelector:@selector(py80Context:logMessage:)])
    {
        [self.delegate py80Context:self
                        logMessage:message];
    }
}

- (void) clearLog
{
    if( [self.delegate respondsToSelector:@selector(py80ContextClearLog:)])
    {
        [self.delegate py80ContextClearLog:self];
    }
}

@end
