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
    size_t dataSize = width * height * 4;
    
    if( dataSize && data.length == dataSize)
    {
        unsigned char *bytes = (unsigned char *)data.bytes;

        // NSBitmapImageRep requires that bitmap uses pre-multiplied alpha
        float a;
        for( NSInteger i=0; i<width * height; i++)
        {
            a = bytes[ i * 4 + 3] / 255.0f;
            bytes[ i * 4] *= a;
            bytes[ i * 4 + 1] *= a;
            bytes[ i * 4 + 2] *= a;
        }
        
        NSBitmapImageRep *imageRep = [[NSBitmapImageRep alloc] initWithBitmapDataPlanes:&bytes
                                                                             pixelsWide:width
                                                                             pixelsHigh:height
                                                                          bitsPerSample:8
                                                                        samplesPerPixel:4
                                                                               hasAlpha:YES
                                                                               isPlanar:NO
                                                                         colorSpaceName:NSDeviceRGBColorSpace
                                                                            bytesPerRow:width * 4
                                                                           bitsPerPixel:32];

        // This is the only way I've ever been able to get a reliable NSImage
        // All other approaches result in drawing glitches depending on size.
        NSImage *image = [[NSImage alloc] initWithData:[imageRep TIFFRepresentation]];

        if( image)
        {
            self.images = [self.images arrayByAddingObject:image];
            return self.images.count;
        }
    }
    
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
