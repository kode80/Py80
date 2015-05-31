//
//  KDEOutputDrawImageCommand.h
//  Py80
//
//  Created by Benjamin S Hopkins on 5/31/15.
//  Copyright (c) 2015 kode80. All rights reserved.
//

#import "KDEOutputCommand.h"

@interface KDEOutputDrawImageCommand : KDEOutputCommand

@property (nonatomic, readwrite, strong) NSImage *image;
@property (nonatomic, readwrite, assign) NSRect rect;

@end
