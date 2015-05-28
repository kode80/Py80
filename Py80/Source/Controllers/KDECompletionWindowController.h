//
//  KDECompletionWindowController.h
//  Py80
//
//  Created by Benjamin S Hopkins on 5/27/15.
//  Copyright (c) 2015 kode80. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface KDECompletionWindowController : NSWindowController <NSTableViewDataSource, NSTableViewDelegate>

@property (nonatomic, readonly, assign) BOOL isVisible;

@property (nonatomic, readwrite, weak) IBOutlet NSTableView *table;

- (void) reloadCompletionsForTextView:(NSTextView *)textView;
- (void) insertCurrentCompletionInTextView:(NSTextView *)textView;

- (void) showForTextView:(NSTextView *)textView;
- (void) hide;

@end
