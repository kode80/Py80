//
//  KDECompletionViewController.m
//  Py80
//
//  Created by Benjamin S Hopkins on 5/27/15.
//  Copyright (c) 2015 kode80. All rights reserved.
//

#import "KDECompletionViewController.h"

#import "KDEPython.h"
#import "KDEPyCompletion.h"
#import "KDEPyCallSignature.h"


@interface KDECompletionViewController ()

@property (nonatomic, readwrite, strong) NSArray *completions;

@end


@implementation KDECompletionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do view setup here.
}

- (BOOL) isVisible
{
    return self.view.window.isVisible;
}

- (void) reloadCompletionsForTextView:(NSTextView *)textView
{
    NSString *source = textView.string;
    const NSRange cursorRange = NSMakeRange( textView.selectedRange.location, 0);
    NSRange currentRange = NSMakeRange( 0, 0);
    NSRange lineRange = [source lineRangeForRange:currentRange];
    
    NSInteger lineNumber = 1;
    
    while( lineRange.location < cursorRange.location &&
          NSMaxRange( lineRange) < cursorRange.location &&
          NSMaxRange( currentRange) < source.length)
    {
        lineNumber++;
        currentRange.location = NSMaxRange( lineRange);
        lineRange = [source lineRangeForRange:currentRange];
    }
    
    NSInteger columnNumber = (cursorRange.location - lineRange.location);
    
    NSCharacterSet *newLineChars = [NSCharacterSet newlineCharacterSet];
    unichar characterAtCursor = cursorRange.location < source.length ? [source characterAtIndex:cursorRange.location] : 0;
    unichar characterBeforeCursor = cursorRange.location > 0 ? [source characterAtIndex:cursorRange.location - 1] : 0;
    
    BOOL beforeIsNewLine = [newLineChars characterIsMember:characterBeforeCursor];
    BOOL cursorIsNewLine = [newLineChars characterIsMember:characterAtCursor];
    
    if( (beforeIsNewLine && cursorIsNewLine == NO) ||
       (beforeIsNewLine && cursorIsNewLine))
    {
        lineNumber++;
        columnNumber = 0;
    }
    
    
    
    NSArray *completionObjects = [[KDEPython sharedPython] completionsForSourceString:source
                                                                                 line:lineNumber
                                                                               column:columnNumber];
    
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
    self.completions = [NSArray arrayWithArray:c];
    [self.table reloadData];
}

- (void) insertCurrentCompletionInTextView:(NSTextView *)textView
{
    NSInteger index = self.table.selectedRow;
    
    if( index > -1)
    {
        KDEPyCompletion *completion = self.completions[ index];
        [textView insertText:completion.complete];
    }
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
    NSTableCellView *view = [tableView makeViewWithIdentifier:@"Completion" owner:self];
    KDEPyCompletion *completion = self.completions[ row];
    view.textField.stringValue = completion.name;
    
    return view;
}

@end
