//
//  KDEOutputDrawSettings.h
//  Py80
//
//  Created by Benjamin S Hopkins on 5/30/15.
//  Copyright (c) 2015 kode80. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KDEOutputCommand.h"

@interface KDEOutputDrawSettings : KDEOutputCommand <NSCopying>

@property (nonatomic, readwrite, strong) NSColor *strokeColor;
@property (nonatomic, readwrite, strong) NSColor *fillColor;
@property (nonatomic, readwrite, assign) CGFloat strokeWidth;
@property (nonatomic, readwrite, strong) NSFont *font;

- (void) assignFrom:(KDEOutputDrawSettings *)drawSettings;

@end
