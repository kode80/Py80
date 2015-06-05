//
//  KDEConsoleViewController.h
//  Py80
//
//  Created by Benjamin S Hopkins on 6/5/15.
//  Copyright (c) 2015 kode80. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@class KDETheme;

@interface KDEConsoleViewController : NSViewController

- (void) clearLogs;
- (void) logMessage:(NSString *)message;

- (void) applyTheme:(KDETheme *)theme;

@end
