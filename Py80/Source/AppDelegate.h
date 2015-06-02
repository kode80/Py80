//
//  AppDelegate.h
//  Py80
//
//  Created by Benjamin S Hopkins on 5/18/15.
//  Copyright (c) 2015 kode80. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class KDEOutputView, ASKSyntaxViewController, KDEExceptionView, KDECompletionWindowController;

@interface AppDelegate : NSObject <NSApplicationDelegate>

@property (nonatomic, readwrite, strong) IBOutlet NSTextView *codeView;
@property (nonatomic, readwrite, strong) IBOutlet NSTextView *console;
@property (nonatomic, readwrite, weak) IBOutlet KDEOutputView *outputView;
@property (nonatomic, readwrite, strong) IBOutlet NSButton *runButton;
@property (nonatomic, readwrite, weak) IBOutlet NSTextField *infoField;
@property (nonatomic, readwrite, strong) IBOutlet ASKSyntaxViewController *syntaxViewController;
@property (nonatomic, readwrite, strong) IBOutlet KDEExceptionView *exceptionView;
@property (nonatomic, readwrite, strong) IBOutlet NSWindow *completionWindow;
@property (nonatomic, readwrite, strong) IBOutlet KDECompletionWindowController *completionWindowController;

- (IBAction) runCode:(id)sender;

- (IBAction) resetOutputMagnification:(id)sender;
- (IBAction) saveOutputContents:(id)sender;
- (IBAction) openPreviousDocument:(id)sender;

@end

