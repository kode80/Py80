//
//  KDEPy80Context.h
//  Py80
//
//  Created by Benjamin S Hopkins on 5/18/15.
//  Copyright (c) 2015 kode80. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@class KDEPyException;
@protocol KDEPy80ContextDelegate;


@interface KDEPy80Context : NSObject

@property (nonatomic, readwrite, weak) id<KDEPy80ContextDelegate> delegate;

+ (KDEPy80Context *) sharedContext;

- (void) log:(NSString *)message;
- (void) clearLog;


- (NSString *) getClipboard;

- (void) setClipboard:(NSString *)string;


- (void) clearDrawing;

- (void) setStrokeRed:(CGFloat)red
                green:(CGFloat)green
                 blue:(CGFloat)blue
                alpha:(CGFloat)alpha;

- (void) setFillRed:(CGFloat)red
              green:(CGFloat)green
               blue:(CGFloat)blue
              alpha:(CGFloat)alpha;

- (void) setStrokeWidth:(CGFloat)width;

- (void) setFont:(NSString *)fontName
            size:(CGFloat)size;

- (void) drawRectAtX:(CGFloat)x
                   y:(CGFloat)y
           withWidth:(CGFloat)width
              height:(CGFloat)height;

- (void) drawOvalInRectAtX:(CGFloat)x
                         y:(CGFloat)y
                 withWidth:(CGFloat)width
                    height:(CGFloat)height;

- (void) drawText:(NSString *)text
              atX:(CGFloat)x
                y:(CGFloat)y;

- (void) drawImage:(NSInteger)imageID
               atX:(CGFloat)x
                 y:(CGFloat)y;

- (void) drawImage:(NSInteger)imageID
         inRectAtX:(CGFloat)x
                 y:(CGFloat)y
         withWidth:(CGFloat)width
            height:(CGFloat)height;

- (NSUInteger) loadImage:(NSString *)path;

- (NSUInteger) createImageWithBytes:(NSData *)data
                              width:(NSInteger)width
                             height:(NSInteger)height;


- (void) reportExceptionType:(NSString *)type
                 description:(NSString *)description
                    filePath:(NSString *)filePath
                    function:(NSString *)function
                  lineNumber:(NSInteger)lineNumber;

- (void) reportProfileStats:(NSArray *)stats;

@end


@protocol KDEPy80ContextDelegate <NSObject>

@optional
- (void) py80Context:(KDEPy80Context *)context
          logMessage:(NSString *)message;

- (void) py80ContextClearLog:(KDEPy80Context *)context;


- (NSString *) py80ContextGetClipboard:(KDEPy80Context *)context;

- (void) py80Context:(KDEPy80Context *)context
        setClipboard:(NSString *)string;


- (void) py80ContextClearDrawing:(KDEPy80Context *)context;

- (void) py80Context:(KDEPy80Context *)context
        setStrokeRed:(CGFloat)red
               green:(CGFloat)green
                blue:(CGFloat)blue
               alpha:(CGFloat)alpha;

- (void) py80Context:(KDEPy80Context *)context
          setFillRed:(CGFloat)red
               green:(CGFloat)green
                blue:(CGFloat)blue
               alpha:(CGFloat)alpha;

- (void) py80Context:(KDEPy80Context *)context
      setStrokeWidth:(CGFloat)width;

- (void) py80Context:(KDEPy80Context *)context
             setFont:(NSString *)fontName
                size:(CGFloat)size;

- (void) py80Context:(KDEPy80Context *)context
         drawRectAtX:(CGFloat)x
                   y:(CGFloat)y
           withWidth:(CGFloat)width
              height:(CGFloat)height;

- (void) py80Context:(KDEPy80Context *)context
   drawOvalInRectAtX:(CGFloat)x
                   y:(CGFloat)y
           withWidth:(CGFloat)width
              height:(CGFloat)height;

- (void) py80Context:(KDEPy80Context *)context
            drawText:(NSString *)text
                 atX:(CGFloat)x
                   y:(CGFloat)y;

- (void) py80Context:(KDEPy80Context *)context
           drawImage:(NSInteger)imageID
                 atX:(CGFloat)x
                   y:(CGFloat)y;

- (void) py80Context:(KDEPy80Context *)context
           drawImage:(NSInteger)imageID
           inRectAtX:(CGFloat)x
                   y:(CGFloat)y
           withWidth:(CGFloat)width
              height:(CGFloat)height;

- (NSUInteger) py80Context:(KDEPy80Context *)context
                 loadImage:(NSString *)path;

- (NSUInteger) py80Context:(KDEPy80Context *)context
      createImageWithBytes:(NSData *)data
                     width:(NSInteger)width
                    height:(NSInteger)height;

- (void) py80Context:(KDEPy80Context *)context
     reportException:(KDEPyException *)exception;

- (void) py80Context:(KDEPy80Context *)context
  reportProfileStats:(NSArray *)stats;

@end
