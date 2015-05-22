//
//  KDEExceptionView.m
//  Py80
//
//  Created by Benjamin S Hopkins on 5/22/15.
//  Copyright (c) 2015 kode80. All rights reserved.
//

#import "KDEExceptionView.h"

@implementation KDEExceptionView

- (void)drawRect:(NSRect)dirtyRect
{
    [super drawRect:dirtyRect];
}

- (void) layout
{
    [super layout];
    self.label.preferredMaxLayoutWidth = self.label.bounds.size.width;
}

@end
