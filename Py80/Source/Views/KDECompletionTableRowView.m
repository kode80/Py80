//
//  KDECompletionTableRowView.m
//  Py80
//
//  Created by Benjamin S Hopkins on 5/28/15.
//  Copyright (c) 2015 kode80. All rights reserved.
//

#import "KDECompletionTableRowView.h"

@implementation KDECompletionTableRowView

- (void) drawSelectionInRect:(NSRect)dirtyRect
{
    NSGradient *gradient = [[NSGradient alloc] initWithColors:@[ [NSColor colorWithDeviceRed:0.443 green:0.655 blue:0.871 alpha:1.000],
                                                                 [NSColor colorWithDeviceRed:0.133 green:0.427 blue:0.725 alpha:1.000]]];
    [gradient drawInRect:dirtyRect
                   angle:90];
}

@end
