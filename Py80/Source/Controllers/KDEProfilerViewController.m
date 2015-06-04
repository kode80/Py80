//
//  KDEProfilerViewController.m
//  Py80
//
//  Created by Benjamin S Hopkins on 6/3/15.
//  Copyright (c) 2015 kode80. All rights reserved.
//

#import "KDEProfilerViewController.h"
#import "KDEPyProfilerStat.h"


@interface KDEProfilerViewController ()

@property (nonatomic, readwrite, strong) NSNumberFormatter *numberFormatter;

@end


@implementation KDEProfilerViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.numberFormatter = [NSNumberFormatter new];
    self.numberFormatter.numberStyle = NSNumberFormatterDecimalStyle;
    self.numberFormatter.maximumFractionDigits = 16;
    self.table.doubleAction = @selector(tableDidDoubleClick:);
}

- (void) setStats:(NSArray *)stats
{
    if( _stats != stats)
    {
        _stats = stats;
        [self.table reloadData];
    }
}

- (IBAction) tableDidDoubleClick:(id)sender
{
    if( self.table.clickedRow > -1 &&
        [self.delegate respondsToSelector:@selector(profilerViewController:didDoubleClickStat:)])
    {
        [self.delegate profilerViewController:self
                           didDoubleClickStat:self.stats[ self.table.clickedRow]];
    }
}

#pragma mark - NSTableViewDataSource

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView
{
    return self.stats.count;
}

- (void) tableViewSelectionDidChange:(NSNotification *)notification
{
    
}

- (void)tableView:(NSTableView *)aTableView
sortDescriptorsDidChange:(NSArray *)oldDescriptors
{
    if( aTableView.sortDescriptors.firstObject)
    {
        self.stats = [self.stats sortedArrayUsingDescriptors:aTableView.sortDescriptors];
        [self.table reloadData];
    }
}

#pragma mark - NSTableViewDelegate

- (NSView *) tableView:(NSTableView *)tableView
    viewForTableColumn:(NSTableColumn *)tableColumn
                   row:(NSInteger)row
{
    NSTableCellView *view = [tableView makeViewWithIdentifier:tableColumn.identifier
                                                        owner:self];
    KDEPyProfilerStat *stat = self.stats[ row];
    NSString *valueString = nil;
    
    if( [tableColumn.identifier isEqualToString:@"calls"])
    {
        valueString = [self.numberFormatter stringFromNumber:stat.callCount];
    }
    else if( [tableColumn.identifier isEqualToString:@"recursive"])
    {
        valueString = [self.numberFormatter stringFromNumber:stat.recallCount];
    }
    else if( [tableColumn.identifier isEqualToString:@"inline"])
    {
        valueString = [self.numberFormatter stringFromNumber:stat.inlineTime];
    }
    else if( [tableColumn.identifier isEqualToString:@"total"])
    {
        valueString = [self.numberFormatter stringFromNumber:stat.totalTime];
    }
    else if( [tableColumn.identifier isEqualToString:@"name"])
    {
        valueString = stat.name;
    }
    else if( [tableColumn.identifier isEqualToString:@"line"])
    {
        valueString = [self.numberFormatter stringFromNumber:stat.lineNumber];
    }
    else if( [tableColumn.identifier isEqualToString:@"filename"])
    {
        valueString = stat.filename;
    }
    
    view.textField.stringValue = valueString ?: @"";
    
    return view;
}

@end
