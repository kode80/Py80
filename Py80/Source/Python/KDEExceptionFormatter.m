//
//  KDEExceptionFormatter.m
//  Py80
//
//  Created by Benjamin S Hopkins on 5/22/15.
//  Copyright (c) 2015 kode80. All rights reserved.
//

#import "KDEExceptionFormatter.h"
#import "KDEPyException.h"

@interface KDEExceptionFormatter ()

@property (nonatomic, readwrite, strong) NSFont *typeFont;
@property (nonatomic, readwrite, strong) NSColor *typeColor;
@property (nonatomic, readwrite, strong) NSFont *descriptionFont;
@property (nonatomic, readwrite, strong) NSColor *descriptionColor;
@property (nonatomic, readwrite, strong) NSFont *infoFont;
@property (nonatomic, readwrite, strong) NSColor *infoColor;

@end


@implementation KDEExceptionFormatter

- (instancetype) initWithTypeFont:(NSFont *)typeFont
                        typeColor:(NSColor *)typeColor
                  descriptionFont:(NSFont *)descriptionFont
                 descriptionColor:(NSColor *)descriptionColor
                         infoFont:(NSFont *)infoFont
                        infoColor:(NSColor *)infoColor
{
    self = [super init];
    
    if( self)
    {
        self.typeFont = typeFont;
        self.typeColor = typeColor;
        self.descriptionFont = descriptionFont;
        self.descriptionColor = descriptionColor;
        self.infoFont = infoFont;
        self.infoColor = infoColor;
    }
    
    return self;
}

- (NSAttributedString *) attributedStringForException:(KDEPyException *)exception
{
    NSString *type = exception.type;
    NSString *externalString = @"";
    if( exception.isExternal)
    {
        type = [type stringByAppendingFormat:@" in %@", exception.filePath.lastPathComponent];
        externalString = [NSString stringWithFormat:@"\n\nFile: %@\nFunction: %@\nLine: %@", exception.filePath,
                                                                                             exception.function,
                                                                                             @(exception.lineNumber)];
    }
    
    NSString *message = [NSString stringWithFormat:@"%@\n%@%@", exception.type, exception.exceptionDescription, externalString];
    
    NSMutableAttributedString *output = [[NSMutableAttributedString alloc] initWithString:message];
    
    NSDictionary *attributes = @{ NSFontAttributeName : self.typeFont,
                                  NSForegroundColorAttributeName : self.typeColor};
    [output setAttributes:attributes
                    range:[message rangeOfString:exception.type]];
    
    attributes = @{ NSFontAttributeName : self.descriptionFont,
                    NSForegroundColorAttributeName : self.descriptionColor};
    [output setAttributes:attributes
                    range:[message rangeOfString:exception.exceptionDescription]];
    
    if( exception.isExternal)
    {
        attributes = @{ NSFontAttributeName : self.infoFont,
                        NSForegroundColorAttributeName : self.infoColor};
        [output setAttributes:attributes
                        range:[message rangeOfString:externalString]];
    }
    
    return output;
}

@end
