//
//  KDEMainViewController.h
//  Py80
//
//  Created by Benjamin S Hopkins on 6/3/15.
//  Copyright (c) 2015 kode80. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@protocol KDEMainViewControllerDelegate;

@class KDEOutputView,
       ASKSyntaxViewController,
       KDEExceptionView,
       KDECompletionWindowController,
       KDEConsoleViewController,
       KDEPyException,
       KDETheme;


@interface KDEMainViewController : NSViewController

@property (nonatomic, readwrite, weak) IBOutlet id<KDEMainViewControllerDelegate> delegate;
@property (nonatomic, readwrite, strong) IBOutlet NSTextView *codeView;
@property (nonatomic, readwrite, strong) IBOutlet KDEConsoleViewController *consoleViewController;
@property (nonatomic, readwrite, strong) IBOutlet NSTextView *console;
@property (nonatomic, readwrite, weak) IBOutlet KDEOutputView *outputView;
@property (nonatomic, readwrite, weak) IBOutlet NSSplitView *horizontalSplitView;
@property (nonatomic, readwrite, weak) IBOutlet NSSplitView *verticalSplitView;
@property (nonatomic, readwrite, strong) IBOutlet ASKSyntaxViewController *syntaxViewController;
@property (nonatomic, readwrite, strong) IBOutlet KDEExceptionView *exceptionView;
@property (nonatomic, readwrite, strong) IBOutlet NSWindow *completionWindow;
@property (nonatomic, readwrite, strong) IBOutlet KDECompletionWindowController *completionWindowController;

- (IBAction) saveOutputContents:(id)sender;
- (IBAction) insertPath:(id)sender;

- (void) showException:(KDEPyException *)exception;

- (void) applyTheme:(KDETheme *)theme;

@end


@protocol KDEMainViewControllerDelegate <NSObject>

- (void) codeDidChangeInMainViewController:(KDEMainViewController *)viewController;

@end
