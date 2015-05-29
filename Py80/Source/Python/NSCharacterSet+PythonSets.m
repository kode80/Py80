//
//  NSCharacterSet+PythonSets.m
//  Py80
//
//  Created by Benjamin S Hopkins on 5/29/15.
//  Copyright (c) 2015 kode80. All rights reserved.
//

#import "NSCharacterSet+PythonSets.h"

@implementation NSCharacterSet (PythonSets)

+ (NSCharacterSet *) pythonIdentifierCharacterSet
{
    return [NSCharacterSet characterSetWithCharactersInString:@"abcdefghijklmnopqrstuvwxyz"
                                                              @"ABCDEFGHIJKLMNOPQRSTUVWXYZ"
                                                              @"0123456789_"];
}

@end
