//
//  AppDelegate.h
//  Py80
//
//  Created by Benjamin S Hopkins on 5/18/15.
//  Copyright (c) 2015 kode80. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class KDEMainViewController, KDEProfilerViewController;

@interface AppDelegate : NSObject <NSApplicationDelegate>

@property (nonatomic, readwrite, strong) IBOutlet NSButton *runButton;
@property (nonatomic, readwrite, weak) IBOutlet NSTextField *infoField;
@property (nonatomic, readwrite, strong) IBOutlet KDEMainViewController *mainViewController;

- (IBAction) runCode:(id)sender;
- (IBAction) profileCode:(id)sender;

- (IBAction) resetOutputMagnification:(id)sender;
- (IBAction) saveOutputContents:(id)sender;
- (IBAction) openPreviousDocument:(id)sender;
- (IBAction) showPreferences:(id)sender;

@end

