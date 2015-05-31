//
//  KDEOutputView.m
//  Py80
//
//  Created by Benjamin S Hopkins on 5/18/15.
//  Copyright (c) 2015 kode80. All rights reserved.
//

#import "KDEOutputView.h"

#import "KDEOutputCommand.h"
#import "KDEOutputDrawSettings.h"
#import "KDEOutputDrawPathCommand.h"
#import "KDEOutputDrawTextCommand.h"
#import "KDEOutputDrawImageCommand.h"

@interface KDEOutputView ()

@property (nonatomic, readwrite, assign) BOOL hasContent;
@property (nonatomic, readwrite, assign) NSRect contentRect;
@property (nonatomic, readwrite, copy) NSArray *drawList;
@property (nonatomic, readwrite, strong) KDEOutputDrawSettings *mostRecentDrawSettings;

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

    KDEOutputDrawSettings *drawSettings = [KDEOutputDrawSettings new];
    
    for( KDEOutputCommand *command in self.drawList)
    {
        [command executeWithDrawSettings:drawSettings];
    }
}

- (BOOL) isFlipped
{
    return YES;
}

- (void) mouseUp:(NSEvent *)theEvent
{
    if( theEvent.clickCount == 2)
    {
        self.enclosingScrollView.animator.magnification = 1.0f;
    }
}

- (void) clear
{
    KDEOutputDrawSettings *defaultSettings = [KDEOutputDrawSettings new];
    defaultSettings.strokeColor = [NSColor blackColor];
    defaultSettings.fillColor = [NSColor clearColor];
    defaultSettings.strokeWidth = 1.0f;
    defaultSettings.font = [NSFont systemFontOfSize:11.0f];
    
    self.hasContent = NO;
    self.mostRecentDrawSettings = defaultSettings;
    self.drawList = @[ defaultSettings];
    
    self.contentRect = NSZeroRect;
    [self expandIntrinsicContentSizeIfNeededForRect:NSZeroRect];
    
    [self setNeedsDisplay:YES];
}

- (void) setStrokeColor:(NSColor *)strokeColor
{
    [self updateDrawSettingsWithAssignmentBlock:^(KDEOutputDrawSettings *settings){
        settings.strokeColor = strokeColor;
    }];
}

- (void) setFillColor:(NSColor *)fillColor
{
    fillColor = fillColor.alphaComponent > 0.0f ? fillColor: nil;
    [self updateDrawSettingsWithAssignmentBlock:^(KDEOutputDrawSettings *settings){
        settings.fillColor = fillColor;
    }];
}

- (void) setStrokeWidth:(CGFloat)strokeWidth
{
    [self updateDrawSettingsWithAssignmentBlock:^(KDEOutputDrawSettings *settings){
        settings.strokeWidth = strokeWidth;
    }];
}

- (void) setFontName:(NSString *)fontName
                size:(CGFloat)size
{
    [self updateDrawSettingsWithAssignmentBlock:^(KDEOutputDrawSettings *settings){
        NSFont *font = [NSFont fontWithName:fontName
                                       size:size];
        if( font)
        {
            settings.font = font;
        }
    }];
}

- (void) addRectangle:(NSRect)rect
{
    KDEOutputDrawPathCommand *command = [KDEOutputDrawPathCommand new];
    command.path = [NSBezierPath bezierPathWithRect:rect];
    self.drawList = [self.drawList arrayByAddingObject:command];
    
    self.hasContent = YES;
    [self expandIntrinsicContentSizeIfNeededForRect:rect];
    [self setNeedsDisplay:YES];
}

- (void) addOval:(NSRect)rect
{
    KDEOutputDrawPathCommand *command = [KDEOutputDrawPathCommand new];
    command.path = [NSBezierPath bezierPathWithOvalInRect:rect];
    self.drawList = [self.drawList arrayByAddingObject:command];
    
    self.hasContent = YES;
    [self expandIntrinsicContentSizeIfNeededForRect:rect];
    [self setNeedsDisplay:YES];
}

- (void) addText:(NSString *)text
         atPoint:(NSPoint)point
{
    KDEOutputDrawTextCommand *command = [KDEOutputDrawTextCommand new];
    command.text = text;
    command.location = point;
    self.drawList = [self.drawList arrayByAddingObject:command];
    self.hasContent = YES;
    
    NSRect rect;
    rect.origin = point;
    rect.size = [text sizeWithAttributes:@{ NSFontAttributeName : self.mostRecentDrawSettings.font }];
    
    [self expandIntrinsicContentSizeIfNeededForRect:rect];
    [self setNeedsDisplay:YES];
}

- (void) addImage:(NSImage *)image
           inRect:(NSRect)rect
{
    KDEOutputDrawImageCommand *command = [KDEOutputDrawImageCommand new];
    command.image = image;
    command.rect = rect;
    
    self.hasContent = YES;
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

- (void) updateDrawSettingsWithAssignmentBlock:(void (^)(KDEOutputDrawSettings * settings))assignmentBlock
{
    if( [self.drawList.lastObject isKindOfClass:[KDEOutputDrawSettings class]])
    {
        assignmentBlock( self.drawList.lastObject);
    }
    else
    {
        KDEOutputDrawSettings *settings = [self.mostRecentDrawSettings copy];
        assignmentBlock( settings);
        self.drawList = [self.drawList arrayByAddingObject:settings];
        self.mostRecentDrawSettings = settings;
    }
}

@end
