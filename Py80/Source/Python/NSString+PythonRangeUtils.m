//
//  NSString+PythonRangeUtils.m
//  Py80
//
//  Created by Benjamin S Hopkins on 5/29/15.
//  Copyright (c) 2015 kode80. All rights reserved.
//

#import "NSString+PythonRangeUtils.h"
#import "NSString+RangeUtils.h"
#import "NSCharacterSet+PythonSets.h"

@implementation NSString (PythonRangeUtils)

- (NSRange) jumpLeftToNextPythonBoundary:(NSRange)originalRange
{
    NSCharacterSet *boundaryCharacters;
    NSRange range = originalRange;
    
    if( range.location > 0)
    {
        boundaryCharacters = [[NSCharacterSet pythonIdentifierCharacterSet] invertedSet];
        
        range = [self expandRangeLeft:range
               withBoundaryCharacters:boundaryCharacters];
        range.length = 0;
        
        if( range.location == originalRange.location)
        {
            range.location--;
        }
    }
    
    return range;
}

- (NSRange) jumpRightToNextPythonBoundary:(NSRange)originalRange
{
    NSCharacterSet *boundaryCharacters;
    unichar character;
    NSRange range = originalRange;
    
    if( NSMaxRange( range) + 1 < self.length)
    {
        range.location += range.length;
        range.length = 0;
        
        boundaryCharacters = [[NSCharacterSet pythonIdentifierCharacterSet] invertedSet];
        character = [self characterAtIndex:NSMaxRange( range)];
        
        if( [boundaryCharacters characterIsMember:character])
        {
            range.location++;
        }
        else
        {
            range = [self expandRangeRight:range
                    withBoundaryCharacters:boundaryCharacters];
            range.location = NSMaxRange( range);
            range.length = 0;
            
            if( range.location == NSMaxRange( originalRange) &&
                range.location + 1 < self.length)
            {
                range.location++;
            }
        }
    }
    
    return range;
}

- (NSRange) expandSelectionLeftToNextPythonBoundary:(NSRange)originalRange
{
    NSCharacterSet *boundaryCharacters;
    NSRange range = originalRange;
    unichar character = 0;
    
    if( range.location > 0)
    {
        boundaryCharacters = [[NSCharacterSet pythonIdentifierLowercaseLettersCharacterSet] invertedSet];
        
        range = [self expandRangeLeft:range
               withBoundaryCharacters:boundaryCharacters];
        
        if( range.location == originalRange.location)
        {
            range.location--;
            range.length++;
        }
        else if( range.location > 0)
        {
            character = [self characterAtIndex:range.location - 1];
            if( [[NSCharacterSet pythonIdentifierUppercaseLettersCharacterSet] characterIsMember:character])
            {
                range.location--;
                range.length++;
            }
        }
    }
    
    return range;
}

- (NSRange) expandSelectionRightToNextPythonBoundary:(NSRange)originalRange
{
    NSCharacterSet *boundaryCharacters;
    unichar character;
    NSRange range = originalRange;
    
    if( NSMaxRange( range) + 1 < self.length)
    {
        boundaryCharacters = [[NSCharacterSet pythonIdentifierLowercaseLettersCharacterSet] invertedSet];
        character = [self characterAtIndex:NSMaxRange( range)];
        
        range = [self expandRangeRight:range
                withBoundaryCharacters:boundaryCharacters];
        
        if( NSMaxRange( range) == NSMaxRange( originalRange) &&
            NSMaxRange( range) < self.length)
        {
            range.length++;
        }
        
        character = [self characterAtIndex:NSMaxRange( range) - 1];
            
        if( [[NSCharacterSet pythonIdentifierUppercaseLettersCharacterSet] characterIsMember:character])
        {
            range = [self expandRangeRight:range
                    withBoundaryCharacters:boundaryCharacters];
        }
    }
    
    return range;
}

@end
