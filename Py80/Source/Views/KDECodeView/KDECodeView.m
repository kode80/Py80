//
//  KDECodeView.m
//  Py80
//
//  Created by Benjamin S Hopkins on 6/9/15.
//  Copyright (c) 2015 kode80. All rights reserved.
//

#import "KDECodeView.h"
#import "KDECodeViewVKConsts.h"
#import "KDECompletionWindowController.h"
#import "KDETokenizer.h"
#import "KDETokenizedString.h"
#import "KDETheme.h"

#import "NSString+RangeUtils.h"
#import "NSString+PythonRangeUtils.h"
#import "NSCharacterSet+PythonSets.h"

@interface KDECodeView ()

@property (nonatomic, readwrite, assign) BOOL didChangeTextTriggersCompletion;
@property (nonatomic, readwrite, copy) NSCharacterSet *triggerCompletionCharSet;

@end


@implementation KDECodeView

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
    
    self.triggerCompletionCharSet = [NSCharacterSet pythonIdentifierCharacterSet];
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
    
    if( modifiers & NSAlternateKeyMask && modifiers & NSShiftKeyMask &&
            code == kVK_LeftArrow)
    {
        [self setSelectedRange:[self.string expandSelectionLeftToNextPythonBoundary:self.selectedRange]];
    }
    else if( modifiers & NSAlternateKeyMask && modifiers & NSShiftKeyMask &&
            code == kVK_RightArrow)
    {
        [self setSelectedRange:[self.string expandSelectionRightToNextPythonBoundary:self.selectedRange]];
    }
    else if( modifiers & NSAlternateKeyMask &&
        code == kVK_LeftArrow)
    {
        [self setSelectedRange:[self.string jumpLeftToNextPythonBoundary:self.selectedRange]];
    }
    else if( modifiers & NSAlternateKeyMask &&
            code == kVK_RightArrow)
    {
        [self setSelectedRange:[self.string jumpRightToNextPythonBoundary:self.selectedRange]];
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

#pragma mark Accessors

- (void) setTokenizer:(KDETokenizer *)tokenizer
{
    if( _tokenizer != tokenizer)
    {
        _tokenizer = tokenizer;
        [self refreshColor];
    }
}

- (void) setTheme:(KDETheme *)theme
{
    _theme = theme;
    [self refreshColor];
}

- (void) setString:(NSString *)string
{
    [super setString:string];
    [self refreshColor];
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
        NSCharacterSet *allowedCharacters = [NSCharacterSet pythonIdentifierCharacterSet];
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
    
    [self refreshColor];
    
    if( self.didChangeTextTriggersCompletion)
    {
        self.didChangeTextTriggersCompletion = NO;
        [self.completionController reloadCompletionsForTextView:self];
        [self.completionController showForTextView:self];
    }
}

#pragma mark - private

- (void) refreshColor
{
    if( self.theme && self.tokenizer)
    {
        KDETokenizedString *tokenizedString = [[KDETokenizedString alloc] initWithString:self.string
                                                                               tokenizer:self.tokenizer];
        [self.textStorage setAttributedString:[tokenizedString attributedStringWithTheme:self.theme]];
    }
}

@end
