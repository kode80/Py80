//
//  KDEPy80Context.h
//  Py80
//
//  Created by Benjamin S Hopkins on 5/18/15.
//  Copyright (c) 2015 kode80. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@protocol KDEPy80ContextDelegate;


@interface KDEPy80Context : NSObject

@property (nonatomic, readwrite, weak) id<KDEPy80ContextDelegate> delegate;

+ (KDEPy80Context *) sharedContext;

- (void) log:(NSString *)message;
- (void) clearLog;

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

- (void) drawRectAtX:(CGFloat)x
                   y:(CGFloat)y
           withWidth:(CGFloat)width
              height:(CGFloat)height;

@end


@protocol KDEPy80ContextDelegate <NSObject>

- (void) py80Context:(KDEPy80Context *)context
          logMessage:(NSString *)message;

- (void) py80ContextClearLog:(KDEPy80Context *)context;

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
         drawRectAtX:(CGFloat)x
                   y:(CGFloat)y
           withWidth:(CGFloat)width
              height:(CGFloat)height;

@end
