//
//  KDEOutputDrawTextCommand.h
//  Py80
//
//  Created by Benjamin S Hopkins on 5/30/15.
//  Copyright (c) 2015 kode80. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KDEOutputCommand.h"

@interface KDEOutputDrawTextCommand : KDEOutputCommand

@property (nonatomic, readwrite, copy) NSString *text;
@property (nonatomic, readwrite, assign) NSPoint location;

@end
