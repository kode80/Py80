//
//  NSString+CursorPosition.h
//  Py80
//
//  Created by Benjamin S Hopkins on 5/28/15.
//  Copyright (c) 2015 kode80. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef struct KDEStringCursor {
    NSInteger line;
    NSInteger column;
} KDEStringCursor;

@interface NSString (CursorPosition)

- (KDEStringCursor) cursorForRange:(NSRange)range;

@end
