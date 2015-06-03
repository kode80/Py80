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

@end


@implementation KDEProfilerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do view setup here.
}

- (void) setStats:(NSArray *)stats
{
    if( _stats != stats)
    {
        _stats = stats;
        [self.table reloadData];
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
        valueString = [stat.callCount stringValue];
    }
    else if( [tableColumn.identifier isEqualToString:@"recursive"])
    {
        valueString = [stat.recallCount stringValue];
    }
    else if( [tableColumn.identifier isEqualToString:@"inline"])
    {
        valueString = [stat.inlineTime stringValue];
    }
    else if( [tableColumn.identifier isEqualToString:@"total"])
    {
        valueString = [stat.totalTime stringValue];
    }
    else if( [tableColumn.identifier isEqualToString:@"name"])
    {
        valueString = stat.name;
    }
    else if( [tableColumn.identifier isEqualToString:@"line"])
    {
        valueString = [stat.lineNumber stringValue];
    }
    else if( [tableColumn.identifier isEqualToString:@"filename"])
    {
        valueString = stat.filename;
    }
    
    view.textField.stringValue = valueString ?: @"";
    
    return view;
}

@end
