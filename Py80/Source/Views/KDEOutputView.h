//
//  KDEOutputView.h
//  Py80
//
//  Created by Benjamin S Hopkins on 5/18/15.
//  Copyright (c) 2015 kode80. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface KDEOutputView : NSView

@property (nonatomic, readonly, assign) BOOL hasContent;

- (void) clear;
- (void) setStrokeColor:(NSColor *)strokeColor;
- (void) setFillColor:(NSColor *)fillColor;
- (void) setStrokeWidth:(CGFloat)strokeWidth;
- (void) setFontName:(NSString *)fontName
                size:(CGFloat)size;
- (void) addRectangle:(NSRect)rect;
- (void) addOval:(NSRect)rect;
- (void) addText:(NSString *)text
         atPoint:(NSPoint)point;

@end
