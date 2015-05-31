//
//  KDEOutputDrawImageCommand.m
//  Py80
//
//  Created by Benjamin S Hopkins on 5/31/15.
//  Copyright (c) 2015 kode80. All rights reserved.
//

#import "KDEOutputDrawImageCommand.h"

@implementation KDEOutputDrawImageCommand

- (void) executeWithDrawSettings:(KDEOutputDrawSettings *)drawSettings
{
    [self.image drawInRect:self.rect];
}

@end
