//
//  KDEThemeItem.m
//  Py80
//
//  Created by Benjamin S Hopkins on 6/4/15.
//  Copyright (c) 2015 kode80. All rights reserved.
//

#import "KDEThemeItem.h"

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

@end
