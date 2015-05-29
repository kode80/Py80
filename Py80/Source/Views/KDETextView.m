//
//  KDETextView.m
//  Py80
//
//  Created by Benjamin S Hopkins on 5/27/15.
//  Copyright (c) 2015 kode80. All rights reserved.
//

#import "KDETextView.h"
#import "KDECompletionWindowController.h"

#import "NSString+RangeUtils.h"

#import "VKConsts.h"

@interface KDETextView ()

@property (nonatomic, readwrite, assign) BOOL didChangeTextTriggersCompletion;
@property (nonatomic, readwrite, copy) NSCharacterSet *triggerCompletionCharSet;

@end


@implementation KDETextView

- (void) dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (BOOL)resignFirstResponder
{
    BOOL result = [super resignFirstResponder];
    if( result)
    {
        [self.completionController hide];
    }
    return result;
}

- (void) awakeFromNib
{
    [super awakeFromNib];
    
    NSMutableCharacterSet *ignoreSet = [NSMutableCharacterSet characterSetWithCharactersInString:@" \t.(){}\"#="];
    [ignoreSet formUnionWithCharacterSet:[NSCharacterSet newlineCharacterSet]];
    
    self.triggerCompletionCharSet = [ignoreSet invertedSet];
}

- (void)viewWillMoveToWindow:(NSWindow *)newWindow
{
    if( newWindow)
    {
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(windowWillClose:)
                                                     name:NSWindowWillCloseNotification
                                                   object:newWindow];
    }
    else
    {
        [[NSNotificationCenter defaultCenter] removeObserver:self
                                                        name:NSWindowWillCloseNotification
                                                      object:self.window];
    }
    [super viewWillMoveToWindow:newWindow];
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

#pragma mark Notifications

- (void) windowWillClose:(NSNotification *)notification
{
    [self.completionController hide];
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

- (NSRange)selectionRangeForProposedRange:(NSRange)proposedSelRange
                              granularity:(NSSelectionGranularity)granularity
{
    if( granularity == NSSelectByWord)
    {
        NSString *source = self.string;
        NSCharacterSet *allowedCharacters = [NSCharacterSet characterSetWithCharactersInString: @"abcdefghijklmnopqrstuvwxyz"
                                                                                                @"ABCDEFGHIJKLMNOPQRSTUVWXYZ"
                                                                                                @"0123456789_"];
        NSCharacterSet *numberCharacters = [NSCharacterSet characterSetWithCharactersInString:@"0123456789"];
        NSUInteger index = proposedSelRange.location;
        
        if( index < source.length &&
            [allowedCharacters characterIsMember:[source characterAtIndex:index]])
        {
            NSRange expandedRange = [source expandRange:proposedSelRange
                                 withBoundaryCharacters:[allowedCharacters invertedSet]];
            
            NSString *subString = [source substringWithRange:expandedRange];
            
            if( subString.length &&
                [numberCharacters characterIsMember:[subString characterAtIndex:0]] == NO)
            {
                return expandedRange;
            }
        }
    }
    
    return [super selectionRangeForProposedRange:proposedSelRange
                                     granularity:granularity];
}

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
