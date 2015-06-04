//
//  KDETheme.h
//  Py80
//
//  Created by Benjamin S Hopkins on 6/4/15.
//  Copyright (c) 2015 kode80. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KDETheme : NSObject

- (instancetype) initWithDictionary:(NSDictionary *)dictionary;
- (NSDictionary *) dictionary;

- (NSColor *) colorForItemName:(NSString *)name;
- (NSFont *) fontForItemName:(NSString *)name;

- (void) setColor:(NSColor *)color
      forItemName:(NSString *)name;
- (void) setFont:(NSFont *)font
     forItemName:(NSString *)name;

@end
