//
//  NSString+CursorPosition.m
//  Py80
//
//  Created by Benjamin S Hopkins on 5/28/15.
//  Copyright (c) 2015 kode80. All rights reserved.
//

#import "NSString+CursorPosition.h"

@implementation NSString (CursorPosition)

- (KDEStringCursor) cursorForRange:(NSRange)range
{
    KDEStringCursor cursor = { 1, 0 };
    
    const NSRange cursorRange = NSMakeRange( range.location, 0);
    NSRange currentRange = NSMakeRange( 0, 0);
    NSRange lineRange = [self lineRangeForRange:currentRange];
    
    while( lineRange.location < cursorRange.location &&
          NSMaxRange( lineRange) < cursorRange.location &&
          NSMaxRange( currentRange) < self.length)
    {
        cursor.line++;
        currentRange.location = NSMaxRange( lineRange);
        lineRange = [self lineRangeForRange:currentRange];
    }
    
    cursor.column = (cursorRange.location - lineRange.location);
    
    NSCharacterSet *newLineChars = [NSCharacterSet newlineCharacterSet];
    unichar characterAtCursor = cursorRange.location < self.length ? [self characterAtIndex:cursorRange.location] : 0;
    unichar characterBeforeCursor = cursorRange.location > 0 ? [self characterAtIndex:cursorRange.location - 1] : 0;
    
    BOOL beforeIsNewLine = [newLineChars characterIsMember:characterBeforeCursor];
    BOOL cursorIsNewLine = [newLineChars characterIsMember:characterAtCursor];
    
    if( (beforeIsNewLine && cursorIsNewLine == NO) ||
       (beforeIsNewLine && cursorIsNewLine))
    {
        cursor.line++;
        cursor.column = 0;
    }
    
    return cursor;
}

@end
