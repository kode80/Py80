//
//  KDETextView.m
//  Py80
//
//  Created by Benjamin S Hopkins on 5/27/15.
//  Copyright (c) 2015 kode80. All rights reserved.
//

#import "KDETextView.h"
#import "KDECompletionViewController.h"

#import "VKConsts.h"

@implementation KDETextView

- (void) keyDown:(NSEvent *)theEvent
{
    BOOL visible = self.completionController.isVisible;
    unsigned short code = theEvent.keyCode;
    
    if( visible && (code == kVK_UpArrow || code == kVK_DownArrow))
    {
        [self.completionController.table keyDown:theEvent];
    }
    else if( visible && code == kVK_Return)
    {
        [self.completionController insertCurrentCompletionInTextView:self];
    }
    else
    {
        [super keyDown:theEvent];
    }
}

- (void) keyUp:(NSEvent *)theEvent
{
    BOOL visible = self.completionController.isVisible;
    unsigned short code = theEvent.keyCode;
    
    if( visible && (code == kVK_UpArrow || code == kVK_DownArrow))
    {
        [self.completionController.table keyUp:theEvent];
    }
    else if( visible && code == kVK_Return)
    {
        
    }
    else
    {
        [super keyUp:theEvent];
    }
}

@end
