//
//  KDEPyException.m
//  Py80
//
//  Created by Benjamin S Hopkins on 6/1/15.
//  Copyright (c) 2015 kode80. All rights reserved.
//

#import "KDEPyException.h"


@interface KDEPyException ()

@property (nonatomic, readwrite, assign) BOOL isExternal;
@property (nonatomic, readwrite, strong) NSString *type;
@property (nonatomic, readwrite, strong) NSString *exceptionDescription;
@property (nonatomic, readwrite, strong) NSString *filePath;
@property (nonatomic, readwrite, strong) NSString *function;
@property (nonatomic, readwrite, assign) NSInteger lineNumber;

@end


@implementation KDEPyException

- (instancetype) initWithType:(NSString *)type
                  description:(NSString *)description
                     filePath:(NSString *)filePath
                     function:(NSString *)function
                   lineNumber:(NSInteger)lineNumber
{
    self = [super init];
    
    if( self)
    {
        self.isExternal = [filePath isEqualToString:@"<string>"] == NO;
        self.type = type;
        self.exceptionDescription = [KDEPyException trimDescription:description];
        self.filePath = filePath;
        self.function = function;
        
        if( self.isExternal)
        {
            self.lineNumber = 1;
        }
        else
        {
            BOOL parseDescription = [KDEPyException lineNumberIsInDescriptionForType:type];
            self.lineNumber = parseDescription ? [KDEPyException lineNumberFromDescription:description] : lineNumber;
        }
    }
    
    return self;
}

+ (BOOL) lineNumberIsInDescriptionForType:(NSString *)type
{
    return [type isEqualToString:@"SyntaxError"];
}

+ (NSInteger) lineNumberFromDescription:(NSString *)description
{
    NSRange lineRange = [description rangeOfString:@"line "];
    NSString *lineString = [description substringFromIndex:lineRange.location + lineRange.length];
    return [lineString integerValue];
}

+ (NSString *) trimDescription:(NSString *)description
{
    NSRange range = [description rangeOfString:@"(<string>, line"];
    return range.location == NSNotFound ? description : [description substringToIndex:range.location];
}

@end
