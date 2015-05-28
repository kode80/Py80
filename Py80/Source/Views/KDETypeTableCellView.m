//
//  KDETypeTableCellView.m
//  Py80
//
//  Created by Benjamin S Hopkins on 5/28/15.
//  Copyright (c) 2015 kode80. All rights reserved.
//

#import "KDETypeTableCellView.h"
#import "KDECompletionTableCellView.h"

@implementation KDETypeTableCellView

- (void) setBackgroundStyle:(NSBackgroundStyle)backgroundStyle
{
    NSTableRowView *row = (NSTableRowView*)self.superview;
    self.textField.textColor = row.isSelected ? [NSColor whiteColor] : [NSColor grayColor];
    self.textField.shadow = row.isSelected ? [KDECompletionTableCellView selectedTextShadow] : nil;
}

@end
