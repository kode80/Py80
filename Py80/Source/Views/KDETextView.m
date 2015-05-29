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
    NSRange range;
    NSCharacterSet *boundaryCharacters;
    unichar character;
    
    if( modifiers & NSAlternateKeyMask && modifiers & NSShiftKeyMask &&
            code == kVK_LeftArrow)
    {
        range = self.selectedRange;
        if( range.location > 0)
        {
            boundaryCharacters = [[self identifierCharacterSet] invertedSet];
            
            range = [self.string expandRangeLeft:range
                          withBoundaryCharacters:boundaryCharacters];
            
            if( range.location == self.selectedRange.location)
            {
                range.location--;
                range.length++;
            }
            
            [self setSelectedRange:range];
        }
    }
    else if( modifiers & NSAlternateKeyMask && modifiers & NSShiftKeyMask &&
            code == kVK_RightArrow)
    {
        range = self.selectedRange;
        if( NSMaxRange( range) + 1 < self.string.length)
        {
            boundaryCharacters = [[self identifierCharacterSet] invertedSet];
            character = [self.string characterAtIndex:NSMaxRange( range)];
            
            if( [boundaryCharacters characterIsMember:character])
            {
                range.length++;
            }
            else
            {
                range = [self.string expandRangeRight:range
                               withBoundaryCharacters:boundaryCharacters];
                
                if( NSMaxRange( range) == NSMaxRange( self.selectedRange) &&
                    NSMaxRange( range) + 1 < self.string.length)
                {
                    range.length++;
                }
            }
            
            [self setSelectedRange:range];
        }
    }
    else if( modifiers & NSAlternateKeyMask &&
        code == kVK_LeftArrow)
    {
        range = self.selectedRange;
        if( range.location > 0)
        {
            boundaryCharacters = [[self identifierCharacterSet] invertedSet];
            
            range = [self.string expandRangeLeft:range
                          withBoundaryCharacters:boundaryCharacters];
            range.length = 0;
            
            if( range.location == self.selectedRange.location)
            {
                range.location--;
            }
            
            [self setSelectedRange:range];
        }
    }
    else if( modifiers & NSAlternateKeyMask &&
            code == kVK_RightArrow)
    {
        range = self.selectedRange;
        if( NSMaxRange( range) + 1 < self.string.length)
        {
            boundaryCharacters = [[self identifierCharacterSet] invertedSet];
            character = [self.string characterAtIndex:NSMaxRange( range)];
            
            if( [boundaryCharacters characterIsMember:character])
            {
                range.location++;
            }
            else
            {
                range = [self.string expandRangeRight:range
                               withBoundaryCharacters:boundaryCharacters];
                range.location = NSMaxRange( range);
                range.length = 0;
                
                if( range.location == NSMaxRange( self.selectedRange) &&
                    range.location + 1 < self.string.length)
                {
                    range.location++;
                }
            }
            
            [self setSelectedRange:range];
        }
    }
    else if( visible &&
        (code == kVK_UpArrow || code == kVK_DownArrow))
    {
        [self.completionController.table keyDown:theEvent];
    }
    else if( visible &&
             code == kVK_Return)
    {
        [self.completionController insertCurrentCompletionInTextView:self];
    }
    else if( visible &&
             code == kVK_Escape)
    {
        [self.completionController hide];
    }
    else if( visible == NO &&
             code == kVK_Space && modifiers & NSControlKeyMask)
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
    NSEventModifierFlags modifiers = theEvent.modifierFlags;
    
    
    if( modifiers & NSAlternateKeyMask && modifiers & NSShiftKeyMask &&
            code == kVK_LeftArrow)
    {
    }
    else if( modifiers & NSAlternateKeyMask && modifiers & NSShiftKeyMask &&
            code == kVK_RightArrow)
    {
    }
    else if( modifiers & NSAlternateKeyMask &&
        code == kVK_LeftArrow)
    {
    }
    else if( modifiers & NSAlternateKeyMask &&
             code == kVK_RightArrow)
    {
    }
    else if( visible && (code == kVK_UpArrow || code == kVK_DownArrow))
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

- (NSRange)selectionRangeForProposedRange:(NSRange)proposedSelRange
                              granularity:(NSSelectionGranularity)granularity
{   
    if( granularity == NSSelectByWord)
    {
        NSString *source = self.string;
        NSCharacterSet *allowedCharacters = [self identifierCharacterSet];
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

#pragma mark - private

- (NSCharacterSet *) identifierCharacterSet
{
    return [NSCharacterSet characterSetWithCharactersInString:@"abcdefghijklmnopqrstuvwxyz"
                                                              @"ABCDEFGHIJKLMNOPQRSTUVWXYZ"
                                                              @"0123456789_"];
}

@end
