//
//  KDEExceptionFormatter.h
//  Py80
//
//  Created by Benjamin S Hopkins on 5/22/15.
//  Copyright (c) 2015 kode80. All rights reserved.
//

#import <Foundation/Foundation.h>

@class KDEPyException;

@interface KDEExceptionFormatter : NSObject

- (instancetype) initWithTypeFont:(NSFont *)typeFont
                        typeColor:(NSColor *)typeColor
                  descriptionFont:(NSFont *)descriptionFont
                 descriptionColor:(NSColor *)descriptionColor
                         infoFont:(NSFont *)infoFont
                        infoColor:(NSColor *)infoColor;

- (NSAttributedString *) attributedStringForException:(KDEPyException *)exception;

@end
