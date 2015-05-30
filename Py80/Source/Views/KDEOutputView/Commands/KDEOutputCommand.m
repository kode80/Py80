//
//  KDEOutputCommand.m
//  Py80
//
//  Created by Benjamin S Hopkins on 5/30/15.
//  Copyright (c) 2015 kode80. All rights reserved.
//

#import "KDEOutputCommand.h"

#import "KDEOutputDrawSettings.h"


@implementation KDEOutputCommand

- (void) executeWithDrawSettings:(KDEOutputDrawSettings *)drawSettings
{
    @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                   reason:@"KDEOutputDrawSettings subclasses must implemented executeWithDrawSettings:"
                                 userInfo:nil];
}

@end
