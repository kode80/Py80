//
//  KDETypeTableCellView.m
//  Py80
//
//  Created by Benjamin S Hopkins on 5/28/15.
//  Copyright (c) 2015 kode80. All rights reserved.
//

#import "KDETypeTableCellView.h"

@implementation KDETypeTableCellView

- (void) setBackgroundStyle:(NSBackgroundStyle)backgroundStyle
{
    NSTableRowView *row = (NSTableRowView*)self.superview;
    self.textField.textColor = row.isSelected ? [NSColor whiteColor] : [NSColor grayColor];
}

@end
