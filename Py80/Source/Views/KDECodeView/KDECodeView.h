//
//  KDECodeView.h
//  Py80
//
//  Created by Benjamin S Hopkins on 5/9/15.
//  Copyright (c) 2015 kode80. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@class KDECompletionWindowController, KDETokenizer, KDETheme;


@interface KDECodeView : NSTextView

@property (nonatomic, readwrite, strong) KDETokenizer *tokenizer;
@property (nonatomic, readwrite, strong) KDETheme *theme;

@property (nonatomic, readwrite, weak) IBOutlet KDECompletionWindowController *completionController;

@end
