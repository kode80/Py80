//
//  AppDelegate.h
//  Py80
//
//  Created by Benjamin S Hopkins on 5/18/15.
//  Copyright (c) 2015 kode80. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface AppDelegate : NSObject <NSApplicationDelegate>

@property (nonatomic, readwrite, strong) IBOutlet NSTextView *codeView;

- (IBAction) runCode:(id)sender;

@end

