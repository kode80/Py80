//
//  KDECompletionTableCellView.m
//  Py80
//
//  Created by Benjamin S Hopkins on 5/28/15.
//  Copyright (c) 2015 kode80. All rights reserved.
//

#import "KDECompletionTableCellView.h"

@implementation KDECompletionTableCellView

+ (NSShadow *) selectedTextShadow
{
    NSShadow *shadow = [NSShadow new];
    shadow.shadowOffset = CGSizeMake( 0.0f, 1.0f);
    shadow.shadowColor = [NSColor colorWithWhite:0.0f
                                                    alpha:0.5f];
    shadow.shadowBlurRadius = 0;
    
    return shadow;
}

- (void) setBackgroundStyle:(NSBackgroundStyle)backgroundStyle
{
    NSTableRowView *row = (NSTableRowView*)self.superview;
    self.textField.textColor = row.isSelected ? [NSColor whiteColor] : [NSColor blackColor];
    self.textField.shadow = row.isSelected ? [KDECompletionTableCellView selectedTextShadow] : nil;
}

@end
