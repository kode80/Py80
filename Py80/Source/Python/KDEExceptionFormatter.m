//
//  KDEExceptionFormatter.m
//  Py80
//
//  Created by Benjamin S Hopkins on 5/22/15.
//  Copyright (c) 2015 kode80. All rights reserved.
//

#import "KDEExceptionFormatter.h"


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

- (NSAttributedString *) attributedStringForExceptionType:(NSString *)type
                                              description:(NSString *)description
                                                 filePath:(NSString *)filePath
                                                 function:(NSString *)function
                                               lineNumber:(NSInteger)lineNumber
{
    if( [type isEqualTo:@"SyntaxError"])
    {
        NSRange lineRange = [description rangeOfString:@"line "];
        NSString *lineString = [description substringFromIndex:lineRange.location + lineRange.length];
        lineNumber = [lineString integerValue];
        description = @"Invalid syntax";
    }
    
    BOOL isExternal = [filePath isEqualTo:@"<string>"] == NO;
    if( isExternal) { type = [type stringByAppendingFormat:@" in %@", filePath.lastPathComponent]; }
    NSString *externalString = isExternal ? [NSString stringWithFormat:@"\n\nFile: %@\nFunction: %@\nLine: %@", filePath, function, @(lineNumber)] : @"";
    NSString *message = [NSString stringWithFormat:@"%@\n%@%@", type, description, externalString];
    
    NSMutableAttributedString *output = [[NSMutableAttributedString alloc] initWithString:message];
    
    NSDictionary *attributes = @{ NSFontAttributeName : self.typeFont,
                                  NSForegroundColorAttributeName : self.typeColor};
    [output setAttributes:attributes
                    range:[message rangeOfString:type]];
    
    attributes = @{ NSFontAttributeName : self.descriptionFont,
                    NSForegroundColorAttributeName : self.descriptionColor};
    [output setAttributes:attributes
                    range:[message rangeOfString:description]];
    
    if( isExternal)
    {
        attributes = @{ NSFontAttributeName : self.infoFont,
                        NSForegroundColorAttributeName : self.infoColor};
        [output setAttributes:attributes
                        range:[message rangeOfString:externalString]];
        lineNumber = 1;
    }
    
    return output;
}

@end
