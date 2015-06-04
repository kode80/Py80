//
//  KDEThemeItem.h
//  Py80
//
//  Created by Benjamin S Hopkins on 6/4/15.
//  Copyright (c) 2015 kode80. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KDEThemeItem : NSObject

@property (nonatomic, readwrite, copy) NSColor *color;
@property (nonatomic, readwrite, copy) NSFont *font;

- (instancetype) initWithDictionary:(NSDictionary *)dictionary;
- (NSDictionary *) dictionary;

@end
