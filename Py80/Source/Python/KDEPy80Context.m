//
//  KDEPy80Context.m
//  Py80
//
//  Created by Benjamin S Hopkins on 5/18/15.
//  Copyright (c) 2015 kode80. All rights reserved.
//

#import "KDEPy80Context.h"

@implementation KDEPy80Context

+ (KDEPy80Context *) sharedContext
{
    static dispatch_once_t onceToken;
    static KDEPy80Context *context = nil;
    dispatch_once(&onceToken, ^{
        context = [KDEPy80Context new];
    });
    return context;
}

- (void) log:(NSString *)message
{
    if( [self.delegate respondsToSelector:@selector(py80Context:logMessage:)])
    {
        [self.delegate py80Context:self
                        logMessage:message];
    }
}

- (void) clearLog
{
    if( [self.delegate respondsToSelector:@selector(py80ContextClearLog:)])
    {
        [self.delegate py80ContextClearLog:self];
    }
}

- (NSString *) getClipboard
{
    if( [self.delegate respondsToSelector:@selector(py80ContextGetClipboard:)])
    {
        return [self.delegate py80ContextGetClipboard:self];
    }
    
    return nil;
}

- (void) setClipboard:(NSString *)string
{
    if( [self.delegate respondsToSelector:@selector(py80Context:setClipboard:)])
    {
        [self.delegate py80Context:self
                      setClipboard:string];
    }
}

- (void) clearDrawing
{
    if( [self.delegate respondsToSelector:@selector(py80ContextClearDrawing:)])
    {
        [self.delegate py80ContextClearDrawing:self];
    }
}

- (void) setStrokeRed:(CGFloat)red
                green:(CGFloat)green
                 blue:(CGFloat)blue
                alpha:(CGFloat)alpha
{
    if( [self.delegate respondsToSelector:@selector(py80Context:setStrokeRed:green:blue:alpha:)])
    {
        [self.delegate py80Context:self
                      setStrokeRed:red
                             green:green
                              blue:blue
                             alpha:alpha];
    }
}

- (void) setFillRed:(CGFloat)red
              green:(CGFloat)green
               blue:(CGFloat)blue
              alpha:(CGFloat)alpha
{
    if( [self.delegate respondsToSelector:@selector(py80Context:setFillRed:green:blue:alpha:)])
    {
        [self.delegate py80Context:self
                        setFillRed:red
                             green:green
                              blue:blue
                             alpha:alpha];
    }
}

- (void) setStrokeWidth:(CGFloat)width
{
    if( [self.delegate respondsToSelector:@selector(py80Context:setStrokeWidth:)])
    {
        [self.delegate py80Context:self
                    setStrokeWidth:width];
    }
}

- (void) drawRectAtX:(CGFloat)x
                   y:(CGFloat)y
           withWidth:(CGFloat)width
              height:(CGFloat)height
{
    if( [self.delegate respondsToSelector:@selector(py80Context:drawRectAtX:y:withWidth:height:)])
    {
        [self.delegate py80Context:self
                       drawRectAtX:x
                                 y:y
                         withWidth:width
                            height:height];
    }
}

- (void) reportExceptionType:(NSString *)type
                 description:(NSString *)description
                    filePath:(NSString *)filePath
                    function:(NSString *)function
                  lineNumber:(NSInteger)lineNumber
{
    if( [self.delegate respondsToSelector:@selector(py80Context:reportExceptionType:description:filePath:function:lineNumber:)])
    {
        [self.delegate py80Context:self
               reportExceptionType:type
                       description:description
                          filePath:filePath
                          function:function
                        lineNumber:lineNumber];
    }
}

@end
