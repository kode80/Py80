//
//  KDEImageStore.m
//  Py80
//
//  Created by Benjamin S Hopkins on 5/31/15.
//  Copyright (c) 2015 kode80. All rights reserved.
//

#import "KDEImageStore.h"


@interface KDEImageStore ()

@property (nonatomic, readwrite, strong) NSArray *images;

@end


@implementation KDEImageStore

- (instancetype) init
{
    self = [super init];
    
    if( self)
    {
        [self reset];
    }
    
    return self;
}

- (NSUInteger) count
{
    return self.images.count;
}

- (void) reset
{
    self.images = @[];
}

- (NSUInteger) addImageAtPath:(NSString *)path
{
    NSImage *image = [[NSImage alloc] initWithContentsOfFile:path];
    
    if( image)
    {
        self.images = [self.images arrayByAddingObject:image];
        return self.images.count;
    }
    
    return 0;
}

- (NSUInteger) addImageWithRGBABytes:(NSData *)data
                               width:(NSUInteger)width
                              height:(NSUInteger)height
{
    return 0;
}

- (NSImage *) getImage:(NSUInteger)imageID
{
    if( imageID > 0 && imageID <= self.count)
    {
        return self.images[ imageID - 1];
    }
    return 0;
}

@end
