//
//  KDEOutputDrawTextCommand.m
//  Py80
//
//  Created by Benjamin S Hopkins on 5/30/15.
//  Copyright (c) 2015 kode80. All rights reserved.
//

#import "KDEOutputDrawTextCommand.h"
#import "KDEOutputDrawSettings.h"

@implementation KDEOutputDrawTextCommand

- (void) executeWithDrawSettings:(KDEOutputDrawSettings *)drawSettings
                     inDirtyRect:(NSRect)dirtyRect
{
    NSColor *backgroundColor = drawSettings.fillColor ?: [NSColor clearColor];
    NSColor *foregroundColor = drawSettings.strokeColor ?: [NSColor blackColor];
    [self.text drawAtPoint:self.location
            withAttributes:@{ NSBackgroundColorAttributeName : backgroundColor,
                              NSForegroundColorAttributeName : foregroundColor,
                              NSFontAttributeName : drawSettings.font }];
}

@end
