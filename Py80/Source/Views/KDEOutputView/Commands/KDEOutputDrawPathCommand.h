//
//  KDEOutputDrawPathCommand.h
//  Py80
//
//  Created by Benjamin S Hopkins on 5/30/15.
//  Copyright (c) 2015 kode80. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KDEOutputCommand.h"

@interface KDEOutputDrawPathCommand : KDEOutputCommand

@property (nonatomic, readwrite, strong) NSBezierPath *path;

@end
