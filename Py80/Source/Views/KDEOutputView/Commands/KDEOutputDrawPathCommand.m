//
//  KDEOutputDrawPathCommand.m
//  Py80
//
//  Created by Benjamin S Hopkins on 5/30/15.
//  Copyright (c) 2015 kode80. All rights reserved.
//

#import "KDEOutputDrawPathCommand.h"
#import "KDEOutputDrawSettings.h"

@implementation KDEOutputDrawPathCommand

- (void) executeWithDrawSettings:(KDEOutputDrawSettings *)drawSettings
                     inDirtyRect:(NSRect)dirtyRect
{
    if( drawSettings.fillColor)
    {
        [self.path fill];
    }
    
    if( drawSettings.strokeWidth > 0.0f)
    {
        self.path.lineWidth = drawSettings.strokeWidth;
        [self.path stroke];
    }
}

@end
