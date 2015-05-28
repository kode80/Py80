//
//  KDECompletionWindowController.m
//  Py80
//
//  Created by Benjamin S Hopkins on 5/27/15.
//  Copyright (c) 2015 kode80. All rights reserved.
//

#import "KDECompletionWindowController.h"

#import "KDEPython.h"
#import "KDEPyCompletion.h"
#import "KDEPyCallSignature.h"

#import "NSString+CursorPosition.h"


@interface KDECompletionWindowController ()

@property (nonatomic, readwrite, strong) NSArray *completions;
@property (nonatomic, readwrite, assign) CGFloat typeColumnWidth;

@end


@implementation KDECompletionWindowController

- (BOOL) isVisible
{
    return self.window.isVisible;
}

- (void) reloadCompletionsForTextView:(NSTextView *)textView
{
    NSString *source = textView.string;
    KDEStringCursor cursor = [source cursorForRange:textView.selectedRange];
    
    NSArray *completionObjects = [[KDEPython sharedPython] completionsForSourceString:source
                                                                                 line:cursor.line
                                                                               column:cursor.column];
    
    NSMutableArray *signatures = [NSMutableArray array];
    NSMutableArray *completions = [NSMutableArray array];
    
    for( id obj in completionObjects)
    {
        if( [obj isKindOfClass:[KDEPyCompletion class]])
        {
            [completions addObject:obj];
        }
        else if( [obj isKindOfClass:[KDEPyCallSignature class]])
        {
            [signatures addObject:obj];
        }
    }
    
    NSMutableDictionary *completionDictionary = [NSMutableDictionary dictionary];
    NSMutableArray *types;
    NSString *type;
    for( KDEPyCompletion *completion in completions)
    {
        type = completion.type;
        types = completionDictionary[ type];
        if( types == nil)
        {
            types = [NSMutableArray array];
            completionDictionary[ type] = types;
        }
        
        [types addObject:completion];
    }
    
    NSMutableArray *c = [NSMutableArray array];
    for( type in completionDictionary)
    {
        types = completionDictionary[ type];
        for( KDEPyCompletion *completion in types)
        {
            [c addObject:completion];
        }
    }
    
    NSTableColumn *typeColumn = self.table.tableColumns[ [self.table columnWithIdentifier:@"Type"]];
    self.typeColumnWidth = [self columnWidthForTypeNames:[completionDictionary allKeys]];
    typeColumn.minWidth = self.typeColumnWidth;
    typeColumn.width = self.typeColumnWidth;
    
    self.completions = [NSArray arrayWithArray:c];
    [self.table reloadData];
    
    if( self.completions.count == 0)
    {
        [self hide];
    }
}

- (void) insertCurrentCompletionInTextView:(NSTextView *)textView
{
    NSInteger index = self.table.selectedRow;
    
    if( index > -1)
    {
        KDEPyCompletion *completion = self.completions[ index];
        [textView insertText:completion.complete];
        [self hide];
    }
}

- (void) showForTextView:(NSTextView *)textView
{
    if( [KDEPython sharedPython].isInitialized && self.completions.count)
    {
        NSRange range = textView.selectedRange;
        range.location -= [self currentIncompleteString].length;
        
        NSRect frame = self.window.frame;
        frame.size.height = MIN( [self tableHeightForRowCount:8],
                                 [self tableHeightForRowCount:self.completions.count]);
        frame.origin = [self windowPointForRange:range
                                      inTextView:textView];
        frame.origin.x -= self.typeColumnWidth + 6.0f;
        
        frame = [textView.window convertRectToScreen:frame];
        frame.origin.y -= frame.size.height;
        
        [self showWindow:nil];
        [self.window setFrame:frame
                      display:YES];
    }
}

- (void) hide
{
    [self close];
}

#pragma mark - NSTableViewDataSource

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView
{
    return self.completions.count;
}

#pragma mark - NSTableViewDelegate

- (NSView *) tableView:(NSTableView *)tableView
    viewForTableColumn:(NSTableColumn *)tableColumn
                   row:(NSInteger)row
{
    NSTableCellView *view = [tableView makeViewWithIdentifier:tableColumn.identifier
                                                        owner:self];
    KDEPyCompletion *completion = self.completions[ row];
    NSMutableString *string = [NSMutableString string];

    if( [tableColumn.identifier isEqualToString:@"Type"])
    {
        [string appendString:completion.type];
    }
    else if( [tableColumn.identifier isEqualToString:@"Completion"])
    {
        [string appendString:completion.name];
        
        if( [completion.type isEqualToString:@"function"])
        {
            [string appendString:@"("];
            if( completion.argNames.count)
            {
                [string appendFormat:@" %@",[completion.argNames componentsJoinedByString:@", "]];
            }
            [string appendString:@")"];
        }
    }
    
    view.textField.stringValue = string;
    
    return view;
}

#pragma mark - private

- (CGFloat) tableHeightForRowCount:(NSInteger)rowCount
{
    return rowCount * (self.table.rowHeight + self.table.intercellSpacing.height);
}

- (NSPoint) windowPointForRange:(NSRange)range
                     inTextView:(NSTextView *)textView
{
    NSString *source = textView.string;
    
    NSRange lineRange = [source lineRangeForRange:range];
    lineRange.length = range.location - lineRange.location;
    
    NSRange glyphRange = [textView.layoutManager glyphRangeForCharacterRange:lineRange
                                                        actualCharacterRange:NULL];
    NSRect lineRect = [textView.layoutManager boundingRectForGlyphRange:glyphRange
                                                        inTextContainer:textView.textContainer];

    NSPoint point = NSMakePoint( NSMaxX( lineRect), NSMaxY( lineRect));
    return [textView convertPoint:point
                           toView:nil];
}

- (CGFloat) columnWidthForTypeNames:(NSArray *)typeNames
{
    NSTableCellView *view = [self.table makeViewWithIdentifier:@"Type"
                                                         owner:self];
    
    CGFloat width = 0.0f;
    CGSize size;
    NSDictionary *attributes = @{ NSFontAttributeName : view.textField.font };
    for( NSString *type in typeNames)
    {
        size = [type sizeWithAttributes:attributes];
        if( size.width > width)
        {
            width = size.width;
        }
    }
    return width + 6.0f;
}

- (NSString *) currentIncompleteString
{
    if( self.completions.count)
    {
        KDEPyCompletion *completion = self.completions.firstObject;
        
        if( completion.complete.length == 0)
        {
            // It's possible that the first completion will be complete
            // eg: "math.acos" would return completions, "acos" and "acosh"
            return completion.name;
        }
        else
        {
            NSRange range = [completion.name rangeOfString:completion.complete
                                                   options:NSBackwardsSearch];
            BOOL isValidRange = range.location > 0 && range.location != NSNotFound;
            
            return isValidRange ? [completion.name substringToIndex:range.location] : nil;
        }
    }
    
    return nil;
}

@end
