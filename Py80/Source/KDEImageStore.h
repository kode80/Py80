//
//  KDEImageStore.h
//  Py80
//
//  Created by Benjamin S Hopkins on 5/31/15.
//  Copyright (c) 2015 kode80. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KDEImageStore : NSObject

@property (nonatomic, readonly, assign) NSUInteger count;

- (void) reset;

- (NSUInteger) addImageAtPath:(NSString *)path;
- (NSUInteger) addImageWithRGBABytes:(NSData *)data
                               width:(NSUInteger)width
                              height:(NSUInteger)height;

- (NSImage *) getImage:(NSUInteger)imageID;

@end
