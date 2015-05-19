//
//  KDEPy80Context.h
//  Py80
//
//  Created by Benjamin S Hopkins on 5/18/15.
//  Copyright (c) 2015 kode80. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@protocol KDEPy80ContextDelegate;


@interface KDEPy80Context : NSObject

@property (nonatomic, readwrite, weak) id<KDEPy80ContextDelegate> delegate;

+ (KDEPy80Context *) sharedContext;

- (void) log:(NSString *)message;
- (void) clearLog;

@end


@protocol KDEPy80ContextDelegate <NSObject>

- (void) py80Context:(KDEPy80Context *)context
          logMessage:(NSString *)message;

- (void) py80ContextClearLog:(KDEPy80Context *)context;

@end
