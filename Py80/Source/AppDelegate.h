//
//  AppDelegate.h
//  Py80
//
//  Created by Benjamin S Hopkins on 5/18/15.
//  Copyright (c) 2015 kode80. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class KDEOutputView, ASKSyntaxViewController;

@interface AppDelegate : NSObject <NSApplicationDelegate>

@property (nonatomic, readwrite, strong) IBOutlet NSTextView *codeView;
@property (nonatomic, readwrite, strong) IBOutlet NSTextView *console;
@property (nonatomic, readwrite, weak) IBOutlet KDEOutputView *outputView;
@property (nonatomic, readwrite, strong) IBOutlet NSButton *runButton;
@property (nonatomic, readwrite, weak) IBOutlet NSTextField *infoField;
@property (nonatomic, readwrite, strong) IBOutlet ASKSyntaxViewController *syntaxViewController;
@property (nonatomic, readwrite, strong) IBOutlet NSView *exceptionView;
@property (nonatomic, readwrite, strong) IBOutlet NSTextField *exceptionLabel;
@property (nonatomic, readwrite, strong) IBOutlet NSLayoutConstraint * exceptionLeftConstraint;
@property (nonatomic, readwrite, strong) IBOutlet NSLayoutConstraint * exceptionTopConstraint;

- (IBAction) runCode:(id)sender;

@end

