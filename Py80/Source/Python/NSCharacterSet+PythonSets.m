//
//  NSCharacterSet+PythonSets.m
//  Py80
//
//  Created by Benjamin S Hopkins on 5/29/15.
//  Copyright (c) 2015 kode80. All rights reserved.
//

#import "NSCharacterSet+PythonSets.h"


NSString * const KDEPythonIdentifierLowercaseLettersString = @"abcdefghijklmnopqrstuvwxyz";
NSString * const KDEPythonIdentifierUppercaseLettersString = @"ABCDEFGHIJKLMNOPQRSTUVWXYZ";
NSString * const KDEPythonIdentifierNumbersString          = @"0123456789_";


@implementation NSCharacterSet (PythonSets)

+ (NSCharacterSet *) pythonIdentifierCharacterSet
{
    NSString *all = [NSString stringWithFormat:@"%@%@%@", KDEPythonIdentifierLowercaseLettersString,
                                                          KDEPythonIdentifierUppercaseLettersString,
                                                          KDEPythonIdentifierNumbersString];
    
    return [NSCharacterSet characterSetWithCharactersInString:all];
}

+ (NSCharacterSet *) pythonIdentifierLowercaseLettersCharacterSet
{
    return [NSCharacterSet characterSetWithCharactersInString:KDEPythonIdentifierLowercaseLettersString];
}

+ (NSCharacterSet *) pythonIdentifierUppercaseLettersCharacterSet
{
    return [NSCharacterSet characterSetWithCharactersInString:KDEPythonIdentifierUppercaseLettersString];
}

+ (NSCharacterSet *) pythonIdentifierNumericCharacterSet
{
    return [NSCharacterSet characterSetWithCharactersInString:KDEPythonIdentifierNumbersString];
}

@end
