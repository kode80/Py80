//
//  KDEOutputView.m
//  Py80
//
//  Created by Benjamin S Hopkins on 5/18/15.
//  Copyright (c) 2015 kode80. All rights reserved.
//

#import "KDEOutputView.h"



@interface KDEOutputViewDrawSettings : NSObject <NSCopying>

@property (nonatomic, readwrite, strong) NSColor *strokeColor;
@property (nonatomic, readwrite, strong) NSColor *fillColor;
@property (nonatomic, readwrite, assign) CGFloat strokeWidth;

@end

@implementation KDEOutputViewDrawSettings

- (instancetype) copyWithZone:(NSZone *)zone
{
    KDEOutputViewDrawSettings *copy = [[KDEOutputViewDrawSettings allocWithZone:zone] init];
    copy.strokeColor = [self.strokeColor copy];
    copy.fillColor = [self.fillColor copy];
    copy.strokeWidth = self.strokeWidth;
    return copy;
}
@end



@interface KDEOutputView ()

@property (nonatomic, readwrite, assign) NSRect contentRect;
@property (nonatomic, readwrite, copy) NSArray *drawList;
@property (nonatomic, readwrite, strong) KDEOutputViewDrawSettings *mostRecentDrawSettings;

@end


@implementation KDEOutputView

- (instancetype) initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if( self)
    {
        [self clear];
    }
    return self;
}

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];

    KDEOutputViewDrawSettings *drawSettings = nil;
    
    for( id command in self.drawList)
    {
        if( [command isKindOfClass:[KDEOutputViewDrawSettings class]])
        {
            drawSettings = command;
            [drawSettings.strokeColor setStroke];
            [drawSettings.fillColor setFill];
        }
        else if( [command isKindOfClass:[NSBezierPath class]])
        {
            NSBezierPath *path = command;
            
            if( drawSettings.fillColor)
            {
                [path fill];
            }
            
            if( drawSettings.strokeWidth > 0.0f)
            {
                path.lineWidth = drawSettings.strokeWidth;
                [path stroke];
            }
        }
    }
}


- (void) clear
{
    KDEOutputViewDrawSettings *defaultSettings = [KDEOutputViewDrawSettings new];
    defaultSettings.strokeColor = [NSColor blackColor];
    defaultSettings.fillColor = [NSColor clearColor];
    defaultSettings.strokeWidth = 1.0f;
    
    self.mostRecentDrawSettings = defaultSettings;
    self.drawList = @[ defaultSettings];
    
    self.contentRect = NSZeroRect;
    [self expandIntrinsicContentSizeIfNeededForRect:NSZeroRect];
    
    [self setNeedsDisplay:YES];
}

- (void) setStrokeColor:(NSColor *)strokeColor
{
    [self updateDrawSettingsWithAssignmentBlock:^(KDEOutputViewDrawSettings *settings){
        settings.strokeColor = strokeColor;
    }];
}

- (void) setFillColor:(NSColor *)fillColor
{
    fillColor = fillColor.alphaComponent > 0.0f ? fillColor: nil;
    [self updateDrawSettingsWithAssignmentBlock:^(KDEOutputViewDrawSettings *settings){
        settings.fillColor = fillColor;
    }];
}

- (void) setStrokeWidth:(CGFloat)strokeWidth
{
    [self updateDrawSettingsWithAssignmentBlock:^(KDEOutputViewDrawSettings *settings){
        settings.strokeWidth = strokeWidth;
    }];
}

- (void) addRectangle:(NSRect)rect
{
    NSBezierPath *path = [NSBezierPath bezierPathWithRect:rect];
    self.drawList = [self.drawList arrayByAddingObject:path];
    
    [self expandIntrinsicContentSizeIfNeededForRect:rect];
    
    [self setNeedsDisplay:YES];
}

- (NSSize)intrinsicContentSize
{
    return self.contentRect.size;
}

#pragma mark Private

- (void) expandIntrinsicContentSizeIfNeededForRect:(NSRect)rect
{
    // Expand rect as a hack to include stroke width
    rect = NSInsetRect( rect, -10, -10);
    
    self.contentRect = NSUnionRect( self.contentRect, rect);
    [self invalidateIntrinsicContentSize];
}

- (void) updateDrawSettingsWithAssignmentBlock:(void (^)(KDEOutputViewDrawSettings * settings))assignmentBlock
{
    if( [self.drawList.lastObject isKindOfClass:[KDEOutputViewDrawSettings class]])
    {
        assignmentBlock( self.drawList.lastObject);
    }
    else
    {
        KDEOutputViewDrawSettings *settings = [self.mostRecentDrawSettings copy];
        assignmentBlock( settings);
        self.drawList = [self.drawList arrayByAddingObject:settings];
        self.mostRecentDrawSettings = settings;
    }
}

@end
