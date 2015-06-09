//
//  KDEThemeItem.m
//  Py80
//
//  Created by Benjamin S Hopkins on 6/4/15.
//  Copyright (c) 2015 kode80. All rights reserved.
//

#import "KDEThemeItem.h"


@interface KDEThemeItem ()

@property (nonatomic, readwrite, copy) NSDictionary *textAttributes;

@end


@implementation KDEThemeItem

- (instancetype) initWithDictionary:(NSDictionary *)dictionary;
{
    self = [super init];
    if( self)
    {
        NSNumber *red = dictionary[ @"Red"];
        NSNumber *green = dictionary[ @"Green"];
        NSNumber *blue = dictionary[ @"Blue"];
        if( red && green && blue)
        {
            self.color = [NSColor colorWithDeviceRed:red.floatValue
                                               green:green.floatValue
                                                blue:blue.floatValue
                                               alpha:1.0f];
        }
        
        NSString *fontName = dictionary[ @"FontName"];
        NSNumber *fontSize = dictionary[ @"FontSize"];
        if( fontName && fontSize)
        {
            self.font = [NSFont fontWithName:fontName
                                        size:fontSize.floatValue];
        }
    }
    return self;
}

- (void) setColor:(NSColor *)color
{
    if( _color != color)
    {
        _color = color;
        [self updateTextAttributes];
    }
}

- (void) setFont:(NSFont *)font
{
    if( _font != font)
    {
        _font = font;
        [self updateTextAttributes];
    }
}

- (NSDictionary *) dictionary
{
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
    if( self.color)
    {
        dictionary[ @"Red"] = @(self.color.redComponent);
        dictionary[ @"Green"] = @(self.color.greenComponent);
        dictionary[ @"Blue"] = @(self.color.blueComponent);
    }
    
    if( self.font)
    {
        dictionary[ @"FontName"] = self.font.fontName;
        dictionary[ @"FontSize"] = @(self.font.pointSize);
    }
    return [NSDictionary dictionaryWithDictionary:dictionary];
}

- (void) updateTextAttributes
{
    NSMutableDictionary *attributes = [NSMutableDictionary dictionary];
    if( self.color)
    {
        attributes[ NSForegroundColorAttributeName] = self.color;
    }
    
    if( self.font)
    {
        attributes[ NSFontAttributeName] = self.font;
    }
    
    self.textAttributes = [NSDictionary dictionaryWithDictionary:attributes];
}

@end
