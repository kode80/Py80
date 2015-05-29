//
//  NSString+RangeUtils.m
//  Py80
//
//  Created by Benjamin S Hopkins on 5/28/15.
//  Copyright (c) 2015 kode80. All rights reserved.
//

#import "NSString+RangeUtils.h"

@implementation NSString (RangeUtils)

- (NSRange) expandRange:(NSRange)range
 withBoundaryCharacters:(NSCharacterSet *)boundaryCharacters
{
    BOOL nextCharIsBoundary = NO;

    while( nextCharIsBoundary == NO)
    {
        if( range.location > 0)
        {
            nextCharIsBoundary = [boundaryCharacters characterIsMember:[self characterAtIndex:range.location - 1]];
        }
        else
        {
            nextCharIsBoundary = YES;
        }
        
        if( nextCharIsBoundary == NO)
        {
            range.location--;
            range.length++;
        }
    }
    
    nextCharIsBoundary = NO;
    NSUInteger end;
    while( nextCharIsBoundary == NO)
    {
        end = range.length ? NSMaxRange( range) - 1 : 0;
        
        if( end + 1 < self.length)
        {
            nextCharIsBoundary = [boundaryCharacters characterIsMember:[self characterAtIndex:end + 1]];
        }
        else
        {
            nextCharIsBoundary = YES;
        }
        
        if( nextCharIsBoundary == NO)
        {
            range.length++;
        }
    }
    
    return range;
}

@end
