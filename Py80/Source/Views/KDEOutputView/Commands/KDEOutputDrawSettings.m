//
//  KDEOutputDrawSettings.m
//  Py80
//
//  Created by Benjamin S Hopkins on 5/30/15.
//  Copyright (c) 2015 kode80. All rights reserved.
//

#import "KDEOutputDrawSettings.h"

@implementation KDEOutputDrawSettings

- (instancetype) copyWithZone:(NSZone *)zone
{
    KDEOutputDrawSettings *copy = [[KDEOutputDrawSettings allocWithZone:zone] init];
    [copy assignFrom:self];
    return copy;
}

- (void) assignFrom:(KDEOutputDrawSettings *)drawSettings
{
    self.strokeColor = [drawSettings.strokeColor copy];
    self.fillColor = [drawSettings.fillColor copy];
    self.strokeWidth = drawSettings.strokeWidth;
    self.font = [drawSettings.font copy];
    
    [self.strokeColor setStroke];
    [self.fillColor setFill];
}

- (void) executeWithDrawSettings:(KDEOutputDrawSettings *)drawSettings
                     inDirtyRect:(NSRect)dirtyRect
{
    [drawSettings assignFrom:self];
}

@end
