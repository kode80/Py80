//
//  KDETextView.m
//  Py80
//
//  Created by Benjamin S Hopkins on 5/27/15.
//  Copyright (c) 2015 kode80. All rights reserved.
//

#import "KDETextView.h"
#import "KDECompletionWindowController.h"

#import "VKConsts.h"

@interface KDETextView ()

@property (nonatomic, readwrite, assign) BOOL didChangeTextTriggersCompletion;
@property (nonatomic, readwrite, copy) NSCharacterSet *triggerCompletionCharSet;

@end


@implementation KDETextView

- (void) awakeFromNib
{
    [super awakeFromNib];
    
    NSMutableCharacterSet *ignoreSet = [NSMutableCharacterSet characterSetWithCharactersInString:@" \t.(){}\""];
    [ignoreSet formUnionWithCharacterSet:[NSCharacterSet newlineCharacterSet]];
    
    self.triggerCompletionCharSet = [ignoreSet invertedSet];
}

- (void) keyDown:(NSEvent *)theEvent
{
    BOOL visible = self.completionController.isVisible;
    unsigned short code = theEvent.keyCode;
    NSEventModifierFlags modifiers = theEvent.modifierFlags;
    
    if( visible && (code == kVK_UpArrow || code == kVK_DownArrow))
    {
        [self.completionController.table keyDown:theEvent];
    }
    else if( visible && code == kVK_Return)
    {
        [self.completionController insertCurrentCompletionInTextView:self];
    }
    else if( visible && code == kVK_Escape)
    {
        [self.completionController hide];
    }
    else if( visible == NO && code == kVK_Space && modifiers & NSControlKeyMask)
    {
        [self.completionController reloadCompletionsForTextView:self];
        [self.completionController showForTextView:self];
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
    else if( visible && code == kVK_Escape)
    {
    }
    else
    {
        [super keyUp:theEvent];
    }
}

#pragma mark NSTextView: Selection change methods

- (void) setSelectedRanges:(NSArray *)ranges affinity:(NSSelectionAffinity)affinity stillSelecting:(BOOL)stillSelectingFlag
{
    [super setSelectedRanges:ranges affinity:affinity stillSelecting:stillSelectingFlag];
    
    if( stillSelectingFlag == NO)
    {
        [self.completionController hide];
    }
}

#pragma mark NSTextView: Text change methods

- (BOOL) shouldChangeTextInRange:(NSRange)affectedCharRange replacementString:(NSString *)replacementString
{
    BOOL result = [super shouldChangeTextInRange:affectedCharRange
                               replacementString:replacementString];
    
    self.didChangeTextTriggersCompletion = result &&
                                           replacementString.length == 1 &&
                                           [self.triggerCompletionCharSet characterIsMember:[replacementString characterAtIndex:0]];
    
    return result;
}

- (void)didChangeText
{
    [super didChangeText];
    
    if( self.didChangeTextTriggersCompletion)
    {
        self.didChangeTextTriggersCompletion = NO;
        [self.completionController reloadCompletionsForTextView:self];
        [self.completionController showForTextView:self];
    }
}

@end
