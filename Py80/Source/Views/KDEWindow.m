//
//  KDEWindow.m
//  Py80
//
//  Created by Benjamin S Hopkins on 5/27/15.
//  Copyright (c) 2015 kode80. All rights reserved.
//

#import "KDEWindow.h"

@implementation KDEWindow

- (instancetype) initWithContentRect:(NSRect)contentRect
                           styleMask:(NSUInteger)aStyle
                             backing:(NSBackingStoreType)bufferingType
                               defer:(BOOL)flag
{
    self = [super initWithContentRect:contentRect styleMask:aStyle backing:bufferingType defer:flag];
    if( self)
    {
        self.opaque = NO;
        self.backgroundColor = [NSColor clearColor];
    }
    return self;
}

- (void) setContentView:(NSView *)contentView
{
    contentView.wantsLayer = YES;
    contentView.layer.frame = contentView.frame;
    contentView.layer.cornerRadius = 5.0f;
    contentView.layer.masksToBounds = YES;
    
    [super setContentView:contentView];
}

@end
